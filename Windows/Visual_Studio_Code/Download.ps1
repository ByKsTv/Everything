Write-Host 'Visual Studio Code > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://code.visualstudio.com/sha/download?build=stable&os=win32-x64', "$env:TEMP\VisualStudioCode.exe")
Write-Host 'Visual Studio Code > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\VisualStudioCode.exe -ArgumentList '/VERYSILENT /MERGETASKS=!runcode'