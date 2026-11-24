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

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$BaseURL = 'https://builds.dotnet.microsoft.com/dotnet/WindowsDesktop'
$DNIM = "$env:TEMP\dnim-win-x64.exe"

# Detect NordVPN
$Installed = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue

$NordVPN = [bool]($Installed.DisplayName -like 'NordVPN*')
$Versions = @('10.0', '11.0')

if ($NordVPN) {
 $Versions += '8.0'
}

# Download DNIM if missing
if (!(Test-Path $DNIM -PathType Leaf)) {
	Write-Host 'Downloading DNIM' -ForegroundColor Green

	$Page = Invoke-WebRequest 'https://www.microsoft.com/en-us/download/details.aspx?id=108827' -UseBasicParsing
	$DDL = [regex]::Match($Page.Content.Replace('\/', '/'), 'https://download\.microsoft\.com/[^"''<>\s\\]+/dnim-win-x64\.exe').Value

	if (!$DDL) {
		throw 'DNIM download URL not found'
	}

	Invoke-WebRequest $DDL -OutFile $DNIM -UseBasicParsing
}

# Uninstall all SDKs
Write-Host 'Uninstalling .NET SDKs' -ForegroundColor Green
& $DNIM uninstall --accept-license --it sdk --include-bin-deployed-installs

if ($LASTEXITCODE -ne 0) {
 throw 'SDK removal failed'
}

# Install Desktop Runtimes
foreach ($Version in $Versions) {
	$Latest = if ($Version -eq '8.0') {
		'8.0.34'
	} else {
		((Invoke-WebRequest "$BaseURL/$Version/latest.version" -UseBasicParsing).Content.Trim() -split '\s+')[-1]
	}

	if ($Latest -notmatch '^\d+\.\d+\.\d+$') {
		throw "Invalid runtime version: $Latest"
	}

	if (Test-Path "$env:ProgramFiles\dotnet\shared\Microsoft.WindowsDesktop.App\$Latest") {
		continue
	}

	$FileName = "windowsdesktop-runtime-$Latest-win-x64.exe"
	$SavePath = "$env:TEMP\$FileName"

	Write-Host "Downloading .NET Desktop Runtime $Latest" -ForegroundColor Green
	Invoke-WebRequest "$BaseURL/$Latest/$FileName" -OutFile $SavePath -UseBasicParsing

	Write-Host "Installing .NET Desktop Runtime $Latest" -ForegroundColor Green
	$Process = Start-Process $SavePath -ArgumentList '/install /quiet /norestart' -Wait -PassThru

	if ($Process.ExitCode -notin 0, 3010) {
		throw "Installation failed: $($Process.ExitCode)"
	}

	Remove-Item $SavePath -Force
}

# Uninstall end-of-life Desktop Runtimes
$Arguments = @('uninstall', '--accept-license', '--it', 'desktopruntime', '--sp', 'eol')

if ($NordVPN) {
	Write-Host 'Preserving .NET Desktop Runtime 8.0.34 for NordVPN' -ForegroundColor Yellow
	$Arguments += @('--klpv', '8.0')
}

& $DNIM @Arguments

if ($LASTEXITCODE -ne 0) {
 throw 'Runtime removal failed'
}
