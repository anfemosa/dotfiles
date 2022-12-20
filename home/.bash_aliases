# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias apti="sudo aptitude install"
alias apts="aptitude search"

alias performance='sudo cpufreq-set -r -g performance ; cat /proc/cpuinfo | grep -i Mhz'

alias rm='echo "Better try with rm-safe or trash-put."; false'
alias rm-safe='trash-put'

#alias static_ip="sudo service network-manager stop ; \
#sudo ip link set dev eth0 down ; \
#sudo ip addr add 192.168.1.100/24 dev eth0 ; \
#sudo ip link set dev eth0 up ; \
#sudo ip route add default via 192.168.1.1 ; "

#alias eclipse="~/bin/eclipse/eclipse &"
#alias cmake_eclipse="cmake -G\"Eclipse CDT4 - Unix Makefiles\" -DCMAKE_ECLIPSE_GENERATE_SOURCE_PROJECT=TRUE"
alias cccmake='mkdir -p build && cd build && cmake .. ; notify-send --urgency=low "CMake finished" && make -j$(awk "BEGIN {printf \"%.0f\n\", $(nproc)*0.8}") ; notify-send --urgency=low "Compilation finished"'

alias git-branch-fresh='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r'

#alias devcontainer_pkg='curl -L "https://git.code.tecnalia.com/tecnalia_robotics-public/gitlab_templates/-/jobs/artifacts/master/raw/dot_devcontainer.tar.gz?job=deploy_devcontainer" | tar xz'
#alias devcontainer_pkg='cp -r ~/workspace/vscode_devcontainer/dot_devcontainer .devcontainer'
#alias devcontainer_ws='cp -r ~/workspace/vscode_devcontainer/dot_devcontainer_catkin_ws .devcontainer'

# ROS
#alias catkin_tools_eclipse='catkin build  --force-cmake -G"Eclipse CDT4 - Unix Makefiles"'
#alias cb='catkin build -j6 --cmake-args -DCMAKE_CXX_FLAGS=-w -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -Wno-dev -- &&  ~/bin/scripts/create_catkin_ws_compilation_database.py'
alias catkinws='catkin locate --workspace $(pwd)'
alias sc='source $(catkinws)/devel/setup.zsh'

# Docker
alias docker_full_clean='docker rm -f $(docker ps -aq) ; docker rmi -f $(docker images -q)'
alias docker_run_x11='docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'
alias docker_run_ssh_auth='docker run -it --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent'
alias docker_run_x11_ssh_auth='docker run -it --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'

# Vagrant
#alias vagrant_resume_all='vagrant global-status | awk "/saved/{print \$1}" | xargs -r -d "\n" -n 1 -- vagrant resume'
#alias vagrant_suspend_all='vagrant global-status | awk "/running/{print \$1}" | xargs -r -d "\n" -n 1 -- vagrant suspend'

# By file extension
alias -s {md,adoc}='code'

# Flatkpak aliases
#alias freecad="org.freecadweb.FreeCAD"
#alias vim="org.vim.Vim"
alias gimp="org.gimp.GIMP"
alias libreoffice="org.libreoffice.LibreOffice"
