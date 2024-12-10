$NextStep_TaskName = 'Step2'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_10_IoT_Enterprise_LTSC_2021/$NextStep_TaskName.ps1", "$env:TEMP\$NextStep_TaskName.ps1")
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NextStep_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
$NextStep_TaskAction = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep_TaskName.ps1"
$NextStep_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
$NextStep_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName $NextStep_TaskName -Action $NextStep_TaskAction -Trigger $NextStep_TaskTrigger -Principal $NextStep_TaskPrincipal -Settings $NextStep_TaskSettings -Force

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Key.ps1')

# Closing Microsoft Edge
Stop-Process -Name 'MicrosoftEdgeUpdate' -Force

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "1. Pin 'File Explorer' to taskbar
2. Unpin 'Documents' and 'Pictures' from Quick Access"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Initial_Setup.ps1')

Start-Process -FilePath 'ms-settings:windowsupdate'
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "Wait for Windows Updates.
1. Click on 'View optional updates'
2. Click on 'Driver updates'
3. Select all
4. Click on 'Download and install'"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = 'Please restart PC after installing all Windows Updates'
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()