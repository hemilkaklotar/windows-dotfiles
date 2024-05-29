
@echo off
setlocal enabledelayedexpansion

REM Define the source directory where your dotfiles repository is located
set "SOURCE_DIR=%~dp0"

REM Define the target home directory
set "TARGET_DIR=%USERPROFILE%"

REM List of directories to be symlinked to the home directory
set "DIRS_TO_SYMLINK=.config .glaze-wm"

REM Function to create symbolic link for a directory
:CreateSymlink
    set "SRC=%SOURCE_DIR%!1!"
    set "DST=%TARGET_DIR%\!1!"
    
    if exist "!DST!" (
        echo Deleting existing directory: "!DST!"
        rmdir /s /q "!DST!"
    )
    
    echo Creating symbolic link: "!DST!" -> "!SRC!"
    mklink /d "!DST!" "!SRC!"
    goto :EOF

REM Loop through each directory and create symbolic links
for %%D in (%DIRS_TO_SYMLINK%) do (
    call :CreateSymlink %%D
)

REM Create symbolic links for files in the repository root (except for packages and kanata)
for %%F in (%SOURCE_DIR%*) do (
    if /i not "%%~nxF"=="packages" if /i not "%%~nxF"=="kanata" if not "%%~aF"=="d" (
        set "SRC=%%F"
        set "DST=%TARGET_DIR%\%%~nxF"
        
        if exist "!DST!" (
            echo Deleting existing file: "!DST!"
            del /q "!DST!"
        )
        
        echo Creating symbolic link: "!DST!" -> "!SRC!"
        mklink "!DST!" "!SRC!"
    )
)

echo All symbolic links have been created.
pause
