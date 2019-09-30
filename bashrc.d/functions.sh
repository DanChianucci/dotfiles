#! /usr/bin/env bash
# Usage: run_with_timeout N cmd args...
#    or: run_with_timeout cmd args...
# In the second case, cmd cannot be a number and the timeout will be 10 seconds.
function run_with_timeout () {
    local time=10
    if [[ $1 =~ ^[0-9]+(.[0-9]+)?$ ]]; then time=$1; shift; fi
    # Run in a subshell to avoid job control messages
    ( "$@" &
      child=$!
      # Avoid default notification in non-interactive shell for SIGTERM
      trap -- "" SIGTERM
      ( sleep $time
        kill $child 2> /dev/null ) &
      wait $child
    )
}

function man() {

  #mb BLINK     START
  #md BOLD      START
  #so STANDOUT  START
  #us UNDERLINE START

    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        man "$@"
}

function domain(){
  echo "User:   " "$(whoami)"
  echo "Host:   " "$(hostname)"
  echo "MAC:    " "$(cat /sys/class/net/em1/address)"
  echo "Domain: " "$(domainname)"
}

function calc {
  echo "scale=4; $1" | bc
}

function pathmunge () {
  if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
  fi
}

function ppath {
  tr ':' '\n' <<< $PATH
}

#Interprets the first argument as a command name and calls the command for each subsequent arguemnt
function multi {
  cmd="${1}"
  for i in "${@:2}"; do
    eval $cmd "$i"
  done
}

function highlight() {
  declare -A fg_color_map
  fg_color_map[black]=30
  fg_color_map[red]=31
  fg_color_map[green]=32
  fg_color_map[yellow]=33
  fg_color_map[blue]=34
  fg_color_map[magenta]=35
  fg_color_map[cyan]=36

  fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
  c_rs=$'\e[0m'
  sed -u s"/\b$2\b/$fg_c\0$c_rs/gI"
}

function ccat(){
  cat $1 | highlight green "\(SUCCESS\|PASS\)" |highlight red "\(FAILURE\|FAIL\|ERROR\|ERR\)"| highlight yellow "\(WARNING\|WARN\)" | highlight blue "\(INFO\|DEBUG\)"
}


function catlog(){
  ccat *.log
}

function bigfiles(){
  find $1 -type f -exec du -a {} + | sort -rn |  head
}
