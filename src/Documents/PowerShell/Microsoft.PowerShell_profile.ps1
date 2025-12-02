
Invoke-Expression (&starship init powershell)

function Start-mnvim { $env:NVIM_APPNAME="mnvim"; nvim }
Set-Alias -Name mnvim -Value Start-mnvim
