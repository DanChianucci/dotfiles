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

function count_jobs(){
  if squeue -V >/dev/null 2>&1 ; then
     run_with_timeout 0.2 squeue -u chianucci | echo "`wc -l` - 1" | bc  || echo '?'
  else
    echo "?"
  fi
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

function hhand() {
  ( cd ~/$1/src && Wa_Handle )
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

function resubmit {
  for var in "$@"
  do
    (hhand
      { cd $var && ./resubmit.sh; } || echo "Could Not resubmit $var"
    )
  done
}


function xgo {
  core_dir=$(xfind "$@")
  if [ -z $core_dir ]; then
    echo "Couldn't Find Project For $*"
  else
    cd $core_dir || return
  fi
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

function sq(){
  cols=$(expr $COLUMNS - 85)
  SQ_FORMAT="%10i %15u %10P   %${cols}j %10T %10M %20R"
  squeue -o "$SQ_FORMAT" "$@"
}

function dq(){
  sq -u chianucci
}
export -f sq dq


function tmux() {
  local tmux
  tmux=$(type -fp tmux)
  case "$1" in
      update-environment|update-env|env-update)
          local v
          while read v; do
              if [[ $v == -* ]]; then
                  unset ${v/#-/}
              else
                  # Add quotes around the argument
                  v=${v/=/=\"}
                  v=${v/%/\"}
                  eval export $v
              fi
          done < <(tmux show-environment)
          ;;
      *)
          $tmux "$@"
          ;;
  esac
}
