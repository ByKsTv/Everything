# Settings: System: Activation
$SvcRestartTask = Get-ScheduledTask | Where-Object TaskName -EQ 'SvcRestartTask'
if ($SvcRestartTask -and $SvcRestartTask.State -eq 'Disabled') {
	Enable-ScheduledTask -TaskPath $SvcRestartTask.TaskPath -TaskName $SvcRestartTask.TaskName
}
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /KMS38

# Settings: Windows Update: Check for updates
UsoClient.exe StartInteractiveScan

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Server/GroupPolicy.ps1')

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable page prediction: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Name 'FPEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable tracking in the web: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'DoNotTrack' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable search and website suggestions: On
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'ShowSearchSuggestionsGlobal' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable form suggestions: On
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'Use FormSuggest' -Value 'no' -PropertyType String -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Do not optimize web search results on the task bar for screen reader: On
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'OptimizeWindowsSearchResultsForScreenReaders' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable SmartScreen Filter: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter' -Name 'EnabledV9' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable sites saving protected media licenses on my device: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy' -Name 'EnableEncryptedMediaExtensions' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable Cortana in Microsoft Edge: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Name 'EnableCortana' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable showing search history: On
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory')) {
	New-Item -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Name '(default)' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Activity History and Clipboard: Disable storage of clipboard history: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Clipboard' -Name 'EnableClipboardHistory' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable transmission of typing information: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\input\TIPC' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Cortana (Personal Assistant): Disable input Personalization: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable Windows Media Player Diagnostics: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\MediaPlayer\Preferences' -Name 'UsageTracking' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable feedback reminders: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to use voice activation: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to use voice activation when device is locked: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationOnLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the standard app for the headset button: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationLastUsed' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable text suggestions when typing on the software keyboard: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableTextPrediction' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable and reset Advertising ID and info: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable sending URLs from apps to Windows Store: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost' -Name 'EnableWebContentEvaluation' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Prohibit apps from running in the background: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to movements: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to diagnostics information: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to calendar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to unpaired devices: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Name 'Value' -Value 'Deny' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to messages: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to contacts: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to documents: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to downloads folder: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to email: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to eye tracking: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for apps to take screenshots: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for desktop apps to take screenshots: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for apps to take screenshots without borders: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for desktop apps to take screenshots without margins: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to device location: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to device microphone: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to music libraries: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to phone calls: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to call history: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to images: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to radios: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to user account information: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to tasks: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to videos: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to camera: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: Privacy: Disable tips, tricks, and suggestions when using Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable Windows Spotlight: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable fun facts, tips, tricks, and more on your lock screen: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable automatic installation of recommended Windows Store Apps: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SilentInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable tips, tricks, and suggestions while using Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Explorer: Disable occassionally showing app suggestions in Start menu: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable suggestions in the timeline: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353698Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable suggestions in Start: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338388Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable showing suggested content in the Settings app: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable Windows Update via peer-to-peer: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Name 'SystemSettingsDownloadMode' -Value 0 -PropertyType DWord -Force
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Name 'DODownloadMode' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable widgets in Windows Explorer: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarDa' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Copilot: Disable the Copilot button from the taskbar: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCopilotButton' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Explorer: Disable ads in Windows Explorer/OneDrive: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable People icon in the taskbar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable news and interests in the taskbar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarViewMode' -Value 2 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable Phone Link app: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'PhoneLinkEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable showing suggestions for using mobile devices with Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'OptedIn' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable access to mobile devices: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'CrossDeviceEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable notifications on lock screen: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: User Behavior: Disable the user of diagnostic data for a tailor-made user experience: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy' -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable app notifications: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Search: Disable search with AI in search box: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDynamicSearchBoxEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of all settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'SyncPolicy' -Value 5 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of accessibility settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of browser settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of credentials (passwords): On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of language settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of design settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of advanced Windows settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable the possibility of suggesting to finish the setup of the device: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Name 'ScoobeSystemSettingEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Cortana (Personal Assistant): Disable and reset Cortana: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Name 'CortanaConsent' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Explorer: Disable OneDrive access to network before login: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\OneDrive')) {
	New-Item -Path 'HKLM:\Software\Microsoft\OneDrive' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\OneDrive' -Name 'PreventNetworkTrafficPreUserSignIn' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable advertisements via Bluetooth: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth')) {
	New-Item -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Bluetooth' -Name 'AllowAdvertising' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Microsoft Edge (legacy version): Disable automatic completion of web addresses in address bar: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser')) {
	New-Item -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\Browser' -Name 'AllowAddressBarDropdown' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable Windows dynamic configuration and update rollouts: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\System')) {
	New-Item -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\System' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\PolicyManager\current\device\System' -Name 'AllowExperimentation' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Cortana (Personal Assistant): Disable download and updates of speech recognition and speech synthesis models: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Speech_OneCore\Preferences' -Name 'ModelDownloadAllowed' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to motion: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to diagnostics information: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to calendar: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to unpaired devices: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Name 'Value' -Value 'Deny' -PropertyType String -Force
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to messages: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to the file system: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to contacts: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to documents: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to downloads folder: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to email: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to eye tracking: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable the ability for apps to take screenshots: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable the ability for apps to take screenshots without borders: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to device microphone: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to music libraries: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to phone calls: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to call history: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to images: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to radios: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to user account information: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to tasks: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to notifications: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to videos: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to camera: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic downloading manufacturers' apps and icons for devices: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Device Metadata' -Name 'PreventDeviceMetadataFromNetwork' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic app updates through Windows Update: On
if (-not (Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate')) {
	New-Item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Name 'AutoDownload' -Value 2 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable Windows Error Reporting: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Location Services: Disable Windows Geolocation Service: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\lfsvc\Service\Configuration' -Name 'Status' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' -Name 'SensorPermissionState' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable the Windows Customer Experience Improvement Program
New-ItemProperty -Path 'HKLM:\Software\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: User Behavior: Disable application telemetry
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\AllowTelemetry' -Name 'Value' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack' -Name 'DiagTrackAuthorization' -Value 00001101 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager' -Name 'MiniTraceSlotEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Security: Disable telemetry: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\DiagTrack' -Name 'Start' -Value 4 -PropertyType DWord -Force
if (-not (Test-Path -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener')) {
	New-Item -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener' -Force
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener' -Name 'Start' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\dmwappushservice' -Name 'Start' -Value 4 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Miscellaneous: Disable Network Connectivity Status indicator: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\NlaSvc\Parameters\Internet' -Name 'EnableActiveProbing' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic Windows Updates: Off
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\wuauserv' -Name 'Start' -Value 3 -PropertyType DWord -Force

# Settings: System: Multitasking: Snap windows: When I snap a window, suggest what I can snap next to it: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SnapAssist' -PropertyType DWord -Value 0 -Force

# Settings: System: Multitasking: Snap windows: Show snap layouts when I over over a window's maximize button: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'EnableSnapAssistFlyout' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: End Task: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -PropertyType DWord -Value 1 -Force

# Settings: System: For developers: File Explorer: Show file extenstions: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideFileExt' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: File Explorer: Show empty drives: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideDrivesWithNoMedia' -PropertyType DWord -Value 0 -Force

# Settings: Bluetooth & devices: Devices: Device settings: Download over metered connections: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeviceSetup' -Name 'CostedNetworkPolicy' -PropertyType DWord -Value 1 -Force

# Settings: Bluetooth & devices: Mouse: Enhance pointer precision: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -PropertyType String -Value 0 -Force

# Settings: Bluetooth & devices: USB: Connection notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Name 'NotifyOnUsbErrors' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Colors: Choose your mode: Dark
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Colors: Transparency effects: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recently added apps: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Start' -Name 'ShowRecentList' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommended files in Start, recent files in File Explorer, and items in Jump Lists: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommendations for tips, shortcuts, new apps, and more: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_IrisRecommendations' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show account-related notifications: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Search: Hide
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Task view: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force

# Settings: Personalization: Taskbar: Taskbar behaviors: Taskbar alignment: Left
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -PropertyType DWord -Value 0 -Force

# Settings: Accessibility: Keyboard: Use the Print screen key to open screen capture: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'PrintScreenKeyForSnippingEnabled' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let websites show me locally relevant content by accessing my language list: Off
New-ItemProperty -Path 'HKCU:\Control Panel\International\User Profile' -Name 'HttpAcceptLanguageOptOut' -PropertyType DWord -Value 1 -Force

# Settings: Privacy & security: General: Let Windows improve Start and search results by tracking app launches: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Inking & typing personalization: Custom inking and typing dictionary: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -PropertyType DWord -Value 0 -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Name 'Value' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Feedback: Feedback fequency: Never
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Search permissions: SafeSearch: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'SafeSearchMode' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Search permissions: History: Search history on this device: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -PropertyType DWord -Value 0 -Force

# Settings: Windows Update: Advanced options: Receive updates for other Microsoft products: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'AllowMUUpdateService' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Get me up to date: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsExpedited' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Download updates over metered connections: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'AllowAutoWindowsUpdateDownloadOverMeteredNetwork' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Notify me when a restart is required to finish updating: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'RestartNotificationsAllowed2' -PropertyType DWord -Value 1 -Force

# Folder Options: Open File Explorer to: This PC
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -PropertyType DWord -Value 1 -Force

# Folder Options: General: Privacy: Show recently used files: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show frequently used folders: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show files from Office.com: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowCloudFilesInQuickAccess' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Advanced settings: Decrease space between items (compact view): On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Advanced settings: Hidden files and folders: Show hidden files, folders, and drives
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -PropertyType DWord -Value 1 -Force

# Power Plan: Restore default schemes
powercfg.exe /restoredefaultschemes
$PowerPlanUltimate = powercfg.exe -list | Select-String -Pattern 'Ultimate Performance'
$PowerPlanHigh = powercfg.exe -list | Select-String -Pattern 'High performance'
if ($PowerPlanUltimate) {
	$PowerPlanGUID = ($PowerPlanUltimate.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	# Power Plan: Ultimate Performance
	powercfg.exe /setactive $PowerPlanGUID
}
elseif ($PowerPlanHigh) {
	$PowerPlanGUID = ($PowerPlanHigh.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	# Power Plan: High performance
	powercfg.exe /setactive $PowerPlanGUID
}
# Power Plan: Turn off display after: 0 Seconds (Never)
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

# Control Panel: Ease of Access: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On
$RemoveBackgroundImagesBytes = [byte[]](Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
$RemoveBackgroundImagesBytes[4] = $RemoveBackgroundImagesBytes[4]-bor 1
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value $RemoveBackgroundImagesBytes -Force

# Uninstall `Feedback Hub`
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage

# Task Manager: Startup apps: Delete: AzureArcSetup
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('AzureArcSetup')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'AzureArcSetup'
}

# Server Manager: Don't show this message again
New-ItemProperty -Path 'HKLM:\Software\Microsoft\ServerManager' -Name 'DoNotPopWACConsoleAtSMLaunch' -PropertyType DWord -Value 1 -Force

# Add username to autologon
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

# Maximum password age (days): Unlimited
net.exe accounts /maxpwage:unlimited

# PasswordComplexity: Off
secedit.exe /export /cfg "$env:TEMP\PasswordComplexity.cfg"
(Get-Content "$env:TEMP\PasswordComplexity.cfg") -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0' | Set-Content "$env:TEMP\PasswordComplexity.cfg"
secedit.exe /configure /db secedit.sdb /cfg "$env:TEMP\PasswordComplexity.cfg" /areas SECURITYPOLICY

# Sound: Communications: Do nothing
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -PropertyType DWord -Value 3 -Force

# Restore the old Context Menu in Windows 11
if (-not (Test-Path -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32')) {
	New-Item -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Name '(Default)' -Value '' -Force

# Taskbar tray icons
Get-ChildItem 'HKCU:\Control Panel\NotifyIconSettings' -Recurse | ForEach-Object { New-ItemProperty -Path $_.PSPath -Name 'IsPromoted' -Value 1 -PropertyType DWORD -Force }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$InitialSetup_Form = New-Object System.Windows.Forms.Form -Property @{
	Text            = 'Initial Setup'
	Font            = [Drawing.Font]::new('Tahoma', 11)
	Width           = 350
	Height          = 380
	StartPosition   = 'CenterScreen'
	FormBorderStyle = 'FixedDialog'
	Topmost         = $true
	MaximizeBox     = $false
	MinimizeBox     = $false
	ControlBox      = $false
}

$InitialSetup_ButtonSpacer = 15
$InitialSetup_ButtonWidth = 57
$InitialSetup_TotalButtonWidth = $InitialSetup_ButtonSpacer + $InitialSetup_ButtonWidth + $InitialSetup_ButtonWidth
$InitialSetup_FormCenterX = [math]::Round(($InitialSetup_Form.ClientSize.Width - $InitialSetup_TotalButtonWidth) / 2)
$InitialSetup_ButtonHeight = 20
$InitialSetup_ButtonYLocation = $InitialSetup_Form.Height - 60

$InitialSetup_OK = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'OK'
	Width     = $InitialSetup_ButtonWidth
	Height    = $InitialSetup_ButtonHeight
	Location  = [Drawing.Point]::new($InitialSetup_FormCenterX, $InitialSetup_ButtonYLocation)
	Add_Click = { $InitialSetup_Form.Close() }
}

$InitialSetup_CancelX = $InitialSetup_FormCenterX + $InitialSetup_ButtonWidth + $InitialSetup_ButtonSpacer
$InitialSetup_Cancel = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'Cancel'
	Width     = $InitialSetup_ButtonWidth
	Height    = $InitialSetup_ButtonHeight
	Location  = [Drawing.Point]::new($InitialSetup_CancelX, $InitialSetup_ButtonYLocation)
	Add_Click = { $InitialSetup_Form.Close() }
}

$InitialSetup_LocX = 5
$InitialSetup_LocY = 0
$InitialSetup_SizeX = $InitialSetup_Form.Width - 30
$InitialSetup_SizeY = 26
$InitialSetup__LocAdd = 30

$InitialSetup_TimeZoneSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $InitialSetup_SizeX
	Height        = $InitialSetup_SizeY
	Location      = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
	DropDownStyle = 'DropDownList'
}
[void] $InitialSetup_TimeZoneSelection.Items.Add('Select Time Zone')
$InitialSetup_TimeZoneSelection.SelectedIndex = 0
$TimeZones = [TimeZoneInfo]::GetSystemTimeZones() | Sort-Object -Property Id
[void] $TimeZones.ForEach({ $InitialSetup_TimeZoneSelection.Items.Add($_.Id) })

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_KeyboardSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $InitialSetup_SizeX
	Height        = $InitialSetup_SizeY
	Location      = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
	DropDownStyle = 'DropDownList'
}
[void] $InitialSetup_KeyboardSelection.Items.Add('Select Keyboard')
$InitialSetup_KeyboardSelection.SelectedIndex = 0
$Keyboard_Tags = @('af-ZA', 'am-ET', 'ar-SA', 'az-Latn-AZ', 'bg-BG', 'bn-IN', 'bs-Latn-BA', 'ca-ES', 'cs-CZ', 'cy-GB', 'da-DK', 'de-DE', 'el-GR', 'en-GB', 'en-US', 'es-ES', 'es-MX', 'et-EE', 'eu-ES', 'fa-IR', 'fi-FI', 'fil-PH', 'fr-CA', 'fr-FR', 'ga-IE', 'gl-ES', 'gu-IN', 'he-IL', 'hi-IN', 'hr-HR', 'hu-HU', 'hy-AM', 'id-ID', 'is-IS', 'it-IT', 'ja-JP', 'ka-GE', 'kk-KZ', 'km-KH', 'kn-IN', 'ko-KR', 'ky-KG', 'lt-LT', 'lv-LV', 'mk-MK', 'ml-IN', 'mn-MN', 'mr-IN', 'ms-MY', 'mt-MT', 'nb-NO', 'nl-NL', 'pl-PL', 'pt-BR', 'pt-PT', 'ro-RO', 'ru-RU', 'si-LK', 'sk-SK', 'sl-SI', 'sq-AL', 'sr-Cyrl-RS', 'sv-SE', 'sw-KE', 'ta-IN', 'te-IN', 'th-TH', 'tr-TR', 'uk-UA', 'ur-PK', 'uz-Latn-UZ', 'vi-VN', 'zh-CN', 'zh-TW')
$Keyboard_Map = @{}
foreach ($Keyboard_Tag in $Keyboard_Tags) {
	try {
		$Keyboard_Map[[Globalization.CultureInfo]::GetCultureInfo($Keyboard_Tag).DisplayName] = $Keyboard_Tag 
	}
	catch {
		$Keyboard_Map[$Keyboard_Tag] = $Keyboard_Tag 
	}
}
$Keyboard_Map.Keys | Sort-Object | ForEach-Object { $InitialSetup_KeyboardSelection.Items.Add($_) | Out-Null }

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_PreComputerName = 'Enter Computer Name'
$InitialSetup_ComputerName = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = $InitialSetup_PreComputerName
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}
$InitialSetup_ComputerName.Add_GotFocus{ if ($InitialSetup_ComputerName.Text -eq $InitialSetup_PreComputerName) {
		$InitialSetup_ComputerName.Text = ''
	}
}
$InitialSetup_ComputerName.Add_LostFocus({ if ($InitialSetup_ComputerName.Text -eq '') {
			$InitialSetup_ComputerName.Text = $InitialSetup_PreComputerName
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_ComputerPasswordCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Computer Password'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_ComputerPasswordTextBox = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = 'Computer Password'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_AutoLogonCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Autologon'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_ComputerPasswordCheckBox.Add_Click(
	{
		$ComputerPasswordEnabled = $InitialSetup_ComputerPasswordCheckBox.Checked
		$InitialSetup_ComputerPasswordTextBox.Enabled = $InitialSetup_AutoLogonCheckBox.Enabled = $ComputerPasswordEnabled
		$InitialSetup_ComputerPasswordTextBox.Text = if ($ComputerPasswordEnabled) {
			'' 
		}
		else {
			'Computer Password'
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemoteDesktop = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Desktop'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemotePowershell = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Powershell'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemotePowershellIP = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = 'Remote Powershell Trusted IP'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_RemotePowershell.Add_Click(
	{
		$RemotePowershellEnabled = $InitialSetup_RemotePowershell.Checked
		$InitialSetup_RemotePowershellIP.Enabled = $RemotePowershellEnabled
		$InitialSetup_RemotePowershellIP.Text = if ($RemotePowershellEnabled) {
			''
		}
		else {
			'Remote Powershell Trusted IP'
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_MozillaFirefox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Mozilla Firefox'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_GoogleChrome = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Google Chrome'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_OK.Add_Click(
	{
		$InitialSetup_Form.Topmost = $false

		if ($InitialSetup_TimeZoneSelection.SelectedItem -and $InitialSetup_TimeZoneSelection.Text -ne 'Select Time Zone') {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Time Zone: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_TimeZoneSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
			tzutil.exe /s $InitialSetup_TimeZoneSelection.SelectedItem
		}

		if ($InitialSetup_KeyboardSelection.SelectedItem -and $InitialSetup_KeyboardSelection.Text -ne 'Select Keyboard') {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Keyboard: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_KeyboardSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
			$LanguageList = Get-WinUserLanguageList
			$LanguageList.Add($Keyboard_Map[$InitialSetup_KeyboardSelection.SelectedItem])
			Set-WinUserLanguageList -LanguageList $LanguageList -Force
		}

		if ($InitialSetup_ComputerName.Text -ne $InitialSetup_PreComputerName) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Computer name: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_ComputerName.Text); [Console]::ResetColor(); [Console]::WriteLine()
			Rename-Computer -NewName $InitialSetup_ComputerName.Text -Force
		}

		if ($InitialSetup_ComputerPasswordCheckBox.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Adding'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-LocalUser -Name $env:USERNAME -Password (ConvertTo-SecureString $InitialSetup_ComputerPasswordTextBox.Text -AsPlainText -Force)
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $InitialSetup_ComputerPasswordTextBox.Text -PropertyType String -Force
		}
		elseif ($InitialSetup_ComputerPasswordCheckBox.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Removing'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-LocalUser -Name $env:username -Password ([securestring]::new())
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
		}
	
		if ($InitialSetup_AutoLogonCheckBox.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1' -PropertyType String -Force
		}
		elseif ($InitialSetup_AutoLogonCheckBox.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
		}

		if ($InitialSetup_RemoteDesktop.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
			Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
		}
		elseif ($InitialSetup_RemoteDesktop.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1
			Disable-NetFirewallRule -DisplayGroup 'Remote Desktop'
		}

		if ($InitialSetup_RemotePowershell.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-NetConnectionProfile -NetworkCategory Private
			Enable-PSRemoting -Force
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Adding IP'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-Item wsman:\localhost\Client\TrustedHosts -Value $InitialSetup_RemotePowershellIP.Text -Force
		}
		elseif ($InitialSetup_RemotePowershell.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Disable-PSRemoting -Force
			Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse
			Clear-Item wsman:\localhost\client\trustedhosts -Force
			Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False | Select-Object -Property DisplayName, Profile, Enabled
			Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name LocalAccountTokenFilterPolicy -Value 0
			Stop-Service WinRM
			Set-Service WinRM -StartupType Manual
		}

		if ($InitialSetup_MozillaFirefox.Checked -eq $true) {
			Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Download.ps1')
		}
	
		if ($InitialSetup_GoogleChrome.Checked -eq $true) {
			Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Download.ps1')
		}
	}
)

$InitialSetup_Form.Controls.Add($InitialSetup_OK)
$InitialSetup_Form.Controls.Add($InitialSetup_Cancel)

$InitialSetup_Form.Controls.Add($InitialSetup_TimeZoneSelection)
$InitialSetup_Form.Controls.Add($InitialSetup_KeyboardSelection)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerName)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerPasswordCheckBox)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerPasswordTextBox)
$InitialSetup_Form.Controls.Add($InitialSetup_AutoLogonCheckBox)
$InitialSetup_Form.Controls.Add($InitialSetup_RemoteDesktop)
$InitialSetup_Form.Controls.Add($InitialSetup_RemotePowershell)
$InitialSetup_Form.Controls.Add($InitialSetup_RemotePowershellIP)
$InitialSetup_Form.Controls.Add($InitialSetup_MozillaFirefox)
$InitialSetup_Form.Controls.Add($InitialSetup_GoogleChrome)

[void] $InitialSetup_Form.ShowDialog()

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Install_Microsoft_Visual_C++_Redistributable.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Install_DirectX_End_User_Runtimes.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')