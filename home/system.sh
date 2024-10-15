# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Override globalalias config
# space expands all aliases, including global
bindkey -M emacs "^ " globalias
bindkey -M viins "^ " globalias

# control-space to make a normal space
bindkey -M emacs " " magic-space
bindkey -M viins " " magic-space

# normal space during searches
bindkey -M isearch " " magic-space

# Determine shell extension
if [ -z $SHELL ]; then
    echo "SHELL not set"
    export SHELL=/usr/bin/zsh
    ext=$(basename ${SHELL});
else
    ext=$(basename ${SHELL});
fi

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
    alias ll='ls -lh'
    alias la='ls -a'
    alias l='ls'
    alias lla='ls -lha'
    alias ls='ls'
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

# Tecnalia T
alias mountT='sudo mount -t cifs //tri.lan/tri /mnt/T --verbose -o vers=3.0,username=110343,password=Bageera\#1983,workgroup=TRI.LAN'

# Dotfiles
alias dot='homeshick cd dotfiles && code . && cd -'
alias dev='cd ${HOME}/srcs/development_environment && code . && cd -'

# Remove all stoped containers
function pagegui() {
	project_name="$1"
    python3 ~/apps/page/page.py $project_name
}