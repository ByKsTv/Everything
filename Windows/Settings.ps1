Write-Host 'Power Plan: Restoring Defaults' -ForegroundColor green -BackgroundColor black
powercfg /restoredefaultschemes

Write-Host 'Power Plan: Activating Ultimate Performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACTIVE e9a42b02-d5df-448d-aa00-03f14749eb61

Write-Host 'Power Plan: Showing all hidden options' -ForegroundColor green -BackgroundColor black
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'CSEnabled' -Value 0 -Force
$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$'
foreach ($item in $PowerCfg) {
 Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE', 'HKLM:') -Name 'Attributes' -Value 2 -Force 
}

Write-Host 'Power Plan: Disabling power throttling' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling') -ne $true) {
	New-Item 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -PropertyType DWord -Value 1 -Force

Write-Host 'Power Plan: Shutdown settings: Disabling Fast Startup' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -PropertyType DWord -Value 0 -Force

Write-Host 'Power Plan: Display: Turn off display after: 0 Seconds (Never)' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

Write-Host 'O&O ShutUp10++: Current User: Disabling transmission of typing information' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\TIPC' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling suggestions in the timeline' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353698Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling tips, tricks and suggestions when using Windows' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling showing suggested content in the Settings app' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling storage of clipboard history for current user' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Clipboard' -Name 'EnableClipboardHistory' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling app access to user account information for current user' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value Deny -PropertyType String -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling app access to diagnostics information for current user' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value Deny -PropertyType String -Force

Write-Host 'O&O ShutUp10++: Current User: Microsoft Edge: Disabling tracking in the web' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main') -ne $true) {
	New-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Force 
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'DoNotTrack' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Microsoft Edge: Disabling page prediction' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead') -ne $true) {
	New-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Force 
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Name 'FPEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Microsoft Edge: Disabling search and website suggestions' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'ShowSearchSuggestionsGlobal' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Microsoft Edge: Disabling Cortana in Microsoft Edge' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI') -ne $true) {
	New-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Force 
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Name 'EnableCortana' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Microsoft Edge: Disabling showing search history' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory') -ne $true) {
	New-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Force 
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Name '(default)' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of all settings' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'SyncPolicy' -Value 5 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of design settings' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of browser settings' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of credentials (passwords)' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of language settings' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of accessibility settings' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling synchronization of Windows settings' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling and Resetting Cortana' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Name 'CortanaConsent' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling Input Personalization' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling fun facts, tips, tricks, and more on your lock screen' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling notifications on the lock screen' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling news and interests in the task bar for current user' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarViewMode' -Value 2 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Current User: Disabling Windows Media Player Diagnostics' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\MediaPlayer\Preferences' -Name 'UsageTracking' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling camera in logon screen' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Personalization') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Personalization' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling and Resetting Advertising ID and info for the machine' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling advertisments via Bluetooth' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth' -Name 'AllowAdvertising' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling backup of text messages into the cloud' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Messaging') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Messaging' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Messaging' -Name 'AllowMessageSync' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Windows Error Reporting' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling biometrical features' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Biometrics') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Biometrics' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Biometrics' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling app access to user account information on this device' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value Deny -PropertyType String -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling app access to diagnostics information on this device' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value Deny -PropertyType String -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling password reveal button' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CredUI') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CredUI' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CredUI' -Name 'DisablePasswordReveal' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Internet access of Windows Media Digital Rights Managment (DRM)' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\WMDRM') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\WMDRM' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\WMDRM' -Name 'DisableOnline' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling automatic completion of web addresses in address bar' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser' -Name 'AllowAddressBarDropdown' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling user feedback in toolbar' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Edge') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Edge' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling storing and autocompleting of credit card data on websites' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Microsoft Edge launch in the background' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling loading the start and new tab pages in the background' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling online speech recognition' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling downlaod and updates of speech recognition and speech synthesis models' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Speech_OneCore\Preferences' -Name 'ModelDownloadAllowed' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling functionallity to locate the system' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableWindowsLocationProvider' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling scripting functionallity to locate the system' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocationScripting' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling application telemetry' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling diagnostic log collection' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'LimitDiagnosticLogCollection' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Windows Update via peer-to-peer' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Name 'SystemSettingsDownloadMode' -Value 0 -PropertyType DWord -Force
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Name 'DODownloadMode' -Value 0 -PropertyType DWord -Force
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeliveryOptimization' -Name 'DODownloadMode' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling updates to the speech recognition and speech syhesis modules' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Speech') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Speech' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Speech' -Name 'AllowSpeechModelUpdate' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling OneDrive access to network before login' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\OneDrive') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\OneDrive' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\OneDrive' -Name 'PreventNetworkTrafficPreUserSignIn' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Microsoft SpyNet memembership' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SpyNetReporting' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling reporting of malware infection information' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\MRT') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\MRT' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\MRT' -Name 'DontReportInfectionInformation' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling Meet now in the task bar on this device' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling news and interests in the taskbar on this device' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling remote assistance connections to this computer' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fAllowToGetHelp' -Value 0 -PropertyType DWord -Force

Write-Host 'O&O ShutUp10++: Local Machine: Disabling installation of PC Health Check' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\PCHC') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\PCHC' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PCHC' -Name 'PreviousUninstall' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Network: WLAN Service: WLAN Settings: Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'AutoConnectAllowedOEM' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Turn off location: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud optimized content: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableCloudOptimizedContent' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud consumer account state content: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Do not show Windows tips: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Microsoft consumer experiences: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Configure Windows spotlight on lock screen: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'ConfigureWindowsSpotlight' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Spotlight collection on Desktop: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSpotlightCollectionOnDesktop' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not use diagnostic data for tailored experiences: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableTailoredExperiencesWithDiagnosticData' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not suggest third-party content in Windows spotlight: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off all Windows spotlight features: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightFeatures' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Action Center: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnActionCenter' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Settings: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnSettings' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off the Windows Welcome Experience: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightWindowsWelcomeExperience' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Control Panel: Allow Online Tips: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'AllowOnlineTips' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Control Panel: Regional and Language Options: Handwriting personalization: Turn off automatic learning: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Do not keep history of recently opened documents: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Notifications: Turn off notifications network usage: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoCloudApplicationNotification' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: App-V: CEIP: Microsoft Customer Experience Improvement Program (CEIP): Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\AppV\CEIP') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Do not send a Windows error report when a generic driver is installed on a device: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
	New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force # Error 
}
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force # Error 

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Prevent Windows from sending an error report when a device driver requests additional woftware during installation: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
	New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force # Error 
}
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force # Error 

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting recognition error reporting: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Name 'PreventHandwritingErrorReports' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Customer Experience Improvement Program: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center 'Did you know?' content: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'Headlines' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center Microsoft Knowledge Base search: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'MicrosoftKBSearch' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Error Reporting: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Force 
}
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Name 'DoReport' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Search Companion content file updates: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\SearchCompanion') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Name 'DisableContentFileUpdates' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet File Association service: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoInternetOpenWith' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off access to the Store: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoUseStoreOpenWith' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet download for Web publishing and online ordering wizards: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWebServices' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Order Prints' picture task: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoOnlinePrintsWizard' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Publish to Web' task for files and folders: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPublishingWizard' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the Windows Messenger Customer Experience Improvement Program: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'CEIP' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting personalization data sharing: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard History: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard synchronization across devices: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowCrossDeviceClipboard' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow publishing of User Activites: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow upload of User Activites: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'UploadUserActivities' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Enabled Activity Feed: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: User Profiles: Turn off the advertising ID: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Remove Program Compatibility Property Page: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePropPage' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Compatibility Engine: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableEngine' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Telemetry: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Inventory Collector: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Program Compatibility Assistant: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePCA' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Steps Recorder: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off SwitchBack Compatibility Engine: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'SbEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow device name to be sent in Windows diagnostic data: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'AllowDeviceNameInTelemetry' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Configure collection of browsing data for Desktop Analytics: Do not allow sending intranet or internet history' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'MicrosoftEdgeDataOptIn' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Disable OneSettings Downloads: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Do not show feedback notifications: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Value 1 -PropertyType DWord -Force
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Force 
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -PropertyType DWord -Value 0 -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Edge UI: Disable help tips: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableHelpSticker' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off Automatic Download nad Update of Map Data: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off unsolicited network  traffic on the Offline Maps settings page: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Online Assistance: Turn off Active Help: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Name 'NoActiveHelp' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cloud Search: Disable Cloud Search' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCloudSearch' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana above lock screen: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaAboveLock' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana Page in OOBE on an AAD account: Disable Cortana Page in AAD' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaInAADPathOOBE' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search highlights: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'EnableDynamicContentInWSB' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search and Cortana to use location: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Do not allow web search: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Value 0 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or disable web results in Search over metered connections: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Set the SafeSearch setting for Search: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchSafeSearch' -Value 3 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Set what information is shared in Search: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ErrorAction SilentlyContinue # Error
}
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchPrivacy' -Force -ErrorAction SilentlyContinue # Error 

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Text Input: Improve inking and typing recognition: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Calendar: Turn off Windows Calendar: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Name 'TurnOffWinCal' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Configure Error Reporting: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Force 
}
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWReporteeName' -Force -ErrorAction SilentlyContinue # Error
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWFileTreeRoot' -Force -ErrorAction SilentlyContinue # Error

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Automatically send memory dumps for OS-generated error reports: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'AutoApproveOSDumps' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send data when on connected to a restricted/costed network: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassNetworkCostThrottling' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send additional data when on battery power: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassPowerThrottling' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Do not send additional data: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'DontSendAdditionalData' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Mobility Center: Turn off Windows Mobility Center: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter') -ne $true) {
	New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Name 'NoMobilityCenter' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not automatically start Windows Messenger initially: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventAutoRun' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not allow Windows Messenger to be run: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventRun' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Microsoft Defender Antivirus: MAPS: Send file samples when further analysis is required: Never send' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SubmitSamplesConsent' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Game Recording and Broadcasing: Disable' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Windows Copilot: Turn off Windows Copilot: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Start Menu and Taskbar: Remove the Meet Now icon: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: File Explorer: Turn off Windows Libraries features that rely on indexed file data: Enabled' -ForegroundColor green -BackgroundColor black
if (-not (Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name 'DisableIndexedLibraryExperience' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Remote Desktop Services: Remote Desktop Connection Client: Allow .rdp files from unkown publishers: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Force 
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'AllowUnsignedFiles' -Value 1 -PropertyType DWord -Force

Write-Host 'Step2: Scheduled tasks: Disabling' -ForegroundColor green -BackgroundColor black
Disable-ScheduledTask -TaskName 'Consolidator' -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\'
Disable-ScheduledTask -TaskName 'DmClient' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'DmClientOnScenarioDownload' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'FamilySafetyMonitor' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'FamilySafetyRefreshTask' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'MapsToastTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'MapsUpdateTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'MareBackup' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'Microsoft Compatibility Appraiser' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'Microsoft-Windows-DiskDiagnosticDataCollector' -TaskPath '\Microsoft\Windows\DiskDiagnostic\'
Disable-ScheduledTask -TaskName 'PcaPatchDbTask' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'ProgramDataUpdater' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'Proxy' -TaskPath '\Microsoft\Windows\Autochk\'
Disable-ScheduledTask -TaskName 'QueueReporting' -TaskPath '\Microsoft\Windows\Windows Error Reporting\'
Disable-ScheduledTask -TaskName 'StartupAppTask' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'UsbCeip' -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\'
Disable-ScheduledTask -TaskName 'XblGameSaveTask' -TaskPath '\Microsoft\XblGameSave\'
Disable-ScheduledTask -TaskName 'PcaPatchDbTask' -TaskPath '\Microsoft\Windows\Application Experience'

Write-Host 'Step2: Windows Capabilities: Removing Internet Explorer' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'Browser.InternetExplorer~~~~0.0.11.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing Windows Media Player' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'Media.WindowsMediaPlayer~~~~0.0.12.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing WordPad' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing Steps Recorder' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'App.StepsRecorder~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing Windows Hello Face' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'Hello.Face.18967~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing Quick Assist' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'App.Support.QuickAssist~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing Math Input Panel' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'MathRecognizer~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Capabilities: Removing OpenSSH Client' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'OpenSSH.Client~~~~0.0.1.0' -Online

# Write-Host 'Step2: Windows Packages: Removing Windows Backup app' -ForegroundColor green -BackgroundColor black
# $windowsbackupapp = Get-WindowsPackage -Online | Where-Object { $_.PackageName -eq 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' }
# if ($windowsbackupapp.PackageState -match 'Installed') {
# 	Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' -Online -NoRestart
# }

Write-Host 'Step2: Hiding Keyboard Switching Notification' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Keyboard Layout\ShowToast') -ne $true) {
	New-Item 'HKCU:\Keyboard Layout\ShowToast' -Force
}
New-ItemProperty -Path 'HKCU:\Keyboard Layout\ShowToast' -Name 'Show' -Value 1 -PropertyType DWord -Force

Write-Host 'Settings: System Properties: Remote: Allow Remote Assistance connections to this computer: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Control\Remote Assistance') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Control\Remote Assistance' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Bing Search: Disabling' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Folder Properties: Customize: Optimize all folders: General items' -ForegroundColor green -BackgroundColor black
$BasePath = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell'
if (Test-Path -Path $BasePath\Bags) {
	Remove-Item -Path $BasePath\Bags -Recurse -Force
}
if (Test-Path -Path $BasePath\BagMRU) {
	Remove-Item -Path $BasePath\BagMRU -Recurse -Force
}
$Bags = New-Item -Path $BasePath -Name 'Bags' -Force
$AllFolders = New-Item -Path $Bags.PSPath -Name 'AllFolders' -Force
$Shell = New-Item -Path $AllFolders.PSPath -Name 'Shell' -Force
New-ItemProperty -Path $Shell.PSPath -Name 'FolderType' -Value 'NotSpecified' -PropertyType String -Force

Write-Host 'Settings: Settings: Personalization: Start: Choose which folders appears on Start: Settings + Explorer' -ForegroundColor green -BackgroundColor black
$itemsToDisplay = @('explorer', 'settings')
$key = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current'
$data = $key.Data[0..19] -Join ','
If ($itemsToDisplay.Length -gt 0) {
	$data += ",203,50,10,$($itemsToDisplay.Length)"
	If ($itemsToDisplay -contains 'explorer') {
		$data += ',5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0'
	}
	If ($itemsToDisplay -contains 'settings') {
		$data += ',5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0'
	}
	If ($itemsToDisplay -contains 'documents') {
		$data += ',5,206,171,211,233,2,36,218,244,3,68,195,138,1,102,130,229,139,177,174,253,253,187,60,0'
	}
	If ($itemsToDisplay -contains 'downloads') {
		$data += ',5,175,230,158,155,14,36,222,147,2,68,213,134,1,102,191,157,135,155,191,143,198,212,55,0'
	}
	If ($itemsToDisplay -contains 'music') {
		$data += ',5,160,140,172,128,11,36,209,254,1,68,178,152,1,102,170,189,208,225,204,234,223,185,21,0'
	}
	If ($itemsToDisplay -contains 'pictures') {
		$data += ',5,160,143,252,193,3,36,138,208,3,68,128,153,1,102,176,181,153,220,205,176,151,222,77,0'
	}
	If ($itemsToDisplay -contains 'videos') {
		$data += ',5,197,203,206,149,4,36,134,251,1,68,244,133,1,102,128,201,206,212,175,217,158,196,181,1,0'
	}
	If ($itemsToDisplay -contains 'network') {
		$data += ',5,196,130,214,243,15,36,141,16,68,174,133,1,102,139,181,211,233,254,210,237,177,148,1,0'
	}
	If ($itemsToDisplay -contains 'personal') {
		$data += ',5,202,224,246,165,7,36,202,242,3,68,232,158,1,102,139,173,143,194,249,160,135,212,188,1,0'
	}
}
$data += ',194,60,1,194,70,1,197,90,1,0'
Set-ItemProperty -Path $key.PSPath -Name 'Data' -Type Binary -Value $data.Split(',')

Write-Host 'Settings: ContentDeliveryManager: Disabling' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'FeatureManagementEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'OemPreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEverEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SilentInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SlideshowEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: System: Tablet: When I sign in: Never use tablet mode' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'SignInMode' -Value 1 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Personalization: Colors: Transparency effects: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Personalization: Start: Show recently opened items in Jump Lists on Start or the taskbar and in File Explorer Quick Access: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Personalization: Start: Show account-related notifications. When off, required notifications are still shown.: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Control Panel: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\Desktop') -ne $true) {
 New-Item 'HKCU:\Control Panel\Desktop' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 0x91, 0x00, 0x00, 0x00)) -PropertyType Binary -Force

Write-Host 'Settings: Control Panel: Ease of Access Center: Make the computer easier to see: Turn off all unnecessary animations (when possible): On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\Desktop\WindowMetrics') -ne $true) {
 New-Item 'HKCU:\Control Panel\Desktop\WindowMetrics' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force

Write-Host 'Settings: Settings: Devices: Mouse: Additional Mouse Options: Pointer Options: Enhance pointer precision: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\Mouse') -ne $true) {
 New-Item 'HKCU:\Control Panel\Mouse' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0' -PropertyType String -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0' -PropertyType String -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0' -PropertyType String -Force

Write-Host 'Settings: Settings: Privacy: Let Windows track app launches to improve Start and search results: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: File Explorer: Ribbon: Details View and Size all columms to fit' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'QatItems' -Value ([byte[]](0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x73, 0x69, 0x71, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x73, 0x63, 0x68, 0x65, 0x6d, 0x61, 0x73, 0x2e, 0x6d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x77, 0x69, 0x6e, 0x64, 0x6f, 0x77, 0x73, 0x2f, 0x32, 0x30, 0x30, 0x39, 0x2f, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x2f, 0x71, 0x61, 0x74, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x20, 0x6d, 0x69, 0x6e, 0x69, 0x6d, 0x69, 0x7a, 0x65, 0x64, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3d, 0x22, 0x30, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x38, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x39, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x32, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x38, 0x34, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x33, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x37, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x35, 0x37, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x34, 0x38, 0x35, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x3e)) -PropertyType Binary -Force

Write-Host 'Settings: Settings: Search: SafeSearch: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'SafeSearchMode' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Search: Search history on this device: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Ease of Access: Automatically hide scroll bars in Windows: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\Accessibility') -ne $true) {
 New-Item 'HKCU:\Control Panel\Accessibility' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'DynamicScrollbars' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: System: Shared experiences: Share across devices: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'RomeSdkChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'CdpSessionUserAuthzPolicy' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Devices: Typing: Add a space after I choose a text suggestion: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnablePredictionSpaceInsertion' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Devices: Typing: Show text suggestions as I type on the software keyboard: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableTextPrediction' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Devices: Typing: Highlight misspelled words: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableSpellchecking' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Devices: Typing: Autocorrect misspelled words: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableAutocorrection' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Devices: Typing: Add a period after I double-tap the Spacebar: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableDoubleTapSpace' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Sounds: Communications: When Windows detects communications activity: Do nothing' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -Value 3 -PropertyType DWord -Force

Write-Host 'Settings: Taskbar: Task View: Disable' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: Personalization: Taskbar: People: Show contacts on the taskbar: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Windows Security: Virus & threat protection: Manage settings: Change notification settings: Recent activity and scan results: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection') -ne $true) {
 New-Item 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection' -Name 'SummaryNotificationDisabled' -Value 1 -PropertyType DWord -Force

Write-Host 'Settings: Windows Security Notification Icon: Off' -ForegroundColor green -BackgroundColor black
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

Write-Host 'Microsoft Edge: Deleting Desktop Shortcut' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk") -eq $true) {
	Remove-Item -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
}

Write-Host 'Remote Desktop Connection: Never show pop-up upon ending session' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Name 'ShowShutdownDialog' -Value 0 -PropertyType DWord -Force

# https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit
# This command forces the kernel timer to constantly poll for interrupts instead of wait for them; dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance
# bcdedit /set disabledynamictick yes

# # Disables the hypervisor which is unneeded on a gaming PC
# bcdedit /set hypervisorlaunchtype off

# # Disable VBS / HVCI
# # https://www.tomshardware.com/how-to/disable-vbs-windows-11
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\DeviceGuard' -Name 'EnableVirtualizationBasedSecurity' -Value 0 -PropertyType DWord -Force

# Process scheduling - 22 = Long, variable, 3x foreground boost (36:12)
# New-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 22 -PropertyType DWord -Force

# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/POSTINSTALL/README.md
# fsutil behavior set DisableDeleteNotify 0
# fsutil behavior set disableLastAccess 1
# fsutil behavior set disable8dot3 1

Write-Host 'Settings: svchost.exe: Group (Decrease Process Number)' -ForegroundColor green -BackgroundColor black
$svchostram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $svchostram -Force

Write-Host 'Settings: Settings: Time & Language: Region: Regional format data: Change data format: Short date: dd/MM/yyyy' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\International') -ne $true) {
 New-Item 'HKCU:\Control Panel\International' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\International' -Name 'sShortDate' -Value 'dd/MM/yyyy' -PropertyType String -Force

Write-Host 'Settings: Settings: Time & Language: Region: Regional format data: Change data format: Long date: dddd, d MMMM, yyyy' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\International') -ne $true) {
 New-Item 'HKCU:\Control Panel\International' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\International' -Name 'sLongDate' -Value 'dddd, d MMMM, yyyy' -PropertyType String -Force

Write-Host 'Settings: Settings: Time & language: Region: Regional format data: Change data format: Short time: HH:mm' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\International') -ne $true) {
 New-Item 'HKCU:\Control Panel\International' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\International' -Name 'sShortTime' -Value 'HH:mm' -PropertyType String -Force

Write-Host 'Settings: Settings: Time & language: Region: Regional format data: Change data format: Long time: HH:mm:ss' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\Control Panel\International') -ne $true) {
 New-Item 'HKCU:\Control Panel\International' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\International' -Name 'sTimeFormat' -Value 'HH:mm:ss' -PropertyType String -Force

Write-Host 'Settings: Settings: Devices: Typing: Typing Insights: Disabling' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Input\Settings') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Name 'InsightsEnabled' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Lock Screen: Setting to black' -ForegroundColor green -BackgroundColor black
takeown /f 'C:\Windows\Web\Screen' /r /d y
icacls 'C:\Windows\Web\Screen' /GRANT Everyone:F, Users:F /t
Add-Type -AssemblyName System.Drawing
$file = "$env:C:\Windows\Web\Screen\img100.jpg"
$edit = New-Object System.Drawing.Bitmap 3840, 2160
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img101.jpg"
$edit = New-Object System.Drawing.Bitmap 3840, 2400
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img101.png"
$edit = New-Object System.Drawing.Bitmap 3840, 2400
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img102.jpg"
$edit = New-Object System.Drawing.Bitmap 6400, 4000
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img103.jpg"
$edit = New-Object System.Drawing.Bitmap 3839, 2400
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img103.png"
$edit = New-Object System.Drawing.Bitmap 3839, 2400
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img104.jpg"
$edit = New-Object System.Drawing.Bitmap 3840, 2400
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
$file = "$env:C:\Windows\Web\Screen\img105.jpg"
$edit = New-Object System.Drawing.Bitmap 1920, 1200
$color = [System.Drawing.Brushes]::Black
$graphics = [System.Drawing.Graphics]::FromImage($edit)
$graphics.FillRectangle($color, 0, 0, $edit.Width, $edit.Height)
$graphics.Dispose()
$edit.Save($file)
takeown /f 'C:\ProgramData\Microsoft\Windows\SystemData' /r /d y
icacls 'C:\ProgramData\Microsoft\Windows\SystemData' /GRANT Everyone:F, Users:F /t
Remove-Item 'C:\ProgramData\Microsoft\Windows\SystemData' -Force -Recurse
Write-Host 'Settings: Settings: Personalization: Lock screen: Show lock screen background pictures on the sign-in screen: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'DisableLogonBackgroundImage' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# DiagTrackService -Disable
# Connected User Experiences and Telemetry
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled
# Block connection for the Unified Telemetry Client Outbound Traffic
Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Block
# DiagnosticDataLevel -Minimal
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Force
}

if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Force
}
# Security level
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 1 -Force
# ErrorReporting -Disable
if ((Get-WindowsEdition -Online).Edition -notmatch 'Core') {
	Get-ScheduledTask -TaskName QueueReporting | Disable-ScheduledTask
	New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Windows Error Reporting' -Name Disabled -PropertyType DWord -Value 1 -Force
}

Get-Service -Name WerSvc | Stop-Service -Force
Get-Service -Name WerSvc | Set-Service -StartupType Disabled
# SigninInfo -Disable
$SID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript { $_.Name -eq $env:USERNAME }).SID
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID")) {
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Name OptOut -PropertyType DWord -Value 1 -Force
# LanguageListAccess -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\International\User Profile' -Name HttpAcceptLanguageOptOut -PropertyType DWord -Value 1 -Force
# AdvertisingID -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force
# WhatsNewInWindows -Disable

if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force
# TailoredExperiences -Disable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force
# BingSearch -Disable
if (-not (Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force
# ThisPC -Hide
# Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Force
# CheckBoxes -Disable'
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force
# HiddenItems -Enable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
# FileExtensions -Show
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
# MergeConflicts -Show
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
# OpenFileExplorerTo -ThisPC
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force
# OneDriveFileExplorerAd -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force
# SnapAssist -Disable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
# FileTransferDialog -Detailed
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force
# RecycleBinDeleteConfirmation -Enable
$ShellState = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState
$ShellState[4] = 51
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
# UserFolders -ThreeDObjects Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# UserFolders Desktop  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
				
# UserFolders Documents  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
			
# # UserFolders Downloads  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
				
# UserFolders Music  Hide  
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
			
# UserFolders Pictures  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# UserFolders Videos  Hide
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# QuickAccessRecentFiles -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force
# QuickAccessFrequentFolders -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force
# TaskbarSearch -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force
# WindowsInkWorkspace -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
# NotificationAreaIcons -Show
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
# NotificationAreaIcons -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 0 -Force
# ControlPanelView -LargeIcons
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
# WindowsColorMode -Dark
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
# AppColorMode -Dark
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
# NewAppInstalledNotification -Hide
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force
# FirstLogonAnimation -Disable
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force
# JPEGWallpapersQuality -Max
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force
# TaskManagerWindow -Expanded
$Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore
if ($Taskmgr) {
	$Taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe
do {
	$Preferences = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction Ignore
}
until ($Preferences)
Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue
$Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
# ShortcutsSuffix -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -PropertyType String -Value '%s.lnk' -Force
# PrtScnSnippingTool -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 0 -Force
# # AppsLanguageSwitch -Disable
# Set-WinLanguageBarOption -UseLegacyLanguageBar
# AeroShaking -Disable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name DisallowShaking -PropertyType DWord -Value 1 -Force
# FolderGroupBy -None
# Clear any Common Dialog views
Get-ChildItem -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell' -Recurse | Where-Object -FilterScript { $_.PSChildName -eq '{885A186E-A440-4ADA-812B-DB871B942259}' } | Remove-Item -Force
# https://learn.microsoft.com/en-us/windows/win32/properties/props-system-null
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name ColumnList -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name GroupBy -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name LogicalViewMode -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name Name -PropertyType String -Value NoName -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name Order -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name PrimaryProperty -PropertyType String -Value 'System.ItemNameDisplay' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name SortByList -PropertyType String -Value 'prop:System.ItemNameDisplay' -Force
# NavigationPaneExpand -Disable
Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Force -ErrorAction SilentlyContinue
# StorageSense -Enable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
# StorageSenseTempFiles -Enable
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq '1') {
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
}
# StorageSenseFrequency -Month
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq '1') {
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
}
# Win32LongPathLimit -Disable
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force
# BSoDStopError -Enable
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 1 -Force
# AdminApprovalMode -Never
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force
# MappedDrivesAppElevatedAccess -Enable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 1 -Force
# DeliveryOptimization -Disable
New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 0 -Force
Delete-DeliveryOptimizationCache -Force
# WindowsManageDefaultPrinter -Disable
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows' -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force
# UpdateMicrosoftProducts -Enable
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2('7971f918-a847-4430-9279-4a52d1efe18d', 7, '')
# InputMethod -English
Set-WinDefaultInputMethodOverride -InputTip '0409:00000409'
# LatestInstalled.NET -Enable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
# WinPrtScrFolder -Default
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{B7BEDE81-DF94-4682-A7D8-57A52620B86F}' -Force -ErrorAction SilentlyContinue
# FoldersLaunchSeparateProcess -Enable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 1 -Force
# ReservedStorage -Disable
Set-WindowsReservedStorageState -State Disabled
# F1HelpPage -Disable
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64')) {
	New-Item -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Name '(default)' -PropertyType String -Value '' -Force
# NumLock -Enable
New-ItemProperty -Path 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force
# CapsLock -Enable
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout' -Name 'Scancode Map' -Force -ErrorAction SilentlyContinue
# StickyShift -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name Flags -PropertyType String -Value 506 -Force
# Autoplay -Disable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force
# ThumbnailCacheRemoval -Enable
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name Autorun -PropertyType DWord -Value 3 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name Autorun -PropertyType DWord -Value 3 -Force
# RestartNotification -Show
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
# RestartDeviceAfterUpdate -Enable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name IsExpedited -PropertyType DWord -Value 1 -Force
# ActiveHours -Manually
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 0 -Force
# RKNBypass -Disable
# Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Force # Error
# PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary
if (Get-Package -Name 'Microsoft Edge' -ProviderName Programs) {
	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' -PropertyType DWord -Value 0 -Force
}
# if (Get-Package -Name 'Microsoft Edge Beta' -ProviderName Programs) {
# 	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
# 		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
# 	}
# 	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}' -PropertyType DWord -Value 0 -Force
# }
# if (Get-Package -Name 'Microsoft Edge Dev' -ProviderName Programs) {
# 	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
# 		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
# 	}
# 	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}' -PropertyType DWord -Value 0 -Force
# }
# if (Get-Package -Name 'Microsoft Edge Canary' -ProviderName Programs) {
# 	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
# 		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
# 	}
# 	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}' -PropertyType DWord -Value 0 -Force
# }
# SATADrivesRemovableMedia -Disable
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device -Name TreatAsInternalPort -Type MultiString -Value @(0, 1, 2, 3, 4, 5) -Force
# RegistryBackup -Disable
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager' -Name EnablePeriodicBackup -Force -ErrorAction SilentlyContinue
# RecentlyAddedApps -Hide
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force	
# AppSuggestions -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force
# PinToStart -UnpinAll
$Script:StartLayout = "$PSScriptRoot\..\StartLayout.xml"
# Unpin all the Start tiles
# Export the current Start layout
Export-StartLayout -Path $Script:StartLayout -UseDesktopApplicationID
[xml]$XML = Get-Content -Path $Script:StartLayout -Encoding UTF8 -Force
$Groups = $XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group
foreach ($Group in $Groups) {
	# Removing all groups inside XML
	$Group.ParentNode.RemoveChild($Group) | Out-Null
}
$XML.Save($Script:StartLayout)
# Temporarily disable changing the Start menu layout
if (-not (Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -PropertyType ExpandString -Value $Script:StartLayout -Force
Start-Sleep -Seconds 3
# Restart the Start menu
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys('^{ESC}')
Start-Sleep -Seconds 3
# Enable changing the Start menu layout
Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force
Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force
Remove-Item -Path $Script:StartLayout -Force
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys('^{ESC}')
# GPUScheduling -Enable
if (Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript { ($_.AdapterDACType -ne 'Internal') -and ($null -ne $_.AdapterDACType) }) {
	# Determining whether an OS is not installed on a virtual machine
	if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch 'Virtual') {
		# Checking whether a WDDM verion is 2.7 or higher
		$WddmVersion_Min = [Microsoft.Win32.Registry]::GetValue('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\FeatureSetUsage', 'WddmVersion_Min', $null)
		if ($WddmVersion_Min -ge 2700) {
			New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name HwSchMode -PropertyType DWord -Value 2 -Force
		}
	}
}
# NetworkProtection -Disable
# Set-MpPreference -EnableNetworkProtection Disabled
# # PUAppsDetection -Disable
# Set-MpPreference -PUAProtection Disabled
# # DefenderSandbox -Disable
# setx /M MP_FORCE_USE_SANDBOX 0
# DismissMSAccount
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
# DismissSmartScreenFilter
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
# CommandLineProcessAudit -Disable
# Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Force
# EventViewerCustomView -Disable
# Remove-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Force
# # PowerShellModulesLogging -Disable
# Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Force
# Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -Force
# PowerShellScriptsLogging -Disable
# Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Force
# AppsSmartScreen -Disable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force
# SaveZoneInformation -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
# WindowsScriptHost -Enable
# Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name Enabled -Force
# WindowsSandbox -Disable
# Checking whether x86 virtualization is enabled in the firmware
if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled) {
	Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
}
# Determining whether Hyper-V is enabled
if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
	Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
}
# MSIExtractContext -Hide
# Remove-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Recurse -Force
# # CABInstallContext -Hide
# Remove-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas -Recurse -Force
# CastToDeviceContext -Hide
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' -PropertyType String -Value '' -Force
# ShareContext -Hide
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}' -PropertyType String -Value '' -Force
	
# EditWithPaint3DContext -Hide
$Extensions = @('.bmp', '.gif', '.jpe', '.jpeg', '.jpg', '.png', '.tif', '.tiff')
foreach ($Extension in $Extensions) {
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force
}
# ImagesEditContext -Hide
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit)) {
	New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force
# PrintCMDContext -Hide
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force
# IncludeInLibraryContext -Hide
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location' -Name '(default)' -PropertyType String -Value '-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}' -Force
# SendToContext -Hide
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name '(default)' -PropertyType String -Value '-{7BA4C740-9E81-11CF-99D3-00AA004AE837}' -Force
# BitmapImageNewContext -Hide
# add if path exists here
if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.MSPaint*').State -eq 'Installed') {
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force
}
# # RichTextDocumentNewContext -Hide
# if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad*').State -eq 'Installed') {
# 	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force
# }
# CompressedFolderNewContext -Hide
# add if path exists here
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force
# MultipleInvokeContext -Disable
# Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -Force

$NetworkAdapters = Get-NetAdapter
$SettingsToChange = @(
	@{ DisplayName = 'Energy Efficient Ethernet'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Energy Efficient Ethernet'; DisplayValue = 'Off' }
	@{ DisplayName = 'Flow Control'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Gigabit Master Slave Mode'; DisplayValue = 'Auto Detect' }
	@{ DisplayName = 'IPv4 Checksum Offload'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Interrupt Moderation Rate'; DisplayValue = 'Off' }
	@{ DisplayName = 'Interrupt Moderation'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Jumbo Frame'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Jumbo Packet'; DisplayValue = '1514' }
	@{ DisplayName = 'Jumbo Packet'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Large Send Offload (IPv4)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Large Send Offload v2 (IPv4)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Large Send Offload v2 (IPv6)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Legacy Switch Compatibility Mode'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Log Link State Event'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Max IRQ per Second'; DisplayValue = '30000' }
	@{ DisplayName = 'Maximum Number of RSS Queues'; DisplayValue = '1 RSS Queues' }
	@{ DisplayName = 'Maximum Number of RSS Queues'; DisplayValue = '1 Queue' }
	@{ DisplayName = 'NS Offload'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'PTP Hardware Timestamp'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Packet Priority & VLAN'; DisplayValue = 'Packet Priority & VLAN Disabled' }
	@{ DisplayName = 'Protocol ARP Offload'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Protocol NS Offload'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Receive Buffers'; DisplayValue = '2048' }
	@{ DisplayName = 'Receive Side Scaling'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Reduce Speed On Power Down'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'SWOI'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Selective Suspend Idle Timeout'; DisplayValue = '5' }
	@{ DisplayName = 'Selective Suspend'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Software Timestamp'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Speed & Duplex'; DisplayValue = '1.0 Gbps Full Duplex' }
	@{ DisplayName = 'System Idle Power Saver'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'TCP Checksum Offload (IPv4)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'TCP Checksum Offload (IPv6)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Transmit Buffers'; DisplayValue = '1024' }
	@{ DisplayName = 'Transmit Buffers'; DisplayValue = '2048' }
	@{ DisplayName = 'UDP Checksum Offload (IPv4)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'UDP Checksum Offload (IPv6)'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Ultra Low Power Mode'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Wait for Link'; DisplayValue = 'Off' }
	@{ DisplayName = 'Wake from S0ix on Magic Packet'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Wake on Link Settings'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Wake on Pattern Match'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'ARP Offload'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'Adaptive Inter-Frame Spacing'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'DMA Coalescing'; DisplayValue = 'Disabled' }
	@{ DisplayName = 'ECMA'; DisplayValue = 'Enabled' }
)
foreach ($Adapter in $NetworkAdapters) {
	try {
		$AdvancedProperties = Get-NetAdapterAdvancedProperty -Name $Adapter.Name -ErrorAction Stop
		foreach ($Setting in $SettingsToChange) {
			$Property = $AdvancedProperties | Where-Object { $_.DisplayName -eq $Setting.DisplayName }
			if ($Property) {
				Write-Host "Network: $($Adapter.Name) - $($Setting.DisplayName): $($Setting.DisplayValue)" -ForegroundColor Green -BackgroundColor Black
				Set-NetAdapterAdvancedProperty -Name $Adapter.Name -DisplayName $Setting.DisplayName -DisplayValue $Setting.DisplayValue
			}
			else {
				Write-Host "Network: $($Adapter.Name) - does not have '$($Setting.DisplayName)' setting." -ForegroundColor Yellow -BackgroundColor Black
			}
		}
	}
	catch {
		Write-Host "Network: $($Adapter.Name) - does not have advanced properties available or an error occurred." -ForegroundColor Red -BackgroundColor Black
	}
}

Write-Host 'Network: Congestion Provider: None' -ForegroundColor green -BackgroundColor black
netsh int tcp set supplemental internet congestionprovider=None

Write-Host 'Network: DCA: Disabled' -ForegroundColor green -BackgroundColor black
netsh int tcp set global dca=Disabled

Write-Host 'Network: Teredo: Disabled' -ForegroundColor green -BackgroundColor black
netsh interface teredo set state disabled

Write-Host 'Network: Auto Tuning Level Local: Normal' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -AutoTuningLevelLocal Normal

Write-Host 'Network: Scaling Heuristics: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -ScalingHeuristics Disabled

Write-Host 'Network: Receive Segment Coalescing: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled

Write-Host 'Network: PacketCoalescingFilter: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled

Write-Host 'Network: Receive Side Scaling: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -ReceiveSideScaling Disabled
netsh int tcp set global rss=disabled

Write-Host 'Network: Large Send Offload: Disabled' -ForegroundColor green -BackgroundColor black
Disable-NetAdapterLso -Name *

Write-Host 'Network: Checksum Offload: Disabled' -ForegroundColor green -BackgroundColor black
Disable-NetAdapterChecksumOffload -Name *

Write-Host 'Network: EcnCapability: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -EcnCapability Disabled

Write-Host 'Network: Chimney: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -Chimney Disabled

Write-Host 'Network: Timestamps: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -Timestamps Disabled

Write-Host 'Network: MaxSynRetransmissions: 2' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -MaxSynRetransmissions 2

Write-Host 'Network: NonSackRttResiliency: Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -NonSackRttResiliency Disabled

Write-Host 'Network: InitialRtoMs: 2000' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -InitialRtoMs 2000

Write-Host 'Network: Internet Explorer Optimization: MaxConnectionsPer1_0Server: 10' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER') -ne $true) {
 New-Item 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER' -Name 'iexplore.exe' -Value 10 -PropertyType DWord -Force

Write-Host 'Network: Internet Explorer Optimization: MaxConnectionsPerServer: 10' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER') -ne $true) {
 New-Item 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER' -Name 'iexplore.exe' -Value 10 -PropertyType DWord -Force

Write-Host 'Network: Host Resolution Priority: LocalPriority: 4' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 4 -PropertyType DWord -Force

Write-Host 'Network: Host Resolution Priority: HostsPriority: 5' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 5 -PropertyType DWord -Force

Write-Host 'Network: Host Resolution Priority: DnsPriority: 6' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 6 -PropertyType DWord -Force

Write-Host 'Network: Host Resolution Priority: NetbtPriority: 7' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 7 -PropertyType DWord -Force

Write-Host 'Network: QoS: NonBestEffortLimit: 0' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Psched') -ne $true) {
 New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Psched' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Psched' -Name 'NonBestEffortLimit' -Value 0 -PropertyType DWord -Force

Write-Host 'Network: QoS: Do not use NLA: Optimal' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value '1' -PropertyType String -Force

Write-Host 'Network: NetworkThrottlingIndex: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile') -ne $true) {
 New-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value -1 -PropertyType DWord -Force

Write-Host 'Network: SystemResponsiveness: Gaming' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -Force

Write-Host 'Network: Network Memory Allocation: Size: Gaming' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force

Write-Host 'Network: IRPStackSize: 32' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType DWord -Force

Write-Host 'Network: Network Memory Allocation: LargeSystemCache: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType DWord -Force

Write-Host 'Network: Dynamic Port Allocation: MaxUserPort: 65534' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType DWord -Force

Write-Host 'Network: Dynamic Port Allocation: TcpTimedWaitDelay: 30' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 30 -PropertyType DWord -Force

Write-Host 'Network: Time to Live: 64' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType DWord -Force

$NetworkGUIDs = (Get-NetAdapter).InterfaceGUID
foreach ($GUID in $NetworkGUIDs) {
	Write-Host 'Network: TcpAckFrequency: Disabled' -ForegroundColor green -BackgroundColor black
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$GUID" -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force

	Write-Host 'Network: TcpDelAckTicks: Disabled' -ForegroundColor green -BackgroundColor black
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$GUID" -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force

	Write-Host 'Network: TCPNoDelay: Enabled' -ForegroundColor green -BackgroundColor black
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$GUID" -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force
}

Write-Host 'Hosts: Adding mobile.events.data.microsoft.com' -ForegroundColor green -BackgroundColor black
$mobileeventsdatamicrosoft = Select-String -Path $env:windir\System32\drivers\etc\hosts -Pattern 'mobile.events.data.microsoft.com'
if ($null -eq $mobileeventsdatamicrosoft) {
	Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1`tmobile.events.data.microsoft.com" -Force
}

Add-Type -AssemblyName System.Windows.Forms
$WakeOnLanAnswer = [System.Windows.Forms.MessageBox]::Show('Enable Wake-On-Lan?

Wake-on-LAN is an Ethernet computer networking standard that allows this PC to be turned on by a network message.
' , 'Wake-On-Lan' , 4, 32)

if ($WakeOnLanAnswer -eq 'Yes') {
	Write-Host 'Network: Wake-On-Lan: On' -ForegroundColor green -BackgroundColor black
	$PnPValue = 256
	$Adapter = Get-NetAdapter | Where-Object { ($_.Status -eq 'Up') }
	$KeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\'
	foreach ($Entry in (Get-ChildItem $KeyPath -ErrorAction SilentlyContinue).Name) {
		
		if ((Get-ItemProperty REGISTRY::$Entry).DriverDesc -eq $Adapter.InterfaceDescription) {
			$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			
			if ($Value -ne $PnPValue) {
				Set-ItemProperty -Path REGISTRY::$Entry -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			}

			if ($Value -eq $PnPValue) {
				Write-Host 'Network: Allow the computer to turn off this device to save power: On' -ForegroundColor green -BackgroundColor black
				Write-Host 'Network: Allow this device to wake the computer: On' -ForegroundColor green -BackgroundColor black
				Write-Host 'Network: Only allow a magic packet to wake the computer: On' -ForegroundColor green -BackgroundColor black
			}
			
			else {
				Write-Host 'Network: Failed'
			}
		}
	}
	
	if ($NetworkSettingsName -match 'Wake on magic packet') {
		Write-Host 'Network: Wake on magic packet: On' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Wake on magic packet' -DisplayValue 'Enabled'
	}

	if ($NetworkSettingsName -match 'Enable PME') {
		Write-Host 'Network: Enable PME: On' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Enable PME' -DisplayValue 'Enabled'
	}

	if ($NetworkSettingsName -match 'Shutdown Wake Up') {
		Write-Host 'Network: Shutdown Wake Up: Enabled' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Shutdown Wake Up' -DisplayValue 'Enabled'
	}

}

if ($WakeOnLanAnswer -eq 'No') {
	Write-Host 'Network: Wake-On-Lan: Off' -ForegroundColor green -BackgroundColor black
	$PnPValue = 24
	$Adapter = Get-NetAdapter | Where-Object { ($_.Status -eq 'Up') }
	$KeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\'
	foreach ($Entry in (Get-ChildItem $KeyPath -ErrorAction SilentlyContinue).Name) {
		
		if ((Get-ItemProperty REGISTRY::$Entry).DriverDesc -eq $Adapter.InterfaceDescription) {
			$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			
			if ($Value -ne $PnPValue) {
				Set-ItemProperty -Path REGISTRY::$Entry -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			}
			
			if ($Value -eq $PnPValue) {
				Write-Host 'Network: Allow the computer to turn off this device to save power: Off' -ForegroundColor green -BackgroundColor black
				Write-Host 'Network: Allow this device to wake the computer: Off' -ForegroundColor green -BackgroundColor black
				Write-Host 'Network: Only allow a magic packet to wake the computer: Off' -ForegroundColor green -BackgroundColor black
			}
			
			else {
				Write-Host 'Network: Failed'
			}
		}
	}

	if ($NetworkSettingsName -match 'Wake on magic packet') {
		Write-Host 'Network: Wake on magic packet: Off' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Wake on magic packet' -DisplayValue 'Disabled'
	}
	
	if ($NetworkSettingsName -match 'Enable PME') {
		Write-Host 'Network: Enable PME: Off' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Enable PME' -DisplayValue 'Disabled'
	}
	
	if ($NetworkSettingsName -match 'Shutdown Wake Up') {
		Write-Host 'Network: Shutdown Wake Up: Disabled' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Shutdown Wake Up' -DisplayValue 'Disabled'
	}
}