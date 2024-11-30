[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$CrystalDiskMark = New-Object System.Net.WebClient
$CrystalDiskMark.Headers.Add('user-agent', 'Wget')
$CrystalDiskMark.DownloadFile('https://crystalmark.info/redirect.php?product=CrystalDiskMarkInstaller', "$ENV:temp\CrystalDiskMark.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $ENV:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'