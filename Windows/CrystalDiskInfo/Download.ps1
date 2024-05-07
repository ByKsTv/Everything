Write-Host 'CrystalDiskInfo > Download' -ForegroundColor green -BackgroundColor black
$CrystalDiskInfo = New-Object System.Net.WebClient
$CrystalDiskInfo.Headers.Add('user-agent', 'Wget')
$CrystalDiskInfo.DownloadFile('https://sourceforge.net/projects/CrystalDiskInfo/files/latest/download', "$ENV:temp\CrystalDiskInfo.exe")
Write-Host 'CrystalDiskInfo > Install' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\CrystalDiskInfo.exe -ArgumentList '/VERYSILENT'