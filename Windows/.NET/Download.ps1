$DotNET_TaskName = '.NET Updater'
if (-not (Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$DotNET_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')"
	$DotNET_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$DotNET_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$DotNET_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $DotNET_TaskName -Action $DotNET_TaskAction -Trigger $DotNET_TaskTrigger -Principal $DotNET_TaskPrincipal -Settings $DotNET_TaskSettings -Force
}

if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NET' -Name 'AllowAUOnServerOS' -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('.NET: Auto-Updates: Enabled'); [Console]::ResetColor(); [Console]::WriteLine()
	if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\.NET') -ne $true) {
		New-Item 'HKLM:\SOFTWARE\Microsoft\.NET' -Force 
	}
	New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NET' -Name 'AllowAUOnServerOS' -Value 1 -PropertyType DWord -Force
}

$DotNET_DesktopRuntime6_Installed = (Get-Package 'Microsoft Windows Desktop Runtime - 6*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_DesktopRuntime8_Installed = (Get-Package 'Microsoft Windows Desktop Runtime - 8*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_DesktopRuntime9_Installed = (Get-Package 'Microsoft Windows Desktop Runtime - 9*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_SDK6_Installed = (Get-Package 'Microsoft .NET SDK 6*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_SDK8_Installed = (Get-Package 'Microsoft .NET SDK 8*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_SDK9_Installed = (Get-Package 'Microsoft .NET SDK 9*' -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1'
$DotNET_Latest6 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'latest-runtime'
$DotNET_Latest8 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'latest-runtime'
$DotNET_Latest9 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).'latest-runtime'
$DotNET_EOL6 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'support-phase'
$DotNET_EOL8 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'support-phase'
$DotNET_EOL9 = (Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).'support-phase'

if ($null -eq $DotNET_DesktopRuntime6_Installed -or $DotNET_DesktopRuntime6_Installed -notmatch $DotNET_Latest6 -and $DotNET_EOL6 -ne 'eol' -and $DotNET_EOL6 -eq 'maintenance') {
	$DotNET_Latest6_DDL = ((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).Releases | Select-Object -First 1).windowsdesktop).files | Where-Object -Property 'name' -Match 'win-x64.exe').url
	$DotNET_Latest6_Filename = [System.IO.Path]::GetFileName(([System.Uri]$DotNET_Latest6_DDL).AbsolutePath)
	$DotNET_Latest6_SavePath = [System.IO.Path]::Combine($env:TEMP, $DotNET_Latest6_Filename)
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DotNET_Latest6_DDL, $DotNET_Latest6_SavePath)

	$DotNET_Latest6_Argument = '/install /quiet /norestart'
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Installing '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest6_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
	Start-Process $DotNET_Latest6_SavePath -ArgumentList $DotNET_Latest6_Argument
}

if ($null -eq $DotNET_DesktopRuntime8_Installed -or $DotNET_DesktopRuntime8_Installed -notmatch $DotNET_Latest8 -and $DotNET_EOL8 -ne 'eol' -and $DotNET_EOL8 -eq 'active') {
	$DotNET_Latest8_DDL = ((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).Releases | Select-Object -First 1).windowsdesktop).files | Where-Object -Property 'name' -Match 'win-x64.exe').url
	$DotNET_Latest8_Filename = [System.IO.Path]::GetFileName(([System.Uri]$DotNET_Latest8_DDL).AbsolutePath)
	$DotNET_Latest8_SavePath = [System.IO.Path]::Combine($env:TEMP, $DotNET_Latest8_Filename)
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DotNET_Latest8_DDL, $DotNET_Latest8_SavePath)

	$DotNET_Latest8_Argument = '/install /quiet /norestart'
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Installing '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest8_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
	Start-Process $DotNET_Latest8_SavePath -ArgumentList $DotNET_Latest8_Argument
}

if ($null -eq $DotNET_DesktopRuntime9_Installed -or $DotNET_DesktopRuntime9_Installed -notmatch $DotNET_Latest9 -and $DotNET_EOL9 -ne 'eol' -and $DotNET_EOL9 -eq 'active') {
	$DotNET_Latest9_DDL = ((((Invoke-RestMethod https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/9.0/releases.json).Releases | Select-Object -First 1).windowsdesktop).files | Where-Object -Property 'name' -Match 'win-x64.exe').url
	$DotNET_Latest9_Filename = [System.IO.Path]::GetFileName(([System.Uri]$DotNET_Latest9_DDL).AbsolutePath)
	$DotNET_Latest9_SavePath = [System.IO.Path]::Combine($env:TEMP, $DotNET_Latest9_Filename)
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DotNET_Latest9_DDL, $DotNET_Latest9_SavePath)

	$DotNET_Latest9_Argument = '/install /quiet /norestart'
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Installing '.NET Desktop Runtime' version "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Latest9_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
	Start-Process $DotNET_Latest9_SavePath -ArgumentList $DotNET_Latest9_Argument
}

# https://learn.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool?tabs=windows
if ($DotNET_EOL6 -eq 'eol' -and $DotNET_DesktopRuntime6_Installed) {
	Write-Host ".NET: Uninstalling .NET Runtime $DotNET_DesktopRuntime6_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_DesktopRuntime6_Installed --runtime --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if ($DotNET_EOL8 -eq 'eol' -and $DotNET_DesktopRuntime8_Installed) {
	Write-Host ".NET: Uninstalling .NET Runtime $DotNET_DesktopRuntime8_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_DesktopRuntime8_Installed --runtime --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if ($DotNET_EOL9 -eq 'eol' -and $DotNET_DesktopRuntime9_Installed) {
	Write-Host ".NET: Uninstalling .NET Runtime $DotNET_DesktopRuntime9_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_DesktopRuntime9_Installed --runtime --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if ($DotNET_SDK6_Installed) {
	Write-Host ".NET: Uninstalling .NET SDK $DotNET_SDK6_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_SDK6_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if ($DotNET_SDK8_Installed) {
	Write-Host ".NET: Uninstalling .NET SDK $DotNET_SDK8_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_SDK8_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}

if ($DotNET_SDK9_Installed) {
	Write-Host ".NET: Uninstalling .NET SDK $DotNET_SDK9_Installed" -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*').browser_download_url, "$env:TEMP\dotnet-core-uninstall.msi")
	Start-Process "$env:TEMP\dotnet-core-uninstall.msi" -ArgumentList '/quiet /norestart' -Wait
	Start-Process "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe" -ArgumentList "dotnet-core-uninstall remove $DotNET_SDK9_Installed --sdk --yes" -Wait
	Start-Process msiexec.exe -ArgumentList "/quiet /uninstall $env:TEMP\dotnet-core-uninstall.msi" -Wait
}