$TaskName = '.NET Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')`""
	$TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NET' -Name 'AllowAUOnServerOS' -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('.NET: Auto-Updates: Enabled'); [Console]::ResetColor(); [Console]::WriteLine()
	if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\.NET')) {
		New-Item 'HKLM:\SOFTWARE\Microsoft\.NET' -Force 
	}
	New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NET' -Name 'AllowAUOnServerOS' -Value 1 -PropertyType DWord -Force
}

$Versions = @('8', '9', '10')
foreach ($Version in $Versions) {
	$VersionPattern = "$Version*"
	$SDK = "Microsoft .NET SDK $VersionPattern"
	$SDKInstalled = (Get-Package $SDK -ErrorAction SilentlyContinue | Where-Object { $_.ProviderName -eq 'Programs' }).Name -replace '.*?(\d+\.\d+\.\d+).*', '$1' | Sort-Object -Descending | Select-Object -First 1
	$FullVersion = "$Version.0"
	$ReleasesJsonURL = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/$FullVersion/releases.json"
	$ReleasesJson = Invoke-RestMethod $ReleasesJsonURL
	$SDKLatest = $ReleasesJson | Select-Object -ExpandProperty 'latest-sdk'
	$SupportPhase = $ReleasesJson | Select-Object -ExpandProperty 'eol-date'
	$SupportPhaseDate = [DateTime]${SupportPhase}
	$Today = Get-Date

	if (($null -eq $SDKInstalled) -or ($SDKInstalled -ne $SDKLatest) -and ($SupportPhaseDate -gt $Today)) {
		$DDL = $ReleasesJson | Select-Object -ExpandProperty 'Releases' | Select-Object -First 1 | Select-Object -ExpandProperty 'sdk' | Select-Object -ExpandProperty 'files' | Where-Object { $_.name -match 'win-x64.exe' } | Select-Object -ExpandProperty 'url'
		$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
		$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SDKLatest'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
		(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

		$Argument = '/install /quiet /norestart'
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SDKLatest'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $SavePath -ArgumentList $Argument -Wait
	}

	if (($SupportPhaseDate -lt $Today) -and ($SDKInstalled)) {
		$UninstallDDL = Invoke-RestMethod -Uri 'https://api.github.com/repos/dotnet/cli-lab/releases/latest' | Select-Object -ExpandProperty 'assets' | Where-Object { $_.name -match '.msi' } | Select-Object -ExpandProperty 'browser_download_url'
		$UninstallFileName = [IO.Path]::GetFileName(([URI]$UninstallDDL).AbsolutePath)
		$UninstallSavePath = [IO.Path]::Combine($env:TEMP, $UninstallFileName)
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallDDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
		(New-Object System.Net.WebClient).DownloadFile($UninstallDDL, $UninstallSavePath)

		$UninstallArgument = '/quiet /norestart'
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallSavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $UninstallSavePath -ArgumentList $UninstallArgument -Wait

		$UninstallToolArgument = "/quiet /uninstall $UninstallSavePath"
		$UninstallToolLocation = "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe"
		$UninstallNETToolArgument = "dotnet-core-uninstall remove $SDKInstalled --sdk --yes"
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SDKInstalled'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallToolLocation'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallNETToolArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $UninstallToolLocation -ArgumentList $UninstallNETToolArgument -Wait
		
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'msiexec.exe'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UninstallToolArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process msiexec.exe -ArgumentList $UninstallToolArgument -Wait
	}
}