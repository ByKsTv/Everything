Unregister-ScheduledTask -TaskName Step4 -Confirm:$false
Write-Host 'Settings > Update & Security > Check for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/OO_ShutUp10/Download.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Network.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
Add-Type -AssemblyName System.Windows.Forms
$PythonAnswer = [System.Windows.Forms.MessageBox]::Show('Install Python?' , 'Python' , 4, 32)
if ($PythonAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
}
$MPVAnswer = [System.Windows.Forms.MessageBox]::Show('Install mpv?' , 'mpv' , 4, 32)
if ($MPVAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1')
}
$qBittorrentAnswer = [System.Windows.Forms.MessageBox]::Show('Install qBittorrent?' , 'qBittorrent' , 4, 32)
if ($qBittorrentAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
}
$TelegramAnswer = [System.Windows.Forms.MessageBox]::Show('Install Telegram?' , 'Telegram' , 4, 32)
if ($TelegramAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Telegram/Download.ps1')
}
$NordVPNAnswer = [System.Windows.Forms.MessageBox]::Show('Install NordVPN?' , 'NordVPN' , 4, 32)
if ($NordVPNAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NordVPN/Download.ps1')
}
$SteamAnswer = [System.Windows.Forms.MessageBox]::Show('Install Steam?' , 'Steam' , 4, 32)
if ($SteamAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Steam/Download.ps1')
}
$NotepadPlusPlusAnswer = [System.Windows.Forms.MessageBox]::Show('Install Notepad++?' , 'Notepad++' , 4, 32)
if ($NotepadPlusPlusAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad_Plus_Plus/Download.ps1')
}
$MediaInfoAnswer = [System.Windows.Forms.MessageBox]::Show('Install MediaInfo?' , 'MediaInfo' , 4, 32)
if ($MediaInfoAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')
}
$DiscordAnswer = [System.Windows.Forms.MessageBox]::Show('Install Discord?' , 'Discord' , 4, 32)
if ($DiscordAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
}
$RazerSynapseAnswer = [System.Windows.Forms.MessageBox]::Show('Install Razer Synapse?' , 'Razer Synapse' , 4, 32)
if ($RazerSynapseAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Razer_Synapse/Download.ps1')
}
$Logitech_G_HUBAnswer = [System.Windows.Forms.MessageBox]::Show('Install Logitech G HUB?' , 'Logitech G HUB' , 4, 32)
if ($Logitech_G_HUBAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Logitech_G_HUB/Download.ps1')
}
$BattlenetAnswer = [System.Windows.Forms.MessageBox]::Show('Install Battle.net?' , 'Battle.net' , 4, 32)
if ($BattlenetAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Battle.net/Download.ps1')
}
$JellyfinAnswer = [System.Windows.Forms.MessageBox]::Show('Install Jellyfin?' , 'Jellyfin' , 4, 32)
if ($JellyfinAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Jellyfin/Download.ps1')
}
$HyperX_NGENUITYAnswer = [System.Windows.Forms.MessageBox]::Show('Install HyperX NGENUITY?' , 'HyperX NGENUITY' , 4, 32)
if ($HyperX_NGENUITYAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/HyperX_NGENUITY/Download.ps1')
}
$OfficeAnswer = [System.Windows.Forms.MessageBox]::Show('Install Office?' , 'Office' , 4, 32)
if ($OfficeAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1')
}
$EdgeUninstallAnswer = [System.Windows.Forms.MessageBox]::Show('Uninstall Edge?

Not recommended, some apps like Visual Studio use Edge.' , 'Edge' , 4, 48)
if ($EdgeUninstallAnswer -eq 'Yes') {
    Write-Host 'Microsoft Edge > Uninstall' -ForegroundColor green -BackgroundColor black
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1')
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1')
}
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00