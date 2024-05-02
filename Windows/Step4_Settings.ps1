Write-Host 'O&O ShutUp10++ > Recommended' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe -OutFile $ENV:temp\OOSU10.exe
$OOSU10 = '############################################################################
# This file was created with O&O ShutUp10++ V1.9.1436
# and can be imported onto another computer. 
#
# Download the application at https://www.oo-software.com/shutup10
# You can then import the file from within the program. 
#
# Alternatively you can import it automatically over a command line.
# Simply use the following parameter: 
# OOSU10.exe <path to file>
# 
# Selecting the Option /quiet ends the app right after the import and the
# user does not get any feedback about the import.
#
# We are always happy to answer any questions you may have!
# © 2015-2023 O&O Software GmbH, Berlin. All rights reserved.
# https://www.oo-software.com/
############################################################################

P001	+
P002	+
P003	+
P004	+
P005	+
P006	+
P008	+
P026	+
P027	+
P028	+
P064	+
P065	+
P066	+
P067	+
P070	+
P069	+
P009	-
P010	-
P015	-
P068	-
P016	-
A001	+
A002	+
A003	+
A004	+
A006	+
A005	+
P007	+
P036	+
P025	+
P033	+
P023	+
P056	+
P057	-
P012	-
P034	-
P013	-
P035	-
P062	-
P063	-
P081	-
P047	-
P019	-
P048	-
P049	-
P020	-
P037	-
P011	-
P038	-
P050	-
P051	-
P018	-
P039	-
P021	-
P040	-
P022	-
P041	-
P014	-
P042	-
P052	-
P053	-
P054	-
P055	-
P029	-
P043	-
P030	-
P044	-
P031	-
P045	-
P032	-
P046	-
P058	-
P059	-
P060	-
P061	-
P024	-
S001	+
S002	+
S003	+
S008	-
E001	+
E002	+
E003	+
E008	+
E007	+
E010	+
E011	+
E012	+
E009	-
E004	-
E005	-
E013	-
E014	-
E006	-
Y001	+
Y002	+
Y003	+
Y004	+
Y005	+
Y006	+
Y007	+
C012	+
C002	+
C013	+
C007	+
C008	+
C009	+
C010	+
C011	+
C014	+
C015	+
L001	+
L003	+
L004	-
L005	-
U001	+
U004	+
U005	+
U006	+
U007	+
W001	+
W011	+
W004	-
W005	-
W010	-
W009	-
P017	-
W006	-
W008	-
M006	+
M011	-
M010	-
O003	-
O001	-
S012	-
S013	-
S014	-
K001	+
K002	+
K005	+
M003	-
M015	-
M016	-
M017	-
M018	-
M019	-
M020	-
M022	+
M001	+
M004	+
M005	+
M024	+
M012	-
M013	-
M014	-
M023	-
N001	-
'
New-Item -Path $ENV:temp\OOSU10.cfg -ItemType File -Value $OOSU10 -Force
$PrivacyAccessLanguageBrowser = 'P015	-'
$PrivacyTextSuggest = 'P068	-'
$EdgeDRM = 'E004	-'
$EdgeOptimizeSearch = 'E005	-'
$ExplorerRecently = 'M011	-'
$ExplorerAds = 'M010	-'
$SearchBing = 'M003	-'
$TaskbarPeople = 'M015	-'
$TaskbarSearch = 'M016	-'
$TaskbarMeet = 'M018	-'
$TaskbarNews = 'M020	-'
$PrivacyBiometrical = 'P009	-'
$SecurityDRM = 'S008	-'
$EdgeBackground = 'E013	-'
$EdgeBackgroundPages = 'E014	-'
$LocationSensors = 'L004	-'
$LocationService = 'L005	-'
$ExplorerOneDrive = 'O003	-'
$ExplorerOneDriveDisable = 'O001	-'
$DefenderSpynet = 'S012	-'
$DefenderSubmit = 'S013	-'
$DefenderReport = 'S014	-'
$TaskbarMeetMachine = 'M017	-'
$TaskbarNewsMachine = 'M019	-'
$MiscKeyManagement = 'M012	-'
$MiscMapData = 'M013	-'
$MiscMapNetwork = 'M014	-'
$MiscPCHealth = 'M023	-'
(Get-Content -Raw $ENV:temp\OOSU10.cfg) -replace $PrivacyAccessLanguageBrowser, 'P015	+' -replace $PrivacyTextSuggest, 'P068	+' -replace $EdgeOptimizeSearch, 'E005	+' -replace $EdgeDRM, 'E004	+' -replace $ExplorerRecently, 'M011	+' -replace $ExplorerAds, 'M010	+' -replace $SearchBing, 'M003	+' -replace $TaskbarPeople, 'M015	+' -replace $TaskbarSearch, 'M016	+' -replace $TaskbarMeet, 'M018	+' -replace $TaskbarNews, 'M020	+' -replace $PrivacyBiometrical, 'P009	+' -replace $SecurityDRM, 'S008	+' -replace $EdgeBackground, 'E013	+' -replace $EdgeBackgroundPages, 'E014	+' -replace $LocationSensors, 'L004	+' -replace $LocationService, 'L005	+' -replace $ExplorerOneDrive, 'O003	+' -replace $ExplorerOneDriveDisable, 'O001	+' -replace $DefenderSpynet, 'S012	+' -replace $DefenderSubmit, 'S013	+' -replace $DefenderReport, 'S014	+' -replace $TaskbarMeetMachine, 'M017	+' -replace $TaskbarNewsMachine, 'M019	+' -replace $MiscKeyManagement, 'M012	+' -replace $MiscMapData, 'M013	+' -replace $MiscMapNetwork, 'M014	+' -replace $MiscPCHealth, 'M023	+' | Set-Content $ENV:temp\OOSU10.cfg
Start-Process $ENV:temp\OOSU10.exe -ArgumentList "$ENV:temp\OOSU10.cfg /quiet" -Wait
Write-Host 'Services > Manual' -ForegroundColor green -BackgroundColor black
Set-Service AJRouter -StartupType Disabled
Set-Service AssignedAccessManagerSvc -StartupType Disabled
Set-Service CDPSvc -StartupType Manual
Set-Service StorSvc -StartupType Manual
Set-Service UsoSvc -StartupType Manual
Set-Service WpnService -StartupType Manual
Set-Service edgeupdate -StartupType Manual
Set-Service vm3dservice -StartupType Manual
Write-Host 'Indexing Service > Off' -ForegroundColor green -BackgroundColor black
Stop-Service -Name WSearch
Set-Service -Name WSearch -StartupType Disabled
Write-Host 'System Properties > Remote > Allow Remote Assistance connections to this computer > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\System\ControlSet001\Control\Remote Assistance') -ne $true) { New-Item 'HKLM:\System\ControlSet001\Control\Remote Assistance' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\System\ControlSet001\Control\Remote Assistance' -Name 'fAllowToGetHelp' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Bing Search > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Folder Properties > Customize > Optimize all folders > General items' -ForegroundColor green -BackgroundColor black
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
Write-Host 'Settings > Personalization > Start > Choose which folders appears on Start > Settings + Explorer' -ForegroundColor green -BackgroundColor black
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
Write-Host 'ContentDeliveryManager > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'FeatureManagementEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'OemPreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SilentInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SlideshowEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'ContentDeliveryAllowed' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEverEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353698Enabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > System > Tablet > When I sign in > Never use tablet mode' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'SignInMode' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Adobe Acrobat > Edit > Prefrences > Security (Enhanced) > Protected View > All Files' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager') -ne $true) { New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'AnyDesk > Optional Offer - Recommended by AnyDesk > Decline' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Google\No Chrome Offer Until') -ne $true) { New-Item 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Name 'AnyDesk Software GmbH' -Value 30241008 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > General > Disable the welcome screen > On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder') -ne $true) { New-Item 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'DisableStartupScreen' -Value 'True' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Playback settings > Continuous reply > Infinite playback' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'NumberOfPlaybacks' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Playback settings > Hide the topmost playing... bar > On' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'HidePlayWnd' -Value 'True' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Keyboard shortcuts (hotkeys) > Play / Pause / Resume playback > F8' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PausePlayKey' -Value 119 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Keyboard shortcuts (hotkeys) > Abort playback > F9' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortPlayKey' -Value 120 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Keyboard shortcuts (hotkeys) > Step-by-step playback > F10' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'StepByStepPlayKey' -Value 121 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Keyboard shortcuts (hotkeys) > Start / Pause / Resume recording > F11' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'RecordKey' -Value 122 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Jitbit Macro Recorder > Settings > Keyboard shortcuts (hotkeys) > Abort recording > F12' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortRecKey' -Value 123 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Personalization > Colors > Transparency effects > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Personalization > Start > Show recently opened items in Jump Lists on Start or the taskbar and in File Explorer Quick Access > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Personalization > Start > Show account-related notifications. When off, required notifications are still shown. > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Personalization > Lock screen > Show lock screen background pictures on the sign-in screen > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'DisableLogonBackgroundImage' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Control Panel > Ease of Access Center > Make the computer easier to see > Remove background images (when available) > On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\Desktop') -ne $true) { New-Item 'HKCU:\Control Panel\Desktop' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 0x91, 0x00, 0x00, 0x00)) -PropertyType Binary -Force -ea SilentlyContinue
Write-Host 'Control Panel > Ease of Access Center > Make the computer easier to see > Turn off all unnecessary animations (when possible) > On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics') -ne $true) { New-Item 'HKCU:\Control Panel\Desktop\WindowMetrics' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Mouse > Additional Mouse Options > Pointer Options > Enhance pointer precision > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\Mouse') -ne $true) { New-Item 'HKCU:\Control Panel\Mouse' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0' -PropertyType String -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0' -PropertyType String -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Privacy > Let Windows track app launches to improve Start and search results > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'File Explorer > Ribbon > Details View and Size all columms to fit' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'QatItems' -Value ([byte[]](0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x73, 0x69, 0x71, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x73, 0x63, 0x68, 0x65, 0x6d, 0x61, 0x73, 0x2e, 0x6d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x77, 0x69, 0x6e, 0x64, 0x6f, 0x77, 0x73, 0x2f, 0x32, 0x30, 0x30, 0x39, 0x2f, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x2f, 0x71, 0x61, 0x74, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x20, 0x6d, 0x69, 0x6e, 0x69, 0x6d, 0x69, 0x7a, 0x65, 0x64, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3d, 0x22, 0x30, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x38, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x39, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x32, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x38, 0x34, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x33, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x37, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x35, 0x37, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x34, 0x38, 0x35, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x3e)) -PropertyType Binary -Force -ea SilentlyContinue
Write-Host 'Settings > Search > SafeSearch > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'SafeSearchMode' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Search > Search history on this device > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Ease of Access > Automatically hide scroll bars in Windows > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\Accessibility') -ne $true) { New-Item 'HKCU:\Control Panel\Accessibility' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Accessibility' -Name 'DynamicScrollbars' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > System > Shared experiences > Share across devices > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'RomeSdkChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'CdpSessionUserAuthzPolicy' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Typing > Add a space after I choose a text suggestion > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnablePredictionSpaceInsertion' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Typing > Show text suggestions as I type on the software keyboard > Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableTextPrediction' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Typing > Highlight misspelled words > Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableSpellchecking' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Typing > Autocorrect misspelled words > Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableAutocorrection' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Devices > Typing > Add a period after I double-tap the Spacebar > Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableDoubleTapSpace' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Sounds > Communications > When Windows detects communications activity > Do nothing' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -Value 3 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Network > WLAN Service > WLAN Settings > Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config') -ne $true) { New-Item 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'AutoConnectAllowedOEM' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Location and Sensors > Turn off location > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off cloud optimized content > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableCloudOptimizedContent' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off cloud consumer account state content > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Cloud Content > Do not show Windows tips > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off Microsoft consumer experiences > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Configure Windows spotlight on lock screen > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'ConfigureWindowsSpotlight' -Value 2 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off Spotlight collection on Desktop > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSpotlightCollectionOnDesktop' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Do not use diagnostic data for tailored experiences > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableTailoredExperiencesWithDiagnosticData' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Do not suggest third-party content in Windows spotlight > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off all Windows spotlight features > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightFeatures' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off Windows Spotlight on Action Center > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnActionCenter' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off Windows Spotlight on Settings > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnSettings' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Cloud Content > Turn off the Windows Welcome Experience > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightWindowsWelcomeExperience' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Control Panel > Allow Online Tips > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'AllowOnlineTips' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Control Panel > Regional and Language Options > Handwriting personalization > Turn off automatic learning > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\InputPersonalization') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Start Menu and Taskbar > Do not keep history of recently opened documents > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Start Menu and Taskbar > Notifications > Turn off notifications network usage > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoCloudApplicationNotification' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > App-V > CEIP > Microsoft Customer Experience Improvement Program (CEIP) > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\AppV\CEIP') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Device Installation > Do not send a Windows error report when a generic driver is installed on a device > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force -ea SilentlyContinue }
if ((Test-Path -LiteralPath 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) { New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Device Installation > Prevent Windows from sending an error report when a device driver requests additional woftware during installation > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force -ea SilentlyContinue }
if ((Test-Path -LiteralPath 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) { New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off handwriting recognition error reporting > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Name 'PreventHandwritingErrorReports' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Windows Customer Experience Improvement Program > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host "Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Help and Support Center 'Did you know?' content > Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'Headlines' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Help and Support Center Microsoft Knowledge Base search > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'MicrosoftKBSearch' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Windows Error Reporting > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Force -ea SilentlyContinue }
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Name 'DoReport' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Search Companion content file updates > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\SearchCompanion') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Name 'DisableContentFileUpdates' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Internet File Association service > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoInternetOpenWith' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off access to the Store > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Explorer') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoUseStoreOpenWith' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off Internet download for Web publishing and online ordering wizards > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWebServices' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host "Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off the 'Order Prints' picture task > Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoOnlinePrintsWizard' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host "Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off the 'Publish to Web' task for files and folders > Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPublishingWizard' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off the Windows Messenger Customer Experience Improvement Program > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'CEIP' -Value 2 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > Internet Communication Management > Internet Communication settings > Turn off handwriting personalization data sharing > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > OS Policies > Allow Clipboard History > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > OS Policies > Allow Clipboard synchronization across devices > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowCrossDeviceClipboard' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > OS Policies > Allow publishing of User Activites > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > OS Policies > Allow upload of User Activites > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'UploadUserActivities' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > OS Policies > Enabled Activity Feed > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > System > User Profiles > Turn off the advertising ID > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Remove Program Compatibility Property Page > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePropPage' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off Application Compatibility Engine > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableEngine' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off Application Telemetry > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off Inventory Collector > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off Program Compatibility Assistant > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePCA' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off Steps Recorder > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Application Compatibility > Turn off SwitchBack Compatibility Engine > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'SbEnable' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds > Allow device name to be sent in Windows diagnostic data > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'AllowDeviceNameInTelemetry' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds > Configure collection of browsing data for Desktop Analytics > Do not allow sending intranet or internet history' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'MicrosoftEdgeDataOptIn' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds > Disable OneSettings Downloads > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Data Collection and Preview Builds > Do not show feedback notifications > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Edge UI > Disable help tips > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableHelpSticker' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Maps > Turn off Automatic Download nad Update of Map Data > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Maps > Turn off unsolicited network  traffic on the Offline Maps settings page > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Online Assistance > Turn off Active Help > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Name 'NoActiveHelp' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow Cloud Search > Disable Cloud Search' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCloudSearch' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow Cortana > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow Cortana above lock screen > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaAboveLock' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow Cortana Page in OOBE on an AAD account > Disable Cortana Page in AAD' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaInAADPathOOBE' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow search highlights > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'EnableDynamicContentInWSB' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Allow search and Cortana to use location > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Do not allow web search > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host "Computer Configuration > Administrative Templates > Windows Components > Search > Don't search the web or display web results in Search > Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host "Computer Configuration > Administrative Templates > Windows Components > Search > Don't search the web or disable web results in Search over metered connections > Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Set the SafeSearch setting for Search > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchSafeSearch' -Value 3 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Search > Set what information is shared in Search > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force -ea SilentlyContinue }
Remove-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchPrivacy' -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Text Input > Improve inking and typing recognition > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Calendar > Turn off Windows Calendar > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Name 'TurnOffWinCal' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Error Reporting > Configure Error Reporting > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Force -ea SilentlyContinue }
Remove-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWReporteeName' -Force -ea SilentlyContinue
Remove-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWFileTreeRoot' -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Error Reporting > Automatically send memory dumps for OS-generated error reports > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'AutoApproveOSDumps' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Error Reporting > Send data when on connected to a restricted/costed network > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassNetworkCostThrottling' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Error Reporting > Send additional data when on battery power > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassPowerThrottling' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Error Reporting > Do not send additional data > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'DontSendAdditionalData' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Mobility Center > Turn off Windows Mobility Center > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Name 'NoMobilityCenter' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Messenger > Do not automatically start Windows Messenger initially > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventAutoRun' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Messenger > Do not allow Windows Messenger to be run > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventRun' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Microsoft Defender Antivirus > MAPS > Send file samples when further analysis is required > Never send' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SubmitSamplesConsent' -Value 2 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Computer Configuration > Administrative Templates > Windows Components > Windows Game Recording and Broadcasing > Disable' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR') -ne $true) { New-Item 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Windows Components > Windows Copilot > Turn off Windows Copilot > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot') -ne $true) { New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'User Configuration > Administrative Templates > Start Menu and Taskbar > Remove the Meet Now icon > Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Settings > Personalization > Taskbar > People > Show contacts on the taskbar > Off' -ForegroundColor green -BackgroundColor black
Write-Host 'Taskbar > Task View > Disable' -ForegroundColor green -BackgroundColor black
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People') -ne $true) { New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue
Write-Host 'Windows Security > Virus & threat protection > Manage settings > Change notification settings > Recent activity and scan results > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection') -ne $true) { New-Item 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows Defender Security Center\Virus and threat protection' -Name 'SummaryNotificationDisabled' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue

Write-Host 'Desktop > Microsoft Edge > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'C:\Users\Public\Desktop\Microsoft Edge.lnk') -eq $true) {
	Remove-Item -LiteralPath 'C:\Users\Public\Desktop\Microsoft Edge.lnk'
}
Write-Host 'Desktop > Firefox > Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath "$env:PUBLIC\Desktop\Firefox.lnk") -eq $true) {
	Remove-Item -Path ("$env:PUBLIC\Desktop\Firefox.lnk") -Force -Recurse
}
Write-Host 'Windows Security Notification Icon > Off' -ForegroundColor green -BackgroundColor black
if ($null -ne (Get-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}
Write-Host 'Legacy Advanced Boot Options Added (F8)' -ForegroundColor green -BackgroundColor black
bcdedit /set `{current`} bootmenupolicy Legacy
Write-Host 'Split Threshold for svchost.exe' -ForegroundColor green -BackgroundColor black
$svchostram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $svchostram -Force
Write-Host 'Settings > Date & time > Time zone > Jerusalem' -ForegroundColor green -BackgroundColor black
Set-TimeZone -Id 'Israel Standard Time'
Write-Host 'Settings > Time & Language > Region > Regional format data > Change data format > Short date > dd/MM/yyyy' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\International') -ne $true) { New-Item 'HKCU:\Control Panel\International' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\International' -Name 'sShortDate' -Value 'dd/MM/yyyy' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Time & Language > Region > Regional format data > Change data format > Long date > dddd, d MMMM, yyyy' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\International') -ne $true) { New-Item 'HKCU:\Control Panel\International' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\International' -Name 'sLongDate' -Value 'dddd, d MMMM, yyyy' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Time & language > Region > Regional format data > Change data format > Short time > HH:mm' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\International') -ne $true) { New-Item 'HKCU:\Control Panel\International' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\International' -Name 'sShortTime' -Value 'HH:mm' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Time & language > Region > Regional format data > Change data format > Long time > HH:mm:ss' -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKCU:\Control Panel\International') -ne $true) { New-Item 'HKCU:\Control Panel\International' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\International' -Name 'sTimeFormat' -Value 'HH:mm:ss' -PropertyType String -Force -ea SilentlyContinue
Write-Host 'Settings > Time & Language > Language > Hebrew Keyboard' -ForegroundColor green -BackgroundColor black
$HebrewUserLanguage = Get-WinUserLanguageList
$HebrewUserLanguage.Add('he-IL')
Set-WinUserLanguageList -LanguageList $HebrewUserLanguage -Force