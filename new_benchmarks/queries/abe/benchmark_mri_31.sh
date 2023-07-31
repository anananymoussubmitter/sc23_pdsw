#!/bin/bash

# SETTINGS BEGIN
QUERY1='{"query":{"match_all":{}}}'
QUERY2='{"query":{"range":{"042b0e2c3af11ba16e11eb8fd5f5fcda":{"gte":8548571427144381606,"lt":10952929710919029111}}}}' # range
QUERY4='{"query":{"term":{"b4da414e32193ee295394be6219e4d30":"298c1336ba36eb8da0c1c430f00865e7"}}}' # term
QUERY3='{"query":{"match_phrase":{"06afa2d7b35183672a6c93bbaff11356":"771941e14252ba396f353b875533d14c"}}}' # phrase
QUERY5='{"query":{"bool":{"must":[{"term":{"b4da414e32193ee295394be6219e4d30":"298c1336ba36eb8da0c1c430f00865e7"}},{"term":{"84084cc05b8ac4cf5d07aa71cbb78adf":546723516}},{"term":{"23368ee5999d172ce38626232aa6b937":546723516}}]}}}' # real_query-1
QUERY6='{"query":{"bool":{"must":[{"term":{"b4da414e32193ee295394be6219e4d30":"298c1336ba36eb8da0c1c430f00865e7"}},{"bool":{"should":[{"bool":{"must":[{"term":{"06afa2d7b35183672a6c93bbaff11356":"771941e14252ba396f353b875533d14c"}},{"match":{"656ba589d1435e9fdba5e88364eb9bbc":"0a7c9a74c61635d0928e6f339e8b8718"}}]}},{"bool":{"must":[{"term":{"06afa2d7b35183672a6c93bbaff11356":"923ca158fe2e2b5ede29a03620208b68"}},{"match":{"656ba589d1435e9fdba5e88364eb9bbc":"63341a287f5cd401e7ec857f6b7d44c4"}}]}}]}}]}}}' # real-query-3
INDEX_NAME="mrirally"
WARMUP_RUNS=25
RUNS=50
# SETTINGS END

#HOSTNAMES_LIST="gcn2049,gcn2051,gcn2053,gcn2055,gcn2057,gcn2059,gcn2061,gcn2063,gcn2065,gcn2067,gcn2069,gcn2071,gcn2073,gcn2075,gcn2077,gcn2079,gcn2081,gcn2083,gcn2085,gcn2087,gcn2089,gcn2091,gcn2093,gcn2095,gcn2991,gcn2993,gcn2995,gcn2997,gcn2999,gcn3001,gcn3003"
HOSTNAMES_LIST="gcn2529,gcn2532,gcn2535,gcn2538,gcn2541,gcn2544,gcn2547,gcn2550,gcn2553,gcn2556,gcn2559,gcn2530,gcn2533,gcn2536,gcn2539,gcn2542,gcn2545,gcn2548,gcn2551,gcn2554,gcn2557,gcn2531,gcn2534,gcn2537,gcn2540,gcn2543,gcn2546,gcn2549,gcn2552,gcn2555,gcn2558"
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
  h=${h#0}
  local m=$(date -d "$1" +%M)
  m=${m#0}
  local s=$(date -d "$1" +%S)
  s=${s#0}

  echo "$((h * 3600 + m * 60 + s))"
}


# Validate the input argument
#if [[ $# -ne 1 ]]; then
#  echo "Usage: $0 <HH:MM:SS>"
#  exit 1
#fi

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
#for q in $QUERY1 $QUERY2 $QUERY3 $QUERY4 $QUERY5 $QUERY6
if [ $2 == "QUERY1" ]
then
for q in $QUERY1
do
  echo    "query   $q"
  warmup_runs $q
  echo "runs    $RUNS"
  time runs $q
  echo "" # newline
  warmup_runs $q
done
fi
if [ $2 == "QUERY2" ]
then
for q in $QUERY2
do
  echo    "query   $q"
  warmup_runs $q
  echo "runs    $RUNS"
  time runs $q
  echo "" # newline
  warmup_runs $q
done
fi

