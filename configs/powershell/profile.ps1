#CurrentUserAllHosts


Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistoryNoDuplicates

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Tab -Function Complete

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-Alias rc Edit-PowershellProfile

$env:PYTHONSTARTUP = "$home\.pythonstartup"

function Edit-PowershellProfile {
    if (Test-Path -Path $PROFILE.CurrentUserCurrentHost){
        code $PROFILE.CurrentUserCurrentHost
    }
    if (Test-Path -Path $PROFILE.CurrentUserAllHosts){
        code $PROFILE.CurrentUserAllHosts
    }
    if (Test-Path -Path $PROFILE.AllUsersCurrentHost){
        code $PROFILE.AllUsersCurrentHost
    }
    if (Test-Path -Path $PROFILE.AllUsersAllHosts){
        code $PROFILE.AllUsersAllHosts
    }
}

Function Test-CommandExists {
  Param ($command)
  $oldPreference = $ErrorActionPreference

  $ErrorActionPreference = 'stop'
  try   {if(Get-Command $command){RETURN $true}}
  Catch {RETURN $false}
  Finally {$ErrorActionPreference=$oldPreference}
}


function Get-ChildItemName { Get-ChildItem -Name }

function Get-ChildItemHidden { Get-ChildItem -Force }

Set-Alias -Name "ls"  -Value Get-ChildItemName -Option AllScope
Set-Alias -Name "ll"  -Value Get-ChildItem
Set-Alias -Name "ll." -Value Get-ChildItemHidden


function Prompt {
    $mywd = (Get-Location).Path
    $mywd = $mywd.Replace( $HOME, '~' )
    $CmdPromptUser   = [Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")[1]
    $CmdPromptDomain = [System.Net.DNS]::GetHostName()
    Write-Host ("PS> ") -ForegroundColor RED -NoNewline
    Write-Host ($CmdPromptUser+"@"+$CmdPromptDomain+": ") -ForegroundColor green -NoNewline
    Write-Host ("$mywd ") -NoNewline -ForegroundColor Blue
    if(![string]::IsNullOrEmpty($env:CONDA_PROMPT_MODIFIER)){
        Write-Host ("$env:CONDA_PROMPT_MODIFIER") -NoNewline -ForegroundColor Yellow
    }
    Write-Host ("$ ") -NoNewline -ForegroundColor White
    return " "
}


if (Get-Module -ListAvailable -Name DirColors){
    Import-Module DirColors
    Update-DirColors ~/.dircolors
}

if(Test-CommandExists conda) {
    (& "conda" "shell.powershell" "hook") | Out-String | Invoke-Expression
}

if(Test-CommandExists starship) {
    Invoke-Expression (&starship init powershell)
}