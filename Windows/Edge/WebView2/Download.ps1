Write-Host 'Edge WebView2: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=2124701', "$env:TEMP\MicrosoftEdgeWebView2RuntimeInstallerX64.exe")

Write-Host 'Edge WebView2: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\MicrosoftEdgeWebView2RuntimeInstallerX64.exe