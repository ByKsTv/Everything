Write-Host 'O&O ShutUp10++ > Recommended' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe -OutFile $ENV:temp\OOSU10.exe
$OOSU10 = '
############################################################################
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
Write-Host 'O&O ShutUp10++ > Custom Settings' -ForegroundColor green -BackgroundColor black
(Get-Content -Raw $ENV:temp\OOSU10.cfg) -replace $PrivacyAccessLanguageBrowser, 'P015	+' -replace $PrivacyTextSuggest, 'P068	+' -replace $EdgeOptimizeSearch, 'E005	+' -replace $EdgeDRM, 'E004	+' -replace $ExplorerRecently, 'M011	+' -replace $ExplorerAds, 'M010	+' -replace $SearchBing, 'M003	+' -replace $TaskbarPeople, 'M015	+' -replace $TaskbarSearch, 'M016	+' -replace $TaskbarMeet, 'M018	+' -replace $TaskbarNews, 'M020	+' -replace $PrivacyBiometrical, 'P009	+' -replace $SecurityDRM, 'S008	+' -replace $EdgeBackground, 'E013	+' -replace $EdgeBackgroundPages, 'E014	+' -replace $LocationSensors, 'L004	+' -replace $LocationService, 'L005	+' -replace $ExplorerOneDrive, 'O003	+' -replace $ExplorerOneDriveDisable, 'O001	+' -replace $DefenderSpynet, 'S012	+' -replace $DefenderSubmit, 'S013	+' -replace $DefenderReport, 'S014	+' -replace $TaskbarMeetMachine, 'M017	+' -replace $TaskbarNewsMachine, 'M019	+' -replace $MiscKeyManagement, 'M012	+' -replace $MiscMapData, 'M013	+' -replace $MiscMapNetwork, 'M014	+' -replace $MiscPCHealth, 'M023	+' | Set-Content $ENV:temp\OOSU10.cfg
Write-Host 'O&O ShutUp10++ > Run' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\OOSU10.exe -ArgumentList "$ENV:temp\OOSU10.cfg /quiet" -Wait