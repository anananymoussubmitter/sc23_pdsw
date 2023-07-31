hostname=$(hostname)
cfg="./cfg"

mkdir "/scratch-emmy/usr/anon/sc/plain/${hostname}"
#chown -R elasticsearch:elasticsearch "/scratch-emmy/usr/anon/sc/plain"
./start_container.sh $cfg "/scratch-emmy/usr/anon/sc/plain/${hostname}"
#./start_container.sh $cfg "/scratch/users/anon/plain/${hostname}"
#./start_container.sh $cfg "./data"
