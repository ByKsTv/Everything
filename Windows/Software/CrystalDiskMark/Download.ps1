[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$DDL = [Uri]::UnescapeDataString((Invoke-WebRequest -UseBasicParsing -Uri 'https://crystalmark.info/redirect.php?product=CrystalDiskMarkInstaller' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location) -replace '.*ad_redirect\.php\?url=', ''
$CrystalDiskMark = New-Object System.Net.WebClient
$CrystalDiskMark.Headers.Add('user-agent', 'Wget')
$CrystalDiskMark.DownloadFile($DDL, "$env:temp\CrystalDiskMark.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: CrystalDiskMark: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'