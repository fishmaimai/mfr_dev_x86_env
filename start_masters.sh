#!/bin/bash 

set -e

LOGDIR=logs/`date +%Y%m%d_%H%M%S`
mkdir -p $LOGDIR
rm -f logs/0
ln -s `readlink -f $LOGDIR` logs/0

source ./set_env.sh

# args
if [ $# -eq 0 ]; then
    echo "Usage: $0 <ros_mfr_adaptor_version>"
    echo " e.g.: $0 maf3.2_0113"
    exit 1
fi
IMAGE_VERSION=$1

# kill all children when exit
function cleanup() {
    echo "cleaning up..."
    docker stop -t 0 ros_mfr_adaptor
    wait
}
trap cleanup EXIT

function run {
    # show command in yellow
    echo -e "\033[33m$1\033[0m"
    # run command in another shell
    bash -c "$1" >$LOGDIR/$2.log 2>&1
    # check return value, and show red if error
    if [ $? -eq 0 ]; then
        echo -e "\033[32m$2 finished\033[0m"
    else
        echo -e "\033[31m$2 error\033[0m"
    fi
}

docker run --rm -dt --network host --ipc host --name ros_mfr_adaptor \
  -e ROS_MASTER_URI=$ROS_MASTER_URI -e ROS_IP=$ROS_IP \
  -e MFR_MASTER_URI=$MFR_MASTER_URI -e MFR_IP=$ROS_IP \
  -v `readlink -f all_adaptor.json`:/home/ros/catkin_ws/install/share/ros_mfr_adaptor/resource/all_adaptor.json \
  artifactory.momenta.works/docker-mpilot-highway-dev/ros_mfr_adaptor:$IMAGE_VERSION bash

# start ros master
run "docker exec -t ros_mfr_adaptor bash -c 'source /home/ros/catkin_ws/install/setup.bash && roscore'" roscore &
sleep 1

# start mfr master
run "docker exec -t ros_mfr_adaptor bash -c 'cd /home/ros/catkin_ws && source install/mfr_setup.bash && shopt -s expand_aliases; python3 "'$'"{MFRUNTIME_DIR_PATH}/tools/mfrtools/script/mfrmaster/mfrmaster.py'" mfrmaster &
sleep 1

# start ros_mfr_adaptor
run "docker exec -t ros_mfr_adaptor bash -c 'source ~/.bashrc && roslaunch ros_mfr_adaptor all_adaptor.launch'" ros_mfr_adaptor &
sleep 1

wait

