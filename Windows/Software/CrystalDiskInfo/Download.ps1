[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('CrystalDiskInfo: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$DDL = [Uri]::UnescapeDataString((Invoke-WebRequest -UseBasicParsing -Uri 'https://crystalmark.info/redirect.php?product=CrystalDiskInfoInstaller' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location) -replace '.*ad_redirect\.php\?url=', ''
$CrystalDiskInfo = New-Object System.Net.WebClient
$CrystalDiskInfo.Headers.Add('user-agent', 'Wget')
$CrystalDiskInfo.DownloadFile($DDL, "$env:temp\CrystalDiskInfo.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('CrystalDiskInfo: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:temp\CrystalDiskInfo.exe -ArgumentList '/VERYSILENT'