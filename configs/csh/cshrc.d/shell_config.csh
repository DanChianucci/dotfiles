# Configure terminal behavior
stty sane -parity
stty -ixon                      # prevent Ctrl-S from locking up the terminal
setenv TERM $term
limit coredumpsize 0

set visiblebell
set autolist                    # Set terminal to list tab complete options when ambiguous
set color                       # Enable 'ls' colors. Custom colors can be set with $LS_COLORS environment variable
set colorcat                    # Enable color for NLS messages. (informational messages from commands)
set filec
set nonomatch
set notify



# Syncronize history between all terminals
set histfile="$HOME/.tcsh_history"
set history=500  # save last 2000 commands
set histdup=erase # remove duplicate commands
set savehist=($history merge lock)

#Variable Not Used by csh, but clean_tcsh_history.py script uses it.
set histignore='cd:l:l.:la.:ll:ll.:lla.:ls:clear:history'
set SHELL=`which $0`


# Key binding not working? Try typing 'cat' in the terminal
# and then hit the key you wish to bind. It should print the
# ascii representation of that key. Replace "\e[A" with the
# result from the cat command that corresponds to the key
# you wish to bind for backward history search and so on.

# bind -f ~/.inputrc
bindkey  "\e[3~"   delete-char               # DELETE
#bindkey "\e[1~"   beginning-of-line         # HOME
#bindkey "\e[5~"   end-of-line               # END
bindkey -k up      history-search-backward   # UP
bindkey -k down    history-search-forward    # DOWN
bindkey -k left    backward-char             # LEFT
bindkey -k right   forward-char              # RIGHT


setenv GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
setenv PYTHONSTARTUP "$HOME/.pythonstartup"


if (-r ~/.dircolors) then
    eval "`dircolors -c ~/.dircolors`" >& /dev/null
endif

pathmunge ~/.scripts