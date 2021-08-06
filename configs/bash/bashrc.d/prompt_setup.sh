#!/bin/bash

# shellcheck disable=SC2034
function colorize() {
  color_map__white="\[\e[0;0m\]"
  color_map__black="\[\e[0;30m\]"
  color_map__red="\[\e[0;31m\]"
  color_map__green="\[\e[0;32m\]"
  color_map__yellow="\[\e[0;33m\]"
  color_map__blue="\[\e[0;34m\]"
  color_map__purple="\[\e[0;35m\]"
  color_map__magenta="\[\e[0;35m\]"
  color_map__cyan="\[\e[0;36m\]"

  color_map__bright_white="\[\e[1;0m\]"
  color_map__bright_black="\[\e[1;30m\]"
  color_map__bright_red="\[\e[1;31m\]"
  color_map__bright_green="\[\e[1;32m\]"
  color_map__bright_yellow="\[\e[1;33m\]"
  color_map__bright_blue="\[\e[1;34m\]"
  color_map__bright_purple="\[\e[1;35m\]"
  color_map__bright_magenta="\[\e[1;35m\]"
  color_map__bright_cyan="\[\e[1;36m\]"

  key="color_map__$1"
  fg_c=${!key:-$1}
  fg_rst="\[\e[0m\]"
  echo -e "$fg_c$2$fg_rst"
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
        echo trunk
        return
    else
        # first check /branches/releases
        chunk=$(echo "${url}" | grep -o "/releases.*")
        if [ "${chunk}" == "" ] ; then
            # then check for some other branch
            chunk=$(echo "${url}" | grep -o "/branches.*")
            if [ "${chunk}" == "" ] ; then
                # last check for a tag
                chunk=$(echo "${url}" | grep -o "/tags.*")
            fi
        fi
    fi

    echo "${chunk}" | awk -F/ '{print $3}'
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
