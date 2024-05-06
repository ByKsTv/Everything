Write-Host 'Firefox > Download' -ForegroundColor green -BackgroundColor black
#Invoke-WebRequest -Uri https://download.mozilla.org/?product=firefox-stub -OutFile $env:TEMP\firefox-stub.exe
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-stub', "$env:TEMP\firefox-stub.exe")
Write-Host 'Firefox > Install' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\firefox-stub.exe -Wait
Start-Sleep -Milliseconds 5000
Write-Host 'Firefox > Import from browser > Uncheck' -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait(' ')
Start-Sleep -Milliseconds 100
Write-Host 'Firefox > Set as default' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 3000
Write-Host 'Firefox > Sign in' -ForegroundColor green -BackgroundColor black
$OpenWithFirefox = New-Object System.Diagnostics.Process
$OpenWithFirefox.StartInfo.Filename = 'firefox.exe'
$OpenWithFirefox.StartInfo.Arguments = 'about:preferences#sync'
$OpenWithFirefox.start()