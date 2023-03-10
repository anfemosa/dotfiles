###################################################################
# ROS aliases and functions
###################################################################

# Define ROS_DISTRO before source ROS on native OS
# if [ -z $ROS_DISTRO ]; then export ROS_DISTRO=noetic; fi
if [[ -z "${ROS_DISTRO}" ]]; then
    ROS_DIR=/opt/ros
    if [ -d "$ROS_DIR" ];
    then
        export ROS_DISTRO=$(basename $(find /opt/ros/* -maxdepth 0 -type d | head -1))
    else
        unset ROS_DISTRO
    fi
fi

# Determine shell extension
if [ -z $SHELL ]; then echo "SHELL not set"; else ext=$(basename ${SHELL}); fi

# Source rosmon
function smon(){
    if [[ -f "/opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}" ]]; then
        source /opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}
    fi
}

# cd to the root of the workspace
function roshome(){
    roscd && cd ..
    ROS_HOME=${PWD}
}

# Source the current workspace
function sourcews(){
    source ./devel/setup.${ext} && smon
}

# Source the current workspace
function sourceros(){
    source /opt/ros/${ROS_DISTRO}/setup.${ext} && smon
    ROS_HOME="/opt/ros/${ROS_DISTRO}/"
}

# Source the current workspace
function sourcethis(){
    pwd_st=${PWD}
    roshome && sourcews
    echo "Sourcing: ${ROS_HOME}"
    cd ${pwd_st}
}

# Automatic catkin build
function cb() {
    pwd_cb=${PWD}
    roshome
    catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release -- "$@"
    sourcethis
    cd ${pwd_cb}
}

# Clean workspace (delete the generated folders, then catkin build)
function cbclean(){
    roshome && rm -rf build devel install && catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release
}

# Initialize catkin workspace, configure and build it
function cib(){
    catkin init && catkin config --extend /opt/ros/${ROS_DISTRO} && catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release
}

# Run ci locally
function runci(){
    # check if exist .rosinstall file
    if [ -f ./.rosinstall ]; then
        echo ".rosinstall in package"
        find ../ -name run_ci -exec bash {} ROS_DISTRO="$@" DOCKER_IMAGE=tecnalia-robotics-docker.artifact.tecnalia.com/flexbotics-base-devel:"$@" UPSTREAM_WORKSPACE=.rosinstall \;
    else
        echo "No .rosinstall in package"
        find ../ -name run_ci -exec bash {} ROS_DISTRO="$@" DOCKER_IMAGE=tecnalia-robotics-docker.artifact.tecnalia.com/flexbotics-base-devel:"$@" \;
    fi
}

# if a new terminal starts in a ws, auto source it (useful for vscode)
if [ -z ${ROS_DISTRO+x} ]; then ;
else
    pwd_init=${PWD}
    cropped=${PWD#${HOME}/ros/${ROS_DISTRO}/}
    WS_name=${cropped%%/*}
    WS_path=${HOME}/ros/${ROS_DISTRO}/${WS_name}
    FILE=${WS_path}/devel/setup.${ext}
    # if PWD belongs to ROS ws then source it
    if [[ -f $FILE ]]; then
        cd ${WS_path}
        source $FILE
        cd ${pwd_init}
        ROS_HOME=${WS_path}
    else
        sourceros
    fi
fi

#alias sc=sourcethis