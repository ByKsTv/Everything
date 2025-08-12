# Task Manager: Startup apps: Delete: AzureArcSetup
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('AzureArcSetup')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'AzureArcSetup'
}

# Server Manager: Don't show this message again
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'DoNotPopWACConsoleAtSMLaunch' -PropertyType DWord -Value 1 -Force

# PasswordComplexity: Off
& secedit.exe /export /cfg "$env:TEMP\PasswordComplexity.cfg"
(Get-Content "$env:TEMP\PasswordComplexity.cfg") -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0' | Set-Content "$env:TEMP\PasswordComplexity.cfg"
& secedit.exe /configure /db secedit.sdb /cfg "$env:TEMP\PasswordComplexity.cfg" /areas SECURITYPOLICY

# Administrative Shares: Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareServer' -Value 0 -PropertyType DWord -Force

# Uninstall Feedback Hub
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage