#!/bin/bash


function colorcode() {
    declare -A color_map
    color_map[white]="\e[0;0m"
    color_map[black]="\e[0;30m"
    color_map[red]="\e[0;31m"
    color_map[green]="\e[0;32m"
    color_map[yellow]="\e[0;33m"
    color_map[blue]="\e[0;34m"
    color_map[purple]="\e[0;35m"
    color_map[magenta]="\e[0;35m"
    color_map[cyan]="\e[0;36m"

    color_map[bright_white]="\e[1;0m"
    color_map[bright_black]="\e[1;30m"
    color_map[bright_red]="\e[1;31m"
    color_map[bright_green]="\e[1;32m"
    color_map[bright_yellow]="\e[1;33m"
    color_map[bright_blue]="\e[1;34m"
    color_map[bright_purple]="\e[1;35m"
    color_map[bright_magenta]="\e[1;35m"
    color_map[bright_cyan]="\e[1;36m"

    color_map[reset]="\e[0m"
    colorcode=${color_map[$1]:-$1}
    echo -e "$colorcode"
}

# shellcheck disable=SC2034
function colorize() {
  fg_c=$(colorcode "$1")
  fg_rst="\e[0m"
  echo -e "\[$fg_c\]$2\[$fg_rst\]"
}


function set_prompt () {
    local last_command=$?
    PS1=''
    if [[ $last_command != 0 ]]; then
        PS1+=$(colorize red '($?)\n')
    fi

    if [[ $(type -t CUSTOM_PS1_LEAD) == "function" ]]; then
        PS1+="$(CUSTOM_PS1_LEAD)"
    fi

    PS1+=$(colorize "${PROMPT_COLOR:-blue}" "$(whoami)@\h ")       #<username>@<hostname>[jobs]: <directory>$

    if [[ $(type -t CUSTOM_PS1_HOST) == "function" ]]; then
        PS1+="$(CUSTOM_PS1_HOST)"
    fi
    PS1+=": "

    if [[ $(type -t CUSTOM_PS1_PREPATH) == "function" ]]; then
        PS1+="$(CUSTOM_PS1_PREPATH)"
    fi

    PS1+=$(colorize green '\w ') # shortened working directory


    if [[ $(type -t CUSTOM_PS1_PATH) == "function" ]]; then
        PS1+="$(CUSTOM_PS1_PATH)"
    fi

    if [[ $(type -t CUSTOM_PS1_TRAIL) == "function" ]]; then
        PS1+="$(CUSTOM_PS1_TRAIL)"
    fi


    PS1+="$ "
    history -a;

}
PROMPT_COMMAND='set_prompt'
