[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Display Driver Uninstaller: Getting latest release'); [Console]::ResetColor(); [Console]::WriteLine()
$DDU1 = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.wagnardsoft.com/display-driver-uninstaller-DDU-').Links | Where-Object { $_.outerHTML -match 'Download Display Driver Uninstaller' } | Select-Object -First 1).href
$DDU2 = ((Invoke-WebRequest -UseBasicParsing -Uri ('https://www.wagnardsoft.com' + $DDU1)).Links | Where-Object { $_.outerHTML -match 'DOWNLOAD' } | Select-Object -First 1).href
$DDU3 = ((Invoke-WebRequest -UseBasicParsing -Uri $DDU2).Links | Where-Object { $_.outerHTML -match 'setup.exe' } | Select-Object -First 1).href

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Display Driver Uninstaller: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDU3, "$env:TEMP\DDU.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Display Driver Uninstaller: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $env:TEMP\DDU.exe -ArgumentList '/S'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Display Driver Uninstaller: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings\Settings.xml")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Display Driver Uninstaller: Creating Display Driver Uninstaller folder'); [Console]::ResetColor(); [Console]::WriteLine()
    New-Item -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller" -ItemType Directory -Force
    New-Item -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings" -ItemType Directory -Force
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Display_Driver_Uninstaller/Settings.xml', "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings\Settings.xml")
}