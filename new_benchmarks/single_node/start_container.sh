CONFIGFOLDER=$1
DATAFOLDER=$2

FILENAME="../singularity_*.sif"
LOGSFOLDER="./bind_mounts/logs"
ENTRYPOINT="./bind_mounts/docker-entrypoint.sh"


if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# if logs folder does not exist, create it
mkdir -p $LOGSFOLDER

# clean up
rm -rf $DATAFOLDER/*
rm -rf $LOGSFOLDER/*

# required by elasticsearch
sysctl -w vm.max_map_count=262144

echo "test"
# start container
singularity run --bind $DATAFOLDER:/usr/share/elasticsearch/data,$LOGSFOLDER:/usr/share/elasticsearch/logs,$CONFIGFOLDER:/usr/share/elasticsearch/config,$ENTRYPOINT:/usr/local/bin/docker-entrypoint.sh $FILENAME
