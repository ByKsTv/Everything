Unregister-ScheduledTask -TaskName Step4 -Confirm:$false
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/OO_ShutUp10/Download.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Group_Policy.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Network.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1 | Invoke-Expression
Add-Type -AssemblyName System.Windows.Forms
$PythonAnswer = [System.Windows.Forms.MessageBox]::Show('Install Python?' , 'Python' , 4, 32)
if ($PythonAnswer -eq 'Yes') {
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1 | Invoke-Expression
}
$MPVAnswer = [System.Windows.Forms.MessageBox]::Show('Install mpv?' , 'mpv' , 4, 32)
if ($MPVAnswer -eq 'Yes') {
    Write-Host 'mpv > Install' -ForegroundColor green -BackgroundColor black
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1 | Invoke-Expression
}
$OfficeAnswer = [System.Windows.Forms.MessageBox]::Show('Install Office?' , 'Office' , 4, 32)
if ($OfficeAnswer -eq 'Yes') {
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1 | Invoke-Expression
}
$qBittorrentAnswer = [System.Windows.Forms.MessageBox]::Show('Install qBittorrent?' , 'qBittorrent' , 4, 32)
if ($qBittorrentAnswer -eq 'Yes') {
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1 | Invoke-Expression
}
$EdgeUninstallAnswer = [System.Windows.Forms.MessageBox]::Show('Uninstall Edge?

Not recommended, some apps like Visual Studio use Edge.' , 'Edge' , 4, 48)
if ($EdgeUninstallAnswer -eq 'Yes') {
    Write-Host 'Microsoft Edge > Uninstall' -ForegroundColor green -BackgroundColor black
    Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1 | Invoke-Expression
    Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1 | Invoke-Expression
}
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00