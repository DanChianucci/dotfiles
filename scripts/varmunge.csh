#/bin/csh


#source varmunge.csh PATH <path_to_add> [before|after]

set __VARVAL = `eval echo \$$1`
if (':'"$__VARVAL"':' !~ '*:'"$2"':*') then
  if ( $3 != "before") then
    setenv $1 "$2"':'"$__VARVAL"
  else
    setenv $1 "$__VARVAL"':'"$2"
  endif
endif
unset __VARVAL;