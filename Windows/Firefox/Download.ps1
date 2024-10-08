Write-Host 'Mozilla Firefox: Downloading group policy' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/mozilla/policy-templates/releases/latest').assets | Where-Object name -Like 'policy_templates*' ).browser_download_url, "$env:TEMP\policy_templates_firefox.zip")

Write-Host 'Mozilla Firefox: Extracting group policy' -ForegroundColor green -BackgroundColor black
Expand-Archive -Path "$env:TEMP\policy_templates_firefox.zip" -DestinationPath "$env:TEMP\policy_templates_firefox" -ErrorAction SilentlyContinue

Write-Host 'Mozilla Firefox: Importing group policy' -ForegroundColor green -BackgroundColor black
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\firefox.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\mozilla.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\en-US\firefox.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\en-US\mozilla.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue

Write-Host 'Mozilla Firefox: Setting Policy' -ForegroundColor green -BackgroundColor black
# https://mozilla.github.io/policy-templates/
if ((Test-Path -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox') -ne $true) {
    New-Item 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableDefaultBrowserAgent' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'BackgroundAppUpdate' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'NoDefaultBookmarks' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableTelemetry' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFeedbackCommands' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFirefoxStudies' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisablePocket' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableProfileRefresh' -Value 1 -PropertyType DWord -Force

Write-Host 'Mozilla Firefox: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")

Write-Host 'Mozilla Firefox: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait

Write-Host 'Mozilla Firefox: Deleting Desktop Shortcut' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:PUBLIC\Desktop\Firefox.lnk") -eq $true) {
    Remove-Item -Path ("$env:PUBLIC\Desktop\Firefox.lnk")
}

Write-Host 'Mozilla Firefox: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"

Write-Host 'Mozilla Firefox: Waiting for browser' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
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
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys(' ')
Start-Sleep -Milliseconds 100

Write-Host 'Mozilla Firefox: Setting as default browser' -ForegroundColor green -BackgroundColor black
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

Write-Host 'Mozilla Firefox: Waiting for user to sign in' -ForegroundColor green -BackgroundColor black
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/?context=fx_desktop_v3&entrypoint=fxa_toolbar_button&action=email&service=sync')
Start-Sleep -Milliseconds 1000

Write-Host 'Mozilla Firefox: Setting foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)

Write-Host 'Mozilla Firefox: Deleting Scheduled Tasks' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla') -eq $true) {
    Unregister-ScheduledTask -TaskName 'Firefox Background Update*' -Confirm:$false
    Unregister-ScheduledTask -TaskName 'Firefox Default Browser Agent*' -Confirm:$false
    $scheduleObject = New-Object -ComObject Schedule.Service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder('\')
    $rootFolder.DeleteFolder('Mozilla', $null)
    Remove-Item -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}