# Returns (svn:<revision>:<branch|tag>[*]) if applicable
function svn_branch_info() {

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
function svn_parse_branch() {
    local chunk url


    if ! url=$(echo "$1" | awk '/^URL: .*/{print $2}')  ; then
        echo trunk && return
    else
        chunk="$(echo "${url}" | sed -n 's/.*\breleases\/\b//p' | grep -E -o '^[^/]+')"
        [ -n "$chunk" ] &&  echo "rel:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/.*\bbranches\/\b//p' | grep -E -o '^[^/]+')"
        [ -n "$chunk" ] && echo "br:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/.*\btags\/\b//p' | grep -E -o '^[^/]+')"
        [ -n "$chunk" ] && echo "tag:${chunk}" && return

        chunk="$(echo "${url}" | sed -n 's/trunk//p' | grep -E -o '^[^/]+')"
        [ -n "$chunk" ] && echo "trunk" && return
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
