# Task Manager: Startup apps: Delete: AzureArcSetup
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('AzureArcSetup')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'AzureArcSetup'
}

# Server Manager: Don't show this message again
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'DoNotPopWACConsoleAtSMLaunch' -PropertyType DWord -Value 1 -Force

# Administrative Shares: Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareServer' -Value 0 -PropertyType DWord -Force

# Uninstall Feedback Hub
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage

$HostsPath = "$env:WINDIR\System32\drivers\etc\hosts"
$Urls = 'r.bing.comms-appx-web'
$Urls | ForEach-Object { $Line = '0.0.0.0 ' + $_; if (-not(Select-String -Path $HostsPath -Pattern $Line)) {
		Add-Content -Path $HostsPath -Value $Line
	} }