Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Key.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Settings.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Network.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/All_Policies.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/O&O_ShutUp10++.ps1')

# Settings: System: Multitasking: Snap windows: Show snap layouts when I over over a window's maximize button: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'EnableSnapAssistFlyout' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: End Task: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -PropertyType DWord -Value 1 -Force

# Settings: System: For developers: File Explorer: Show empty drives: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideDrivesWithNoMedia' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recently added apps: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Start' -Name 'ShowRecentList' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommendations for tips, shortcuts, new apps, and more: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_IrisRecommendations' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar behaviors: Taskbar alignment: Left
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Inking & typing personalization: Custom inking and typing dictionary: Off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Name 'Value' -PropertyType DWord -Value 0 -Force

# Settings: Windows Update: Advanced options: Receive updates for other Microsoft products: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'AllowMUUpdateService' -PropertyType DWord -Value 1 -Force

# Folder Options: General: Privacy: Show files from Office.com: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowCloudFilesInQuickAccess' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Advanced settings: Decrease space between items (compact view): On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -PropertyType DWord -Value 1 -Force

# Task Manager: Startup apps: Delete: AzureArcSetup
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('AzureArcSetup')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'AzureArcSetup'
}

# Task Manager: Startup apps: Delete: SecurityHealthSystray
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

# Server Manager: Don't show this message again
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'DoNotPopWACConsoleAtSMLaunch' -PropertyType DWord -Value 1 -Force

# PasswordComplexity: Off
secedit.exe /export /cfg "$env:TEMP\PasswordComplexity.cfg"
(Get-Content "$env:TEMP\PasswordComplexity.cfg") -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0' | Set-Content "$env:TEMP\PasswordComplexity.cfg"
secedit.exe /configure /db secedit.sdb /cfg "$env:TEMP\PasswordComplexity.cfg" /areas SECURITYPOLICY

# Restore the old Context Menu in Windows 11
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Name '(Default)' -Value '' -Force

# Taskbar tray icons
Get-ChildItem 'HKCU:\Control Panel\NotifyIconSettings' -Recurse | ForEach-Object { New-ItemProperty -Path $_.PSPath -Name 'IsPromoted' -Value 1 -PropertyType DWORD -Force }

# File Explorer: Remove Gallery
Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' -Recurse -Force

# File Explorer: Remove Home
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' -Name '(default)' -Value 'CLSID_MSGraphHomeFolder' -PropertyType String -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' -Name 'HiddenByDefault' -Value 1 -PropertyType DWord -Force

# Hide Give feedback from settings page
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\SettingsPageVisibility')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\SettingsPageVisibility' -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\SettingsPageVisibility" -Name "Value" -Value "hide:Feedback" -Force

# Administrative Shares: Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareServer' -Value 0 -PropertyType DWord -Force

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Initial_Setup.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Arkenfox.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Install_Microsoft_Visual_C++_Redistributable.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/DirectX_End_User_Runtimes/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Software_Selection.ps1')

# Uninstall Feedback Hub
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage

# Settings: Windows Update: Check for updates
UsoClient.exe StartInteractiveScan