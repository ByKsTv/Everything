if (!(Test-Path -Path "$env:TEMP\Windows 10 IoT Enterprise LTSC 2021.iso")) {
    Write-Host 'Windows 10 IoT Enterprise LTSC 2021: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://massgrave.dev/windows_ltsc_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'windows_10_iot_enterprise_ltsc_2021_x64') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\Windows_10_IoT_Enterprise_LTSC_2021.iso")
}

Write-Host 'Rufus: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://rufus.ie/en/' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match '.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\Rufus.exe")

Write-Host 'Rufus: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:TEMP\Rufus.exe" -ArgumentList "--gui --locale=en-US --iso=$env:TEMP\Windows_10_IoT_Enterprise_LTSC_2021.iso"