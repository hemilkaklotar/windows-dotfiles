oh-my-posh init pwsh | Invoke-Expression
Set-Alias -Name vim -Value nvim
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function fzf-preview {
    param (
        [string]$directory = (Get-Location),
        [string]$previewCommand = 'cat {}'
    )
    Set-Location $directory
    Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } | fzf --preview "$previewCommand"
}

Set-Alias -Name vimf -Value vim fzf-preview


Import-Module -Name Microsoft.WinGet.CommandNotFound
