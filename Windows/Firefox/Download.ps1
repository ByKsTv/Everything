if ((Test-Path -LiteralPath "$env:ProgramFiles\Mozilla Firefox") -ne $true) {
    Write-Host 'Firefox > Download' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")
    Write-Host 'Firefox > Install' -ForegroundColor green -BackgroundColor black
    Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait
    Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
    while (($null -eq (Get-Process -Name 'firefox' -ErrorAction SilentlyContinue))) {
    }
    Start-Sleep -Milliseconds 1000
    Add-Type @'
    using System;
    using System.Runtime.InteropServices;
    public class SFW {
       [DllImport("user32.dll")]
       [return: MarshalAs(UnmanagedType.Bool)]
       public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
'@
    $FirefoxWindow = Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }
    Write-Host 'Firefox > Set Foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow($FirefoxWindow.MainWindowHandle)
    Start-Sleep -Milliseconds 1000
    Write-Host 'Firefox > Import from browser > Uncheck' -ForegroundColor green -BackgroundColor black
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
    [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
    [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
    [System.Windows.Forms.SendKeys]::SendWait(' ')
    Start-Sleep -Milliseconds 100
    Write-Host 'Firefox > Set as default' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Write-Host 'Firefox > Sign in' -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/')
}