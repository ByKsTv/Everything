Add-Type @'
using System;
using System.Runtime.InteropServices;
public class SFW {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -eq $true) {
    [System.Diagnostics.Process]::Start('chrome.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
if ((Test-Path -LiteralPath "$env:ProgramFiles\Mozilla Firefox") -eq $true) {
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/')
}
Start-Sleep -Milliseconds 6000
$BrowserWindow = Get-Process | Where-Object { $_.mainWindowTitle -match 'chrome' -or $_.mainWindowTitle -match 'firefox' }
Write-Host 'Browser > Set Foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow($BrowserWindow.MainWindowHandle)
Start-Sleep -Milliseconds 1000
Add-Type -AssemblyName System.Windows.Forms
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ((Test-Path -LiteralPath "$env:ProgramFiles\Mozilla Firefox") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+k')
}
Start-Sleep -Milliseconds 2000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'button startbutton'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'closest'{)}{[}0{]}.click{(}{)}")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
}
if ((Test-Path -LiteralPath "$env:ProgramFiles\Mozilla Firefox") -eq $true) {
    [System.Windows.Forms.SendKeys]::SendWait('^+i')
}
$Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$NVCleanstallPath = Join-Path $Downloads 'NVCleanstall_*.exe'
While (!(Test-Path $NVCleanstallPath -ErrorAction SilentlyContinue)) {
}
do {
    $dirStats = Get-Item $NVCleanstallPath | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -ne 0) )
Start-Process -FilePath $NVCleanstallPath -ArgumentList '/install /tasks="DriverUpdateCheck,DesktopIcon" /silent'