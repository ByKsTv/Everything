Write-Host 'Firefox Setup' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://download.mozilla.org/?product=firefox-stub -OutFile $env:TEMP\firefox-stub.exe
Start-Process $env:TEMP\firefox-stub.exe