# Read each line from the list_scoop file and install each package using Scoop
Get-Content ~/dotfiles/packages/list_scoop | ForEach-Object { scoop install $_}

# Read each line from the list_choco file and install each package using Chocolatey
Get-Content ~/dotfiles/packages/list_choco | ForEach-Object { choco install $_ -y}
