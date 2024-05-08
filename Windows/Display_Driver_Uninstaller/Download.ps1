Write-Host 'Display Driver Uninstaller > Get latest' -ForegroundColor green -BackgroundColor black
$DDU1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.wagnardsoft.com/display-driver-uninstaller-DDU-' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download Display Driver Uninstaller') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU2 = 'https://www.wagnardsoft.com' + $DDU1
$DDU3 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'DOWNLOAD') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU4 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU3 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
Write-Host 'Display Driver Uninstaller > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($DDU4, "$env:TEMP\DDU.exe")
if (!(Test-Path -Path $env:ProgramFiles\7-Zip)) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
}
$DesktopPath = [Environment]::GetFolderPath('Desktop')
Write-Host 'Display Driver Uninstaller > Extract to desktop' -ForegroundColor green -BackgroundColor black
&$env:ProgramFiles\7-Zip\7z.exe x "$env:TEMP\DDU.exe" -o"$DesktopPath" -y