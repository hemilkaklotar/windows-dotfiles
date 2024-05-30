# Define the source directory containing the scripts
$scriptDir = Join-Path -Path $HOME -ChildPath "dotfiles\scripts"

# Check if script directory exists
if (-Not (Test-Path $scriptDir)) {
    Write-Host "Script directory does not exist: $scriptDir"
    exit
}

# Get all .ps1 scripts in the script directory
$scripts = Get-ChildItem -Path $scriptDir -Filter *.ps1

foreach ($script in $scripts) {
    $scriptPath = $script.FullName
    $confirmation = Read-Host "Do you want to run the script $($script.Name)? (yes/no)"

    if ($confirmation -eq "yes" -or $confirmation -eq "y" -or $confirmation -eq "Y") {
        Write-Host "Running script: $scriptPath"
        try {
            # Execute the script
            & $scriptPath
        } catch {
            Write-Host "An error occurred while running $scriptPath $_"
        }
    } else {
        Write-Host "Skipped script: $scriptPath"
    }
}
