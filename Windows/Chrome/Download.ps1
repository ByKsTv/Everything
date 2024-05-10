if ((Test-Path -LiteralPath "$env:ProgramFiles\Google\Chrome\Application") -ne $true) {
    Write-Host 'Chrome > Open Download URL On Edge Browser' -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('msedge.exe', 'https://www.google.com/chrome/')
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
    Write-Host 'Chrome > Waiting for Edge Browser' -ForegroundColor green -BackgroundColor black
    while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Edge' } -ErrorAction SilentlyContinue))) {
    }
    Start-Sleep 1
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Edge' }).MainWindowHandle)
    Start-Sleep 5
    Add-Type -AssemblyName System.Windows.Forms
    Write-Host 'Chrome > Open Console On Edge Browser' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('^+j')
    Start-Sleep 5
    #Write-Host 'Chrome > Focus Console On Edge Browser' -ForegroundColor green -BackgroundColor black
    #[System.Windows.Forms.SendKeys]::SendWait('{TAB}')
    #Start-Sleep 1
    #[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'chr-checkbox__input js-stats-cb-sdf'{)}{[}0{]}.click{(}{)}")
    #[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    #[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'environment environment--active'{)}{[}0{]}.click{(}{)}")
    #[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Write-Host 'Chrome > Download Chrome Using Console On Edge Browser' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'chr-download-button chr-download-button--header js-accept-install'{)}{[}0{]}.click{(}{)}")
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    #[System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'chr-link js-download show'{)}{[}0{]}.click{(}{)}")
    #[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    $Downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    Write-Host 'Chrome > Waiting For Download To Complete' -ForegroundColor green -BackgroundColor black
    While (!(Test-Path "$Downloads\ChromeSetup.exe" -ErrorAction SilentlyContinue)) {
    }
    do {
        $dirStats = Get-Item "$Downloads\ChromeSetup.exe" | Measure-Object -Sum Length
    } 
    until( ($dirStats.Sum -ne 0) )
    Write-Host 'Chrome > Install' -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$Downloads\ChromeSetup.exe"
}