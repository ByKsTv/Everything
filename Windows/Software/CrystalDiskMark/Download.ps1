[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$CrystalDiskMark = New-Object System.Net.WebClient
$CrystalDiskMark.Headers.Add('user-agent', 'Wget')
$CrystalDiskMark.DownloadFile('https://sourceforge.net/projects/crystaldiskmark/files/latest/download', "$env:temp\CrystalDiskMark.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'