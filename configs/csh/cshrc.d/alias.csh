#/bin/csh
alias reload "reset && source ~/.cshrc"
alias ppath 'echo $PATH | tr ":" "\n"'


#! /usr/bin/env bash
set LS_COMMON = "--color=auto -I NTUSER.DAT\* -I ntuser.\*"
ls --group-directories-first >& /dev/null
if( $? == 0  ) then
  alias ls "ls $LS_COMMON --group-directories-first"
else
  alias ls "ls $LS_COMMON"
endif


alias l   "ls"
alias l.  "ls -d .*"
alias la. "ls -A"

alias ll   "ls -lh"
alias ll.  "ls -lhd .*"
alias lla. "ls -lhA"



alias tree "tree -Csuh"

alias cls "clear"
alias clc "clear"



alias psg   "ps aux | grep -v grep | grep -i -e VSZ -e"
alias histg "history | grep"

alias watch "watch "

alias fbacks 'find . -name "*.s" -o -name "*.bak" -o -name "*~" -o -name "*.pyc" -type f'
alias rmb    'rm `fbacks`'

alias weather "curl wttr.in"


alias up 'set __dirname=`~/.scripts/up.py \!*` && cd $__dirname; unset __dirname'

alias vup 'set __dirname=`~/.scripts/up.py venv`; \\
           set __filename="$__dirname/bin/activate.csh"; \\
           if ( -e "$__filename" ) echo "$__filename" && source "$__filename"; \\
           if ( ! -e "$__filename") echo "No virtualenv found"; \\
           unset __dirname; \\
           unset __filename;'


alias varmunge   'source ~/.scripts/varmunge.csh'
alias pathmunge  'varmunge PATH'


alias clearhist 'rm $histfile && history -c'