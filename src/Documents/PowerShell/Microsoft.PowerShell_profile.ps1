
Invoke-Expression (&starship init powershell)

function Start-mnvim { $env:NVIM_APPNAME="mnvim"; nvim }
Set-Alias -Name mnvim -Value Start-mnvim
function Start-nvide { $env:NVIM_APPNAME="mnvim"; neovide }
Set-Alias -Name nvide -Value Start-nvide
