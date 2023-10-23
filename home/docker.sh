# docker common commands
export dockerfiles_DIR=~/srcs/development_environment/dockerfiles;

alias dim="docker images"
alias dpsa="docker ps -a"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dsp="docker system prune --all"
alias dimp="docker image prune"

# Build docker image
# usage: dockbuild {noetic, melodic}
function dockbuild(){
    if [ $# -lt 1 ]; then
        echo "Usage: dockbuild <ROS_DISTRO> [build_args]"
        echo "build_args:"
        echo "      EXT_SHELL - zsh (default) or bash"
        return 1
    fi

	cd $dockerfiles_DIR;

    if [ $# -lt 2 ]; then
        echo "Building ROS_DISTRO:"$1 "with SHELL_VERSION: zsh"
        docker build -t devenv:$1 --build-arg ROS_DISTRO=$1 --build-arg EXT_SHELL="zsh" -f devenv.Dockerfile .
    else
        if [ $2 = "bash" ]; then
            echo "Building ROS_DISTRO:"$1 "with SHELL_VERSION:"$2
            docker build -t devenv:$1 --build-arg ROS_DISTRO=$1 --build-arg EXT_SHELL=$2 -f devenv.Dockerfile .
        else
            echo "SHELL_VERSION:"$2 "not supported"
        fi
    fi
}

# Run container with rocker
# usage: rundock {noetic, melodic} [{remodel_ws, odin_ws}] [cmd]
# ToDo Add extra parameters by arg
# To share docker --volume /var/run/docker.sock:/var/run/docker.sock:ro
# To share video (usb-cam) --volume /dev/video0:/dev/video0
function dockrun() {
    # Check if the image exist
    if [[ "$(docker images -q devenv:$1 2> /dev/null)" == "" ]]; then
        # build the image
        dockbuild $1
    fi

    # Check if the container exist
    if [[ $(docker ps -aq -f name=$1) ]]; then
        # Attach to conayiner
        docker exec -it $1 bash -c "cd ~/ros/$1/$2 && $ext"
    else
        # Launch container
        cd ~/ros/$1/$2;
        rocker --home --ssh --git --user --privileged --nvidia --x11 --network host --name $1 devenv:$1 $3
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

# function runremodel() {
# 	rocker --x11 --nvidia --privileged --network=host --name remodel_docker --oyr-run-arg " -v iiwa_state_recorder:/home/remodel/iiwa_state_recorder -v /home/andres/test/remodel_shared:/home/remodel/remodel_shared" -- remodel_app:melodic bash -c "'roslaunch remodel_app remodel_app.launch use_sim:=true docker:=true skill_manager:=true collision_detector:=true ui:=true cad:=true joystick:=false'"
# }

# function docrun() {
# 	rocker --nvidia --pulse --x11 --volume /dev/video0:/dev/video0 --privileged --oyr-run-arg " -v odin_robot_volume:/root/" --name odin_robot --network host odin_robot:melodic $1
# }

# function runodin() {
# 	rocker --nvidia --pulse --x11 --privileged --volume /dev/video0:/dev/video0 --name odin_melodic --network host devenv:melodic $1
# }

#DOCKER
alias dexec='f(){ docker exec -w /root/ --detach-keys="ctrl-@" -e DISPLAY=$DISPLAY -it $1  /bin/bash -c "terminator --no-dbus";  unset -f f; }; f'
alias dexec_nt='f(){ docker exec --detach-keys="ctrl-@" -e DISPLAY=$DISPLAY -it $1  /bin/bash ;  unset -f f; }; f'
alias dstart='f(){ docker start $1; dexec $1;  unset -f f; }; f'
# Run using same X and .ssh folder
alias drun='f(){ docker run -it -e DISPLAY=$DISPLAY --detach-keys="ctrl-@" -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.ssh:/root/.ssh:ro -v ~/docker_share/:/root/docker_share/ --net=host --name $2 $1; unset -f f; }; f'
alias drun_nvidia='f(){ docker run -it --name $2 --privileged \
    --net=host \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --env=DISPLAY \
    --env=QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all \
    --device /dev/snd \
    -e NVIDIA_VISIBLE_DEVICES=0 \
    --detach-keys="ctrl-@" \
    -v ~/.ssh:/root/.ssh:ro \
    -v ~/docker_share/:/root/docker_share/ \
    $1 /bin/bash; unset -f f; }; f'
