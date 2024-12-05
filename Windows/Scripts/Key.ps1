$SvcRestartTask = Get-ScheduledTask | Where-Object TaskName -EQ 'SvcRestartTask'
if ($SvcRestartTask -and $SvcRestartTask.State -eq 'Disabled') {
	Enable-ScheduledTask -TaskPath $SvcRestartTask.TaskPath -TaskName $SvcRestartTask.TaskName
}

if ((Get-WmiObject -Class Win32_OperatingSystem).ProductType -eq 3) {
    & ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /KMS38
}
else {
    & ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /HWID
}  