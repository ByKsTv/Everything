Write-Host 'Mozila Firefox: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")

Write-Host 'Mozila Firefox: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait

Write-Host 'Mozila Firefox: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"

Write-Host 'Mozila Firefox: Waiting for process' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process -Name 'firefox' -ErrorAction SilentlyContinue))) {
}
Start-Sleep -Milliseconds 1000

Write-Host 'Mozila Firefox: Setting foreground' -ForegroundColor green -BackgroundColor black
(New-Object -ComObject WScript.Shell).AppActivate((Get-Process firefox).MainWindowTitle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozila Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait(' ')
Start-Sleep -Milliseconds 100

Write-Host 'Mozila Firefox: Setting as default browser' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

Write-Host 'Mozila Firefox: Waiting for user to sign in' -ForegroundColor green -BackgroundColor black
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/')