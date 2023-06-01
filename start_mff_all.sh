# #!/bin/bash

# LOGDIR=logs/`date +%Y%m%d_%H%M%S`
# mkdir -p $LOGDIR
# rm -f logs/0
# ln -s `readlink -f $LOGDIR` logs/0

# START_DIR=`pwd`

# export SELF_IP=10.8.106.94
# export REMOTE_IP=10.8.106.94
# export ROS_IP=$SELF_IP
# export ROS_MASTER_URI=http://$REMOTE_IP:11311
# export MFR_IP=$SELF_IP
# export MFR_MASTER_URI=http://$REMOTE_IP:11300

# # kill all children when exit
# trap "trap - SIGTERM && kill -SIGTERM -$$" SIGINT SIGTERM EXIT

# function run {
#     # show command in yellow
#     echo -e "\033[33m$1\033[0m"
#     # run command in another shell
#     bash -c "$1" >$LOGDIR/$2.log 2>&1
#     # check return value, and show red if error
#     if [ $? -eq 0 ]; then
#         echo -e "\033[32m$2 finished\033[0m"
#     else
#         echo -e "\033[31m$2 error\033[0m"
#     fi
# }

# new_session() {
#     if tmux has-session -t ${NAME} > /dev/null 2>&1; then
#         echo "kill session:"${NAME}
#         tmux kill-session -t ${NAME}
#         sleep 5
#     fi
#     echo "start session:"${NAME}
#     tmux new-session -s ${NAME} -d
#     sleep 1
# }

# # NAME="mff_master"
# # new_session

# # start ros master
# # WINDOW_NAME="ros_master"
# # tmux rename-window -t ${NAME}:0 ${WINDOW_NAME}
# # tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'cd catkin_ws && source devel/setup.bash && roscore' roscore & sleep 1" C-m
# run "cd catkin_ws && source devel/setup.bash && roscore" roscore &
# sleep 1

# # start rosbridge_suite websocket server
# # run "cd catkin_ws && source devel/setup.bash && roslaunch rosbridge_server rosbridge_websocket.launch" rosbridge &
# # sleep 1

# # start mfr master
# run "bash start_mfrmaster.sh" mfrmaster &
# sleep 2
# # WINDOW_NAME="mfr_master"
# # tmux rename-window -t ${NAME}:1 ${WINDOW_NAME}
# # tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'bash start_mfrmaster.sh' mfrmaster & sleep 2" C-m

# # PROJECT_ROOT_DIR=mff/build/repo/devcar_with_cuda11.1/deploy

# # # start mffmain
# # run "cd $PROJECT_ROOT_DIR && source common/bash/mfr_setup.bash && cd modules/mff/script && bash run_mffmain.sh" mffmain &
# # sleep 1

# # start ros_mfr_adaptor
# run "cd catkin_ws && source devel/setup.bash && roslaunch ros_mfr_adaptor ros_mfr_adaptor.launch" ros_mfr_adaptor &
# sleep 1
# # WINDOW_NAME="ros_mfr_adaptor"
# # tmux rename-window -t ${NAME}:2 ${WINDOW_NAME}
# # tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'cd catkin_ws && source devel/setup.bash && roslaunch ros_mfr_adaptor ros_mfr_adaptor.launch' ros_mfr_adaptor & sleep 1" C-m

# # start mffviz_adaptor
# # run "cd catkin_ws && source devel/setup.bash && roslaunch mffviz_adaptor mffviz_adaptor.launch" mffviz_adaptor &
# # sleep 1

# #rosbag play -l /mffviz/viz:=/mff/mffviz_ -r 16 gear_p_apa_quit.bag od_dectection_pause.bag

# # wait for all
# wait
#!/bin/bash

LOGDIR=logs/`date +%Y%m%d_%H%M%S`
mkdir -p $LOGDIR
rm -f logs/0
ln -s `readlink -f $LOGDIR` logs/0

START_DIR=`pwd`

export SELF_IP=10.9.60.64
export REMOTE_IP=10.9.60.64
export ROS_IP=$SELF_IP
export ROS_MASTER_URI=http://$REMOTE_IP:11311
export MFR_IP=$SELF_IP
export MFR_MASTER_URI=http://$REMOTE_IP:11300

# kill all children when exit
trap "trap - SIGTERM && kill -SIGTERM -$$" SIGINT SIGTERM EXIT

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

new_session() {
    if tmux has-session -t ${NAME} > /dev/null 2>&1; then
        echo "kill session:"${NAME}
        tmux kill-session -t ${NAME}
        sleep 5
    fi
    echo "start session:"${NAME}
    tmux new-session -s ${NAME} -d
    sleep 1
}

# NAME="mff_master"
# new_session

# kill running ros and mfrmaster services
ros_pid=$(ps -ef | grep "roscore" | grep -v grep | awk '{print $2}')
if [[ $ros_pid != "" ]]; then
  echo "killing ROS..."
  kill $ros_pid
fi

mfr_pid=$(ps -ef | grep "start_mfrmaster.sh" | grep -v grep | awk '{print $2}')
if [[ $mfr_pid != "" ]]; then
  echo "killing MFR master..."
  kill $mfr_pid
fi

adaptor_pid=$(ps -ef | grep "ros_mfr_adaptor" | grep -v grep | awk '{print $2}')
if [[ $adaptor_pid != "" ]]; then
  echo "killing ROS to MFR adaptor..."
  kill $adaptor_pid
fi

# start ros master
# WINDOW_NAME="ros_master"
# tmux rename-window -t ${NAME}:0 ${WINDOW_NAME}
# tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'cd catkin_ws && source devel/setup.bash && roscore' roscore & sleep 1" C-m
run "cd catkin_ws && source devel/setup.bash && roscore" roscore &
sleep 1

# start mfr master
run "bash start_mfrmaster.sh" mfrmaster &
sleep 2
# WINDOW_NAME="mfr_master"
# tmux rename-window -t ${NAME}:1 ${WINDOW_NAME}
# tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'bash start_mfrmaster.sh' mfrmaster & sleep 2" C-m

# start ros_mfr_adaptor
run "cd catkin_ws && source devel/setup.bash && roslaunch ros_mfr_adaptor ros_mfr_adaptor.launch" ros_mfr_adaptor &
sleep 1
# WINDOW_NAME="ros_mfr_adaptor"
# tmux rename-window -t ${NAME}:2 ${WINDOW_NAME}
# tmux send-keys -t ${NAME}:${WINDOW_NAME} "run 'cd catkin_ws && source devel/setup.bash && roslaunch ros_mfr_adaptor ros_mfr_adaptor.launch' ros_mfr_adaptor & sleep 1" C-m

# wait for all
wait
