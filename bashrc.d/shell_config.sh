#! /usr/bin/env bash

shopt -s extglob
shopt -s histappend    #append don't overwrite historyfile
shopt -s checkwinsize  #Check Win size after each command
shopt -s histappend
shopt -s cmdhist

#PROMPT_DIRTRIM=3

{ test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"; } &>/dev/null

export CDPATH=".:~:~/tools:~/cores:~/subsystems"
export HISTTIMEFORMAT='%T     '
export HISTIGNORE='&:[ ]*:ls:pwd:cls:clear:clc:history:ll:histg:cd'
export HISTCONTROL='erasedups:ignoreboth'

export PYTHONSTARTUP="$HOME/.pythonstartup"


export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

bind -f ~/.inputrc


function colorize(){
  declare -A color_map
  color_map[white]="\[\e[0;0m\]"
  color_map[black]="\[\e[0;30m\]"
  color_map[red]="\[\e[0;31m\]"
  color_map[green]="\[\e[0;32m\]"
  color_map[yellow]="\[\e[0;33m\]"
  color_map[blue]="\[\e[0;34m\]"
  color_map[purple]="\[\e[0;35m\]"
  color_map[magenta]="\[\e[0;35m\]"
  color_map[cyan]="\[\e[0;36m\]"


  fg_c=${color_map[$1]:-$1}
  fg_rst="\[\e[0m\]"
  echo -e "$fg_c$2$fg_rst"
}


#Customization
# PROMPT_COLOR   - Color of the user@domain string (name or escape sequence)
# CUSTOM_PS1_CMD - Custom Command to run places the output inside [] before the directory
set_prompt () {
    local last_command=$?
    PS1=''
    if [[ $last_command != 0 ]]; then
        PS1+=$(colorize red '($?)\n')
    fi

    PS1+=$(colorize "${PROMPT_COLOR:-blue}" "$(whoami)@\h")       #<username>@<hostname>[jobs]: <directory>$

    if [ -n "$CUSTOM_PS1_CMD" ]; then
      custom_val=$($CUSTOM_PS1_CMD)
      if [ -n "$custom_val" ]; then
          PS1+=$(colorize purple "[$custom_val]")
      fi
    fi

    PS1+=": "
    PS1+=$(colorize green '\w ') # shortened working directory

    if [ -n "$CONDA_PROMPT_MODIFIER" ]; then
        PS1+=$(colorize purple "$CONDA_PROMPT_MODIFIER")
    fi

    # Add git information
    local git_br
    git_br=$(git branch --color=never 2> /dev/null | sed -e '/^[^*]/d' -e 's/^\*\s*//')
    if [ -n "$git_br" ]; then
        PS1+=$(colorize yellow "($git_br)")
    fi

    PS1+=" $ "
    history -a;

}
PROMPT_COMMAND='set_prompt'
