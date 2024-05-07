Write-Host 'CrystalDiskMark > Download' -ForegroundColor green -BackgroundColor black
$CrystalDiskMark = New-Object System.Net.WebClient
$CrystalDiskMark.Headers.Add('user-agent', 'Wget')
$CrystalDiskMark.DownloadFile('https://sourceforge.net/projects/CrystalDiskMark/files/latest/download', "$ENV:temp\CrystalDiskMark.exe")
Write-Host 'CrystalDiskMark > Install' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'