# Path for Docker files
export dockerfiles_path=~/srcs/development_environment/dockerfiles;

# docker common commands
alias dim="docker images"
alias dpsa="docker ps -a"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dsp="docker system prune --all"
alias dimp="docker image prune"

# Auto determine shell extension
if [ -z $SHELL ]; then
    echo "${RED}SHELL not set${NC}"
    export SHELL=/bin/zsh
    ext=$(basename ${SHELL});
else
    ext=$(basename ${SHELL});
fi

# Build a docker image
function dockbuild(){
    current_dir=$(pwd)

    if [ $# -lt 1 ]; then
        echo "${BLUE} dockbuild: Build a docker image for ROS"
        echo "Usage: dockbuild <ROS_DISTRO> [build_args]"
        echo "ROS_DISTRO: Ros distribution. e.g. melodic, noetic, humble, etc."
        echo "build_args:"
        echo "      --shell: shell to use in the container. e.g. bash or zsh"
        echo "      --ws: file name with packages to install in the workspace. e.g. neurondones_humble.txt"
        echo "      --force: force rebuild the image"
        echo "Whiout build_args, default shell: ${ext}${NC}"
        return 1
    fi

    ros_distro=$1
    shell=${ext}
    shell_path="/bin/${ext}"

	cd $dockerfiles_path;

    build_options="--build-arg ROS_DISTRO=${ros_distro}"

    while [[ $# -gt 1 ]]; do
        key="$2"
        case $key in
            --shell)
                shell="$3"
                case $shell in
                    bash|zsh)
                        ;;
                    *)
                        echo "${RED}SHELL: ${shell} not supported${NC}"
                        cd $current_dir
                        return 1
                    ;;
                esac
                build_options="${build_options} --build-arg EXT_SHELL=${shell} --build-arg SHELL=${shell_path}"
                shift
                shift
                ;;
            --ws)
                ws_packages="${3}"
                build_options="${build_options} --build-arg PACKAGES=${ws_packages}"
                shift
                shift
                ;;
            --force)
                echo "${YELLOW}Force rebuild the image${NC}"
                build_options="${build_options} --no-cache"
                shift
                ;;
            *)
                echo "${RED}build_args: ${key} not supported${NC}"
                return 1
                ;;
        esac
    done
    build_command="docker build -t devenv:${ros_distro} ${build_options} -f devenv.Dockerfile ."
    echo "${YELLOW}${build_command}${NC}"
    $(echo "$build_command")
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
        echo "${BLUE} dockrun: Run a docker image for ROS"
        echo "Usage: dockrun <ROS_DISTRO> [options]"
        echo "ROS_DISTRO:"
        echo "      melodic, noetic, humble, jazzy,etc."
        echo "Options:"
        echo "      --ws: path to workspace. e.g. odin_ws"
        echo "      --share: resource to share with the container, e.g. video, pcan or dev"
        echo "      --shell: shell to use in the container. By default zsh"
        echo "      --parse: parse_args to use in the container, e.g. --oyr-spacenav. By default none"
        echo "      --image: use an specific image. By default uses the ROS base image"
        echo "Examples:"
        echo "dockrun humble --ws mairon_ws"
        echo "dockrun noetic --ws neurondones_ws --share pcan"
        echo "dockrun melodic --ws odinrobot_ws --share video --shell bash${NC}"
        return 1
    fi

    container_name="$1"
    image="devenv:$1"
    docker_shell=${ext}
    workspace="${HOME}/ros/${container_name}"
    resource_to_share=""
    parse_args=""
    run_options=""
    run_message="Container name: ${container_name}"

    while [[ $# -gt 1 ]]; do
        key="$2"

        case $key in
            --image)
                image="$3:${container_name}"
                run_message="${run_message}\nImage: ${image}"
                shift
                shift
                ;;
            --ws)
                workspace="${HOME}/ros/${container_name}/$3"
                run_message="${run_message}\nWorkspace: ${workspace}"
                shift
                shift
                ;;
            --shell)
                docker_shell="$3"
                run_message="${run_message}\nShell: ${docker_shell}"
                shift
                shift
                ;;
            --share)
                resource=$3
                case $resource in
                    video)
                        resource_to_share="${resource_to_share} --volume /dev/video0:/dev/video0"
                        ;;
                    pcan)
                        resource_to_share="${resource_to_share} --volume /dev/pcanusb32:/dev/pcanusb32"
                        ;;
                    dev)
                        resource_to_share=" --volume /dev:/dev"
                        ;;
                    *)
                        echo "Resource not supported: ${resource}"
                        return 1
                        ;;
                esac
                run_message="${run_message}\nResource to share: ${resource_to_share}"
                run_options="${run_options} ${resource_to_share}"
                shift
                shift
                ;;
            --parse)
                parse_args=" $3"
                run_message="${run_message}\nParse args: ${parse_args}"
                run_options="${run_options} ${parse_args}"
                shift
                shift
                ;;
            *)  # Unknown option
                echo "Unknown option: $2"
                return 1
                ;;
        esac
    done

    export ROS_WORKSPACE=${workspace}

    echo "${BLUE}${run_message}${NC}"

    # Check if the image exist
    if [[ "$(docker images -q $image 2> /dev/null)" == "" ]]; then
        # build the image
        echo "${GREEN}Docker image for ${container_name} does not exist. Building...${NC}"
        echo "${YELLOW}dockbuild ${container_name} ${docker_shell}${NC}"
        if dockbuild ${container_name} --shell ${docker_shell}; then
            echo "${GREEN}Docker image for ${container_name} successfully built.${NC}"
        else
            echo "${RED}Docker image for ${container_name} failed to build.${NC}"
            return 1
        fi
    fi

    cd $workspace

    # Check if the container exist
    if [[ $(docker ps -aq -f name=$container_name) ]]; then
        echo "${YELLOW}Container ${container_name} already running. Attach console to container.${NC}"
        # Attach to container
        docker exec -it ${container_name} bash -c "cd ${workspace} && ${docker_shell}"
    else
        echo "${GREEN}Container ${container_name} not running. Launching...${NC}"
        # Launch container
        rocker_command="rocker --home --ssh --git --user --user-preserve-groups --privileged --nvidia --x11 --network host ${run_options} --name ${container_name} ${image} ${docker_shell}"
        echo "${YELLOW}${rocker_command}${NC}"
        $(echo "$rocker_command")
    fi

    cd $current_dir
}

function dockexec() {
    current_dir=$(pwd)

    if [ $# -lt 1 ]; then
        echo "${BLUE} dockexec: attach to a docker container for ROS"
        echo "Usage: dockexec <ROS_DISTRO> [options]"
        echo "ROS_DISTRO: Ros distribution. e.g. melodic, noetic, humble, etc."
        echo "options: "
        echo "      --ws: path to workspace. e.g. odin_ws"
        echo "      --shell: shell to use in the container. e.g. bash or zsh"
        echo "Example:"
        echo "dockexec noetic --ws neurondones_ws --shell bash${NC}"
        return 1
    fi

    container_name="$1"
    workspace="${HOME}/ros/${container_name}"
    docker_shell=${ext}

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
            *)  # Unknown option
                echo "Unknown option: $2"
                return 1
                ;;
        esac
    done

    cd ${workspace}

    # Check if the container exist
    if [[ $(docker ps -aq -f name=${container_name}) ]]; then
        echo "${YELLOW}Container ${container_name} already running. Attach console to container.${NC}"
        echo "${BLUE}workspace: ${workspace}"
        echo "shell: ${docker_shell}${NC}"
        # Attach to container
        echo "${GREEN}docker exec -it ${container_name} ${docker_shell}${NC}"
        docker exec -it ${container_name} ${docker_shell} -c "sc"
    else
        # Launch container
        echo "${RED}Container ${1} does not exist${NC}"
        cd $current_dir
        return 1
    fi

    cd $current_dir
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