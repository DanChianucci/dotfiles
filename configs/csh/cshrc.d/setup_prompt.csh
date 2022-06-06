#---------------------------------------
# Configure Prompt
#---------------------------------------

# Set color shortcuts
# First number after '[' signifies the attribute
# i.e. '01' for bold
# Second number is the foreground color, third
# (left blank here for default) is the background color
set   black="%{\033[0;30m%}"
set    blue="%{\033[0;34m%}"
set    cyan="%{\033[0;36m%}"
set   green="%{\033[0;32m%}"
set  orange="%{\033[0;33m%}"
set  purple="%{\033[0;35m%}"
set     red="%{\033[0;31m%}"
set  violet="%{\033[0;35m%}"
set   white="%{\033[0;37m%}"
set  yellow="%{\033[0;33m%}"
set     end="%{\033[0m%}"


set default_group=`/bin/id -g -n dchu`
set group=`/bin/id -g -n`
if ("$group" != "$default_group") then
    set group = "${red}($group) ${green}"
else
    set group
endif


set prompt = "${red}csh> ${green}%n${green}@%m $group\: ${blue}%~${end} $ "

# Cleanup
unset default_group group
unset red green yellow blue magenta cyan yellow white end



# Key binding not working? Try typing 'cat' in the terminal
# and then hit the key you wish to bind. It should print the
# ascii representation of that key. Replace "\e[A" with the
# result from the cat command that corresponds to the key
# you wish to bind for backward history search and so on.

# bind -f ~/.inputrc
bindkey "\e[3~"  delete-char             #DELETE
bindkey "\e[1~"  beginning-of-line       #HOME
bindkey "\e[5~"  end-of-line             #END
bindkey "\e[A"   history-search-backward #UP
bindkey "\e[B"   history-search-forward  #DOWN
bindkey "\e[C"   forward-char            #RIGHT
bindkey "\e[D"   backward-char           #LEFT


if (-r ~/.dircolors) then
    eval "`dircolors -c ~/.dircolors`" >& /dev/null
endif

setenv PYTHONSTARTUP "$HOME/.pythonstartup"