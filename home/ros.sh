###################################################################
# ROS aliases and functions
###################################################################

if [[ "${ROS_DISTRO}" == "noetic" || "${ROS_DISTRO}" == "melodic" ]]; then
    export ROS_VERSION=1
else
    export ROS_VERSION=2
fi

# Enable colcon tools
if [[ "${ROS_VERSION}" = 2 ]]; then
    # Quick directory change
    if [[ -f "/usr/share/colcon_cd/function/colcon_cd.sh" ]]; then
        source /usr/share/colcon_cd/function/colcon_cd.sh
    fi
    # Completion
    if [[ -f "/usr/share/colcon_argcomplete/hook/colcon-argcomplete.${ext}" ]]; then
        source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.${ext}
    fi
fi

# Source rosmon
function smon(){
    if [[ ${ROS_VERSION} = 1 ]]; then
        if [[ -f "/opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}" ]]; then
            source /opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}
        else
            echo "rosmon not found."
        fi
    fi
}

# cd to the root of the workspace
function roshome(){
    if [ "${ROS_VERSION}" = 1 ]
    then
        if command -v roscd &> /dev/null
        then
            roscd && cd ..
            export ROS_HOME=$(pwd)
        else
            echo "command ** roscd ** not found"
        fi
    else
        if command -v colcon_cd &> /dev/null
        then
            colcon_cd
        else
            echo "command ** colcon_cd ** not found"
        fi
    fi
}

# Source the current workspace
function sourcews(){
    current_dir=$(pwd)
    cropped=${PWD#${HOME}/ros/${ROS_DISTRO}/}
    ws_name=${cropped%%/*}
    ws_path=${HOME}/ros/${ROS_DISTRO}/${ws_name}

    if [ "${ROS_VERSION}" = 1 ]
    then
        FILE=${ws_path}/devel/setup.${ext}
    else
        FILE=${ws_path}/install/setup.${ext}
    fi

    # if PWD belongs to ROS workspace then source it
    if [[ -f $FILE ]]; then
        cd ${ws_path}
        echo "${GREEN}Sourcing workspace: ${FILE}${NC}"
        source $FILE && smon
        cd ${current_dir}
        export ROS_HOME=${ws_path}
    else
        echo "${RED}Workspace not found: ${FILE}${NC}"
    fi
}

# Source the current workspace
function sourceros(){
    source /opt/ros/${ROS_DISTRO}/setup.${ext}
    export ROS_HOME="/opt/ros/${ROS_DISTRO}/"
    # In ROS 1 source rosmon
    if [ "${ROS_VERSION}" = 1 ]
    then
        smon
    fi
}

# Automatic catkin build
function cb() {
    pwd_cb=$(pwd)
    if [ "${ROS_VERSION}" = 1 ]
    then
        roshome
        catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release -- "$@"
    else
        colcon build --parallel-workers 6 "$@"
    fi

    sourcews
    cd ${pwd_cb}
}

# Clean workspace (delete the generated folders, then catkin build)
function cbclean(){
    if [ "${ROS_VERSION}" = 1 ]
    then
        roshome && rm -rf build devel install && catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release
    else
        rm -rf build log install && cb "$@"
    fi
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

alias sc=sourcews

# Check if ROS_DISTRO is set.
if [[ -z "${ROS_DISTRO}" ]]; then
    ROS_DIR=/opt/ros
    if [ -d "$ROS_DIR" ];
    then
        export ROS_DISTRO=$(basename $(find /opt/ros/* -maxdepth 0 -type d | head -1))
        #echo "ROS_DISTRO set to ${ROS_DISTRO}"
    else
        unset ROS_DISTRO
        #echo "${YELLOW}ROS is not installed.${NC}"
    fi
else
    sourcews
fi