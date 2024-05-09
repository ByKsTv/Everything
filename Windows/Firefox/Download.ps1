if ((Test-Path -LiteralPath "$env:ProgramFiles\Mozilla Firefox") -ne $true) {
    Write-Host 'Firefox > Download' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")
    Write-Host 'Firefox > Install' -ForegroundColor green -BackgroundColor black
    Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait
    Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
    Start-Sleep -Milliseconds 6000
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
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/')
}