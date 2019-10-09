#! /usr/bin/env bash

LS_COMMON="--color=auto -I NTUSER.DAT\* -I ntuser.\*"
if ls --group-directories-first > /dev/null 2>&1; then
  alias ls="ls $LS_COMMON --group-directories-first"
else
  alias ls="ls $LS_COMMON"
fi;
alias ll="ls -lh"
alias ll.="ls -lAh"
alias l="ls"
alias l.="ls -d .*"



if rm -I --version > /dev/null 2>&1; then
  alias rm="rm -I"
fi


alias tree="tree -Csuh"

alias reload="reset && source ~/.bashrc"

alias emacs="emacs -Q"
alias cls="clear"
alias clc="clear"

alias top=htop
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias histg="history | grep"



alias watch="watch "

alias xww="find . -type f -perm /200"


alias fbacks='find . -name "*.s" -o -name "*.bak" -o -name "*~" -o -name "*.pyc" -type f'
alias rmb='rm `fbacks`'

alias weather="curl wttr.in"
