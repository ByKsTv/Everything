$DotNET_TaskName = '.NET Updater'
if (-not (Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$DotNET_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$DotNET_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')`""
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

$DotNET_Versions = @('8', '9')
foreach ($DotNET_Version in $DotNET_Versions) {
	$DotNET_VersionPattern = "$DotNET_Version*"
	$DotNET_SDK = "Microsoft .NET SDK $DotNET_VersionPattern"
	$DotNET_SDKInstalled = (Get-Package $DotNET_SDK -ErrorAction SilentlyContinue | Where-Object ProviderName -EQ 'Programs').Name -replace '.*?(\d+\.\d+\.\d+).*', '$1' | Select-Object -First 1
	$DotNET_FullVersion = "$DotNET_Version.0"
	$DotNET_ReleasesJsonURL = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/$DotNET_FullVersion/releases.json"
	$DotNET_ReleasesJson = Invoke-RestMethod $DotNET_ReleasesJsonURL
	$DotNET_SDKLatest = $DotNET_ReleasesJson.'latest-sdk'
	$DotNET_SupportPhase = $DotNET_ReleasesJson.'eol-date'
	$DotNET_SupportPhaseDate = [DateTime]${DotNET_SupportPhase}
	$DotNET_Today = Get-Date

	if (($null -eq $DotNET_SDKInstalled) -or ($DotNET_SDKInstalled -ne $DotNET_SDKLatest) -and ($DotNET_SupportPhaseDate -gt $DotNET_Today)) {
		$DotNET_DDL = (((($DotNET_ReleasesJson).Releases | Select-Object -First 1).sdk).files | Where-Object -Property 'name' -Match 'win-x64.exe').url
		$DotNET_Filename = [IO.Path]::GetFileName(([URI]$DotNET_DDL).AbsolutePath)
		$DotNET_SavePath = [IO.Path]::Combine($env:TEMP, $DotNET_Filename)
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_SDKLatest'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
		(New-Object System.Net.WebClient).DownloadFile($DotNET_DDL, $DotNET_SavePath)

		$DotNET_Argument = '/install /quiet /norestart'
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_SDKLatest'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $DotNET_SavePath -ArgumentList $DotNET_Argument -Wait
	}

	if ($DotNET_SupportPhaseDate -lt $DotNET_Today -and $DotNET_SDKInstalled) {
		$DotNET_UninstallDDL = ((Invoke-RestMethod 'https://api.github.com/repos/dotnet/cli-lab/releases/latest').assets | Where-Object name -Like '*.msi*' | Select-Object -First 1).browser_download_url
		$DotNET_UninstallFilename = [IO.Path]::GetFileName(([URI]$DotNET_UninstallDDL).AbsolutePath)
		$DotNET_UninstallSavePath = [IO.Path]::Combine($env:TEMP, $DotNET_UninstallFilename)
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallDDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($DotNET_UninstallDDL, $DotNET_UninstallSavePath)

		$DotNET_UninstallArgument = '/quiet /norestart'
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallSavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $DotNET_UninstallSavePath -ArgumentList $DotNET_UninstallArgument -Wait

		$DotNET_UninstallToolArgument = "/quiet /uninstall $DotNET_UninstallSavePath"
		$DotNET_UninstallToolLocation = "${env:ProgramFiles(x86)}\dotnet-core-uninstall\dotnet-core-uninstall.exe"
		$DotNET_UninstallNETToolArgument = "dotnet-core-uninstall remove $DotNET_SDKInstalled --sdk --yes"
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft .NET SDK'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_SDKInstalled'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallToolLocation'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallNETToolArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process $DotNET_UninstallToolLocation -ArgumentList $DotNET_UninstallNETToolArgument -Wait
		
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'dotnet-core-uninstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'msiexec.exe'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_UninstallToolArgument'"); [Console]::ResetColor(); [Console]::WriteLine()
		Start-Process msiexec.exe -ArgumentList $DotNET_UninstallToolArgument -Wait
	}
}