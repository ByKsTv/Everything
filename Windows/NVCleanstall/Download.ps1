Write-Host 'NVCleanstall: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
if (-not ([System.Management.Automation.PSTypeName]'SFW').Type) {
    Add-Type @'
using System;
using System.Runtime.InteropServices;
public class SFW {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
}

Write-Host 'NVCleanstall: Checking which browser is installed' -ForegroundColor green -BackgroundColor black
$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

Write-Host 'NVCleanstall: Downloading' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    [System.Diagnostics.Process]::Start('chrome.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
Write-Host 'NVCleanstall: Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 1000

Write-Host 'NVCleanstall: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host 'NVCleanstall: Starting browser console' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    (New-Object -ComObject wscript.shell).SendKeys('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    (New-Object -ComObject wscript.shell).SendKeys('^+k')
}
Start-Sleep -Milliseconds 2000

Write-Host 'NVCleanstall: Sending download click using browser console' -ForegroundColor green -BackgroundColor black
(New-Object -ComObject wscript.shell).SendKeys("document.getElementsByClassName{(}'button startbutton'{)}{[}0{]}.click{(}{)}")
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000
(New-Object -ComObject wscript.shell).SendKeys("document.getElementsByClassName{(}'closest'{)}{[}0{]}.click{(}{)}")
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

Write-Host 'NVCleanstall: Closing browser console' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    (New-Object -ComObject wscript.shell).SendKeys('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    (New-Object -ComObject wscript.shell).SendKeys('^+i')
}

Write-Host 'NVCleanstall: Waiting for download to complete' -ForegroundColor green -BackgroundColor black
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
While (!(Test-Path "$Downloads\NVCleanstall*.exe" -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
do {
    $dirStats = Get-Item "$Downloads\NVCleanstall*.exe" | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )

Write-Host 'NVCleanstall: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$Downloads\NVCleanstall*.exe" -ArgumentList '/install /tasks="DriverUpdateCheck,DesktopIcon" /verysilent' -Wait

Write-Host 'NVCleanstall: Deleting from Downloads folder' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$Downloads\NVCleanstall*.exe") -eq $true) {
    Remove-Item -Path ("$Downloads\NVCleanstall*.exe")
}

Write-Host 'NVCleanstall: Using custom settings' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall' -Force
}
$NVCleanstallCustomSettings = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/settings.json')
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall' -Name 'PreviousTweaks' -Value $NVCleanstallCustomSettings -PropertyType String -Force