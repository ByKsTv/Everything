$DotNET = '.NET Updater'
$DotNET_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $DotNET }
if (!($DotNET_Exists)) {
	Write-Host ".NET: Task Scheduler: Adding $DotNET" -ForegroundColor green -BackgroundColor black
	$DotNET_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$DotNET_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')"
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

Write-Host '.NET: Enabling Auto-Updates' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\.NET') -ne $true) {
	New-Item 'HKLM:\SOFTWARE\Microsoft\.NET' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NET' -Name 'AllowAUOnServerOS' -Value 1 -PropertyType DWord -Force

Write-Host '.NET: Getting current versions' -ForegroundColor green -BackgroundColor black
# https://learn.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
$DotNETReleaseID = Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release
switch ($DotNETReleaseID) {
	{ $_ -ge 533325 } {
		$DotNETVersionNumber = '4.8.1 or later'; break 
	}
	{ $_ -ge 528040 } {
		$DotNETVersionNumber = '4.8'; break 
	}
	{ $_ -ge 461808 } {
		$DotNETVersionNumber = '4.7.2'; break 
	}
	{ $_ -ge 461308 } {
		$DotNETVersionNumber = '4.7.1'; break 
	}
	{ $_ -ge 460798 } {
		$DotNETVersionNumber = '4.7'; break 
	}
	{ $_ -ge 394802 } {
		$DotNETVersionNumber = '4.6.2'; break 
	}
	{ $_ -ge 394254 } {
		$DotNETVersionNumber = '4.6.1'; break 
	}
	{ $_ -ge 393295 } {
		$DotNETVersionNumber = '4.6'; break 
	}
	{ $_ -ge 379893 } {
		$DotNETVersionNumber = '4.5.2'; break 
	}
	{ $_ -ge 378675 } {
		$DotNETVersionNumber = '4.5.1'; break 
	}
	{ $_ -ge 378389 } {
		$DotNETVersionNumber = '4.5'; break 
	}
	default {
		$DotNETVersionNumber = $null; break 
	}
}

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

$DotNET9_Installed = Get-Package -Name 'Microsoft .NET SDK 9*' -ErrorAction SilentlyContinue
if ($DotNet9_Installed) {
	$DotNet9_Installed = (($DotNET9_Installed | Select-Object -ExpandProperty 'Name').Replace('Microsoft .NET SDK ', '')).Replace(' (x64)', '')
}

Write-Host '.NET: Getting latest versions' -ForegroundColor green -BackgroundColor black
$DotNET6_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'latest-sdk'
$DotNET7_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).'latest-sdk'
$DotNET8_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'latest-sdk'
$DotNET9_Latest = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).'latest-sdk'

Write-Host '.NET: Getting information about end of life versions' -ForegroundColor green -BackgroundColor black
$DotNET6_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'support-phase'
$DotNET7_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).'support-phase'
$DotNET8_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'support-phase'
$DotNET9_EOL = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).'support-phase'

Write-Host '.NET: Comparing current versions against latest versions' -ForegroundColor green -BackgroundColor black
# https://dotnet.microsoft.com/en-us/download/dotnet-framework
if ('4.8.1 or later' -ne $DotNETVersionNumber) {
	$DotNET4SDK1_URL = (Invoke-WebRequest -UseBasicParsing -Uri 'https://dotnet.microsoft.com/en-us/download/dotnet-framework' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match '.NET Framework') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
	$DotNET4SDK2_URL = 'https://dotnet.microsoft.com/' + $DotNET4SDK1_URL
	$DotNET4SDK3_URL = (Invoke-WebRequest -UseBasicParsing -Uri $DotNET4SDK2_URL | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Developer pack') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
	$DotNET4SDK4_URL = 'https://dotnet.microsoft.com/' + $DotNET4SDK3_URL
	$DotNET4SDK5_URL = (Invoke-WebRequest -UseBasicParsing -Uri $DotNET4SDK4_URL | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'click here to download manually') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

	Write-Host '.NET: Downloading .NET Framework Latest SDK' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile("$DotNET4SDK5_URL", "$env:TEMP\NET-Framework-Latest-SDK.exe")

	Write-Host '.NET: Installing .NET Framework Latest SDK' -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\NET-Framework-Latest-SDK.exe" -ArgumentList '/quiet /norestart'
}

if (($null -eq $DotNET6_Installed) -or ($DotNET6_Installed -notmatch $DotNET6_Latest) -and ($DotNET6_EOL -ne 'eol') -and ($DotNET6_EOL -eq 'active')) {
	Write-Host ".NET: Downloading .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET6_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET6_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}

if (($null -eq $DotNET7_Installed) -or ($DotNET7_Installed -notmatch $DotNET7_Latest) -and ($DotNET7_EOL -ne 'eol') -and ($DotNET7_EOL -eq 'active')) {
	Write-Host ".NET: Downloading .NET $DotNET7_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET7_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET7_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET7_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}

if (($null -eq $DotNET8_Installed) -or ($DotNET8_Installed -notmatch $DotNET8_Latest) -and ($DotNET8_EOL -ne 'eol') -and ($DotNET8_EOL -eq 'active')) {
	Write-Host ".NET: Downloading .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET8_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET8_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}

if (($null -eq $DotNET9_Installed) -or ($DotNET9_Installed -notmatch $DotNET9_Latest) -and ($DotNET9_EOL -ne 'eol') -and ($DotNET9_EOL -eq 'active')) {
	Write-Host ".NET: Downloading .NET $DotNET9_Latest" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Like 'dotnet-sdk-win-x64.exe').url, "$env:TEMP\dotnet-$DotNET9_Latest-sdk-win-x64.exe")

	Write-Host ".NET: Installing .NET $DotNET9_Latest" -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath "$env:TEMP\dotnet-$DotNET9_Latest-sdk-win-x64.exe" -ArgumentList '/install /quiet /norestart'
}

Write-Host '.NET: Checking end of life versions' -ForegroundColor green -BackgroundColor black
# https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool?tabs=windows
if (($DotNET6_EOL -eq 'eol') -and ($DotNET6_Installed)) {
	Write-Host ".NET: Uninstalling .NET $DotNET6_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET6_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if (($DotNET7_EOL -eq 'eol') -and ($DotNET7_Installed)) {
	Write-Host ".NET: Uninstalling .NET $DotNET7_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET7_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if (($DotNET8_EOL -eq 'eol') -and ($DotNET8_Installed)) {
	Write-Host ".NET: Uninstalling .NET $DotNET8_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET8_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if (($DotNET9_EOL -eq 'eol') -and ($DotNET9_Installed)) {
	Write-Host ".NET: Uninstalling .NET $DotNET9_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet' -Wait
	Start-Process cmd.exe "/c dotnet-core-uninstall remove $DotNET9_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}