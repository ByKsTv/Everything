Start-Process powershell.exe -ArgumentList '-NoProfile -WindowStyle Minimized -Command "Invoke-Expression (New-Object Net.WebClient).DownloadString(''https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Update.ps1'')"'

$NextStep_TaskName = 'Step2'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NextStep_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
$NextStep_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Maximized -Command `"`$Host.UI.RawUI.WindowTitle = '$NextStep_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_11_IoT_Enterprise_LTSC_2024/$NextStep_TaskName.ps1')`""
$NextStep_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
$NextStep_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName $NextStep_TaskName -Action $NextStep_TaskAction -Trigger $NextStep_TaskTrigger -Principal $NextStep_TaskPrincipal -Settings $NextStep_TaskSettings -Force

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/PowerPlan.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Key.ps1')

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$Popup_Text = "Pin 'File Explorer' to taskbar"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Initial_Setup.ps1')

Start-Process -FilePath 'ms-settings:windowsupdate'
& UsoClient.exe StartInteractiveScan

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$Popup_Text = "Wait for Windows Updates.
1. Click on 'Advanced options'
2. Click on 'Optional updates'
3. Select all
4. Click on 'Download & install'"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$Popup_Text = 'Please restart PC after installing all Windows Updates'
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null