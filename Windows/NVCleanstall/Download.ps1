Write-Host 'NVCleanstall > Add option to set browser to foreground' -ForegroundColor green -BackgroundColor black
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
$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
Write-Host 'NVCleanstall > Download' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    [System.Diagnostics.Process]::Start('chrome.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
Write-Host 'NVCleanstall > Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
}
Start-Sleep -Milliseconds 1000
Write-Host 'NVCleanstall > Set Foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000
Add-Type -AssemblyName System.Windows.Forms
if ($InstalledSoftware -match 'Chrome') {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Windows.Forms.SendKeys]::SendWait('^+k')
}
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'button startbutton'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'closest'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
if ($InstalledSoftware -match 'Chrome') {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Windows.Forms.SendKeys]::SendWait('^+i')
}
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
Write-Host 'NVCleanstall > Waiting for download' -ForegroundColor green -BackgroundColor black
While (!(Test-Path "$Downloads\NVCleanstall*.exe" -ErrorAction SilentlyContinue)) {
}
do {
    $dirStats = Get-Item "$Downloads\NVCleanstall*.exe" | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )
Write-Host 'NVCleanstall > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$Downloads\NVCleanstall*.exe" -ArgumentList '/install /tasks="DriverUpdateCheck,DesktopIcon" /verysilent' -Wait