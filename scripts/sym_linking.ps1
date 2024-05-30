# Define the source and target directories
$sourceDir = "$HOME/dotfiles/config"
$targetDir = "$HOME"
$backupDir = "$HOME/backup"

# Get the current date
$currentDate = Get-Date -Format "yyyyMMdd"

# Check if source directory exists
if (-Not (Test-Path $sourceDir)) {
    Write-Host "Source directory does not exist: $sourceDir"
    exit
}

# Check if target directory exists, create if it does not
if (-Not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# Check if backup directory exists, create if it does not
if (-Not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir
}

# Get all top-level items in the source directory
$items = Get-ChildItem -Path $sourceDir

foreach ($item in $items) {
    $sourcePath = $item.FullName
    $targetPath = Join-Path -Path $targetDir -ChildPath $item.Name

    # If the target path exists, rename and move it to the backup directory
    if (Test-Path $targetPath) {
        $backupPath = Join-Path -Path $backupDir -ChildPath "$($item.Name).backup.$currentDate"
        Move-Item -Path $targetPath -Destination $backupPath
        Write-Host "Moved existing item $targetPath to $backupPath"
    }

    # Create symbolic link
    if ($item.PSIsContainer) {
        cmd /c mklink /D "$targetPath" "$sourcePath"
    } else {
        cmd /c mklink "$targetPath" "$sourcePath"
    }

    Write-Host "Created symbolic link for $sourcePath at $targetPath"
}
