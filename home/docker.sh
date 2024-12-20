# Path for Docker files
export dockerfiles_path=~/devenv/dockerfiles;

# docker common commands
# if command -v podman &> /dev/null
# then
#     alias docker="podman"
# fi

alias dim="docker images"
alias dpsa="docker ps -a"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dsp="docker system prune --all"
alias dimp="docker image prune"

# Build a docker image
# ToDo: SHELL and SHELL_PATH seem to be the same
# ToDo: build a base image devenv:ROS_DISTRO and use it to build the workspace images
function dockbuild(){
    local current_dir=$(pwd)

    # List of supported ROS distros
    local ros_list="kinetic melodic noetic foxy humble jazzy rolling"

    local ros_distro=$1

    # Check if the first argument is a valid ROS version
    if [[ ! " $ros_list " =~ .*\ $ros_distro\ .* ]]; then
        echo "${RED}ROS_DISTRO: ${ros_distro} not supported${NC}"

        # Exit with error
        cd $current_dir
        return 1
    fi

    if [ $# -lt 1 ]; then
        echo "${BLUE}dockbuild: Build a docker image for ROS"
        echo "Usage: dockbuild <ROS_DISTRO> [build_args]"
        echo "ROS_DISTRO: Ros distribution. e.g. melodic, noetic, humble, etc."
        echo "build_args:"
        echo "      --shell: shell to use in the container. e.g. bash or zsh"
        echo "      --ws: name of the workspace to install packages. e.g. neurondones"
        echo "      --force: force rebuild the image"
        echo "Whiout build_args, default shell: ${ext}${NC}"
        cd $current_dir
        return 1
    fi

    local shell=${ext}
    local shell_path="/bin/${ext}"
    local image_name="devenv:${ros_distro}"
    local target="--target devenv"

	cd $dockerfiles_path;

    local build_options="--build-arg ROS_DISTRO=${ros_distro}"
    local build_command="docker build"

    while [[ $# -gt 1 ]]; do
        local key="$2"
        case $key in
            --shell)
                shell="$3"
                case $shell in
                    bash|zsh)
                        ;;
                    *)
                        echo "${RED}SHELL: ${shell} not supported${NC}"

                        # Exit with error
                        cd $current_dir
                        return 1
                    ;;
                esac
                build_options="${build_options} --build-arg EXT_SHELL=${shell} --build-arg SHELL=${shell_path}"
                shift
                shift
                ;;
            --ws)
                local ws_packages="${3}_${ros_distro}.txt"
                build_options="${build_options} --build-arg PACKAGES=${ws_packages}"

                # Check if the image base devenv exist
                echo "${YELLOW}Checking if image $image_name exists${NC}"
                if [[ "$(docker images -q $image_name 2> /dev/null)" == "" ]]; then
                    echo "${RED}Image base $image_name does not exist. Building it...${NC}"
                    echo "${YELLOW}Building image $image_name${NC}"
                    build_command="docker build -t ${image_name} ${build_options} ${target} -f devenv.Dockerfile ."
                    echo "${YELLOW}${build_command}${NC}"
                    $(echo "$build_command")
                else
                    echo "${GREEN}Image $image_name exists${NC}"
                fi
                echo "${YELLOW}Building workspace extended image${NC}"
                image_name="${3}:${ros_distro}"
                target="--target workspace-extended"
                shift
                shift
                ;;
            --force)
                echo "${YELLOW}Force rebuild the image${NC}"
                build_options="${build_options} --no-cache"
                shift
                ;;
            --peak)
                echo "${YELLOW}Installing PeakCAN driver${NC}"
                build_options="${build_options} --build-arg PEAK_DRIVER=install"
                shift
                ;;
            --open3d)
                echo "${YELLOW}Installing Open3D driver${NC}"
                build_options="${build_options} --build-arg OPEN3D=install"
                shift
                ;;
            --conan)
                echo "${YELLOW}Installing Conan compiler${NC}"
                build_options="${build_options} --build-arg CONAN=install"
                shift
                ;;
            *)
                echo "${RED}build_args: ${key} not supported${NC}"

                # Exit with error
                cd $current_dir
                return 1
                ;;
        esac
    done
    # --format docker for podman
    build_command="docker build -t ${image_name} ${build_options} ${target} -f devenv.Dockerfile ."
    echo "${YELLOW}${build_command}${NC}"
    $(echo "$build_command")

    # Exit with success
    echo "${GREEN}Docker image for ${container_name} successfully built${NC}"
    cd $current_dir
    return 0
}

# Run container with rocker
# To share docker --volume /var/run/docker.sock:/var/run/docker.sock:ro
# To share video (usb-cam) --volume /dev/video0:/dev/video0
# To share pcan --volume /dev/pcanusb32:/dev/pcanusb32
# To share dev folder --volume /dev:/dev
function dockrun() {
    local current_dir=$(pwd)

    # List of supported ROS distros
    local ros_list="kinetic melodic noetic foxy humble jazzy rolling"

    local ros_distro=$1

    # Check if the first argument is a valid ROS version
    if [[ ! " $ros_list " =~ .*\ $ros_distro\ .* ]]; then
        echo "${RED}ROS_DISTRO: ${ros_distro} not supported${NC}"

        # Exit with error
        cd $current_dir
        return 1
    fi

    if [ $# -lt 1 ]; then
        echo "${BLUE}dockrun: Run a docker image for ROS"
        echo "Usage: dockrun <ROS_DISTRO> [options]"
        echo "ROS_DISTRO:"
        echo "      kinetic, melodic, noetic, foxy, humble, jazzy, or rolling"
        echo "Options:"
        echo "      --ws: path to workspace. e.g. odin_ws"
        echo "      --share: resource to share with the container, e.g. video, pcan or dev"
        echo "      --shell: shell to use in the container. By default zsh"
        echo "      --parse: parse_args to use in the container, e.g. --oyr-spacenav. By default none"
        echo "      --image: use an specific image. By default uses the ROS base image"
        echo "Examples:"
        echo "dockrun humble --ws mairon_ws"
        echo "dockrun noetic --ws neurondones_ws --share pcan"
        echo "dockrun humble --ws dummy_ws --share video --shell bash"
        echo "dockrun jazzy --ws mairon_ws --share video --shell zsh --parse --oyr-spacenav"
        echo "dockrun humble --ws neurondones_ws --share dev --shell zsh --image neurondones${NC}"

        # Exit with error
        cd $current_dir
        return 1
    fi

    local container_name="$ros_distro"
    local image="devenv:$ros_distro"
    local docker_shell=${ext}
    local workspace_base="${HOME}"
    local workspace="${workspace_base}"
    local resource_to_share=""
    local parse_args=""
    local run_options=""
    local run_message="Container name: ${container_name}"

    while [[ $# -gt 1 ]]; do
        local key="$2"

        case $key in
            --image)
                image="$3:${container_name}"
                run_message="${run_message}\nImage: ${image}"
                shift
                shift
                ;;
            --ws)
                local ws="$3"
                workspace="${workspace_base}/${ws}"
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
                local resource=$3
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
                        echo "${RED}Resource not supported: ${resource}${NC}"

                        # Exit with error
                        cd $current_dir
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
            *)
                echo "${RED}build_args: ${key} not supported${NC}"

                # Exit with error
                cd $current_dir
                return 1
                ;;
        esac
    done

    export ROS_WORKSPACE=${workspace}

    echo "${BLUE}${run_message}${NC}"

    # Check if the image exist
    if [[ "$(docker images -q $image 2> /dev/null)" == "" ]]; then
        # build the image
        echo "${RED}Docker image for ${image} does not exist. Building it...${NC}"

        dockbuild ${ros_distro} --shell ${docker_shell} --ws ${ws%_ws}
        if [[ $? -ne 0 ]]; then
            echo "${RED}Docker image for ${container_name} failed to build.${NC}"

            # Exit with error
            cd $current_dir
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
        local rocker_command="rocker --home --ssh --git --user --user-preserve-groups --privileged --nvidia --x11 --network host ${run_options} --name ${container_name} ${image} ${docker_shell}"
        echo "${YELLOW}${rocker_command}${NC}"
        $(echo "$rocker_command")
    fi

    # Exit with success
    cd $current_dir
    return 0
}

function dockexec() {
    local current_dir=$(pwd)

    if [ $# -lt 1 ]; then
        echo "${BLUE}dockexec: attach to a docker container for ROS"
        echo "Usage: dockexec <ROS_DISTRO> [options]"
        echo "ROS_DISTRO: Ros distribution. e.g. melodic, noetic, humble, etc."
        echo "options: "
        echo "      --ws: path to workspace. e.g. odin_ws"
        echo "      --shell: shell to use in the container. e.g. bash or zsh"
        echo "Example:"
        echo "dockexec noetic --ws neurondones_ws --shell bash${NC}"

        # Exit with error
        cd $current_dir
        return 1
    fi

    local container_name="$1"
    local workspace="${HOME}"
    local docker_shell=${ext}

    while [[ $# -gt 1 ]]; do
        local key="$2"

        case $key in
            --ws)
                workspace="$3"
                shift
                shift
                ;;
            --shell)
                docker_shell="$3"
                shift
                shift
                ;;
            *)
                echo "${RED}Unknown option: $2${NC}"

                # Exit with error
                cd $current_dir
                return 1
                ;;
        esac
    done

    # cd ${workspace}

    # Check if the container exist
    if [[ $(docker ps -aq -f name=${container_name}) ]]; then
        echo "${YELLOW}Container ${container_name} already running. Attach console to container.${NC}"
        echo "${BLUE}workspace: ${workspace}"
        echo "shell: ${docker_shell}${NC}"
        # Attach to container
        echo "${GREEN}docker exec -it ${container_name} ${docker_shell} -c \"cd ${workspace}; ${docker_shell}\"${NC}"
        docker exec -it ${container_name} ${docker_shell} -c "cd ${workspace}; ${docker_shell}"
    else
        # Launch container
        echo "${RED}Container ${1} does not exist.${NC}"

        # Exit with error
        cd $current_dir
        return 1
    fi

    # Exit with success
    cd $current_dir
    return 0
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

function cleancode() {
    if [ -d $HOME/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers ]; then
        rm -rf $HOME/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers
        echo "${BLUE}Removed ms-vscode-remote.remote-containers${NC}"
    fi
    if [ -d $HOME/.config/Code/User/workspaceStorage ]; then
        rm -rf $HOME/.config/Code/User/workspaceStorage
        echo "${BLUE}Removed workspaceStorage${NC}"
    fi
    if [ -d $HOME/.config/Code/Cache ]; then
        rm -rf $HOME/.config/Code/Cache
        echo "${BLUE}Removed code Cache${NC}"
    fi
    if [ -d $HOME/.config/Code/CachedData ]; then
        rm -rf $HOME/.config/Code/CachedData
        echo "${BLUE}Removed code CachedData${NC}"
    fi
}

# function runpythonsyntax(){
# 	rocker --home --name python_syntax tecnalia-docker-dev.artifact.tecnalia.com/docker:git
# }