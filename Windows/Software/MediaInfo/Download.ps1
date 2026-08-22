$TaskName = 'Mediainfo Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/Download.ps1')`""
	$TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mediainfo' -ErrorAction SilentlyContinue).DisplayVersion
$LatestVersion = (Invoke-RestMethod -Uri 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest').name

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
	$RemoteCFG = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/MediaInfo.cfg'
	$LocalCFG = "$env:APPDATA\MediaInfo\Plugin\MediaInfo.cfg"
	if (-not (Test-Path -Path $LocalCFG)) {
		New-Item -Path $LocalCFG -ItemType File -Force
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mediainfo'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' custom settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$RemoteCFG'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LocalCFG'"); [Console]::ResetColor(); [Console]::WriteLine()
		(New-Object System.Net.WebClient).DownloadFile($RemoteCFG, $LocalCFG)
	}

	$GUI_DDL = 'https:' + (((Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows').Links | Where-Object { $_.outerHTML -match 'GUI' } | Select-Object -First 1).href)
	$GUI_FileName = [IO.Path]::GetFileName(([URI]$GUI_DDL).AbsolutePath)
	$GUI_SavePath = [IO.Path]::Combine($env:TEMP, $GUI_FileName)
	$CLI_DDL = 'https:' + (((Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows').Links | Where-Object { $_.outerHTML -match 'CLI' } | Select-Object -First 1).href)
	$CLI_FileName = [IO.Path]::GetFileName(([URI]$CLI_DDL).AbsolutePath)
	$CLI_SavePath = [IO.Path]::Combine($env:TEMP, $CLI_FileName)

	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mediainfo GUI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GUI_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GUI_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($GUI_DDL, $GUI_SavePath)
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mediainfo CLI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CLI_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CLI_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($CLI_DDL, $CLI_SavePath)

	$GUI_Argument = '/S'
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mediainfo GUI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GUI_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GUI_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
	Start-Process $GUI_SavePath -ArgumentList $GUI_Argument -Wait

	$CLI_Destination = [IO.Path]::GetDirectoryName((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'MediaInfo' }).UninstallString)
	$CLI_Destination = [IO.Path]::Combine($CLI_Destination, 'CLI')
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mediainfo CLI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CLI_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CLI_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
	Expand-Archive -Path $CLI_SavePath -DestinationPath $CLI_Destination -Force

	$OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
	if (-not ($OLD_PATH.Contains($CLI_Destination))) {
		$NEW_PATH = "$OLD_PATH;$CLI_Destination"
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CLI_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
		[Environment]::SetEnvironmentVariable('Path', $NEW_PATH, [EnvironmentVariableTarget]::User)
		$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + '; ' + [Environment]::GetEnvironmentVariable('Path', 'User')
	}
}
