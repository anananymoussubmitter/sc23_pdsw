#!/bin/bash

# Call it with
# ./scriptname ./path/to/your/Dockerfile
#
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


docker_filename="docker_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
singularity_filename="singularity_$(date +%Y-%m-%d_%H-%M-%S).sif"

docker save "$(sudo docker build -q -f Dockerfile .)" -o $docker_filename && \
singularity build $singularity_filename docker-archive://$docker_filename
