#! /usr/bin/env bash


if ls --group-directories-first > /dev/null 2>&1; then
  alias ls='ls -X --color="auto" --group-directories-first'
else
  alias ls='ls -X --color="auto"'
fi;

if rm -I --version > /dev/null 2>&1; then
  alias rm="rm -I"
fi


alias ll="ls -lh"
alias la="ls -A"
alias l="ls -CF"
alias l.="ls -d .*"
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

alias createvnc="vncserver -geometry 2560x1440 -geometry 1920x1200 -geometry 1920x1080"
alias weather="curl wttr.in"
