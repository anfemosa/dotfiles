# -----------------
# Zsh configuration
# -----------------

export SHELL=$(which zsh)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

#
# Cache
#

# Create a cache folder if it isn't exists
ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[ ! -d $ZSH_CACHE_DIR ] && mkdir -p $ZSH_CACHE_DIR/completion

# Define a custom file for compdump
export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS


#
# Input/output
#

zstyle ':zim:input' double-dot-expand yes

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

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

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

# *********************
# Completion options
# *********************

[ -f /usr/share/vcstool-completion/vcs.zsh ] &&  source /usr/share/vcstool-completion/vcs.zsh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fpath=($HOME/.zfunc $fpath)

# Initialize modules.
[ -f ${ZIM_HOME}/init.zsh ] && source ${ZIM_HOME}/init.zsh

# To solve complete command not found issue
autoload -U bashcompinit && bashcompinit
eval "$(register-python-argcomplete3 pipx)"
# Enable argcomplete for ROS 2 and colcon
if (( ${+commands[register-python-argcomplete3]} )); then
  eval "$(register-python-argcomplete3 ros2)"
  eval "$(register-python-argcomplete3 colcon)"
fi

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

# *********************
# User configuration
# *********************

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/apps:$PATH

# Include dotfiles
[ -f $HOME/.homesick/repos/dotfiles/home/.init_shell ] && source $HOME/.homesick/repos/dotfiles/home/.init_shell

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

[ -f  "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
if command -v atuin &> /dev/null
then
  eval "$(atuin init zsh)"
fi

(( ! ${+functions[p10k]} )) || p10k finalize