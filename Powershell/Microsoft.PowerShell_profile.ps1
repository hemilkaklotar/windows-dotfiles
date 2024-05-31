# Set the path for Starship configuration file
$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\config\starship\starship.toml"

# Initialize oh-my-posh (commented out, but included for reference)
# oh-my-posh init pwsh | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussell.omp.json" | Invoke-Expression

# Import the Terminal-Icons module for file icons in the terminal
Import-Module -Name Terminal-Icons

# Disable virtual environment prompt (commented out, but included for reference)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Initialize the Starship prompt
Invoke-Expression (&starship init powershell)

# Initialize zoxide, a smarter cd command
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Define a function to use Neovim with fzf finder and file preview
function Invoke-NvimFzf {
    $directory = Get-Location
    $previewCommand = 'cat {}'
    Set-Location $directory
    Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } | fzf --preview "$previewCommand" | ForEach-Object { nvim $_ }
}

# Create aliases for Neovim and the custom fzf finder function
Set-Alias -Name vim -Value nvim
Set-Alias vimf Invoke-NvimFzf

# Import the Microsoft WinGet CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
