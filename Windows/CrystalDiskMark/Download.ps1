Write-Host 'CrystalDiskMark: Downloading' -ForegroundColor green -BackgroundColor black
$CrystalDiskMark = New-Object System.Net.WebClient
$CrystalDiskMark.Headers.Add('user-agent', 'Wget')
$CrystalDiskMark.DownloadFile('https://crystalmark.info/redirect.php?product=CrystalDiskMarkInstaller', "$ENV:temp\CrystalDiskMark.exe")

Write-Host 'CrystalDiskMark: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'