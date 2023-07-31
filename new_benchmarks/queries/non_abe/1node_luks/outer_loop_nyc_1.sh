#!/bin/bash

# to sync the start without mpi
#if [ "$#" -ne 1 ]; then
#    echo "Give HH:MM:SS"
#    exit 1
#fi

HOSTNAME=$(hostname)
TIME_TO_START=$1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# SETTINGS TO PROPERLY SAVE THE RESULTS
CLUSTER_SIZE=1
ENCRYPTION_TYPE="luks"
BENCHMARK_TYPE="nyc"

QUERY=$2
RUN=$3

WORKERS=48

# Where we save
RESULT_PATH="../resultcurl/eth/${QUERY}/${RUN}/${BENCHMARK_TYPE}/${ENCRYPTION_TYPE}/${CLUSTER_SIZE}/"
mkdir -p $RESULT_PATH

echo "DEBUG" $RESULT_PATH



for ((i=0; i<$WORKERS; i++))
do
  ./benchmark_${BENCHMARK_TYPE}_${CLUSTER_SIZE}.sh $TIME_TO_START $QUERY > ${RESULT_PATH}/${HOSTNAME}_${i}.txt 2>&1 &
done
#wait
