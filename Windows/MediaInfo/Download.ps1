$Mediainfo_TaskName = 'Mediainfo Updater'
if (-not (Get-ScheduledTask -TaskName $Mediainfo_TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$Mediainfo_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')"
	$Mediainfo_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$Mediainfo_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$Mediainfo_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $Mediainfo_TaskName -Action $Mediainfo_TaskAction -Trigger $Mediainfo_TaskTrigger -Principal $Mediainfo_TaskPrincipal -Settings $Mediainfo_TaskSettings -Force
}

$Mediainfo_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mediainfo' -ErrorAction SilentlyContinue).DisplayVersion
$Mediainfo_LatestVersion = (Invoke-RestMethod 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest').Name

if ($null -eq $Mediainfo_InstalledVersion -or $Mediainfo_InstalledVersion -notmatch $Mediainfo_LatestVersion) {
	$Mediainfo_RemoteCFG = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/MediaInfo.cfg'
	$Mediainfo_LocalCFG = "$env:APPDATA\MediaInfo\Plugin\MediaInfo.cfg"
	if (-not (Test-Path -Path $Mediainfo_LocalCFG)) {
		New-Item -Path $Mediainfo_LocalCFG -ItemType File -Force
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading 'Mediainfo' custom settings from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_RemoteCFG'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_LocalCFG'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($Mediainfo_RemoteCFG, $Mediainfo_LocalCFG)
	}
	
	$Mediainfo_GUI_DDL = 'https:' + ((Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows').Links | Where-Object { $_.outerHTML -match 'GUI' } | Select-Object -First 1).href
	$MediaInfo_GUI_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Mediainfo_GUI_DDL).AbsolutePath)
	$MediaInfo_GUI_SavePath = [System.IO.Path]::Combine($env:TEMP, $MediaInfo_GUI_Filename)
	$Mediainfo_CLI_DDL = 'https:' + ((Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows').Links | Where-Object { $_.outerHTML -match 'CLI' } | Select-Object -First 1).href
	$MediaInfo_CLI_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Mediainfo_CLI_DDL).AbsolutePath)
	$MediaInfo_CLI_SavePath = [System.IO.Path]::Combine($env:TEMP, $MediaInfo_CLI_Filename)
	
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading 'Mediainfo' GUI from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_GUI_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_GUI_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($Mediainfo_GUI_DDL, $MediaInfo_GUI_SavePath)
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Downloading 'Mediainfo' CLI from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_CLI_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_CLI_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($Mediainfo_CLI_DDL, $MediaInfo_CLI_SavePath)

	$MediaInfo_GUI_Argument = '/S'
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Installing 'Mediainfo' GUI from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_GUI_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_GUI_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
	Start-Process $MediaInfo_GUI_SavePath -ArgumentList $MediaInfo_GUI_Argument

	$MediaInfo_CLI_Destination = "$env:ProgramFiles\MediaInfo\CLI"
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Installing 'Mediainfo' CLI from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_CLI_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_CLI_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
	Expand-Archive -Path $MediaInfo_CLI_SavePath -DestinationPath $MediaInfo_CLI_Destination -Force
	
	$MediaInfo_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
	if ($MediaInfo_OLD_PATH -notlike "*$MediaInfo_CLI_Destination*") {
		$MediaInfo_NEW_PATH = "$MediaInfo_OLD_PATH;$MediaInfo_CLI_Destination"
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Adding 'Mediainfo' CLI from "); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MediaInfo_CLI_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
		[System.Environment]::SetEnvironmentVariable('Path', $MediaInfo_NEW_PATH, [System.EnvironmentVariableTarget]::User)
		$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
	}
}