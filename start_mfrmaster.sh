#!/bin/bash 
# use this script only in x86 platform for playback or simulation
MFRPROTO_PATH=/home/ros/Downloads/catkin_ws/build/mfrproto/
MFRUNTIME_DIR_PATH=/home/ros/Downloads/catkin_ws/src/maf_common/thirdparty/mfr-release/.cmake/..

export MFRUNTIME_DYNAMIC_LIBRARY_PATH=${MFRPROTO_PATH}../:${MFRPROTO_PATH}../install/lib/:${MFRUNTIME_DIR_PATH}/lib/Linux-x86_64-gcc5.4/
export MFBAG_DYNAMIC_LIBRARY_PATH=${MFRPROTO_PATH}../thirdparty/mfbag:${MFRPROTO_PATH}../install/lib/:${MFRPROTO_PATH}../../devel/lib/
export LD_LIBRARY_PATH=${MFRPROTO_PATH}../:${MFRUNTIME_DIR_PATH}/lib/Linux-x86_64-gcc5.4/
export MFRUNTIME_BINARY_PATH=${MFRUNTIME_DIR_PATH}/tools/mfrtools/bin/Linux-x86_64-gcc5.4/
export MFBAG_PYTHON_PATH=${MFRUNTIME_DIR_PATH}/thirdparty/mfbag/python/
export MFRUNTIME_PYTHON_PATH=${MFRUNTIME_DIR_PATH}/python/
export LD_LIBRARY_PATH=${MFRPROTO_PATH}:${MFRUNTIME_DYNAMIC_LIBRARY_PATH}:${LD_LIBRARY_PATH}

${MFRUNTIME_BINARY_PATH}/mfrmaster -p 11300
