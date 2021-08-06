#! /usr/bin/env bash

shopt -s extglob
shopt -s histappend    #append don't overwrite historyfile
shopt -s checkwinsize  #Check Win size after each command
shopt -s histappend
shopt -s cmdhist

#PROMPT_DIRTRIM=3

{ test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"; } &>/dev/null

export HISTTIMEFORMAT='%T     '
export HISTIGNORE='&:[ ]*:ls:pwd:cls:clear:clc:history:ll:histg:cd'
export HISTCONTROL='erasedups:ignoreboth'

export PYTHONSTARTUP="$HOME/.pythonstartup"


export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

bind -f ~/.inputrc
