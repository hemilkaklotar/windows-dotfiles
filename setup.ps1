# Set the destination directory
$destinationDir = "C:\Users\$env:USERNAME"

# Change directory to the current directory
Set-Location $PSScriptRoot

# Get a list of all files in the dotfiles directory
$dotfiles = Get-ChildItem -Recurse -File

foreach ($file in $dotfiles) {
    # Get the relative path of the file
    $relativePath = ~\dotfiles

    # Check if the file or directory already exists in the destination directory
    $destinationFile = Join-Path -Path $destinationDir -ChildPath ($relativePath + "\" + $file.Name)
    if (Test-Path $destinationFile) {
        # Backup the existing file or directory
        $backupFile = $destinationFile + ".backup"
        if (Test-Path $backupFile) {
            Write-Error "Error: Backup file already exists for $($file.FullName)"
            exit 1
        } else {
            Move-Item -Path $destinationFile -Destination $backupFile
        }
    }

    # Create the corresponding directory structure in the destination folder
    $destinationPath = Join-Path -Path $destinationDir -ChildPath $relativePath
    if (!(Test-Path $destinationPath)) {
        New-Item -Path $destinationPath -ItemType Directory | Out-Null
    }

    # Create symbolic link to the file in the destination folder
    New-Item -ItemType SymbolicLink -Path $destinationPath -Name $file.Name -Value $file.FullName
}

Write-Output "Symbolic links created successfully."
