Write-Host 'HyperX NGENUITY: Downloading' -ForegroundColor green -BackgroundColor black
$Hyperx = New-Object System.Net.WebClient
$Hyperx.Headers.Add('user-agent', 'Wget')
$Hyperx.DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://hyperx.com/pages/ngenuity' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match '.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$ENV:temp\HyperX_NGENUITY.exe")

Write-Host 'HyperX NGENUITY: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\HyperX_NGENUITY.exe