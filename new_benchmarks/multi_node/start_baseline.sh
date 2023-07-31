hostname=$(hostname)
cfg="./hpc-configs/${hostname}"

cd /scratch-emmy/usr/gzadmhno/sc/new_benchmarks/multi_node

mkdir "/scratch-emmy/usr/gzadmhno/sc/plain/${hostname}"
chown -R elasticsearch:elasticsearch "/scratch-emmy/usr/gzadmhno/sc/plain/${hostname}"
./start_container.sh $cfg "/scratch-emmy/usr/gzadmhno/sc/plain/${hostname}"
