Write-Host 'Plex: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
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

Write-Host 'Plex: Checking which browser is installed' -ForegroundColor green -BackgroundColor black
$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

Write-Host 'Plex: Downloading' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    [System.Diagnostics.Process]::Start('chrome.exe', 'https://www.plex.tv/media-server-downloads/#plex-media-server')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://www.plex.tv/media-server-downloads/#plex-media-server')
}

Write-Host 'Plex: Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
}
Start-Sleep -Milliseconds 1000

Write-Host 'Plex: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host 'Plex: Starting browser console' -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
if ($InstalledSoftware -match 'Chrome') {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Windows.Forms.SendKeys]::SendWait('^+k')
}
Start-Sleep -Milliseconds 2000

Write-Host 'Plex: Sending download click using browser console' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'user-arch'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000

Write-Host 'Plex: Closing browser console' -ForegroundColor green -BackgroundColor black
if ($InstalledSoftware -match 'Chrome') {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ($InstalledSoftware -match 'Firefox') {
    [System.Windows.Forms.SendKeys]::SendWait('^+i')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('%o')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('s')
}

Write-Host 'Plex: Waiting for download to complete' -ForegroundColor green -BackgroundColor black
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
While (!(Test-Path "$Downloads\PlexMediaServer*.exe" -ErrorAction SilentlyContinue)) {
}
do {
    $dirStats = Get-Item "$Downloads\PlexMediaServer*.exe" | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )

Write-Host 'Plex: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$Downloads\PlexMediaServer*.exe" -ArgumentList '/VERYSILENT'