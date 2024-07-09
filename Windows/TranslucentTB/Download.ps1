Write-Host 'TranslucentTB: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest').assets | Where-Object name -Like '*appinstaller*').browser_download_url, "$env:TEMP\TranslucentTB.appinstaller")

Write-Host 'TranslucentTB: Installing' -ForegroundColor green -BackgroundColor black
Add-AppxPackage -AppInstallerFile "$env:TEMP\TranslucentTB.appinstaller"

Write-Host 'TranslucentTB: Using custom settings' -ForegroundColor green -BackgroundColor black
$TranslucentTBLoc = Get-Item -Path "$env:LOCALAPPDATA\Packages\*TranslucentTB*\RoamingState\"
$TranslucentTBSettingsLoc = "$TranslucentTBLoc\settings.json"
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/TranslucentTB/settings.json', "$TranslucentTBSettingsLoc")

Write-Host 'TranslucentTB: Hiding pop-up' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\*TranslucentTB*' -Name 'WasEverActivated' -Value 1 -PropertyType DWord -Force