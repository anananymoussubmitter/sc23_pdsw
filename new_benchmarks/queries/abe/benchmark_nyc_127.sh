#!/bin/bash

# SETTINGS BEGIN
QUERY1='{"query":{"match_all":{}}}'
QUERY2='{"query":{"range":{"f8b1f618eb3c3942ec41d52f49210fb4":{"gte":2320009027036418,"lt":2364476974132175}}}}'
INDEX_NAME="nyc_taxis"
WARMUP_RUNS=25
RUNS=50
# SETTINGS END

HOSTNAMES_LIST="gcn2145,gcn2147,gcn2149,gcn2151,gcn2153,gcn2155,gcn2159,gcn2161,gcn2163,gcn2165,gcn2167,gcn2169,gcn2171,gcn2173,gcn2175,gcn2177,gcn2179,gcn2181,gcn2183,gcn2185,gcn2187,gcn2189,gcn2191,gcn2241,gcn2243,gcn2245,gcn2247,gcn2249,gcn2251,gcn2253,gcn2255,gcn2257,gcn2259,gcn2261,gcn2263,gcn2265,gcn2267,gcn2269,gcn2271,gcn2273,gcn2275,gcn2277,gcn2279,gcn2281,gcn2283,gcn2285,gcn2287,gcn2337,gcn2339,gcn2341,gcn2343,gcn2345,gcn2347,gcn2349,gcn2351,gcn2353,gcn2355,gcn2357,gcn2359,gcn2361,gcn2363,gcn2365,gcn2367,gcn2369,gcn2371,gcn2373,gcn2375,gcn2377,gcn2379,gcn2381,gcn2383,gcn2433,gcn2435,gcn2437,gcn2439,gcn2441,gcn2443,gcn2445,gcn2447,gcn2449,gcn2451,gcn2453,gcn2455,gcn2457,gcn2459,gcn2461,gcn2463,gcn2465,gcn2467,gcn2469,gcn2471,gcn2473,gcn2475,gcn2477,gcn2479,gcn2529,gcn2530,gcn2531,gcn2532,gcn2533,gcn2534,gcn2535,gcn2536,gcn2537,gcn2538,gcn2539,gcn2540,gcn2541,gcn2542,gcn2543,gcn2544,gcn2545,gcn2546,gcn2547,gcn2548,gcn2549,gcn2550,gcn2551,gcn2552,gcn2553,gcn2554,gcn2555,gcn2556,gcn2557,gcn2558,gcn2559,gcn2560"
#HOSTNAMES_LIST="gcn2529,gcn2532,gcn2535,gcn2538,gcn2541,gcn2544,gcn2547,gcn2550,gcn2553,gcn2556,gcn2559,gcn2530,gcn2533,gcn2536,gcn2539,gcn2542,gcn2545,gcn2548,gcn2551,gcn2554,gcn2557,gcn2531,gcn2534,gcn2537,gcn2540,gcn2543,gcn2546,gcn2549,gcn2552,gcn2555,gcn2558"
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

