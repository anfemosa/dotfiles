###################################################################
# ROS aliases and functions
###################################################################

if [[ "${ROS_DISTRO}" == "noetic" || "${ROS_DISTRO}" == "melodic" || "${ROS_DISTRO}" == "kinetic" ]]; then
    export ROS_VERSION=1
else
    export ROS_VERSION=2
fi

# Enable colcon tools
if [[ "${ROS_VERSION}" -eq 2 ]]; then
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
function sc_rosmon(){
    if [[ "${ROS_VERSION}" -eq 1 ]]; then
        if [[ -f "/opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}" ]]; then
            source /opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.${ext}
        fi
    fi
}

# cd to the root of the workspace
function roshome(){
    cd ${ROS_HOME}
}

# Source the current workspace
function sc_ws(){
    local current_dir="$PWD"
    local workspace_dir=""
    local config_file=""

    if [[ "${ROS_VERSION}" -eq 1 ]]
    then
        config_file=devel/setup.${ext}
    else
        config_file=install/setup.${ext}
    fi

    # Subimos en los directorios para buscar el workspace de ROS
    while [[ "$current_dir" != "/" ]]; do
        # Revisar si estamos en un workspace de ROS[1-2]
        if [[ -f "$current_dir/$config_file" ]]; then
            workspace_dir="$current_dir"
            echo "${GREEN}Sourcing workspace: $current_dir/$config_file${NC}"
            source "$current_dir/$config_file" && sc_rosmon
            export ROS_HOME=$workspace_dir
            break
        fi
        # Subimos un nivel de directorio
        current_dir="$(dirname "$current_dir")"
    done

    if [[ "$workspace_dir" == "/" ]]; then
        echo "${RED}Not in a workspace!${NC}"
    fi
}

alias sc=sc_ws

# Source the ros base installation
function sc_ros(){
    source /opt/ros/${ROS_DISTRO}/setup.${ext}
    # In ROS 1 source rosmon
    if [[ "${ROS_VERSION}" -eq 1 ]]
    then
        sc_rosmon
    fi
}

# Automatic catkin build
function cb() {
    pwd_cb=$(pwd)
    roshome

    if [[ "${ROS_VERSION}" -eq 1 ]]
    then
        catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release -- "$@"
    else
        colcon build --parallel-workers 6 "$@"
    fi

    sc_ws
    cd ${pwd_cb}
}

# Clean the workspace by deleting the generated folders (build, log, devel/install).
function clean_ws(){
    pwd_cb=$(pwd)
    if [[ "${ROS_VERSION}" -eq 1 ]]
    then
        roshome && rm -rf build devel install
    else
        roshome && rm -rf build log install
    fi
    cd ${pwd_cb}
}

# Clean workspace (delete the generated folders) then build ws
function cbclean(){
    clean_ws && cb "$@"
}

# Initialize catkin workspace, configure and build it
function cib(){
    if [[ "${ROS_VERSION}" -eq 1 ]]
    then
        catkin init && catkin config --extend /opt/ros/${ROS_DISTRO} && catkin build --summarize --cmake-args -DCMAKE_BUILD_TYPE=Release
    fi
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

# Check if ROS_DISTRO is set.
if [[ -z "${ROS_DISTRO}" ]]; then
    ROS_DIR=/opt/ros
    if [ -d "${ROS_DIR}" ];
    then
        export ROS_DISTRO=$(basename $(find /opt/ros/* -maxdepth 0 -type d | head -1))
        #echo "ROS_DISTRO set to ${ROS_DISTRO}"
    else
        unset ROS_DISTRO
        #echo "${YELLOW}ROS is not installed.${NC}"
    fi
else
    sc_ws
fi

alias resetROS='ros2 daemon stop && ros2 daemon start'