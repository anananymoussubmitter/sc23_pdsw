#!/bin/bash

cd /scratch-emmy/usr/gzadmhno/sc/new_benchmarks/multi_node

hostname=$(hostname)
cfg="./hpc-configs/${hostname}"


mkdir "/data/gocryptfs/${hostname}"
chown -R elasticsearch:elasticsearch "/data/gocryptfs/${hostname}"
./start_container.sh $cfg "/data/gocryptfs/${hostname}"
