Write-Host 'Mozila Firefox: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")

Write-Host 'Mozila Firefox: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait

Write-Host 'Mozila Firefox: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"

Write-Host 'Mozila Firefox: Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
}
Start-Sleep -Milliseconds 10000

Write-Host 'Mozila Firefox: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
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

Write-Host 'Mozila Firefox: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozila Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait(' ')
Start-Sleep -Milliseconds 100

Write-Host 'Mozila Firefox: Setting as default browser' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

Write-Host 'Mozila Firefox: Waiting for user to sign in' -ForegroundColor green -BackgroundColor black
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/')