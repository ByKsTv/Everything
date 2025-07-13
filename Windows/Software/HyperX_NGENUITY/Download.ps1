[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: HyperX NGENUITY: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
$Hyperx = New-Object System.Net.WebClient
$Hyperx.Headers.Add('user-agent', 'Wget')
$Hyperx.DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://hyperx.com/pages/ngenuity' | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -match '.exe' } | Select-Object -First 1 | Select-Object -ExpandProperty 'href'), "$env:temp\HyperX_NGENUITY.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: HyperX NGENUITY: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $env:TEMP\HyperX_NGENUITY.exe