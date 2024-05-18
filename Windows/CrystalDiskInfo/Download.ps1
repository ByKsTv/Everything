Write-Host 'CrystalDiskInfo: Downloading' -ForegroundColor green -BackgroundColor black
$CrystalDiskInfo = New-Object System.Net.WebClient
$CrystalDiskInfo.Headers.Add('user-agent', 'Wget')
$CrystalDiskInfo.DownloadFile('https://crystalmark.info/redirect.php?product=CrystalDiskInfoInstaller', "$ENV:temp\CrystalDiskInfo.exe")

Write-Host 'CrystalDiskInfo: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\CrystalDiskInfo.exe -ArgumentList '/VERYSILENT'