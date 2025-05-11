[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskInfo: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$CrystalDiskInfo = New-Object System.Net.WebClient
$CrystalDiskInfo.Headers.Add('user-agent', 'Wget')
$CrystalDiskInfo.DownloadFile('https://sourceforge.net/projects/crystaldiskinfo/files/latest/download', "$env:temp\CrystalDiskInfo.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskInfo: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:temp\CrystalDiskInfo.exe -ArgumentList '/VERYSILENT'