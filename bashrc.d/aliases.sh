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
alias sview="sview &"


alias ccat='egrep --color "\b(FAIL|FAILURE|ERROR|WARNING)\b|$"'
alias catlog='egrep --color "\b(FAIL|FAILURE|ERROR|WARNING)\b|$" *.log'
alias watch="watch "




alias wsq="watch sq"
alias wdq="watch dq"



alias xww="find . -type f -perm /200"
alias dwo="xwo -u chianucci"

alias fbacks='find . -name "*.s" -o -name "*.bak" -o -name "*~" -o -name "*.pyc" -type f'
alias rmb='rm `fbacks`'


function screensize(){
  if   [ $1 = "left" ]; then
    xrandr -s 1920x1200
  elif [ $1 = "center" ]; then
    xrandr -s 2560x1440
  elif [ $1 = "right" ]; then
    xrandr -s 1920x1080
  else
    echo "screensize argument must be one of left, center, right"
    return 1
  fi
}
alias left="screensize left"
alias center="screensize center"
alias right="screensize right"

alias createvnc="vncserver -geometry 2560x1440"
alias weather="curl wttr.in"
