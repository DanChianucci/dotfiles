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

# Returns (svn:<revision>:<branch|tag>[*]) if applicable
svn_prompt() {

    local branch dirty rev info
    if info=$(svn info 2>/dev/null); then
        branch=$(svn_parse_branch "${info}")

        # Uncomment if you want to display the current revision.
        rev=$(echo "${info}" | awk '/^Revision: [0-9]+/{print $2}')

        # Uncomment if you want to display whether the repo is 'dirty.' In some
        # cases (on large repos) this may take a few seconds, which can
        # noticeably delay your prompt after a command executes.
        # [ "$(svn status)" ] && dirty='*'

        if [ "$branch" != "" ] ; then
            echo "svn:${branch}${dirty}:${rev}"
        fi
        return 0
    fi
    return 1

}

# Returns the current branch or tag name from the given `svn info` output
svn_parse_branch() {
    local chunk url


    if ! url=$(echo "$1" | awk '/^URL: .*/{print $2}')  ; then
        echo trunk && return
    else
        chunk="$(echo "${url}" | sed -n 's/.*\breleases\/\b//p' | egrep -o '^[^/]+')"
        [ -n "$chunk" ] &&  echo "rel:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/.*\bbranches\/\b//p' | egrep -o '^[^/]+')"
        [ -n "$chunk" ] && echo "br:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/.*\btags\/\b//p' | egrep -o '^[^/]+')"
        [ -n "$chunk" ] && echo "tag:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/.*\btrunk\/\b//p' | egrep -o '^[^/]+')"
        [ -n "$chunk" ] && echo "trunk" && return
    fi


    return 0

}

git_prompt(){
    git_br=$(git branch --color=never 2> /dev/null | sed -e '/^[^*]/d' -e 's/^\*\s*//')
    if [ -n "${git_br}" ] ; then
        echo "git:${git_br}"
        return 0
    fi
    return 1
}

#Customization
# PROMPT_COLOR          - Color of the user@domain string (name or escape sequence)
# CUSTOM_PS1_CMDS       - Custom Command to run places the output inside [] before the directory
#                         Multiple commands can be seperated by ;'.  each string is run through eval so commads will be replaced by the output
#                         ex '$(mycommand);hello'  is replaced with the outputs of mycommand folled by the string hello
set_prompt () {
    local last_command=$?
    PS1=''
    if [[ $last_command != 0 ]]; then
        PS1+=$(colorize red '($?)\n')
    fi

    PS1+=${CUSTOM_PS1_LEADER:-}
    PS1+=$(colorize "${PROMPT_COLOR:-blue}" "$(whoami)@\h")       #<username>@<hostname>[jobs]: <directory>$

    if [ -n "$CUSTOM_PS1_CMDS" ]; then
        PS1+='\[\e[0;35m\]'
        OLDIFS=$IFS
        IFS=";"
        for i in ${CUSTOM_PS1_CMDS}; do
            v="$(eval echo "$i") "
            if [[ -n "${v// }" ]]; then
              PS1+="$v "
            fi
        done
        IFS=$OLDIFS
        PS1+="\[\e[0m\]"
    fi

    PS1+=": "
    PS1+=$(colorize green '\w ') # shortened working directory

    # Add git information

    scm_prompt=$(git_prompt || svn_prompt)
    if [ -n "$scm_prompt" ]; then
        PS1+=$(colorize yellow "($scm_prompt)")
    fi

    PS1+=" $ "
    history -a;

}
PROMPT_COMMAND='set_prompt'
