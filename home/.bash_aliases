# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# apt aliases
alias apti="sudo apt install"
alias aptu="sudo apt update"
alias aptg="sudo apt upgrade"
alias aptl="apt list --upgradable"
alias aptr="sudo apt remove --purge"
alias apts="apt-cache search"

#alias performance='sudo cpufreq-set -r -g performance ; cat /proc/cpuinfo | grep -i Mhz'

#alias rm='f() {echo Better try with rm-safe or trash-put.};f'
#alias rm='trash-put'
alias rm-safe='trash-put'

#alias cccmake='mkdir -p build && cd build && cmake .. ; notify-send --urgency=low "CMake finished" && make -j$(awk "BEGIN {printf \"%.0f\n\", $(nproc)*0.8}") ; notify-send --urgency=low "Compilation finished"'

#alias git-branch-fresh='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r'

# ROS
#alias catkinws='catkin locate --workspace $(pwd)'
#alias sc='source $(catkinws)/devel/setup.zsh'

# Docker
#alias docker_full_clean='docker rm -f $(docker ps -aq) ; docker rmi -f $(docker images -q)'
#alias docker_run_x11='docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'
#alias docker_run_ssh_auth='docker run -it --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent'
#alias docker_run_x11_ssh_auth='docker run -it --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'

# By file extension
#alias -s {md,adoc}='code'

# homeshick
alias hshick='homeshick'

# Flatkpak aliases
alias gimp="org.gimp.GIMP"
alias libreoffice="org.libreoffice.LibreOffice"

alias f-update="flatpak update"

alias sys-update="f-update ; \
                  aptu ; \
                  aptg ;"
