Write-Host 'Display Driver Uninstaller: Getting latest release' -ForegroundColor green -BackgroundColor black
$DDU1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.wagnardsoft.com/display-driver-uninstaller-DDU-' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download Display Driver Uninstaller') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU2 = 'https://www.wagnardsoft.com' + $DDU1
$DDU3 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'DOWNLOAD') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU4 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU3 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'setup.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Display Driver Uninstaller: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($DDU4, "$env:TEMP\DDU.exe")

Write-Host 'Display Driver Uninstaller: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DDU.exe -ArgumentList '/S'

Write-Host 'Display Driver Uninstaller: Using custom settings' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Settings.xml', "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings\Settings.xml")