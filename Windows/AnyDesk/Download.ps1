Write-Host 'AnyDesk: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.anydesk.com/AnyDesk.exe', "$env:TEMP\AnyDesk.exe")

Write-Host 'AnyDesk: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\AnyDesk.exe -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --create-shortcuts --create-desktop-icon --silent'

Write-Host 'AnyDesk: Optional Offer - Recommended by AnyDesk: Decline' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Name 'AnyDesk Software GmbH' -Value 30241008 -PropertyType DWord -Force