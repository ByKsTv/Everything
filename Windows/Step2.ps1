[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Removing current step'); [Console]::ResetColor(); [Console]::WriteLine()
Unregister-ScheduledTask -TaskName Step2 -Confirm:$false

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Initiating next step'); [Console]::ResetColor(); [Console]::WriteLine()
$NextStep_TaskName = 'Step3'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep_TaskName.ps1", "$env:TEMP\$NextStep_TaskName.ps1")
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NextStep_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
$NextStep_TaskAction = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep_TaskName.ps1"
$NextStep_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
$NextStep_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName $NextStep_TaskName -Action $NextStep_TaskAction -Trigger $NextStep_TaskTrigger -Principal $NextStep_TaskPrincipal -Settings $NextStep_TaskSettings -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Windows Key: Activating'); [Console]::ResetColor(); [Console]::WriteLine()
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /HWID

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Arkenfox: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Windows Settings: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Restarting'); [Console]::ResetColor(); [Console]::WriteLine()
Restart-Computer -Force