if (!(Test-Path -Path "$env:TEMP\Windows 10 IoT Enterprise LTSC 2021.iso")) {
    Write-Host 'Windows 10 IoT Enterprise LTSC 2021: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://massgrave.dev/windows_ltsc_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'windows_10_iot_enterprise_ltsc_2021_x64') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\Windows 10 IoT Enterprise LTSC 2021.iso")
}

Write-Host 'Rufus: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://rufus.ie/en/' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match '.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\Rufus.exe")

Write-Host 'Rufus: Starting' -ForegroundColor green -BackgroundColor black
Start-Process cmd -ArgumentList "/C start $env:TEMP\Rufus.exe"

Write-Host 'Rufus: Waiting for window' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Rufus' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Rufus: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
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

Write-Host 'Rufus: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Rufus' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host 'Rufus: Selecting .ISO' -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 2000

Write-Host 'Rufus: Selecting .ISO folder' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('{F4}')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait('^a')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait("$env:LOCALAPPDATA\Temp")
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
Start-Sleep -Milliseconds 1000
[System.Windows.Forms.SendKeys]::SendWait('%n')
Start-Sleep -Milliseconds 1000

Write-Host 'Rufus: Selecting .ISO file' -ForegroundColor green -BackgroundColor black
[System.Windows.Forms.SendKeys]::SendWait('Windows 10 IoT Enterprise LTSC 2021.iso')
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')