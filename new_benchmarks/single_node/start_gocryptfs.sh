hostname=$(hostname)
cfg="./cfg"

./start_container.sh $cfg "/data/gocryptfs/${hostname}"
