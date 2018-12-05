#! /usr/bin/env bash

shopt -s extglob
shopt -s histappend    #append don't overwrite historyfile
shopt -s checkwinsize  #Check Win size after each command
shopt -s histappend



{ test -r ~/.dircolors && eval "$(dircolors ~/.dircolors)"; } &>/dev/null

export CDPATH=".:~"
export HISTTIMEFORMAT='%T     '
export HISTIGNORE='ls:pwd:cls:clear:clc:history:ll:histg:cd'
export HISTCONTROL='ignoreboth'


export PYTHONSTARTUP=$HOME/.pythonstartup

source ${HOME}/.config/bashrc.d/git_prompt.bash

set_prompt () {
    local last_command=$?
    PS1=''

    # color escape codes
    local color_off='\[\e[0m\]'
    local color_red='\[\e[0;31m\]'
    local color_green='\[\e[0;32m\]'
    local color_yellow='\[\e[0;33m\]'
    local color_blue='\[\e[0;34m\]'
    local color_purple='\[\e[0;35m\]'
    local color_cyan='\[\e[0;36m\]'
    local num_jobs

    if [[ $last_command != 0 ]]; then
        PS1+=$color_red
        PS1+='($?)\n'
        PS1+=$color_off
    fi

    PS1+=$color_blue
    PS1+="\u@\h"       #<username>@<hostname>[jobs]: <directory>$
    PS1+=$color_off

    num_jobs=$(count_jobs)
    if [[ $num_jobs -gt 0 ]]; then
        PS1+=$color_purple
        PS1+="[$num_jobs]"
        PS1+=$color_off
    fi

    # add purple exit code if non-zero



    PS1+=$color_off
    PS1+=": "


    PS1+=$color_green
    PS1+='\w' # shortened working directory

    # Add git information
    local git_br
    git_br=$(__git_ps1 '%s')
    if [ ! -z $git_br ]; then
        PS1+=$color_yellow
        PS1+=" ("
        PS1+=$git_br
        PS1+=") "
    fi



    PS1+=$color_off
    PS1+="$ "

    history -a;

}
PROMPT_COMMAND='set_prompt'

bind -f ~/.inputrc
