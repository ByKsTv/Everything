Write-Host 'Display Driver Uninstaller: Getting latest release' -ForegroundColor green -BackgroundColor black
$DDU1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.wagnardsoft.com/display-driver-uninstaller-DDU-' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download Display Driver Uninstaller') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU2 = 'https://www.wagnardsoft.com' + $DDU1
$DDU3 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'DOWNLOAD') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$DDU4 = (Invoke-WebRequest -UseBasicParsing -Uri $DDU3 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'setup.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Display Driver Uninstaller: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($DDU4, "$env:TEMP\DDU.exe")

Write-Host 'Display Driver Uninstaller: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DDU.exe -ArgumentList '/S'

Write-Host 'Display Driver Uninstaller: Using custom settings' -ForegroundColor green -BackgroundColor black
$DDUSettings = '<?xml version="1.0" encoding="utf-8"?>
<DisplayDriverUninstaller Version="18.0.7.6">
	<Settings>
		<SelectedLanguage>en-US</SelectedLanguage>
		<RemoveMonitors>True</RemoveMonitors>
		<RemoveCrimsonCache>True</RemoveCrimsonCache>
		<RemoveAMDDirs>True</RemoveAMDDirs>
		<RemoveAudioBus>False</RemoveAudioBus>
		<RemoveAMDKMPFD>False</RemoveAMDKMPFD>
		<RemoveNvidiaDirs>True</RemoveNvidiaDirs>
		<RemovePhysX>True</RemovePhysX>
		<Remove3DTVPlay>True</Remove3DTVPlay>
		<RemoveGFE>True</RemoveGFE>
		<RemoveNVBROADCAST>True</RemoveNVBROADCAST>
		<RemoveNVCP>True</RemoveNVCP>
		<RemoveINTELCP>True</RemoveINTELCP>
		<RemoveAMDCP>True</RemoveAMDCP>
		<UseRoamingConfig>False</UseRoamingConfig>
		<CheckUpdates>True</CheckUpdates>
		<CreateRestorePoint>True</CreateRestorePoint>
		<SaveLogs>True</SaveLogs>
		<RemoveVulkan>True</RemoveVulkan>
		<ShowOffer>False</ShowOffer>
		<EnableSafeModeDialog>False</EnableSafeModeDialog>
		<PreventWinUpdate>False</PreventWinUpdate>
		<UsedBCD>False</UsedBCD>
		<KeepNVCPopt>False</KeepNVCPopt>
	</Settings>
</DisplayDriverUninstaller>'

if (!(Test-Path -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller")) {
    New-Item -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller" -Value 'Display Driver Uninstaller' -ItemType Directory
}
Set-Content -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller\Settings\Settings.xml" -Value $DDUSettings -Force