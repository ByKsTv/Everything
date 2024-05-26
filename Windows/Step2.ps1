Write-Host 'Step2: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step2 -Confirm:$false

Write-Host 'Step2: Initiating next step' -ForegroundColor green -BackgroundColor black
$NextStep = 'Step3'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1", "$env:TEMP\$NextStep.ps1")

Write-Host "Step2: Task Scheduler: Adding $NextStep" -ForegroundColor green -BackgroundColor black
$NextStep_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$NextStep_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep.ps1"
$NextStep_Trigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$NextStep_Parameters = @{
	TaskName  = $NextStep
	Principal = $NextStep_Principal
	Action    = $NextStep_Action
	Trigger   = $NextStep_Trigger
	Settings  = $NextStep_Settings
}
Register-ScheduledTask @NextStep_Parameters -Force

Write-Host 'Step2: Windows Key: Activating' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /HWID

Write-Host 'Step2: Mozila Firefox Arkenfox: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

Write-Host 'Step2: Windows Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')

Write-Host 'Step2: Restarting' -ForegroundColor green -BackgroundColor black
shutdown /r /t 00