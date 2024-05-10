Unregister-ScheduledTask -TaskName Step4 -Confirm:$false
Write-Host 'Settings > Update & Security > Check for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/OO_ShutUp10/Download.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Network.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')
Add-Type -AssemblyName System.Windows.Forms
$NVCleanstallAnswer = [System.Windows.Forms.MessageBox]::Show('Install NVCleanstall?' , 'NVCleanstall' , 4, 32)
if ($NVCleanstallAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')
}
$PlexAnswer = [System.Windows.Forms.MessageBox]::Show('Install Plex?' , 'Plex' , 4, 32)
if ($PlexAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')
}
$7ZipAnswer = [System.Windows.Forms.MessageBox]::Show('Install 7-Zip?' , '7-Zip' , 4, 32)
if ($7ZipAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
}
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
$CrystalDiskInfoAnswer = [System.Windows.Forms.MessageBox]::Show('Install CrystalDiskInfo?' , 'CrystalDiskInfo' , 4, 32)
if ($CrystalDiskInfoAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskInfo/Download.ps1')
}
$CrystalDiskMarkAnswer = [System.Windows.Forms.MessageBox]::Show('Install CrystalDiskMark?' , 'CrystalDiskMark' , 4, 32)
if ($CrystalDiskMarkAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskMark/Download.ps1')
}
$AnyDeskAnswer = [System.Windows.Forms.MessageBox]::Show('Install AnyDesk?' , 'AnyDesk' , 4, 32)
if ($AnyDeskAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/AnyDesk/Download.ps1')
}
$Display_Driver_UninstallerAnswer = [System.Windows.Forms.MessageBox]::Show('Install Display Driver Uninstaller?' , 'Display Driver Uninstaller' , 4, 32)
if ($Display_Driver_UninstallerAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Download.ps1')
}
$Visual_Studio_CodeAnswer = [System.Windows.Forms.MessageBox]::Show('Install Visual Studio Code?' , 'Visual Studio Code' , 4, 32)
if ($Visual_Studio_CodeAnswer -eq 'Yes') {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')
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
    # wait for script update:
    #Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1')
    # test it after windows update:
    #Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/he3als/EdgeRemover/main/RemoveEdge.ps1')"
    #Start-Sleep -Milliseconds 2000
    #[System.Windows.Forms.SendKeys]::SendWait('2')
}
$RestartAnswer = [System.Windows.Forms.MessageBox]::Show('Restart?' , 'Restart' , 4, 32)
if ($RestartAnswer -eq 'Yes') {
    shutdown /r /t 00
}