# Path for Docker files
export dockerfiles_path=~/devenv/dockerfiles;

# docker common commands
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
    current_dir=$(pwd)

    # List of supported ROS distros
    ros_list="kinetic melodic noetic foxy humble jazzy rolling"

    ros_distro=$1
    
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

    shell=${ext}
    shell_path="/bin/${ext}"
    image_name="devenv:${ros_distro}"
    target="--target devenv"

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
                ws_packages="${3}_${ros_distro}.txt"
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
            *)
                echo "${RED}build_args: ${key} not supported${NC}"
                
                # Exit with error
                cd $current_dir
                return 1
                ;;
        esac
    done
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
    current_dir=$(pwd)

    # List of supported ROS distros
    ros_list="kinetic melodic noetic foxy humble jazzy rolling"

    ros_distro=$1
    
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

    container_name="$ros_distro"
    image="devenv:$1"
    docker_shell=${ext}
    workspace_base="${HOME}/ros/${container_name}"
    workspace="${workspace_base}"
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
                ws="$3"
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
        rocker_command="rocker --home --ssh --git --user --user-preserve-groups --privileged --nvidia --x11 --network host ${run_options} --name ${container_name} ${image} ${docker_shell}"
        echo "${YELLOW}${rocker_command}${NC}"
        $(echo "$rocker_command")
    fi

    # Exit with success
    cd $current_dir
    return 0
}

function dockexec() {
    current_dir=$(pwd)

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
            *)
                echo "${RED}Unknown option: $2${NC}"
                
                # Exit with error
                cd $current_dir
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

function cleandevc() {
    if [ -d /home/andres/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers]; then
        rm -rf /home/andres/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers
    fi
}

# function runpythonsyntax(){
# 	rocker --home --name python_syntax tecnalia-docker-dev.artifact.tecnalia.com/docker:git
# }