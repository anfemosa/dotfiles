
if command -v lsd &> /dev/null
then
    # Directories
    alias ll='lsd -lh --group-dirs=first'
    alias la='lsd -a --group-dirs=first'
    alias l='lsd --group-dirs=first'
    alias lla='lsd -lha --group-dirs=first'
    alias ls='lsd --group-dirs=first'
else
    alias ll='ls -lh'
    alias la='ls -a'
    alias l='ls'
    alias lla='ls -lha'
    alias ls='ls'
fi

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

alias mountT='sudo mount -t cifs //tri.lan/tri /mnt/T --verbose -o username=110343,password=Bageera\#1983,workgroup=TRI.LAN'
