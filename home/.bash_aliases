# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# apt aliases
alias f-update="flatpak update"

alias apti="sudo apt install -y"
alias aptu="sudo apt update"
alias aptg="sudo apt upgrade -y"
alias aptl="apt list --upgradable"
alias aptr="sudo apt remove --purge"
alias apts="apt-cache search"

alias supdate="f-update ; \
                aptu ; \
                aptg ;"

alias rm='trash-put'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
