oh-my-posh init pwsh | Invoke-Expression
Set-Alias -Name vim -Value nvim
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function Invoke-NvimFzf {
    $directory = Get-Location
    $previewCommand = 'cat {}'
    Set-Location $directory
    Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } | fzf --preview "$previewCommand" | ForEach-Object { nvim $_ }
}
# Nvim with fzf finder and file preview
Set-Alias vimf Invoke-NvimFzf

Import-Module -Name Microsoft.WinGet.CommandNotFound
