(&mise activate pwsh) | Out-String | Invoke-Expression

Invoke-Expression (&starship init powershell)

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# example command - use $Location with a different command:
$commandOverride = [ScriptBlock]{ param($Location) Write-Host $Location }
# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride
# tab
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

function Start-mnvim { $env:NVIM_APPNAME="mnvim"; nvim }
Set-Alias -Name mnvim -Value Start-mnvim
function Start-nvide { $env:NVIM_APPNAME="mnvim"; neovide }
Set-Alias -Name nvide -Value Start-nvide
