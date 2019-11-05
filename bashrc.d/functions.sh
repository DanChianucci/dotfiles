#! /usr/bin/env bash
# Usage: run_with_timeout N cmd args...
#    or: run_with_timeout cmd args...
# In the second case, cmd cannot be a number and the timeout will be 10 seconds.
function run_with_timeout () {
    local time=10
    if [[ $1 =~ ^[0-9]+(.[0-9]+)?$ ]]; then time=$1; shift; fi

    # Run in a subshell to avoid job control messages
    (
      "$@" &                                     #Run the command in bg
      child=$!                                   #hold onto the childs PID
      trap -- "" SIGTERM                         #Avoid default notification in non-interactive shell for SIGTERM

      ( sleep $time;  kill $child 2>/dev/null) & #Wait for time, and then kill child
      wait $child                                #Wait until child finishes or it is killed
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


#https://superuser.com/questions/878640/unix-script-wait-until-a-file-exists
function wait_file() {
  local file="'$1'"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout

  until test $((wait_seconds--)) -eq 0 -o -f "$(find . -name '$file' | head -1)" ; do
    sleep 1;
  done

  ((++wait_seconds))
}


function colors(){
  DOTS='•••'
  printf "\n                 40m     41m     42m     43m     44m     45m     46m     47m\n";
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m'; do
    FG=${FGs// /}
    printf " $FGs \033[$FG  $DOTS  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
      printf "$EINS \033[$FG\033[$BG  $DOTS  \033[0m";
    done
    printf "\n"
  done
  printf "\n"
}


function attach()
{
  if [ $# -eq 0 ]; then
    tmux attach >/dev/null 2>&1 || tmux new-session
  else
    tmux new-session -AP -F "Created New Session: #{session_name}" -s $1
  fi
}