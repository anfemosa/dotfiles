# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# docker common commands
export dockerfiles_path=~/srcs/development_environment/dockerfiles;

alias dim="docker images"
alias dpsa="docker ps -a"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dsp="docker system prune --all"
alias dimp="docker image prune"

# Determine shell extension
if [ -z $SHELL ]; then
    echo "SHELL not set"
    export SHELL=/usr/bin/zsh
    ext=$(basename ${SHELL});
else
    ext=$(basename ${SHELL});
fi

# Build docker image
# usage: dockbuild {noetic, melodic}
function dockbuild(){
    current_dir=$(pwd)

    if [ $# -lt 1 ]; then
        echo "${BLUE}Usage: dockbuild <ROS_DISTRO> [build_args]"
        echo "ROS_DISTRO:"
        echo "      melodic, noetic, humble, etc."
        echo "build_args:"
        echo "      EXT_SHELL - zsh (default) or bash${NC}"
        return 1
    fi

	cd $dockerfiles_path;

    ros_distro=$1
    shell=${ext}
    shell_path="/usr/bin/zsh"

    if [[ $# -gt 1 ]]; then
        key=$2
        shell=$3
        if [[ $shell = "zsh" ]]; then
            shell_path="/usr/bin/zsh"
        elif [[ $shell = "bash" ]]; then
            shell_path="/bin/bash"
        else
            echo "SHELL_VERSION: ${shell} not supported"
            cd $current_dir
            return 1
        fi
    fi

    echo "${GREEN}Building ROS_DISTRO: ${ros_distro} with SHELL_VERSION: ${shell}${NC}"
    docker build -t devenv:${ros_distro} --build-arg ROS_DISTRO=${ros_distro} --build-arg EXT_SHELL=${shell} --build-arg SHELL=${shell_path} -f devenv.Dockerfile .
    cd $current_dir
}

# Run container with rocker
# To share docker --volume /var/run/docker.sock:/var/run/docker.sock:ro
# To share video (usb-cam) --volume /dev/video0:/dev/video0
# To share pcan --volume /dev/pcanusb32:/dev/pcanusb32
# To share dev folder --volume /dev:/dev
function dockrun() {
    current_dir=$(pwd)

    if [ $# -lt 1 ]; then
        echo "${BLUE}Usage: dockrun <ROS_DISTRO> [options]"
        echo "ROS_DISTRO:"
        echo "      melodic, noetic, humble, etc."
        echo "Options:"
        echo "      --ws: path to workspace. e.g. odin_ws"
        echo "      --share: resource to share with the container. e.g. /dev/video0, /dev/pcanusb32, /dev"
        echo "      --shell: shell to use in the container. By default zsh"
        echo "      --parse: parse_args to use in the container. By default none"
        echo "Examples:"
        echo "dockrun humble --ws mairon_ws"
        echo "dockrun noetic --ws neurondones_ws --share pcan"
        echo "dockrun melodic --ws odinrobot_ws --share video --shell bash${NC}"
        return 1
    fi

    container_name="$1"
    docker_shell=${ext}
    workspace="${HOME}/ros/${container_name}"
    resource_to_share=""
    parse_args=""

    while [[ $# -gt 1 ]]; do
        key="$2"

        case $key in
            --ws)
                workspace="${HOME}/ros/${container_name}/$3"
                shift
                shift
                ;;
            --shell)
                docker_shell="$3"
                shift
                shift
                ;;
            --share)
                resource=$3
                if [[ $resource = "video" ]]; then
                    resource_to_share="--volume /dev/video0:/dev/video0"
                elif [[ $resource = "pcan" ]]; then
                    resource_to_share="--volume /dev/pcanusb32:/dev/pcanusb32"
                elif [[ $resource = "dev" ]]; then
                    resource_to_share="--volume /dev:/dev"
                fi
                shift
                shift
                ;;
            --parse)
                parse_args="$3"
                shift
                shift
                ;;
            *)  # Unknown option
                echo "Unknown option: $2"
                return 1
                ;;
        esac
    done

    # Check if the image exist
    if [[ "$(docker images -q devenv:$container_name 2> /dev/null)" == "" ]]; then
        # build the image
        echo "${GREEN}Docker image for ${container_name} does not exist. Building...${NC}"
        echo "${YELLOW}dockbuild ${container_name} ${docker_shell}${NC}"
        if dockbuild ${container_name} ${docker_shell}; then
            echo "${GREEN}Docker image for ${container_name} successfully built.${NC}"
        else
            echo "${RED}Docker image for ${container_name} failed to build.${NC}"
            return 1
        fi
    fi

    cd $workspace

    # Check if the container exist
    if [[ $(docker ps -aq -f name=$container_name) ]]; then
        echo "Container ${container_name} already running. Attach console to container."
        # Attach to container
        docker exec -it ${container_name} bash -c "cd ${workspace} && ${docker_shell}"
    else
        echo "${GREEN}Container ${container_name} not running. Launching...${NC}"
        # Launch container
        rocker_command="rocker --home --ssh --git --user --privileged --nvidia ${resource_to_share} ${parse_args} --x11 --network host --name ${container_name} devenv:${container_name} ${docker_shell}"
        echo "${BLUE}Resource to share: ${resource_to_share}"
        echo "Workspace: ${workspace}"
        echo "Shell: ${docker_shell}"
        echo "Container name: ${container_name}"
        echo "Parse args: ${parse_args}${NC}"
        echo "${YELLOW}${rocker_command}${NC}"
        $(echo "$rocker_command")
    fi

    cd $current_dir
}

function dockexec() {
    if [ $# -lt 1 ]; then
        echo "${BLUE}Usage: dockexec <ROS_DISTRO> [workspace] [command]"
        echo "ROS_DISTRO:"
        echo "      melodic, noetic, humble, etc."
        echo "Example:"
        echo "dockexec noetic neurondones_ws roscore${NC}"
        return 1
    fi

    # Check if the image exist
    if [[ "$(docker images -q devenv:$1 2> /dev/null)" == "" ]]; then
        # build the image
        echo "${RED}Docker image for ${1} does not exist${NC}"
        return 1
    fi

    # Check if the container exist
    if [[ $(docker ps -aq -f name=$1) ]]; then
        # Attach to container
        if [ $# -lt 2 ]; then
            docker exec -it $1 bash -c "cd ${HOME}/ros/$1 && $ext"
        else
            docker exec -it $1 bash -c "cd ${HOME}/ros/$1/$2 && $ext"
        fi
    else
        # Launch container
        echo "${RED}Container for ${1} does not exist${NC}"
        return 1
    fi
}

# Remove all stoped containers
function drma() {
	drm $(docker ps -a -f status=exited -q)
}


# Remove all unused or dangling immages
function drmui(){
	drmi $(dim --filter "dangling=true" -q --no-trunc)
}

# Stop and remove
function dsr() {
	docker stop $1;
	docker rm $1
}

# function runpythonsyntax(){
# 	rocker --home --name python_syntax tecnalia-docker-dev.artifact.tecnalia.com/docker:git
# }
