# Define the source and target paths
$sourceFile = Join-Path -Path $HOME -ChildPath "dotfiles\kanata\RunKanata.vbs"
$targetDir = Join-Path -Path $HOME -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$targetFile = Join-Path -Path $targetDir -ChildPath "RunKanata.vbs"

# Check if source file exists
if (-Not (Test-Path $sourceFile)) {
    Write-Host "Source file does not exist: $sourceFile"
    exit
}

# Check if target directory exists, create if it does not
if (-Not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir
}

# If the target path exists, remove it
if (Test-Path $targetFile) {
    Remove-Item -Path $targetFile -Force
}

# Create symbolic link
cmd /c mklink "$targetFile" "$sourceFile"

Write-Host "Created symbolic link for $sourceFile at $targetFile"
