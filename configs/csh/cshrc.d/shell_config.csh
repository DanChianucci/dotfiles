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
set history=2000  # save last 2000 commands
set histdup=erase # remove duplicate commands
set savehist=(2000 merge)
