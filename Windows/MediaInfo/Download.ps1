$Mediainfo = 'Mediainfo Updater'
$Mediainfo_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Mediainfo }
if (!($Mediainfo_Exists)) {
	Write-Host "Mediainfo: Task Scheduler: Adding $Mediainfo" -ForegroundColor green -BackgroundColor black
	$Mediainfo_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$Mediainfo_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')"
	$Mediainfo_Trigger = New-ScheduledTaskTrigger -AtLogOn
	$Mediainfo_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
	$Mediainfo_Parameters = @{
		TaskName  = $Mediainfo
		Principal = $Mediainfo_Principal
		Action    = $Mediainfo_Action
		Trigger   = $Mediainfo_Trigger
		Settings  = $Mediainfo_Settings
	}
	Register-ScheduledTask @Mediainfo_Parameters -Force
}

Write-Host 'Mediainfo: Get latest release' -ForegroundColor green -BackgroundColor black
$MediaInfoHREF = (Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'GUI') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$MediaInfoDL = 'https:' + $MediaInfoHREF

Write-Host 'Mediainfo: Checking if updated' -ForegroundColor green -BackgroundColor black
$MediainfoInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Mediainfo' -ErrorAction SilentlyContinue).DisplayVersion
$MediaInfoGit = Invoke-WebRequest -UseBasicParsing 'https://api.github.com/repos/MediaArea/MediaInfo/releases/latest' | ConvertFrom-Json
$MediaInfoLatestVer = $MediaInfoGit.name

if ($null -eq $MediainfoInstalledVer) {
	Write-Host 'Mediainfo: Checking folders' -ForegroundColor green -BackgroundColor black
	if (!(Test-Path -Path $env:APPDATA\MediaInfo)) {
		New-Item -Path $env:APPDATA\MediaInfo -Value MediaInfo -ItemType Directory
	}
	if (!(Test-Path -Path $env:APPDATA\MediaInfo\Plugin)) {
		New-Item -Path $env:APPDATA\MediaInfo\Plugin -Value Plugin -ItemType Directory
	}
	
	Write-Host 'Mediainfo: Using custom settings' -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/MediaInfo.cfg', "$env:APPDATA\MediaInfo\Plugin\MediaInfo.cfg")
}

if ($MediainfoInstalledVer -match $MediaInfoLatestVer) {
	Write-Host 'Mediainfo: Latest Version Is Already Installed' -ForegroundColor green -BackgroundColor black
}

elseif ($MediainfoInstalledVer -notmatch $MediaInfoLatestVer ) {
	Write-Host 'Mediainfo: Downloading' -ForegroundColor green -BackgroundColor black
	(New-Object System.Net.WebClient).DownloadFile($MediaInfoDL, "$env:TEMP\MediaInfo.exe")

	Write-Host 'Mediainfo: Installing' -ForegroundColor green -BackgroundColor black
	Start-Process -FilePath $env:TEMP\MediaInfo.exe -ArgumentList '/S'
}