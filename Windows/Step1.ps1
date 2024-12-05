$NextStep_TaskName = 'Step2'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep_TaskName.ps1", "$env:TEMP\$NextStep_TaskName.ps1")
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NextStep_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
$NextStep_TaskAction = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep_TaskName.ps1"
$NextStep_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
$NextStep_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName $NextStep_TaskName -Action $NextStep_TaskAction -Trigger $NextStep_TaskTrigger -Principal $NextStep_TaskPrincipal -Settings $NextStep_TaskSettings -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing Edge'); [Console]::ResetColor(); [Console]::WriteLine()
$stopedgerunning = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
$stopedgerunning | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "1. Pin 'File Explorer' to taskbar
2. Unpin 'Documents' and 'Pictures' from Quick Access"
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Power Plan: Display: Turn off display after: 0 Seconds (Never)'); [Console]::ResetColor(); [Console]::WriteLine()
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Power Plan: Shutdown settings: Disabling Fast Startup'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -PropertyType DWord -Value 0 -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Disabling Restart Apps'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name RestartApps -PropertyType DWord -Value 0 -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Name: Renaming to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:username'"); [Console]::ResetColor(); [Console]::WriteLine()
if ($env:computername -ne $env:username) {
	Rename-Computer -NewName $env:username
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Changing to never expires'); [Console]::ResetColor(); [Console]::WriteLine()
Set-LocalUser -Name $env:username -PasswordNeverExpires 1
net accounts /maxpwage:unlimited

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('AutoAdminLogon: Adding username'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon') -ne $true) {
 New-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Initial_Setup.ps1')

(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2('7971f918-a847-4430-9279-4a52d1efe18d', 7, '')
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name IsExpedited -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 0 -Force
Start-Process -FilePath 'ms-settings:windowsupdate'
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "Wait for Windows Updates.
1. Click on 'View optional updates'
2. Click on 'Driver updates'
3. Select all
4. Click on 'Download and install'"
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = 'Please restart PC after installing all Windows Updates'
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()