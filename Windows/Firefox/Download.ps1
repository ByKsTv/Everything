Write-Host 'Mozilla Firefox: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")

Write-Host 'Mozilla Firefox: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait

Write-Host 'Mozilla Firefox: Hosts: Adding incoming.telemetry.mozilla.org' -ForegroundColor green -BackgroundColor black
$Mozillaincomingtelemetry = Select-String -Path $env:windir\System32\drivers\etc\hosts -Pattern 'incoming.telemetry.mozilla.org'
if ($null -eq $Mozillaincomingtelemetry) {
	Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1`tincoming.telemetry.mozilla.org" -Force
}

Write-Host 'Mozilla Firefox: Deleting Desktop Shortcut' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:PUBLIC\Desktop\Firefox.lnk") -eq $true) {
    Remove-Item -Path ("$env:PUBLIC\Desktop\Firefox.lnk")
}

Write-Host 'Mozilla Firefox: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"

Write-Host 'Mozilla Firefox: Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
}
Start-Sleep -Milliseconds 10000

Write-Host 'Mozilla Firefox: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
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

Write-Host 'Mozilla Firefox: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozilla Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait(' ')
Start-Sleep -Milliseconds 100

Write-Host 'Mozilla Firefox: Setting as default browser' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

Write-Host 'Mozilla Firefox: Waiting for user to sign in' -ForegroundColor green -BackgroundColor black
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/?context=fx_desktop_v3&entrypoint=fxa_toolbar_button&action=email&service=sync')