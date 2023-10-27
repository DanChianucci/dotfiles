#! /usr/bin/env bash

SHELL="$(which "$(ps -o comm= -p $$)")"


shopt -s extglob
shopt -s histappend    #append don't overwrite historyfile
shopt -s checkwinsize  #Check Win size after each command
shopt -s cmdhist

#PROMPT_DIRTRIM=3

{ test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"; } &>/dev/null

HISTTIMEFORMAT='%T     '
HISTIGNORE='&:[ \t]*:cd:l:l.:la.:ll:ll.:lla.:ls:clear:history'
HISTCONTROL='erasedups:ignoreboth'
HISTFILE="$HOME/.bash_history"

PYTHONSTARTUP="$HOME/.pythonstartup"

GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export SHELL  HISTTIMEFORMAT HISTIGNORE HISTCONTROL PYTHONSTARTUP GCC_COLORS

bind -f ~/.inputrc

pathmunge ~/.scripts
