COORDINATOR_NODE=10.241.130.145
OWN_HOSTNAME=$(hostname)
OWN_IP=$(getent hosts ${OWN_HOSTNAME} | awk '{ print $1 }')

/scratch-emmy/usr/anon/sc/Python/bin/esrallyd start --node-ip=${OWN_IP} --coordinator-ip=${COORDINATOR_NODE}
