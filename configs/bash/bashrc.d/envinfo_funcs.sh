#!/bin/bash

# Returns (svn  <branch> <rev>) if applicable
function svn_branch_info() {
    local branch rev url

    url="$(svn info --show-item url 2>/dev/null)"
    if [ "$url" != "" ] ; then
        rev="$(svn info --show-item revision)"
        branch=$(svn_parse_branch "${url}")

        if [ "$branch" != "" ] ; then
            echo "svn ${branch} r${rev}"
        fi
    fi
}

# Returns the current branch or tag name from the given `svn info` output
function svn_parse_branch() {
    local chunk url

    if ! url="$1"; then
        echo "???" && return
    else
        declare -A match_types
        match_types["tg"]="tags"
        match_types["rl"]="releases"
        match_types["us"]="branches\/user\(_branches\)\?"
        match_types["pr"]="branches\/project\(_branches\)\?"
        match_types["fe"]="branches\/feature\(_branches\)\?"
        match_types["br"]="branches"

        for matchtype in tg rl us pr fe br; do
            ptrn=${match_types["$matchtype"]}
            chunk="$(echo "${url}/" | sed -n "s/.*\b${ptrn}\/\b//p" | grep -E -o '^[^/]+')"
            [ -n "$chunk" ] && echo "${matchtype}:${chunk}" && return 3
        done


        chunk="$(echo "${url}" | sed -n 's/trunk//p' | grep -E -o '^[^/]+')"
        [ -n "$chunk" ] && echo "trunk" && return 3


    fi

    return 0

}

function git_branch_info(){
    git_br=$(git branch --color=never 2> /dev/null | sed -e '/^[^*]/d' -e 's/^\*\s*//')
    if [ -n "${git_br}" ] ; then
        echo "git:${git_br}"
        return 0
    fi
    return 1
}

function virtualenv_info(){
    # Get Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Strip out the path and just leave the env name
        venv="${VIRTUAL_ENV##*/}"
    else
        # In case you don't have one activated
        venv=''
    fi
    [[ -n "$venv" ]] && echo "[$venv]"
}
