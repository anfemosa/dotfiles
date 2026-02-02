# shellcheck shell=bash
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# shellcheck source=/dev/null
# shellcheck disable=SC2296
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # shellcheck disable=SC2296
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Clone antidote if necessary.
[[ -e ${ZDOTDIR:-$HOME}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"

# Source antidote.
source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"

# Load plugins definided at ~/.zsh_plugins.txt
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/apps:$PATH

# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

[ -f /usr/share/vcstool-completion/vcs.zsh ] &&  source /usr/share/vcstool-completion/vcs.zsh

fpath=("$HOME/.homesick/repos/homeshick/completions" "${fpath[@]}")
fpath=("$HOME/.zfunc" "${fpath[@]}")

autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

if command -v pypx &> /dev/null
then
    eval "$(register-python-argcomplete3 pipx)"
fi


# *********************
# zsh cache compdump
# *********************

# Create a cache folder if it isn't exists
if [ ! -d "$HOME/.cache/zsh" ]; then
    mkdir -p "$HOME/.cache/zsh"
fi

# Define a custom file for compdump
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"

# *********************
# command-line fuzzy finder
# *********************
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude \".git\" ."

# Set up fzf key bindings and fuzzy completion
# shellcheck source=/dev/null
source <(fzf --zsh)

# *********************
# User configuration
# *********************

export SHELL=/bin/zsh

# Include dotfiles
[ -f "$HOME/.homesick/repos/dotfiles/home/.init_shell" ] && source "$HOME/.homesick/repos/dotfiles/home/.init_shell"

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
[[ ! -f "$HOME/.homesick/repos/dotfiles/home/.p10k.zsh" ]] || source "$HOME/.homesick/repos/dotfiles/home/.p10k.zsh"

# Created by `pipx` on 2024-12-19 16:39:58
export PATH="$PATH:$HOME/.local/bin"

# opencode
export PATH=/home/pipe/.opencode/bin:$PATH

cursor() {
  (nohup /home/pipe/apps/Cursor-2.4.23-x86_64.AppImage --no-sandbox -g "$@" >/dev/null 2>&1 &)
}