#zmodload zsh/zprof

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/apps:$PATH
export PATH=$HOME/apps/xela_server:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

source ~/apps/antigen.zsh
antigen use oh-my-zsh

antigen theme romkatv/powerlevel10k

antigen bundle docker
antigen bundle git
antigen bundle globalias
antigen bundle last-working-dir
antigen bundle sudo
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle wfxr/forgit
antigen bundle paulirish/git-open
antigen bundle popstas/zsh-command-time
antigen bundle MichaelAquilina/zsh-auto-notify
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

# *********************
# command-line fuzzy finder
# *********************
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude \".git\" ."

# *********************
# zsh cache compdump
# *********************

# Create a cache folder if it isn't exists
if [ ! -d "$HOME/.cache/zsh" ]; then
    mkdir -p $HOME/.cache/zsh
fi

# Define a custom file for compdump
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"

# *********************
# User configuration
# *********************

# Use code as default editor
export EDITOR="code -r"

source $HOME/.init_shell

# Include dotfiles
source "$HOME/.homesick/repos/dotfiles/home/system.sh"
source "$HOME/.homesick/repos/dotfiles/home/git.sh"
source "$HOME/.homesick/repos/dotfiles/home/docker.sh"
source "$HOME/.homesick/repos/dotfiles/home/ros.sh"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#zprof
