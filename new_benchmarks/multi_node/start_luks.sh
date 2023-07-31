#!/bin/bash

cd /scratch-emmy/usr/gzadmhno/sc/new_benchmarks/multi_node

hostname=$(hostname)
cfg="./hpc-configs/${hostname}"

chown -R elasticsearch:elasticsearch /data/esluks
./start_container.sh $cfg "/data/esluks"
