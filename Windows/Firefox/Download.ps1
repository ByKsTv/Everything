[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Downloading group policy'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/mozilla/policy-templates/releases/latest').assets | Where-Object name -Like 'policy_templates*' ).browser_download_url, "$env:TEMP\policy_templates_firefox.zip")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Extracting group policy'); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path "$env:TEMP\policy_templates_firefox.zip" -DestinationPath "$env:TEMP\policy_templates_firefox" -ErrorAction SilentlyContinue

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Importing group policy'); [Console]::ResetColor(); [Console]::WriteLine()
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\firefox.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\mozilla.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\en-US\firefox.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_firefox\windows\en-US\mozilla.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting Policy'); [Console]::ResetColor(); [Console]::WriteLine()
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$env:TEMP\firefox.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:TEMP\firefox.exe -ArgumentList '/S' -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Deleting Desktop Shortcut'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path "$env:PUBLIC\Desktop\Firefox.lnk") -eq $true) {
    Remove-Item -Path ("$env:PUBLIC\Desktop\Firefox.lnk")
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Starting'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process "$env:ProgramFiles\Mozilla Firefox\firefox.exe"

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 10000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozilla Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys(' ')
Start-Sleep -Milliseconds 100

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting as default browser'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for user to sign in'); [Console]::ResetColor(); [Console]::WriteLine()
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/?context=fx_desktop_v3&entrypoint=fxa_toolbar_button&action=email&service=sync')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Deleting Scheduled Tasks'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla') -eq $true) {
    Unregister-ScheduledTask -TaskName 'Firefox Background Update*' -Confirm:$false
    Unregister-ScheduledTask -TaskName 'Firefox Default Browser Agent*' -Confirm:$false
    $scheduleObject = New-Object -ComObject Schedule.Service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder('\')
    $rootFolder.DeleteFolder('Mozilla', $null)
    Remove-Item -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}