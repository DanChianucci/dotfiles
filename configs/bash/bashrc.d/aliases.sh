#! /usr/bin/env bash

LS_COMMON="--color=auto -I NTUSER.DAT\* -I ntuser.\*"
if ls --group-directories-first > /dev/null 2>&1; then
  alias ls="ls $LS_COMMON --group-directories-first"
else
  alias ls="ls $LS_COMMON"
fi;

alias l="ls"
alias l.="ls -d .*"
alias la.="ls -A"

alias ll="ls -lh"
alias ll.="ls -lhd .*"
alias lla.="ls -lhA"

if rm -I --version > /dev/null 2>&1; then
  alias rm="rm -I"
fi

alias tree="tree -Csuh"
alias reload="reset && source ~/.bashrc"

alias cls="clear"
alias clc="clear"

if command -v htop > /dev/null; then
  alias top=htop
fi

alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias histg="history | grep"

alias watch="watch "

alias fbacks='find . -name "*.s" -o -name "*.bak" -o -name "*~" -o -name "*.pyc" -type f'
alias rmb='rm $(fbacks)'

alias weather="curl wttr.in"
