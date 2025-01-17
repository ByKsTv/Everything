# Settings: System: Multitasking: Snap windows: Show snap layouts when I over over a window's maximize button: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'EnableSnapAssistFlyout' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: End Task: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -PropertyType DWord -Value 1 -Force

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

# Folder Options: General: Privacy: Show files from Office.com: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowCloudFilesInQuickAccess' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Decrease space between items (compact view): On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -PropertyType DWord -Value 1 -Force

# Task Manager: Startup apps: Delete: SecurityHealthSystray
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

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
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\SettingsPageVisibility' -Name 'Value' -Value 'hide:Feedback' -Force

# Show default Start layout
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_Layout' -PropertyType DWord -Value 0 -Force

# Settings: Accessibility: Keyboard: Notification preferences: Notify me when I turn on Sticky, Filter, or Toogle keys from keyboard: Off
# Settings: Accessibility: Keyboard: Notification preferences: Play a sound when I turn Sticky, Filter, or Toogle keys on or off from the keyboard: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'Warning Sounds' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'Sound on Activation' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\Keyboard Response' -Name 'Flags' -PropertyType DWord -Value 102 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -PropertyType DWord -Value 486 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\ToggleKeys' -Name 'Flags' -PropertyType DWord -Value 38 -Force

# Settings: System: Display: Multiple displays: Ease cursor movement between displays: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name 'CursorDeadzoneJumpingSetting' -PropertyType DWord -Value 0 -Force

# Context menu: Remove 'Share'
New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{e2bf9676-5f8f-435c-97eb-11607a5bedf7}' -Value '' -PropertyType String -Force

# Context menu: Remove 'Cast to device'
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' -Value 'Play to Menu' -PropertyType String -Force

# File Explorer: Restore to Windows 10 Navigation bar
# if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths')) {
# 	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' -Force
# }
# $TypedPaths_AccessControl = (Get-Acl 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths')
# $TypedPaths_AccessControl.SetAccessRule((New-Object System.Security.AccessControl.RegistryAccessRule(
# 			[Security.Principal.WindowsIdentity]::GetCurrent().Name, 'FullControl', 'Deny')))
# Set-Acl -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths' -AclObject $TypedPaths_AccessControl

# Context Menu: Remove 'Add to Favorites'
[Microsoft.Win32.Registry]::ClassesRoot.DeleteSubKeyTree('*\shell\pintohomefile')