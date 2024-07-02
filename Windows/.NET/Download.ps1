$DotNET = '.NET Updater'
$DotNET_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $DotNET }
if (!($DotNET_Exists)) {
	Write-Host ".NET: Task Scheduler: Adding $DotNET" -ForegroundColor green -BackgroundColor black
	$DotNET_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$DotNET_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')"
	$DotNET_Trigger = New-ScheduledTaskTrigger -AtLogOn
	$DotNET_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
	$DotNET_Parameters = @{
		TaskName  = $DotNET
		Principal = $DotNET_Principal
		Action    = $DotNET_Action
		Trigger   = $DotNET_Trigger
		Settings  = $DotNET_Settings
	}
	Register-ScheduledTask @DotNET_Parameters -Force
}

Write-Host '.NET: Getting current version' -ForegroundColor green -BackgroundColor black
$DotNET6_Installed = Get-Package -Name 'Microsoft .NET SDK 6*' -ErrorAction SilentlyContinue
if ($DotNet6_Installed) {
	$DotNet6_Installed = (($DotNET6_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}
$DotNET8_Installed = Get-Package -Name 'Microsoft .NET SDK 8*' -ErrorAction SilentlyContinue
if ($DotNet8_Installed) {
	$DotNet8_Installed = (($DotNET8_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}

Write-Host '.NET: Getting latest version' -ForegroundColor green -BackgroundColor black
$DotNET6_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'latest-sdk'
$DotNET8_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'latest-sdk'

Write-Host '.NET: Comparing current version against latest version' -ForegroundColor green -BackgroundColor black
if (($null -eq $DotNET6_Installed) -or ($DotNET6_Installed -notmatch $DotNET6_Latest)) {
	Write-Host ".NET: Downloading .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}
if (($null -eq $DotNET8_Installed) -or ($DotNET8_Installed -notmatch $DotNET8_Latest)) {
	Write-Host ".NET: Downloading .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}