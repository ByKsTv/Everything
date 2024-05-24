# https://learn.microsoft.com/en-us/previous-versions/windows/hardware/design/dn613985(v=vs.85)
Write-Host 'PowerPlan: Importing Ultimate Performance' -ForegroundColor green -BackgroundColor black
$ultimateScheme = powercfg /LIST | Where-Object { $_ -match 'Ultimate Performance' }
if ($null -eq $ultimateScheme) {
	(New-Object System.Net.WebClient).DownloadFile('https://github.com/ByKsTv/Everything/raw/main/Windows/Ultimate_Performance.pow', "$env:TEMP\Ultimate_Performance.pow")
	powercfg /IMPORT "$env:TEMP\Ultimate_Performance.pow" 'e9a42b02-d5df-448d-aa00-03f14749eb61'
}

Write-Host 'PowerPlan: Activating Ultimate Performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACTIVE e9a42b02-d5df-448d-aa00-03f14749eb61

Write-Host 'PowerPlan: Deleting all power plans' -ForegroundColor green -BackgroundColor black
$powerPlans = powercfg /LIST | Select-String -Pattern 'GUID: ([\w-]+)' | ForEach-Object { $_.Matches.Groups[1].Value }
foreach ($plan in $powerPlans) {
	powercfg /DELETE $plan
}

Write-Host 'PowerPlan: Changing screen to never turns off' -ForegroundColor green -BackgroundColor black
powercfg /CHANGE monitor-timeout-ac 0
powercfg /CHANGE monitor-timeout-dc 0
powercfg /CHANGE standby-timeout-ac 0
powercfg /CHANGE standby-timeout-dc 0

Write-Host 'PowerPlan: Disabling hibernate' -ForegroundColor green -BackgroundColor black
powercfg /HIBERNATE off
powercfg /CHANGE hibernate-timeout-ac 0
powercfg /CHANGE hibernate-timeout-dc 0
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabledDefault' -PropertyType DWord -Value 0 -Force

Write-Host 'PowerPlan: Disabling power throttling' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -PropertyType DWord -Value 1 -Force

Write-Host 'PowerPlan: Disabling lock option' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -Name 'ShowLockOption' -PropertyType DWord -Value 0 -Force

Write-Host 'PowerPlan: Disabling sleep option' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' -Name 'ShowSleepOption' -PropertyType DWord -Value 0 -Force

Write-Host 'PowerPlan: Disabling fast boot option' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -PropertyType DWord -Value 0 -Force

Write-Host 'PowerPlan: Unparking CPU cores' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583' -Name 'ValueMax' -PropertyType DWord -Value 0 -Force
powercfg /SETACVALUEINDEX SCHEME_CURRENT sub_processor CPMINCORES 100
powercfg /SETACVALUEINDEX SCHEME_CURRENT sub_processor CPMINCORES1 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT sub_processor CPMINCORES 100
powercfg /SETDCVALUEINDEX SCHEME_CURRENT sub_processor CPMINCORES1 100

Write-Host 'PowerPlan: Setting system responsiveness' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -PropertyType DWord -Value 0 -Force

Write-Host 'PowerPlan: Turn off hard disk after: 0 seconds' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0x00000000
powercfg /CHANGE disk-timeout-ac 0
powercfg /CHANGE disk-timeout-dc 0

Write-Host 'PowerPlan: Desktop background settings: Slide show: Paused' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001

Write-Host 'PowerPlan: Wireless Adapter Settings: Maximum Performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 000

Write-Host 'PowerPlan: Sleep: Sleep after: 0 seconds' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0x00000000

Write-Host 'PowerPlan: Allow hybrid sleep: Off' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000

Write-Host 'PowerPlan: Hibernate after: 0 seconds' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0x00000000

Write-Host 'PowerPlan: Allow wake timers: Disable' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000

Write-Host 'PowerPlan: USB settings: USB selective suspend setting: Disabled' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 000

Write-Host 'PowerPlan: Power buttons and lid: Start menu power button: Shut down' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 002
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 002

Write-Host 'PowerPlan: PCI Express: Link State Power Management: Off' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000

# https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit
# Do not enable, CPU will be at 100% Usage constintly
Write-Host 'PowerPlan: Processor idle disable: Processor idle disable: Processor idle enable' -ForegroundColor green -BackgroundColor black
powercfg /attributes SUB_PROCESSOR 5d76a2ca-e8c0-402f-a133-2158492d58ad -ATTRIB_HIDE
powercfg /SETACVALUEINDEX SCHEME_CURRENT sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0

Write-Host 'PowerPlan: Processor power management: Minimum processor state: 100%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 0x00000064
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 0x00000064

Write-Host 'PowerPlan: System cooling policy: Active' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001

Write-Host 'PowerPlan: Maximum processor state: 100%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 0x00000064
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 0x00000064

Write-Host 'PowerPlan: Display: Turn off display after: 0 seconds' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0x00000000

Write-Host 'PowerPlan: Display brightness: 100%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0x00000064
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0x00000064

Write-Host 'PowerPlan: Dimmed display brightness: 100%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0x00000064
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0x00000064

Write-Host 'PowerPlan: Enable adaptive brightness: Off' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 000

Write-Host 'PowerPlan: Video playback quality bias: Video playback performance bias' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 001
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 001

Write-Host 'PowerPlan: When playing video: Optimize video quality' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 000

Write-Host 'PowerPlan: intel(r) graphics settings intel(r) graphics power plan maximum performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 002
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 44f3beca-a7c0-460e-9df2-bb8b99e0cba6 3619c3f2-afb2-4afc-b0e9-e7fef372de36 002

Write-Host 'PowerPlan: amd power slider overlay best performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT c763b4ec-0e50-4b6b-9bed-2b92a6ee884e 7ec1751b-60ed-4588-afb5-9819d3d77d90 003
powercfg /SETDCVALUEINDEX SCHEME_CURRENT c763b4ec-0e50-4b6b-9bed-2b92a6ee884e 7ec1751b-60ed-4588-afb5-9819d3d77d90 003

Write-Host 'PowerPlan: ati graphics power settings ati powerplay settings maximize performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT f693fb01-e858-4f00-b20f-f30e12ac06d6 191f65b5-d45c-4a4f-8aae-1ab8bfd980e6 001
powercfg /SETDCVALUEINDEX SCHEME_CURRENT f693fb01-e858-4f00-b20f-f30e12ac06d6 191f65b5-d45c-4a4f-8aae-1ab8bfd980e6 001

Write-Host 'PowerPlan: switchable dynamic graphics global settings maximize performance' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e276e160-7cb0-43c6-b20b-73f5dce39954 a1662ab2-9d34-4e53-ba8b-2639b9e20857 003
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e276e160-7cb0-43c6-b20b-73f5dce39954 a1662ab2-9d34-4e53-ba8b-2639b9e20857 003

Write-Host 'PowerPlan: Battery: Critical battery notification: Off' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 000

Write-Host 'PowerPlan: Critical battery action: Do nothing' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 000

Write-Host 'PowerPlan: Low battery level: 0%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0x00000000

Write-Host 'PowerPlan: Critical battery level: 0%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0x00000000

Write-Host 'PowerPlan: Low battery notification: Off' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 000

Write-Host 'PowerPlan: Low battery action: Do nothing' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 000

Write-Host 'PowerPlan: Reserve battery level: 0%' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0x00000000

Write-Host 'PowerPlan: low screen brightness when using battery saver disable' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0x00000064
powercfg /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0x00000064

Write-Host 'PowerPlan: turn battery saver on automatically at never' -ForegroundColor green -BackgroundColor black
powercfg /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0x00000000
powercfg /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0x00000000

# https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services-using-mdm
# https://learn.microsoft.com/en-us/windows/privacy/manage-windows-21h2-endpoints

Write-Host 'O&O ShutUp10++: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe', "$env:TEMP\OOSU10.exe")

Write-Host 'O&O ShutUp10++: Getting latest recommended settings' -ForegroundColor green -BackgroundColor black
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

Write-Host 'O&O ShutUp10++: Writing latest recommended settings' -ForegroundColor green -BackgroundColor black
New-Item -Path $ENV:temp\OOSU10.cfg -ItemType File -Value $OOSU10 -Force

Write-Host 'O&O ShutUp10++: Modifying settings' -ForegroundColor green -BackgroundColor black
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

Write-Host 'O&O ShutUp10++: Starting' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\OOSU10.exe -ArgumentList "$ENV:temp\OOSU10.cfg /quiet" -Wait

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
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
	New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Prevent Windows from sending an error report when a device driver requests additional woftware during installation: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) {
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force 
}
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
	New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force

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
	New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchPrivacy' -Force

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
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWReporteeName' -Force
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWFileTreeRoot' -Force

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

Write-Host 'Step2: Scheduled tasks: Disabling telemetry' -ForegroundColor green -BackgroundColor black
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
Disable-ScheduledTask -TaskName 'WinSAT' -TaskPath '\Microsoft\Windows\Maintenance'

Write-Host 'Step2: Windows Capabilities: Disabling' -ForegroundColor green -BackgroundColor black
# Get-WindowsCapability -Online | Where-Object { $_.State -ne 'NotPresent' }
Remove-WindowsCapability -Name 'App.StepsRecorder~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'App.Support.QuickAssist~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'Browser.InternetExplorer~~~~0.0.11.0' -Online
Remove-WindowsCapability -Name 'Media.WindowsMediaPlayer~~~~0.0.12.0' -Online
Remove-WindowsCapability -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'Hello.Face.18967~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'OneCoreUAP.OneSync~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'MathRecognizer~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'OpenSSH.Client~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'DirectX.Configuration.Database~~~~0.0.1.0' -Online
# Notepad
Add-WindowsCapability -Name 'Microsoft.Windows.Notepad~~~~0.0.1.0' -Online
# PowerShell ISE
Add-WindowsCapability -Name 'Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0' -Online
# Windows Fax and Scan
Add-WindowsCapability -Name 'Print.Fax.Scan~~~~0.0.1.0' -Online
# Print Managment
Add-WindowsCapability -Name 'Print.Management.Console~~~~0.0.1.0' -Online
# Paint
Add-WindowsCapability -Name 'Microsoft.Windows.MSPaint~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Optional Features: Disabling' -ForegroundColor green -BackgroundColor black
# Get-WindowsOptionalFeature -Online | Where-Object { $_.State -like 'Enabled' }
Disable-WindowsOptionalFeature -FeatureName 'LegacyComponents' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowerShellV2' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowershellV2Root' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-XPSServices-Features' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WorkFolders-Client' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MediaPlayback' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WCF-Services45' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WCF-TCP-PortSharing45' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-PrintToPDFServices-Features' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MSRDC-Infrastructure' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'NetFx4-AdvSrvs' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'SearchEngine-Client-Package' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Microsoft-SnippingTool' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-Foundation-InternetPrinting-Client' -Online -NoRestart
# RDP
Enable-WindowsOptionalFeature -FeatureName 'Microsoft-RemoteDesktopConnection' -Online -NoRestart
# Print
Enable-WindowsOptionalFeature -FeatureName 'Printing-Foundation-Features' -Online -NoRestart
# SMB
if (Get-SmbClientNetworkInterface | Where-Object { $_.RdmaCapable -eq $false } ) {
	Disable-WindowsOptionalFeature -FeatureName 'SmbDirect' -Online -NoRestart
}
elseif (Get-SmbClientNetworkInterface | Where-Object { $_.RdmaCapable -eq $true } ) {
	Enable-WindowsOptionalFeature -FeatureName 'SmbDirect' -Online -NoRestart
}

Write-Host 'Step2: Windows Packages: Removing Windows Backup app' -ForegroundColor green -BackgroundColor black
Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4291' -Online -NoRestart
Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' -Online -NoRestart

Write-Host 'Step2: NuGet: Uninstalling' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:ProgramFiles\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:ProgramFiles\PackageManagement" -ForegroundColor green -BackgroundColor black
	icacls "$env:ProgramFiles\PackageManagement" /grant Users:F
	Remove-Item -Path ("$env:ProgramFiles\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:LOCALAPPDATA\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:LOCALAPPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
	Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:APPDATA\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:APPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
	Remove-Item -Path ("$env:APPDATA\PackageManagement") -Force -Recurse
}

Write-Host 'Step2: PSWindowsUpdate: Uninstalling' -ForegroundColor green -BackgroundColor black
Uninstall-Module PSWindowsUpdate -Force
if ((Test-Path -Path "$env:ProgramFiles\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:ProgramFiles\PackageManagement" -ForegroundColor green -BackgroundColor black
	icacls "$env:ProgramFiles\PackageManagement" /grant Users:F
	Remove-Item -Path ("$env:ProgramFiles\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:LOCALAPPDATA\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:LOCALAPPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
	Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:APPDATA\PackageManagement")) {
	Write-Host "Step2: NuGet: Deleting $env:APPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
	Remove-Item -Path ("$env:APPDATA\PackageManagement") -Force -Recurse
}

Write-Host 'Settings: Services: Setting to manual' -ForegroundColor green -BackgroundColor black
# https://docs.microsoft.com/en-us/windows-server/security/windows-services/security-guidelines-for-disabling-system-services-in-windows-server
# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/SERVICES/README.md
Set-Service AJRouter -StartupType Disabled
Set-Service AppVClient -StartupType Disabled
Set-Service AssignedAccessManagerSvc -StartupType Disabled
Set-Service AxInstSV -StartupType Disabled
Set-Service CDPSvc -StartupType Manual
Set-Service CscService -StartupType Disabled
Set-Service FrameServer -StartupType Disabled
Set-Service MapsBroker -StartupType Disabled
Set-Service NetTcpPortSharing -StartupType Disabled
Set-Service PhoneSvc -StartupType Disabled
Set-Service PrintNotify -StartupType Disabled
Set-Service QWAVE -StartupType Disabled
Set-Service RemoteAccess -StartupType Disabled
# RmSvc is wifi?
Set-Service RmSvc -StartupType Disabled
Set-Service SCardSvr -StartupType Disabled
Set-Service SSDPSRV -StartupType Disabled
Set-Service ScDeviceEnum -StartupType Disabled
Set-Service SensorDataService -StartupType Disabled
Set-Service SensorService -StartupType Disabled
Set-Service SensrSvc -StartupType Disabled
Set-Service SharedAccess -StartupType Disabled
Set-Service ShellHWDetection -StartupType Disabled
Set-Service Spooler -StartupType Disabled
Set-Service StorSvc -StartupType Manual
Set-Service TabletInputService -StartupType Disabled
Set-Service UevAgentService -StartupType Disabled
Set-Service UserDataSvc -StartupType Disabled
Set-Service UsoSvc -StartupType Manual
Set-Service WSearch -StartupType Disabled
Set-Service WalletService -StartupType Disabled
Set-Service WiaRpc -StartupType Disabled
Set-Service WpnService -StartupType Manual
Set-Service SEMgrSvc -StartupType Disabled
Set-Service XblAuthManager -StartupType Disabled
Set-Service XblGameSave -StartupType Disabled
# bluthoot
Set-Service bthserv -StartupType Disabled
Set-Service dmwappushservice -StartupType Disabled
Set-Service edgeupdate -StartupType Manual
Set-Service icssvc -StartupType Disabled
Set-Service lfsvc -StartupType Disabled
Set-Service lltdsvc -StartupType Disabled
Set-Service stisvc -StartupType Disabled
Set-Service tzautoupdate -StartupType Disabled
Set-Service upnphost -StartupType Disabled
Set-Service vm3dservice -StartupType Manual
Set-Service wisvc -StartupType Disabled

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

Write-Host 'Settings: ContentDeliveryManager: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'FeatureManagementEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'OemPreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SilentInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SlideshowEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'ContentDeliveryAllowed' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEverEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353698Enabled' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Settings: System: Tablet: When I sign in: Never use tablet mode' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'SignInMode' -Value 1 -PropertyType DWord -Force

Write-Host 'Settings: Adobe Acrobat: Edit: Prefrences: Security (Enhanced): Protected View: All Files' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force

Write-Host 'Settings: AnyDesk: Optional Offer - Recommended by AnyDesk: Decline' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Name 'AnyDesk Software GmbH' -Value 30241008 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: General: Disable the welcome screen: On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Force 
}

New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'DisableStartupScreen' -Value 'True' -PropertyType String -Force
Write-Host 'Settings: Jitbit Macro Recorder: Settings: Playback settings: Continuous reply: Infinite playback' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'NumberOfPlaybacks' -Value 0 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Playback settings: Hide the topmost playing... bar: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'HidePlayWnd' -Value 'False' -PropertyType String -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: General: Move the playback toolbar to the right: On' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PlayRecFormsOnTheRight' -Value 'True' -PropertyType String -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Play / Pause / Resume playback: F8' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PausePlayKey' -Value 119 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort playback: F9' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortPlayKey' -Value 120 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Step-by-step playback: F10' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'StepByStepPlayKey' -Value 121 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Start / Pause / Resume recording: F11' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'RecordKey' -Value 122 -PropertyType DWord -Force

Write-Host 'Settings: Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort recording: F12' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortRecKey' -Value 123 -PropertyType DWord -Force

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

Write-Host 'Settings: Desktop: Microsoft Edge: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'C:\Users\Public\Desktop\Microsoft Edge.lnk') -eq $true) {
	Remove-Item -Path 'C:\Users\Public\Desktop\Microsoft Edge.lnk'
}

Write-Host 'Settings: Desktop: Firefox: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:PUBLIC\Desktop\Firefox.lnk") -eq $true) {
	Remove-Item -Path ("$env:PUBLIC\Desktop\Firefox.lnk")
}

Write-Host 'Settings: Windows Security Notification Icon: Off' -ForegroundColor green -BackgroundColor black
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

Write-Host 'Settings: Boot Options: Standard (default)' -ForegroundColor green -BackgroundColor black
bcdedit /set `{current`} bootmenupolicy standard

# https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit
# This command forces the kernel timer to constantly poll for interrupts instead of wait for them; dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance
bcdedit /set disabledynamictick yes

# Disables the hypervisor which is unneeded on a gaming PC
bcdedit /set hypervisorlaunchtype off

# Disable VBS / HVCI
# https://www.tomshardware.com/how-to/disable-vbs-windows-11
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\DeviceGuard' -Name 'EnableVirtualizationBasedSecurity' -Value 0 -PropertyType DWord -Force

# Process scheduling - 22 = Long, variable, 3x foreground boost (36:12)
New-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 22 -PropertyType DWord -Force

# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/POSTINSTALL/README.md
fsutil behavior set DisableDeleteNotify 0
fsutil behavior set disableLastAccess 1
fsutil behavior set disable8dot3 1

Write-Host 'Settings: svchost.exe: Group (Decrease Process Number)' -ForegroundColor green -BackgroundColor black
$svchostram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $svchostram -Force
Write-Host 'Settings: Settings: Date & time: Time zone: Jerusalem' -ForegroundColor green -BackgroundColor black
Set-TimeZone -Id 'Israel Standard Time'

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

Write-Host 'Settings: Settings: Time & Language: Language: Hebrew Keyboard' -ForegroundColor green -BackgroundColor black
$HebrewUserLanguage = Get-WinUserLanguageList
$HebrewUserLanguage.Add('he-IL')
Set-WinUserLanguageList -LanguageList $HebrewUserLanguage -Force

Write-Host 'Settings: Lock Screen: Setting to black' -ForegroundColor green -BackgroundColor black
# https://github.com/fr33thytweaks/Ultimate-Windows-Optimization-Guide/blob/main/6%20Windows/13%20Signout%20Lockscreen.ps1
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
Write-Host 'Settings: Settings: Personalization: Lock screen: Show lock screen background pictures on the sign-in screen: On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System') -ne $true) {
	New-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'DisableLogonBackgroundImage' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# https://github.com/fr33thytweaks/Ultimate-Windows-Optimization-Guide/blob/main/6%20Windows/10%20Timer%20Resolution.ps1
# https://forums.guru3d.com/threads/windows-timer-resolution-tool-in-form-of-system-service.376458/

# Write-Host 'Settings: Compiling Timer Resolution Service' -ForegroundColor green -BackgroundColor black
# $SetTimerResService = @'
# // comand line for compilation:
# // c:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe SetTimerResolutionService.cs

# using System;
# using System.Runtime.InteropServices;
# using System.ServiceProcess;
# using System.ComponentModel;
# using System.Configuration.Install;
# using System.Collections.Generic;
# using System.Reflection;
# using System.IO;
# using System.Management;
# using System.Threading;
# using System.Diagnostics;

# [assembly: AssemblyVersion("2.1")]
# [assembly: AssemblyProduct("Set Timer Resolution service")]

# namespace WindowsService
# {
#     class WindowsService : ServiceBase
#     {
#         public WindowsService()
#         {
#             this.ServiceName = "STR";
#             this.EventLog.Log = "Application";
            
#             // These Flags set whether or not to handle that specific
#             //  type of event. Set to true if you need it, false otherwise.
#             this.CanStop = true;

#             this.CanHandlePowerEvent = false;
#             this.CanHandleSessionChangeEvent = false;
#             this.CanPauseAndContinue = false;
#             this.CanShutdown = false;
#         }

#         static void Main()
#         {
#             ServiceBase.Run(new WindowsService());
#         }


#         protected override void OnStart(string[] args)
#         {
#             base.OnStart(args);

#             // read processes names from ini-file
#             ReadProcessList();

#             // retrieve timer resolutions
#             NtQueryTimerResolution(out this.MininumResolution, out this.MaximumResolution, out this.DefaultResolution);
#             if(null != this.EventLog)
#                 try { this.EventLog.WriteEntry(String.Format("Minimum={0}; Maximum={1}; Default={2}; Processes='{3}'", this.MininumResolution, this.MaximumResolution, this.DefaultResolution, null != this.ProcessesNames ? String.Join("','", this.ProcessesNames) : "")); }
#                 catch {}

#             if(null == this.ProcessesNames)
#             {
#                 // there is no ini-file, so just set maximum resolution and exit monitoring
#                 SetMaximumResolution();
#                 return;
#             }
#             if(0 == this.ProcessesNames.Count)
#             {
#                 // ini-file is empty, so just exit monitoring
#                 return;
#             }

#             // create delegate for async method execution
#             this.ProcessStartDelegate = new OnProcessStart(this.ProcessStarted);

#             try
#             {
#                 // subscribe for a start of processes
#                 String query = String.Format("SELECT * FROM __InstanceCreationEvent WITHIN 0.5 WHERE (TargetInstance isa \"Win32_Process\") AND (TargetInstance.Name=\"{0}\")", String.Join("\" OR TargetInstance.Name=\"", this.ProcessesNames));
#                 this.startWatch = new ManagementEventWatcher(query);
#                 this.startWatch.EventArrived += this.startWatch_EventArrived;
#                 this.startWatch.Start();
#             }
#             catch(Exception ee)
#             {
#                 if(null != this.EventLog)
#                     try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Error); }
#                     catch {}
#             }
#         }

#         protected override void OnStop()
#         {
#             // stop the event watchers
#             if(null != this.startWatch)
#             {
#                 this.startWatch.Stop();
#             }

#             base.OnStop();
#         }

#         ManagementEventWatcher startWatch;

#         void startWatch_EventArrived(object sender, EventArrivedEventArgs e) 
#         {
#             try
#             {
#                 ManagementBaseObject process = (ManagementBaseObject)e.NewEvent.Properties["TargetInstance"].Value;
#                 UInt32 processId = (UInt32)process.Properties["ProcessId"].Value;
#                 this.ProcessStartDelegate.BeginInvoke(processId, null, null);
#             } 
#             catch(Exception ee) 
#             {
#                 if(null != this.EventLog)
#                     try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
#                     catch {}

#             }
#         }

#         [DllImport("kernel32.dll", SetLastError=true)]
#         static extern Int32 WaitForSingleObject(IntPtr Handle, Int32 Milliseconds);

#         [DllImport("kernel32.dll", SetLastError=true)]
#         static extern IntPtr OpenProcess(UInt32 DesiredAccess, Int32 InheritHandle, UInt32 ProcessId);

#         [DllImport("kernel32.dll", SetLastError=true)]
#         static extern Int32 CloseHandle(IntPtr Handle);

#         const UInt32 SYNCHRONIZE = 0x00100000;

#         delegate void OnProcessStart(UInt32 processId);
#         OnProcessStart ProcessStartDelegate = null;

#         void ProcessStarted(UInt32 processId)
#         {
#             SetMaximumResolution();
#             IntPtr processHandle = IntPtr.Zero;
#             try
#             {
#                 processHandle = OpenProcess(SYNCHRONIZE, 0, processId);
#                 if(processHandle != IntPtr.Zero)
#                     WaitForSingleObject(processHandle, -1);
#             } 
#             catch(Exception ee) 
#             {
#                 if(null != this.EventLog)
#                     try { this.EventLog.WriteEntry(ee.ToString(), EventLogEntryType.Warning); }
#                     catch {}
#             }
#             finally
#             {
#                 if(processHandle != IntPtr.Zero)
#                     CloseHandle(processHandle); 
#             }
#             SetDefaultResolution();
#         }

#         List<String> ProcessesNames = null;

#         void ReadProcessList()
#         {
#             String iniFilePath = Assembly.GetExecutingAssembly().Location + ".ini";
#             if(File.Exists(iniFilePath))
#             {
#                 this.ProcessesNames = new List<String>();
#                 String[] iniFileLines = File.ReadAllLines(iniFilePath);
#                 foreach(var line in iniFileLines)
#                 {
#                     String[] names = line.Split(new char[] {',', ' ', ';'} , StringSplitOptions.RemoveEmptyEntries);
#                     foreach(var name in names)
#                     {
#                         String lwr_name = name.ToLower();
#                         if(!lwr_name.EndsWith(".exe"))
#                             lwr_name += ".exe";
#                         if(!this.ProcessesNames.Contains(lwr_name))
#                             this.ProcessesNames.Add(lwr_name);
#                     }
#                 }
#             }
#         }


#         [DllImport("ntdll.dll", SetLastError=true)]
#         static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, out uint CurrentResolution);

#         [DllImport("ntdll.dll", SetLastError=true)]
#         static extern int NtQueryTimerResolution(out uint MinimumResolution, out uint MaximumResolution, out uint ActualResolution);

#         uint DefaultResolution = 0;
#         uint MininumResolution = 0;
#         uint MaximumResolution = 0;

#         long processCounter = 0;

#         void SetMaximumResolution()
#         {
#             long counter = Interlocked.Increment(ref this.processCounter);
#             if(counter <= 1)
#             {
#                 uint actual = 0;
#                 NtSetTimerResolution(this.MaximumResolution, true, out actual);
#                 if(null != this.EventLog)
#                     try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
#                     catch {}
#             }
#         }

#         void SetDefaultResolution()
#         {
#             long counter = Interlocked.Decrement(ref this.processCounter);
#             if(counter < 1)
#             {
#                 uint actual = 0;
#                 NtSetTimerResolution(this.DefaultResolution, true, out actual);
#                 if(null != this.EventLog)
#                     try { this.EventLog.WriteEntry(String.Format("Actual resolution = {0}", actual)); }
#                     catch {}
#             }
#         }
#     }

#     [RunInstaller(true)]
#     public class WindowsServiceInstaller : Installer
#     {
#         /// <summary>
#         /// Public Constructor for WindowsServiceInstaller.
#         /// - Put all of your Initialization code here.
#         /// </summary>
#         public WindowsServiceInstaller()
#         {
#             ServiceProcessInstaller serviceProcessInstaller = 
#                                new ServiceProcessInstaller();
#             ServiceInstaller serviceInstaller = new ServiceInstaller();

#             //# Service Account Information
#             serviceProcessInstaller.Account = ServiceAccount.LocalSystem;
#             serviceProcessInstaller.Username = null;
#             serviceProcessInstaller.Password = null;

#             //# Service Information
#             serviceInstaller.DisplayName = "Set Timer Resolution Service";
#             serviceInstaller.StartType = ServiceStartMode.Automatic;

#             //# This must be identical to the WindowsService.ServiceBase name
#             //# set in the constructor of WindowsService.cs
#             serviceInstaller.ServiceName = "STR";

#             this.Installers.Add(serviceProcessInstaller);
#             this.Installers.Add(serviceInstaller);
#         }
#     }

# }
# '@
# Set-Content -Path "$env:C:\Windows\SetTimerResolutionService.cs" -Value $SetTimerResService -Force
# Start-Process -Wait 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe' -ArgumentList '-out:C:\Windows\SetTimerResolutionService.exe C:\Windows\SetTimerResolutionService.cs' -WindowStyle Hidden
# Remove-Item "$env:C:\Windows\SetTimerResolutionService.cs"
# Write-Host 'Settings: Starting Timer Resolution Service' -ForegroundColor green -BackgroundColor black
# New-Service -Name 'Set Timer Resolution Service' -BinaryPathName "$env:C:\Windows\SetTimerResolutionService.exe"
# Set-Service -Name 'Set Timer Resolution Service' -StartupType Auto
# Set-Service -Name 'Set Timer Resolution Service' -Status Running
# if ((Test-Path -LiteralPath 'HKLM:\System\ControlSet001\Control\Session Manager\kernel') -ne $true) {
# 	New-Item 'HKLM:\System\ControlSet001\Control\Session Manager\kernel' -Force
# }
# New-ItemProperty -LiteralPath 'HKLM:\System\ControlSet001\Control\Session Manager\kernel' -Name 'GlobalTimerResolutionRequests' -Value 1 -PropertyType DWord -Force

# Sohpia Script
# Last updated 23/05/2024
# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Sophia.ps1
# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Module/Sophia.psm1
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
Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Force
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
# FileExplorerRibbon -Expanded
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force
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
# TaskViewButton -Hide
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force
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
$Taskmgr = Get-Process -Name Taskmgr
if ($Taskmgr) {
	$Taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe
do {
	$Preferences = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences
}
until ($Preferences)
Stop-Process -Name Taskmgr
$Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
# ShortcutsSuffix -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -PropertyType String -Value '%s.lnk' -Force
# PrtScnSnippingTool -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 0 -Force
# AppsLanguageSwitch -Disable
Set-WinLanguageBarOption
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
Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Force
# StorageSense -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 0 -Force
# StorageSenseTempFiles -Enable
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq '1') {
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
}
# StorageSenseFrequency -Month
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq '1') {
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
}
# Hibernation -Disable
POWERCFG /HIBERNATE OFF
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
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{B7BEDE81-DF94-4682-A7D8-57A52620B86F}' -Force
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
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout' -Name 'Scancode Map' -Force
# StickyShift -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name Flags -PropertyType String -Value 506 -Force
# Autoplay -Disable
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force
# ThumbnailCacheRemoval -Enable
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name Autorun -PropertyType DWord -Value 3 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name Autorun -PropertyType DWord -Value 3 -Force
# SaveRestartableApps -Disable
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name RestartApps -PropertyType DWord -Value 0 -Force
# RestartNotification -Show
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
# RestartDeviceAfterUpdate -Enable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name IsExpedited -PropertyType DWord -Value 1 -Force
# ActiveHours -Manually
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 0 -Force
# InstallVCRedist
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/VC_redist.x86.exe', "$env:TEMP\VC_redist.x86.exe")
Start-Process -FilePath "$env:TEMP\VC_redist.x86.exe" -ArgumentList '/install /passive /norestart'
(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/VC_redist.x64.exe', "$env:TEMP\VC_redist.x64.exe")
Start-Process -FilePath "$env:TEMP\VC_redist.x64.exe" -ArgumentList '/install /passive /norestart'
# InstallDotNetRuntimes -Runtimes NET6x64, NET8x64
$NET6LatestRelease = (Invoke-RestMethod -UseBasicParsing -Uri https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json).'latest-release'
(New-Object System.Net.WebClient).DownloadFile("https://dotnetcli.azureedge.net/dotnet/Runtime/$NET6LatestRelease/dotnet-runtime-$NET6LatestRelease-win-x64.exe", "$env:TEMP\dotnet-runtime-$NET6LatestRelease-win-x64.exe")
Start-Process -FilePath "$env:TEMP\dotnet-runtime-$NET6LatestRelease-win-x64.exe" -ArgumentList '/install /passive /norestart'
$NET8LatestRelease = (Invoke-RestMethod -UseBasicParsing -Uri https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/8.0/releases.json).'latest-release'
(New-Object System.Net.WebClient).DownloadFile("https://dotnetcli.azureedge.net/dotnet/Runtime/$NET8LatestRelease/dotnet-runtime-$NET8LatestRelease-win-x64.exe", "$env:TEMP\dotnet-runtime-$NET8LatestRelease-win-x64.exe")
Start-Process -FilePath "$env:TEMP\dotnet-runtime-$NET8LatestRelease-win-x64.exe" -ArgumentList '/install /passive /norestart'
# RKNBypass -Disable
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name AutoConfigURL -Force
# PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary
if (Get-Package -Name 'Microsoft Edge' -ProviderName Programs) {
	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' -PropertyType DWord -Value 0 -Force
}
if (Get-Package -Name 'Microsoft Edge Beta' -ProviderName Programs) {
	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}' -PropertyType DWord -Value 0 -Force
}
if (Get-Package -Name 'Microsoft Edge Dev' -ProviderName Programs) {
	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}' -PropertyType DWord -Value 0 -Force
}
if (Get-Package -Name 'Microsoft Edge Canary' -ProviderName Programs) {
	if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate)) {
		New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name 'CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}' -PropertyType DWord -Value 0 -Force
}
# SATADrivesRemovableMedia -Disable
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device -Name TreatAsInternalPort -Type MultiString -Value @(0, 1, 2, 3, 4, 5) -Force
# RegistryBackup -Disable
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager' -Name EnablePeriodicBackup -Force
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
Stop-Process -Name StartMenuExperienceHost -Force
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
$wshell = New-Object -ComObject WScript.Shell
$wshell.SendKeys('^{ESC}')
Start-Sleep -Seconds 3
# Enable changing the Start menu layout
Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force
Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force
Remove-Item -Path $Script:StartLayout -Force
Stop-Process -Name StartMenuExperienceHost -Force
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
Set-MpPreference -EnableNetworkProtection Disabled
# PUAppsDetection -Disable
Set-MpPreference -PUAProtection Disabled
# DefenderSandbox -Disable
setx /M MP_FORCE_USE_SANDBOX 0
# DismissMSAccount
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
# DismissSmartScreenFilter
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
# CommandLineProcessAudit -Disable
Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Force
# EventViewerCustomView -Disable
Remove-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Force
# # PowerShellModulesLogging -Disable
Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Force
Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -Force
# PowerShellScriptsLogging -Disable
Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Force
# AppsSmartScreen -Disable
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force
# SaveZoneInformation -Disable
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments)) {
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
# WindowsScriptHost -Enable
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name Enabled -Force
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
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Recurse -Force
# CABInstallContext -Hide
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas -Recurse -Force
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
if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.MSPaint*').State -eq 'Installed') {
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force
}
# RichTextDocumentNewContext -Hide
if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad*').State -eq 'Installed') {
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force
}
# CompressedFolderNewContext -Hide
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force
# MultipleInvokeContext -Disable
Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -Force

# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/PSDSC/GamingMinimal.ps1
# DisableWidgets 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' -Name AllowNewsAndInterests -PropertyType DWord -Value 0 -Force
# DisableMouseTouchFeedback1 

Write-Host 'Network: IPv4: MTU: 1500' -ForegroundColor green -BackgroundColor black
$AdapterName = $(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).Name
netsh interface ipv4 set subinterface "$AdapterName" mtu=1500 store=persistent

Write-Host 'Network: IPv6: MTU: 1500' -ForegroundColor green -BackgroundColor black
netsh interface ipv6 set subinterface "$AdapterName" mtu=1500 store=persistent

Write-Host 'Network: Congestion Provider: None' -ForegroundColor green -BackgroundColor black
netsh int tcp set supplemental internet congestionprovider=None

Write-Host 'Network: DCA: Disabled' -ForegroundColor green -BackgroundColor black
netsh int tcp set global dca=Disabled

Write-Host 'Network: Teredo: Disabled' -ForegroundColor green -BackgroundColor black
netsh interface teredo set state disabled
$NetworkSettingsName = Get-NetAdapterAdvancedProperty | Select-Object -Property 'DisplayName'

if ($NetworkSettingsName -match 'ARP Offload') {
	Write-Host 'Network: ARP Offload: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'ARP Offload' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Adaptive Inter-Frame Spacing') {
	Write-Host 'Network: Adaptive Inter-Frame Spacing: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Adaptive Inter-Frame Spacing' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'DMA Coalescing') {
	Write-Host 'Network: DMA Coalescing: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'DMA Coalescing' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'ECMA') {
	Write-Host 'Network: ECMA: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'ECMA' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Energy Efficient Ethernet') {
	Write-Host 'Network: Energy Efficient Ethernet: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Energy Efficient Ethernet') {
	Write-Host 'Network: Energy Efficient Ethernet: Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Off'
}

if ($NetworkSettingsName -match 'Flow Control') {
	Write-Host 'Network: Flow Control: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Flow Control' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Gigabit Master Slave Mode') {
	Write-Host 'Network: Gigabit Master Slave Mode: Auto Detect' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Gigabit Master Slave Mode' -DisplayValue 'Auto Detect'
}

if ($NetworkSettingsName -match 'IPv4 Checksum Offload') {
	Write-Host 'Network: IPv4 Checksum Offload: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'IPv4 Checksum Offload' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Interrupt Moderation Rate') {
	Write-Host 'Network: Interrupt Moderation Rate: Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Interrupt Moderation Rate' -DisplayValue 'Off'
}

if ($NetworkSettingsName -match 'Interrupt Moderation') {
	Write-Host 'Network: Interrupt Moderation: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Jumbo Frame') {
	Write-Host 'Network: Jumbo Frame: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Frame' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Jumbo Packet') {
	Write-Host 'Network: Jumbo Packet: 1514' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Packet' -DisplayValue '1514'
}

if ($NetworkSettingsName -match 'Jumbo Packet') {
	Write-Host 'Network: Jumbo Packet: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Packet' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Large Send Offload (IPv4)') {
	Write-Host 'Network: Large Send Offload (IPv4): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload (IPv4)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Large Send Offload v2 (IPv4)') {
	Write-Host 'Network: Large Send Offload v2 (IPv4): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload v2 (IPv4)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Large Send Offload v2 (IPv6)') {
	Write-Host 'Network: Large Send Offload v2 (IPv6): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload v2 (IPv6)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Legacy Switch Compatibility Mode') {
	Write-Host 'Network: Legacy Switch Compatibility Mode: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Legacy Switch Compatibility Mode' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Log Link State Event') {
	Write-Host 'Network: Log Link State Event: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Log Link State Event' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Max IRQ per Second') {
	Write-Host 'Network: Max IRQ per Second: 30000' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Max IRQ per Second' -DisplayValue '30000'
}

if ($NetworkSettingsName -match 'Maximum Number of RSS Queues') {
	Write-Host 'Network: Maximum Number of RSS Queues: 1 Queue' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Maximum Number of RSS Queues' -DisplayValue '1 Queue'
}

if ($NetworkSettingsName -match 'NS Offload') {
	Write-Host 'Network: NS Offload: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'NS Offload' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'PTP Hardware Timestamp') {
	Write-Host 'Network: PTP Hardware Timestamp: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'PTP Hardware Timestamp' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Packet Priority & VLAN') {
	Write-Host 'Network: Packet Priority & VLAN: Packet Priority & VLAN Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Packet Priority & VLAN' -DisplayValue 'Packet Priority & VLAN Disabled'
}

if ($NetworkSettingsName -match 'Protocol ARP Offload') {
	Write-Host 'Network: Protocol ARP Offload: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Protocol ARP Offload' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Protocol NS Offload') {
	Write-Host 'Network: Protocol NS Offload: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Protocol NS Offload' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Receive Buffers') {
	Write-Host 'Network: Receive Buffers: 2048' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Receive Buffers' -DisplayValue '2048'
}

if ($NetworkSettingsName -match 'Receive Side Scaling') {
	Write-Host 'Network: Receive Side Scaling: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Receive Side Scaling' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Reduce Speed On Power Down') {
	Write-Host 'Network: Reduce Speed On Power Down: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Reduce Speed On Power Down' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'SWOI') {
	Write-Host 'Network: SWOI: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'SWOI' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Selective Suspend Idle Timeout') {
	Write-Host 'Network: Selective Suspend Idle Timeout: 5' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Selective Suspend Idle Timeout' -DisplayValue '5'
}

if ($NetworkSettingsName -match 'Selective Suspend') {
	Write-Host 'Network: Selective Suspend: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Selective Suspend' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Software Timestamp') {
	Write-Host 'Network: Software Timestamp: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Software Timestamp' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Speed & Duplex') {
	Write-Host 'Network: Speed & Duplex: 1.0 Gbps Full Duplex' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Speed & Duplex' -DisplayValue '1.0 Gbps Full Duplex'
}

if ($NetworkSettingsName -match 'System Idle Power Saver') {
	Write-Host 'Network: System Idle Power Saver: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'System Idle Power Saver' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'TCP Checksum Offload (IPv4)') {
	Write-Host 'Network: TCP Checksum Offload (IPv4): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'TCP Checksum Offload (IPv6)') {
	Write-Host 'Network: TCP Checksum Offload (IPv6): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'TCP Checksum Offload (IPv6)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Transmit Buffers') {
	Write-Host 'Network: Transmit Buffers: 1024' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Transmit Buffers' -DisplayValue '1024'
}

if ($NetworkSettingsName -match 'Transmit Buffers') {
	Write-Host 'Network: Transmit Buffers: 2048' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Transmit Buffers' -DisplayValue '2048'
}

if ($NetworkSettingsName -match 'UDP Checksum Offload (IPv4)') {
	Write-Host 'Network: UDP Checksum Offload (IPv4): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'UDP Checksum Offload (IPv6)') {
	Write-Host 'Network: UDP Checksum Offload (IPv6): Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'UDP Checksum Offload (IPv6)' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Ultra Low Power Mode') {
	Write-Host 'Network: Ultra Low Power Mode: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Ultra Low Power Mode' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Wait for Link') {
	Write-Host 'Network: Wait for Link: Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wait for Link' -DisplayValue 'Off'
}

if ($NetworkSettingsName -match 'Wake from S0ix on Magic Packet') {
	Write-Host 'Network: Wake from S0ix on Magic Packet: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake from S0ix on Magic Packet' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Wake on Link Settings') {
	Write-Host 'Network: Wake on Link Settings: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake on Link Settings' -DisplayValue 'Disabled'
}

if ($NetworkSettingsName -match 'Wake on Pattern Match') {
	Write-Host 'Network: Wake on Pattern Match: Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake on Pattern Match' -DisplayValue 'Disabled'
}

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
netsh int tcp set global chimney=disabled 

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

Write-Host 'Network: TcpAckFrequency: Disabled' -ForegroundColor green -BackgroundColor black
$NetworkGUID = (Get-NetAdapter).InterfaceGUID
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force

Write-Host 'Network: TcpDelAckTicks: Disabled' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force

Write-Host 'Network: TCPNoDelay: Enabled' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force

# https://www.thewindowsclub.com/disable-netbios-and-llmnr-protocols-via-gpo
Write-Host 'Network: NetBIOS: Disabling' -ForegroundColor green -BackgroundColor black
$NetBiosRegistry = 'HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces'
Get-ChildItem $NetBiosRegistry | ForEach-Object { Set-ItemProperty -Path "$NetBiosRegistry\$($_.pschildname)" -Name NetbiosOptions -Value 2 }

# NetworkDiscovery -Enable
# Changed it abit
Set-NetConnectionProfile -NetworkCategory Private
Set-NetFirewallRule -Group '@FirewallAPI.dll,-28502', '@FirewallAPI.dll,-32752' -Profile Private -Enabled True

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