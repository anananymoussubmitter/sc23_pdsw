#!/bin/bash

# SETTINGS BEGIN
QUERY1='"query":{"match_all":{}}'
QUERY2='{"query":{"range":{"total_amount":{"gte":5,"lt":15}}}}'
QUERY3='{"size":0,"query":{"bool":{"filter":{"range":{"trip_distance":{"lt":50,"gte":0}}}}},"aggs":{"distance_histo":{"histogram":{"field":"trip_distance","interval":1},"aggs":{"total_amount_stats":{"stats":{"field":"total_amount"}}}}}}'
INDEX_NAME="nyc_taxis"
WARMUP_RUNS=25
RUNS=50
# SETTINGS END

HOSTNAMES_LIST="127.0.0.1"
IFS=', ' read -r -a HOSTNAMES <<< "$HOSTNAMES_LIST"

# sanity checks
# See: https://www.elastic.co/guide/en/elasticsearch/reference/current/shard-request-cache.html
for h in ${HOSTNAMES[@]}; do
  # it is configured to not cache anyways (see ingest rally tracks index.json) but what do we have to lose
  curl -s -o /dev/null -X POST "${h}:9200/${INDEX_NAME}/_cache/clear?request=true&pretty"
done

warmup_runs() {
  local q=$1
  for ((i=0; i<$RUNS; i++))
  do
    local HOSTNAME=${HOSTNAMES[$((RANDOM % ${#HOSTNAMES[@]}))]}
    curl -s -o /dev/null -X GET "$HOSTNAME:9200/${INDEX_NAME}/_search" -H 'Content-Type: application/json' --data "$q"
  done
}

runs() {
  local q=$1
  local error_count=0
  for ((i=0; i<$RUNS; i++))
  do 
    local HOSTNAME=${HOSTNAMES[$((RANDOM % ${#HOSTNAMES[@]}))]}
    curl -s -o /dev/null -X GET "$HOSTNAME:9200/${INDEX_NAME}/_search" -H 'Content-Type: application/json' --data "$q"

    # i.e. curl got non-2xx status code
    if [ $? -ne 0 ]; then
      ((error_count++))
    fi

  done

  echo -n "error_count" $error_count
}

time_to_seconds() {
  local h=$(date -d "$1" +%H)
  local m=$(date -d "$1" +%M)
  local s=$(date -d "$1" +%S)

  echo "$((h * 3600 + m * 60 + s))"
}

# Validate the input argument
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <HH:MM:SS>"
  exit 1
fi
time_arg=$1
if ! [[ $time_arg =~ ^([0-9]{2}):([0-9]{2}):([0-9]{2})$ ]]; then
  echo "Invalid time format. Please use HH:MM:SS format."
  exit 1
fi

current_time=$(date +%T)
current_seconds=$(time_to_seconds "$current_time")
target_seconds=$(time_to_seconds "$time_arg")
time_difference=$((target_seconds - current_seconds))

sleep "$time_difference"

# main program
for q in $QUERY1 $QUERY2 $QUERY3 
do
  echo    "query   $q"
  warmup_runs $q
  echo "runs    $RUNS"
  time runs $q
  echo "" # newline
  warmup_runs $q
done
