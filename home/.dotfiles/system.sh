# lsd
if command -v lsd &> /dev/null
then
    # Directories
    alias ll='lsd -lh --group-dirs=first'
    alias la='lsd -a --group-dirs=first'
    alias l='lsd --group-dirs=first'
    alias lla='lsd -lha --group-dirs=first'
    alias ls='lsd --group-dirs=first'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lla='ls -lha'
fi

# bat ==> cat
if command -v bat &> /dev/null
then
    # Files
    alias cat='bat'
fi

# Python
if command -v ipython &> /dev/null
then
    alias ipy='ipython'
fi

# Dotfiles
alias dot='homeshick cd dotfiles && code . && cd -'
alias dev='cd ${HOME}/devenv && code . && cd -'
alias notes='cd ${HOME}/ws_files && code . && cd -'
