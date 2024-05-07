Unregister-ScheduledTask -TaskName Step3 -Confirm:$false
$NextStep = 'Step4'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1", "$env:TEMP\$NextStep.ps1")
Write-Host "Task Scheduler > $NextStep" -ForegroundColor green -BackgroundColor black
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
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Sophia_Script/Download.ps1')
Write-Host 'Paint > Install' -ForegroundColor green -BackgroundColor black
Add-WindowsCapability -Name 'Microsoft.Windows.MSPaint~~~~0.0.1.0' -Online
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00