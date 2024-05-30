
# Get the default profile path
$defaultProfilePath = $PROFILE

# Define the custom profile path
$customProfilePath = "$HOME\dotfiles\Powershell\Microsoft.PowerShell_profile.ps1"

# Ensure the custom profile path exists
if (-Not (Test-Path $customProfilePath)) {
    Write-Error "The custom profile file does not exist: $customProfilePath"
    exit
}

# Rename the existing profile file with a timestamp if it exists
if (Test-Path $defaultProfilePath) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupPath = "$defaultProfilePath.$timestamp.bak"
    Rename-Item -Path $defaultProfilePath -NewName $backupPath
    Write-Output "Existing profile file renamed to: $backupPath"
}

# Create the symbolic link
New-Item -ItemType SymbolicLink -Path $defaultProfilePath -Target $customProfilePath

Write-Output "Symbolic link created from $defaultProfilePath to $customProfilePath"
