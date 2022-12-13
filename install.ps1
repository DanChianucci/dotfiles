$env:PROFILE = $PROFILE.CurrentUserAllHosts
dotbot -d "$PSScriptRoot" -c "install.conf.yaml"
