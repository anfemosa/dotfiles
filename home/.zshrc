# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source ~/apps/antigen.zsh
# antigen use oh-my-zsh

# antigen theme romkatv/powerlevel10k

# antigen bundle direnv
# antigen bundle command-not-found
# antigen bundle docker
# antigen bundle git
# antigen bundle globalias
# antigen bundle last-working-dir
# antigen bundle sudo
# antigen bundle zsh-users/zsh-history-substring-search
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle wfxr/forgit@main
# antigen bundle paulirish/git-open
# antigen bundle popstas/zsh-command-time
# antigen bundle MichaelAquilina/zsh-auto-notify
# antigen bundle MichaelAquilina/zsh-you-should-use
# antigen bundle zsh-users/zsh-autosuggestions
# antigen bundle atuinsh/atuin@main

# antigen apply

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/apps:$PATH

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

[ -f /usr/share/vcstool-completion/vcs.zsh ] &&  source /usr/share/vcstool-completion/vcs.zsh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fpath=($HOME/.zfunc $fpath)

# To solve complete command not found issue
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