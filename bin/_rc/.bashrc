#!/bin/bash
#set -x
#export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) bind 'set enable-bracketed-paste off' ;;
      *) return;;
esac

[ -z "$PS1" ] && return
# shellcheck source=./.bashps1
source ~/.bashps1

#see https://sanctum.geek.nz/arabesque/better-bash-history/
# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -s lithist

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
export HISTCONTROL=$HISTCONTROL:ignorespace:ignoredups
export HISTTIMEFORMAT='%F %T '

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE='bg:fg:history'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# shellcheck source=./.bash_aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_tokens ] && source ~/.bash_tokens
#[ -f ~/.bash_k8s ] && source ~/.bash_k8s

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source ~/.bash_complete || echo "Issue in ~/.bash_complete"

export EDITOR=/usr/bin/mcedit
[ -f ~/.bash_bin ]   && source ~/.bash_bin
[ -f ~/.bash_local ] && source ~/.bash_local
PATH="$PATH:$HOME/bin:$HOME/.local/bin"
export PATH

_wttr()
{
    # change Paris to your default location
#    local L="${LANG%_*}"
    local l=uk

    local debug=${1:-0};  [ $# -eq 0 ] || shift
    local loc=${1:-Sumy}; [ $# -eq 0 ] || shift
    local params=${1:-};  [ $# -eq 0 ] || shift
    [ "$params" != 0 ] && params="?$params"

    echo
    cmd="curl -fGsS -H 'Accept-Language: $l' 'wttr.in/$loc$params'"
    [ "$debug" != 0 ] && echo "$cmd"
    eval "$cmd"
}

wttr() {
    local debug=${1:-1}
    local city=Sumy
    echo
    echo "curl -fGsS -H 'Accept-Language: uk' 'wttr.in/:help'"
    echo "_wttr $debug 'moon' 'F'"
    echo "_wttr 1 '$city' 'M1&F'"
    echo "_wttr $debug '$city' 'M3&QF'"
    echo "_wttr $debug '$city' 'format=v2&F'"
#    _wttr 0 "$city" "M1&QFn"
#    _wttr $debug '$city' 'format=v2&F'
}
env | grep -q 'INTELLIJ_TERMINAL_'  || wttr 0

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#remove dublicated paths
WHICH=/usr/bin/which
CMD_env=$($WHICH env)
CMD_grep=$($WHICH grep)
CMD_cut=$($WHICH cut)
CMD_tr=$($WHICH tr)
CMD_awk=$($WHICH awk)
PATH=$($CMD_env | $CMD_grep -E '\bPATH=' | $CMD_cut -d '=' -f2 | $CMD_tr ':' '\n' | $CMD_awk '!x[$0]++' | tr '\n' ':')

export PATH="${PATH%%:}"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/yournick/google-cloud-sdk/google-cloud-sdk/path.bash.inc' ]; then . '/home/yournick/google-cloud-sdk/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/yournick/google-cloud-sdk/google-cloud-sdk/completion.bash.inc' ]; then . '/home/yournick/google-cloud-sdk/google-cloud-sdk/completion.bash.inc'; fi
