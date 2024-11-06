# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Determine shell extension
if [ -z $SHELL ]; then
    echo "SHELL not set"
    export SHELL=/bin/zsh
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

# Dotfiles
alias dot='homeshick cd dotfiles && code . && cd -'
alias dev='cd ${HOME}/devenv && code . && cd -'
