# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/apps/antigen.zsh
antigen use oh-my-zsh

antigen theme romkatv/powerlevel10k

antigen bundle direnv
antigen bundle command-not-found
antigen bundle docker
antigen bundle git
antigen bundle globalias
antigen bundle last-working-dir
antigen bundle sudo
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle wfxr/forgit@main
antigen bundle paulirish/git-open
antigen bundle popstas/zsh-command-time
antigen bundle MichaelAquilina/zsh-auto-notify
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle atuinsh/atuin@main

antigen apply

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/apps:$PATH

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

[ -f /usr/share/vcstool-completion/vcs.zsh ] &&  source /usr/share/vcstool-completion/vcs.zsh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fpath=($HOME/.zfunc $fpath)

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

eval "$(register-python-argcomplete3 pipx)"

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
# command-line fuzzy finder
# *********************
# [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# if command -v fzf &> /dev/null
# then
#     source <(fzf --zsh)
# fi

# export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude \".git\" ."

# *********************
# User configuration
# *********************

export SHELL=/bin/zsh

# Include dotfiles
[ -f $HOME/.homesick/repos/dotfiles/home/.init_shell ] && source $HOME/.homesick/repos/dotfiles/home/.init_shell

# history options
setopt hist_ignore_all_dups

# Override globalalias config
# space expands all aliases, including global
bindkey -M emacs "^ " globalias
bindkey -M viins "^ " globalias

# control-space to make a normal space
bindkey -M emacs " " magic-space
bindkey -M viins " " magic-space

# normal space during searches
bindkey -M isearch " " magic-space

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.homesick/repos/dotfiles/home/.p10k.zsh ]] || source $HOME/.homesick/repos/dotfiles/home/.p10k.zsh

# Created by `pipx` on 2024-12-19 16:39:58
export PATH="$PATH:/home/TRI.LAN/110343/.local/bin"

[ -f  "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
if command -v atuin &> /dev/null
then
  eval "$(atuin init zsh)"
fi