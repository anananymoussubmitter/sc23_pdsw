hostname=$(hostname)
cfg="./hpc-configs/${hostname}"

cd /scratch-emmy/usr/anon/sc/new_benchmarks/multi_node

mkdir "/dev/shm/esdata"
chown -R elasticsearch:elasticsearch "/dev/shm/esdata"
./start_container.sh $cfg "/dev/shm/esdata"
