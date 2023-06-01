#!/bin/bash 

set -e

source ./set_env.sh

# args
if [ $# -eq 0 ]; then
    echo "Usage: $0 <ros_mfr_adaptor_version> <bag_file_name>"
    echo " e.g.: $0 maf3.2_0113 parking.bag"
    exit 1
fi
IMAGE_VERSION=$1
BAG_FILE=$2

function cleanup() {
    docker rm -f rosbag-play
}
trap cleanup EXIT

docker run --rm -dt --network host --ipc host --name rosbag-play \
  -e ROS_MASTER_URI=$ROS_MASTER_URI -e ROS_IP=$ROS_IP \
  -v `readlink -f all_adaptor.json`:/home/ros/catkin_ws/install/share/ros_mfr_adaptor/resource/all_adaptor.json \
  -v `readlink -f $BAG_FILE`:/home/ros/bag.bag \
  artifactory.momenta.works/docker-mpilot-highway-dev/ros_mfr_adaptor:$IMAGE_VERSION bash

docker exec -it rosbag-play bash -c 'source /opt/ros/kinetic/setup.bash ; rosbag play -l /home/ros/bag.bag'

