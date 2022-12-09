#---------------------------------------
# Configure Prompt
#---------------------------------------


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

set DEFAULT_USER_PROMPT="${red}csh> ${green}%n${green}@%m $group\: ${blue}%~${end} $ "
set prompt="$DEFAULT_USER_PROMPT"

# Cleanup
unset default_group group
unset red green yellow blue magenta cyan yellow white end
