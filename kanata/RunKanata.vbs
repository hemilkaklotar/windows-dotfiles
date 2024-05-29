Set objShell = CreateObject("WScript.Shell")

' Correctly use environment variables for home directory
command = """%USERPROFILE%\scoop\apps\kanata\current\kanata.exe"" --cfg ""%USERPROFILE%\dotfiles\kanata\keyboard.kbd"""

' Create a new shell instance and run the command in the background
objShell.Run command, 0, False
