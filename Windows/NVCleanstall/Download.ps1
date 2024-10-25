[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Checking which browser is installed'); [Console]::ResetColor(); [Console]::WriteLine()
$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
if ($InstalledSoftware -match 'Chrome') {
    [System.Diagnostics.Process]::Start('chrome.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Starting browser console'); [Console]::ResetColor(); [Console]::WriteLine()
if ($InstalledSoftware -match 'Chrome') {
    (New-Object -ComObject wscript.shell).SendKeys('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    (New-Object -ComObject wscript.shell).SendKeys('^+k')
}
Start-Sleep -Milliseconds 2000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Sending download click using browser console'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object -ComObject wscript.shell).SendKeys("document.getElementsByClassName{(}'button startbutton'{)}{[}0{]}.click{(}{)}")
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000
(New-Object -ComObject wscript.shell).SendKeys("document.getElementsByClassName{(}'closest'{)}{[}0{]}.click{(}{)}")
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Closing browser console'); [Console]::ResetColor(); [Console]::WriteLine()
if ($InstalledSoftware -match 'Chrome') {
    (New-Object -ComObject wscript.shell).SendKeys('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    (New-Object -ComObject wscript.shell).SendKeys('^+i')
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Waiting for download to complete'); [Console]::ResetColor(); [Console]::WriteLine()
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
While (!(Test-Path "$Downloads\NVCleanstall*.exe" -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
do {
    $dirStats = Get-Item "$Downloads\NVCleanstall*.exe" | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath "$Downloads\NVCleanstall*.exe" -ArgumentList '/install /tasks="DriverUpdateCheck,DesktopIcon" /verysilent' -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Deleting from Downloads folder'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path "$Downloads\NVCleanstall*.exe") -eq $true) {
    Remove-Item -Path ("$Downloads\NVCleanstall*.exe")
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('NVCleanstall: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall' -Force
}
$NVCleanstallCustomSettings = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/settings.json')
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall' -Name 'PreviousTweaks' -Value $NVCleanstallCustomSettings -PropertyType String -Force