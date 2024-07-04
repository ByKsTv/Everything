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

Write-Host '.NET: Getting current versions' -ForegroundColor green -BackgroundColor black
$DotNET6_Installed = Get-Package -Name 'Microsoft .NET SDK 6*' -ErrorAction SilentlyContinue
if ($DotNet6_Installed) {
	$DotNet6_Installed = (($DotNET6_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}
$DotNET7_Installed = Get-Package -Name 'Microsoft .NET SDK 7*' -ErrorAction SilentlyContinue
if ($DotNet7_Installed) {
	$DotNet7_Installed = (($DotNET7_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}
$DotNET8_Installed = Get-Package -Name 'Microsoft .NET SDK 8*' -ErrorAction SilentlyContinue
if ($DotNet8_Installed) {
	$DotNet8_Installed = (($DotNET8_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}

Write-Host '.NET: Getting latest versions' -ForegroundColor green -BackgroundColor black
$DotNET6_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'latest-sdk'
$DotNET7_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).'latest-sdk'
$DotNET8_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'latest-sdk'

Write-Host '.NET: Getting information about end of life versions' -ForegroundColor green -BackgroundColor black
$DotNET6_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'support-phase'
$DotNET7_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).'support-phase'
$DotNET8_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'support-phase'

Write-Host '.NET: Comparing current versions against latest versions' -ForegroundColor green -BackgroundColor black
if (($null -eq $DotNET6_Installed) -or ($DotNET6_Installed -notmatch $DotNET6_Latest) -and ($DotNET6_EOL -ne 'eol')) {
	Write-Host ".NET: Downloading .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}
if (($null -eq $DotNET7_Installed) -or ($DotNET7_Installed -notmatch $DotNET7_Latest) -and ($DotNET7_EOL -ne 'eol')) {
	Write-Host ".NET: Downloading .NET $DotNET7_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET7_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET7_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET7_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}
if (($null -eq $DotNET8_Installed) -or ($DotNET8_Installed -notmatch $DotNET8_Latest) -and ($DotNET8_EOL -ne 'eol')) {
	Write-Host ".NET: Downloading .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}

Write-Host '.NET: Checking end of life versions' -ForegroundColor green -BackgroundColor black
# https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool?tabs=windows
if (($DotNET6_EOL -eq 'eol') -and ($DotNET6_Installed)) {
	Write-Host '.NET: Uninstalling .NET 6' -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET6_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}
if (($DotNET7_EOL -eq 'eol') -and ($DotNET7_Installed)) {
	Write-Host '.NET: Uninstalling .NET 7' -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET7_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}
if (($DotNET8_EOL -eq 'eol') -and ($DotNET8_Installed)) {
	Write-Host '.NET: Uninstalling .NET 8' -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET8_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}