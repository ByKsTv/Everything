# Power Plan: Restore default schemes
powercfg.exe /restoredefaultschemes
$PowerPlanUltimate = powercfg.exe -list | Select-String -Pattern 'Ultimate Performance'
$PowerPlanHigh = powercfg.exe -list | Select-String -Pattern 'High performance'
if ($PowerPlanUltimate) {
	$PowerPlanGUID = ($PowerPlanUltimate.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	powercfg.exe /setactive $PowerPlanGUID
}
elseif ($PowerPlanHigh) {
	$PowerPlanGUID = ($PowerPlanHigh.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	powercfg.exe /setactive $PowerPlanGUID
}

# Disable hibernation
powercfg.exe /HIBERNATE OFF

# Power Plan: Showing all hidden options
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'CSEnabled' -Value 0 -Force
$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$'
foreach ($item in $PowerCfg) {
	Set-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE', 'HKLM:') -Name 'Attributes' -Value 2 -Force 
}

# Power Plan: Require a password on wakeup: No
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0

# Power Plan: Power plan type: High performance
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1

# Power Plan: Device idle policy: High performance
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0

# Power Plan: Disconnected Standby Mode: Normal
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 68afb2d9-ee95-47a8-8f50-4115088073b1 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 68afb2d9-ee95-47a8-8f50-4115088073b1 0

# Power Plan: Networking connectivity in Standby: Enable
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1
 
# Power Plan: Hard disk: AHCI Link Power Management - HIPM/DIPM: Active
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0

# Power Plan: Hard disk: Maximum Power Level: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 51dea550-bb38-4bc4-991b-eacf37be5ec8 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 51dea550-bb38-4bc4-991b-eacf37be5ec8 100

# Power Plan: Hard disk: Turn off hard disk after: 0 Seconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0

# Power Plan: Hard disk: Hard disk burst ignore time: 0 Minutes
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 0

# Power Plan: Hard disk: Secondary NVMe Idle Timeout: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0

# Power Plan: Hard disk: Primary NVMe Idle Timeout: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0

# Power Plan: Hard disk: AHCI Link Power Management - Adaptive: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0

#Power Plan: Hard disk: Secondary NVMe Power State Transition Latency Tolerance: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dbc9e238-6de9-49e3-92cd-8c2b4946b472 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dbc9e238-6de9-49e3-92cd-8c2b4946b472 0

# Power Plan: Hard disk: NVMe NOPPME: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0

# Power Plan: Hard disk: Primary NVMe Power State Transition Latency Tolerance: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 0

# Power Plan: Internet Explorer mode: JavaScript Timer Frequency: Maximum Performance
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1

# Power Plan: Desktop background settings: Slide show: Paused
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1

# Power Plan: Wireless Adapter Settings: Power Saving Mode: Maximum Performance
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0

#Power Plan: Sleep: Legacy RTC mitigations: Disable
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 1a34bdc3-7e6b-442e-a9d0-64b6ef378e84 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 1a34bdc3-7e6b-442e-a9d0-64b6ef378e84 0

# Power Plan: Sleep: Allow Away Mode Policy: Yes
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1

# Power Plan: Sleep: Sleep after: 0 Minutes (Never)
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

# Power Plan: System unattended sleep timeout: 0 Seconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0

# Power Plan: Sleep: Allow hybrid sleep: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

# Power Plan: Sleep: Hibernate after: 0 Seconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0

# Power Plan: Sleep: Allow system required policy: Yes
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 a4b195f5-8225-47d8-8012-9d41369786e2 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 a4b195f5-8225-47d8-8012-9d41369786e2 1

# Power Plan: Sleep: Allow Standby States: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0

# Power Plan: Sleep: Allow wake timers: Important Wake Timers Only
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 2

# Power Plan: Sleep: Allow sleep with remote opens: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d 0

# Power Plan: USB settings: Hub Selective Suspend Timeout: 0 Millisecond
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0

# Power Plan: USB settings: USB selective suspend setting: Disabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# Power Plan: USB settings: Setting IOC on all TDs: Enabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1

# Power Plan: USB settings: USB 3 Link Power Mangement: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0

# Power Plan: Idle Resiliency: Execution Required power request timeout: 4294967295 Seconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 4294967295
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 4294967295

# Power Plan: Idle Resiliency: IO coalescing timeout: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c36f0eb4-2988-4a70-8eee-0884fc2c2433 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c36f0eb4-2988-4a70-8eee-0884fc2c2433 0

# Power Plan: Idle Resiliency: Processor Idle Resiliency Timer Resolution: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c42b79aa-aa3a-484b-a98f-2cf32aa90a28 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c42b79aa-aa3a-484b-a98f-2cf32aa90a28 0

# Power Plan: Idle Resiliency: Deep Sleep Enabled/Disabled: Deep Sleep Disabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0

# Power Plan: Interrupt Steering Settings: Interrupt Steering Mode: Any unparked processor
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3

# Power Plan: Interrupt Steering Settings: Target Load: 10 Tenths of a percent
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 73cde64d-d720-4bb2-a860-c755afe77ef2 10
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 73cde64d-d720-4bb2-a860-c755afe77ef2 10

# Power Plan: Interrupt Steering Settings: Unparked time trigger: 0 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0

# Power Plan: Power buttons and lid: Lid close action: Do nothing
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

# Power Plan: Power buttons and lid: Power button action: Shutdown
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

# Power Plan: Power buttons and lid: Enable forced button/lid shutdown: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 833a6b62-dfa4-46d1-82f8-e09e34d029d6 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 833a6b62-dfa4-46d1-82f8-e09e34d029d6 0

# Power Plan: Power buttons and lid: Sleep button action: Do nothing
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0

# Power Plan: Power buttons and lid: Lid open action: Do nothing
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 0

# Power Plan: Power buttons and lid: Start menu power button: Shut down
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2

# Power Plan: PCI Express: Link State Power Management: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0

# Power Plan: Processor power management: Processor performance increase threshold: 1%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1

# Power Plan: Processor power management: Processor performance increase threshold for Processor Power Efficiency Class 1: 1%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1

# Power Plan: Processor power management: Processor performance core parking min cores: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100

# Power Plan: Processor power management: Processor performance core parking min cores for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100

# Power Plan: Processor power management: Processor performance decrease threshold: 1%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1

# Power Plan: Processor power management: Processor performance decrease threshold for Processor Power Efficiency Class 1: 1%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1

# Power Plan: Processor power management: Initial performance for Processor Power Efficiency Class 1 when unparked: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100

# Power Plan: Processor power management: Processor performance core parking concurrency threshold: 10%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 10
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 10

# Power Plan: Processor power management: Processor performance core parking increase time: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1

# Power Plan: Processor power management: Processor energy performance preference policy: 0%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0

# Power Plan: Processor power management: Processor energy performance preference policy for Processor Power Efficiency Class 1: 0%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0

# Power Plan: Processor power management: Allow Throttle States: Off
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0

# Power Plan: Processor power management: Processor performance increase time for Processor Power Efficiency Class 1: 1 Tme check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4009efa7-e72d-4cba-9edf-91084ea8cbc3 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4009efa7-e72d-4cba-9edf-91084ea8cbc3 1

# Power Plan: Processor power management: Processor performance decrease policy: Single
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1

# Power Plan: Processor power management: Processor performance decrease policy for Processor Power Efficiency Class 1: Single
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1

# Power Plan: Processor power management: Processor performance core parking parked performance state: Lightest Performance State
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2

# Power Plan: Processor power management: Processor performance core parking parked performance state for Processor Power Efficiency Class 1: Lightest Performance State
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2

# Power Plan: Processor power management: Processor performance boost policy: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 45bcc044-d885-43e2-8605-ee0ec6e96b59 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 45bcc044-d885-43e2-8605-ee0ec6e96b59 100

# Power Plan: Processor power management: Processor performance increase policy: Rocket
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2

# Power Plan: Processor power management: Processor performance increase policy for Processor Power Efficiency Class 1: Rocket
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2

# Power Plan: Processor power management: Processor idle demote threshold: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100

# Power Plan: Processor power management: Processor performance core parking distribution threshold: 10% 
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 10
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 10

# Power Plan: Processor power management: Processor performance time check interval: 15 Milliseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 15
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 15

# Power Plan: Processor power management: Processor duty cycling: Disabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4e4450b3-6179-4e91-b8f1-5bb9938f81a1 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4e4450b3-6179-4e91-b8f1-5bb9938f81a1 0

# Power Plan: Processor power management: Processor idle disable: Enable Idle
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0

# Power Plan: Processor power management: Latency sensitivity hint min unparked cores/packages: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100

# Power Plan: Processor power management: Latency sensitivity hint min unparked cores/packages for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100

# Power Plan: Processor power management: Latency sensitivity hint processor performance: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100

# Power Plan: Processor power management: Latency sensitivity hint processor performance for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100

# Power Plan: Processor power management: Processor idle threshold scaling: Disable scaling
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 0

# Power Plan: Processor power management: Processor performance core parking decrease policy: Single core
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1

# Power Plan: Processor power management: Maximum processor frequency: 0 MHz
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0

# Power Plan: Processor power management: Maximum processor frequency for Processor Power Efficiency Class 1: 0 MHz
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e101 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e101 0

# Power Plan: Processor power management: Processor idle promote threshold: 0%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 0

# Power Plan: Processor power management: Processor performance history count: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f5f 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f5f 1

# Power Plan: Processor power management: Processor performance history count for Processor Power Efficiency Class 1: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f60 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f60 1

# Power Plan: Processor power management: Processor performance decrease time for Processor Power Efficiency Class 1: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1

# Power Plan: Processor power management: Heterogeneous policy in effect: Use heterogeneous policy 4
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 4
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 4

# Power Plan: Processor power management: Minimum processor state: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100

# Power Plan: Processor power management: Minimum processor state for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100

# Power Plan: Processor power management: Processor performance autonomous mode: Disabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0

# Power Plan: Processor power management: Heterogeneous thread scheduling policy: Performant processors
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 1

# Power Plan: Processor power management: Processor performance core parking overutilization threshold: 90%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 90
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 90

# Power Plan: Processor power management: System cooling policy: Active
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1

# Power Plan: Processor power management: Processor performance core parking soft park latency: 0 Microseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 97cfac41-2217-47eb-992d-618b1977c907 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 97cfac41-2217-47eb-992d-618b1977c907 0

# Power Plan: Processor power management: Processor performance increase time: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5aa 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5aa 1

# Power Plan: Processor power management: Processor performance increase time for Processor Power Efficiency Class 1: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5ab 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5ab 1

# Power Plan: Processor power management: Processor idle state maximum: 0
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 9943e905-9a30-4ec1-9b99-44dd3b76f7a2 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 9943e905-9a30-4ec1-9b99-44dd3b76f7a2 0

# Power Plan: Processor power management: Processor performance level increase threshold for Processor Power Efficiency Class 1 processor count increase: 
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b000397d-9b0b-483d-98c9-692a6060cfbf 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b000397d-9b0b-483d-98c9-692a6060cfbf 0

# Power Plan: Processor power management: Heterogeneous short running thread scheduling policy: Performant processors
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 1

# Power Plan: Processor power management: Maximum processor state: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100

# Power Plan: Processor power management: Maximum processor state for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ed 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ed 100

# Power Plan: Processor power management: Processor performance boost mode: Aggresive
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2

# Power Plan: Processor power management: Processor idle time check: 10000 Microseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 10000
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 10000

# Power Plan: Processor power management: Processor performance core parking increase policy: Single core
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 1

# Power Plan: Processor power management: Processor autonomous activity window: 10000 Microseconds
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 10000
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 10000

# Power Plan: Processor power management: Processor performance decrease time: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c8 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c8 1

# Power Plan: Processor power management: Processor performance decrease time for Processor Power Efficiency Class 1: 1 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1

# Power Plan: Processor power management: Processor performance core parking decrease time: 20 Time check intervals
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 20
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 20

# Power Plan: Processor power management: Processor performance core parking utility distribution: Enabled
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 e0007330-f589-42ed-a401-5ddb10e785d3 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 e0007330-f589-42ed-a401-5ddb10e785d3 1

# Power Plan: Processor power management: Processor performance core parking max cores: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100

# Power Plan: Processor power management: Processor performance core parking max cores for Processor Power Efficiency Class 1: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334029 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334029 100

# Power Plan: Processor power management: Processor performance core parking concurrency headroom threshold: 10%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 10
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 10

# Power Plan: Processor power management: Processor performance level decrease threshold for Processor Power Efficiency Class 1 processor count decrease: 0
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f8861c27-95e7-475c-865b-13c0cb3f9d6b 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f8861c27-95e7-475c-865b-13c0cb3f9d6b 0

# Power Plan: Processor power management: A floor performance for Processor Power Efficiency Class 0 when there are Processor Power Efficiency Class 1 processors unparked: 100%
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 fddc842b-8364-4edc-94cf-c17f60de1c80 100
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 fddc842b-8364-4edc-94cf-c17f60de1c80 100

# Power Plan: Graphics settings: GPU preference policy: None
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 0

# Write-Host 'Power Plan: Display: Dim display after: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

Write-Host 'Power Plan: Display: Turn off display after: 0 Seconds (Never)' -ForegroundColor green -BackgroundColor black
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

Write-Host 'Power Plan: Display: Advanced Color quality bias: Advanced Color visual quality bias' -ForegroundColor green -BackgroundColor black
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 684c3e69-a4f7-4014-8754-d45179a56167 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 684c3e69-a4f7-4014-8754-d45179a56167 1

# Write-Host 'Power Plan: Display: Console lock display off timeout: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 8ec4b3a5-6868-48c2-be75-4f3044be88a7 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 8ec4b3a5-6868-48c2-be75-4f3044be88a7 0

# Write-Host 'Power Plan: Display: Adaptive display: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 90959d22-d6a1-49b9-af93-bce885ad335b 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 90959d22-d6a1-49b9-af93-bce885ad335b 0

# Write-Host 'Power Plan: Display: Allow display required policy: No=0/Yes=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0

# Write-Host 'Power Plan: Display: Display brightness: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0

# Write-Host 'Power Plan: Display: Dimmed display brightness: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0

# Write-Host 'Power Plan: Display: Enable adaptive brightness: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reserve Time: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 468fe7e5-1158-46ec-88bc-5b96c9e44fd0 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 468fe7e5-1158-46ec-88bc-5b96c9e44fd0 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reset Percentage: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 49cb11a5-56e2-4afb-9d38-3df47872e21b 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 49cb11a5-56e2-4afb-9d38-3df47872e21b 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Non-sensor Input Presence Timeout: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 5adbbfbc-074e-4da1-ba38-db8b36b2c8f3 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 5adbbfbc-074e-4da1-ba38-db8b36b2c8f3 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Budget Grace Period: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 60c07fe1-0556-45cf-9903-d56e32210242 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 60c07fe1-0556-45cf-9903-d56e32210242 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: User Presence Prediction mode: Disabled=0/Enabled=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 82011705-fb95-4d46-8d35-4042b1d20def 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 82011705-fb95-4d46-8d35-4042b1d20def 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Budget Percent: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 9fe527be-1b70-48da-930d-7bcf17b44990 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 9fe527be-1b70-48da-930d-7bcf17b44990 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reserve Grace Period: 0 Seconds' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 c763ee92-71e8-4127-84eb-f6ed043a3e3d 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 c763ee92-71e8-4127-84eb-f6ed043a3e3d 0

# Write-Host 'Power Plan: Multimedia settings: When sharing media: Allow the computer to sleep=0/Prevent idling to sleep=1/Allow the computer to enter Away Mode=2' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 0

Write-Host 'Power Plan: Multimedia settings: Video playback quality bias: Video playback performance bias' -ForegroundColor green -BackgroundColor black
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1

Write-Host 'Power Plan: Multimedia settings: When playing video: Optimize video quality' -ForegroundColor green -BackgroundColor black
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0

# Write-Host 'Power Plan: Energy Saver settings: Display brightness weight: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0

# Write-Host 'Power Plan: Energy Saver settings: Energy Saver Policy: 0=User/Aggresive=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 5c5bb349-ad29-4ee2-9d0b-2b25270f7a81 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 5c5bb349-ad29-4ee2-9d0b-2b25270f7a81 0

# Write-Host 'Power Plan: Energy Saver settings: Charge level: 0 Percent battery charge' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0

# Write-Host 'Power Plan: Battery: Critical battery notification: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0

# Write-Host 'Power Plan: Battery: Critical battery action: DoNothing=0/Sleep=1/Hibernate=2/Shutdown=3' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0

# Write-Host 'Power Plan: Battery: Low battery level: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0

# Write-Host 'Power Plan: Battery: Critical battery level: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0

# Write-Host 'Power Plan: Battery: Low battery notification: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0

# Write-Host 'Power Plan: Battery: Low battery action: DoNothing=0/Sleep=1/Hibernate=2/Shutdown=3' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 0

# Write-Host 'Power Plan: Battery: Reserve battery level: 0%' -ForegroundColor green -BackgroundColor black
# powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0
# powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0

# Settings: System: Multitasking: Snap windows: When I snap a window, suggest what I can snap next to it: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SnapAssist' -PropertyType DWord -Value 0 -Force

# Folder Options: Open File Explorer to: This PC
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Colors: Transparency effects: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Colors: Choose your mode: Dark
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommended files in Start, recent files in File Explorer, and items in Jump Lists: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show account-related notifications: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Search: Hide
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0 -Force

# Settings: Time & language: Typing: Autocorrect misspelled words: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableAutocorrection' -PropertyType DWord -Value 0 -Force

# Settings: Time & language: Typing: Highlight misspelled words: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableSpellchecking' -PropertyType DWord -Value 0 -Force

# Settings: Accessibility: Keyboard: Use the Print screen key to open screen capture: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'PrintScreenKeyForSnippingEnabled' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let Windows improve Start and search results by tracking app launches: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let websites show me locally relevant content by accessing my language list: Off
New-ItemProperty -Path 'HKCU:\Control Panel\International\User Profile' -Name 'HttpAcceptLanguageOptOut' -PropertyType DWord -Value 1 -Force

# Settings: Privacy & security: Search permissions: SafeSearch: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'SafeSearchMode' -PropertyType DWord -Value 0 -Force

# Settings: Windows Update: Advanced options: Get me up to date: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsExpedited' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Notify me when a restart is required to finish updating: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'RestartNotificationsAllowed2' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Taskbar: Taskbar items: Task view: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force

# Settings: Privacy & security: Search permissions: History: Search history on this device: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show recently used files: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show frequently used folders: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -PropertyType DWord -Value 0 -Force

# Add username to autologon
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

# Sound: Communications: Do nothing
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -PropertyType DWord -Value 3 -Force

# Lock Screen: Black image
takeown.exe /f "$env:windir\Web\Screen" /r /d y
icacls.exe "$env:windir\Web\Screen" /GRANT Everyone:F, Users:F /t
$LockScreenImages = @(
	@{file = 'img100.jpg'; width = 3840; height = 2160 },
	@{file = 'img101.jpg'; width = 3840; height = 2400 },
	@{file = 'img101.png'; width = 3840; height = 2400 },
	@{file = 'img102.jpg'; width = 6400; height = 4000 },
	@{file = 'img103.jpg'; width = 3839; height = 2400 },
	@{file = 'img103.png'; width = 3839; height = 2400 },
	@{file = 'img104.jpg'; width = 3840; height = 2400 },
	@{file = 'img105.jpg'; width = 1920; height = 1200 }
)
Add-Type -AssemblyName System.Drawing
foreach ($LockScreenImage in $LockScreenImages) {
	$filePath = "$env:windir\Web\Screen\$($LockScreenImage.file)"
	$bitmap = New-Object System.Drawing.Bitmap $LockScreenImage.width, $LockScreenImage.height
	$graphics = [Drawing.Graphics]::FromImage($bitmap)
	$graphics.FillRectangle([Drawing.Brushes]::Black, 0, 0, $bitmap.Width, $bitmap.Height)
	$graphics.Dispose()
	$bitmap.Save($filePath)
	$bitmap.Dispose()
}

# Settings: Bluetooth & devices: Mouse: Enhance pointer precision: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -PropertyType String -Value 0 -Force

# Maximum password age (days): Unlimited
net.exe accounts /maxpwage:unlimited

# Control Panel: Ease of Access: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On
$RemoveBackgroundImagesBytes = [byte[]](Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
$RemoveBackgroundImagesBytes[4] = $RemoveBackgroundImagesBytes[4]-bor 1
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value $RemoveBackgroundImagesBytes -Force

# Settings: Accessibility: Visual effects: Always show scrollbars: On
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'DynamicScrollbars' -Value 0 -PropertyType DWord -Force

# Show the file transfer dialog box in the detailed mode
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Name 'EnthusiastMode' -PropertyType DWord -Value 1 -Force

# Set the quality factor of the JPEG desktop wallpapers to maximum
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'JPEGImportQuality' -PropertyType DWord -Value 100 -Force

# Disable the Connected User Experiences and Telemetry (DiagTrack) service, and block connection for the Unified Telemetry Client Outbound Traffic
Get-Service -Name 'DiagTrack' | Stop-Service -Force
Get-Service -Name 'DiagTrack' | Set-Service -StartupType Disabled
Get-NetFirewallRule -Group 'DiagTrack' | Set-NetFirewallRule -Enabled True -Action Block

# Turn off Windows Error Reporting
Get-Service -Name 'WerSvc' | Stop-Service -Force
Get-Service -Name 'WerSvc' | Set-Service -StartupType Disabled

# Folder Options: View: Always show icons, never thumbnails: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'IconsOnly' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Always show menus: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AlwaysShowMenus' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Display file icon on thumbnails: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTypeOverlay' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Display file size information in folder tips: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'FolderContentsInfoTip' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Display the full path in the title bar: Enabled
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Name 'FullPath' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Hidden files and folders: Show hidden files, folders, and drives
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Hide empty drives: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideDrivesWithNoMedia' -Value 0 -PropertyType DWord -Force

# Folder Options: View: Hide extensions for known file types: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -PropertyType DWord -Force

# Folder Options: View: Hide folder merge conflicts: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideMergeConflicts' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Hide protected operating system files (Recommended): Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Launch folder windows in a separate process: Enabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Restore previous folder windows at logon: Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'PersistBrowsers' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Show drive letters: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowDriveLettersFirst' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Show encrypted or compressed NTFS files in color: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowEncryptCompressedColor' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show pop-up description for folder and desktop items: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowInfoTip' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show preview handlers in pewview pane: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowPreviewHandlers' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show status bar: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowStatusBar' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Use check boxes to select items: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Use Sharing Wizard (Recommended): Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SharingWizardOn' -PropertyType DWord -Value 1 -Force

# Folder Options: View: When typing into list view: Select the typed item in the view
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TypeAhead' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Always show availability status: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllCloudStates' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Expand to open folder: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneExpandToCurrentFolder' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Show all folders: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllFolders' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Show libraries: Disabled
if (-not (Test-Path -Path 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}')) {
	New-Item -Path 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Name 'System.IsPinnedToNameSpaceTree' -PropertyType DWord -Value 0 -Force

# Turn off Sticky keys by pressing the Shift key 5 times
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -PropertyType String -Value 506 -Force

# Display Stop error code when BSoD occurs
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name 'DisplayParameters' -PropertyType DWord -Value 1 -Force

# Hide seconds on the taskbar clock
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -PropertyType DWord -Value 0 -Force

# Display the recycle bin files delete confirmation dialog
$ShellState = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState'
$ShellState[4] = 51
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState' -PropertyType Binary -Value $ShellState -Force

# Settings: Accounts: Sign-in options: Automatically save my restartable apps and restart them when I sign back in: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'RestartApps' -PropertyType DWord -Value 0 -Force

# Remote Desktop Connection: Never show pop-up upon ending session
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client')) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Name 'ShowShutdownDialog' -Value 0 -PropertyType DWord -Force

# Settings: Bluetooth & devices: Devices: Device settings: Download over metered connections: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup' -Name 'CostedNetworkPolicy' -PropertyType DWord -Value 1 -Force

# Settings: Bluetooth & devices: AutoPlay: Removeable media: Open folder to view files (File Explorer)
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force

# Settings: Bluetooth & devices: AutoPlay: Memory card: Open folder to view files (File Explorer)
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force

# Settings: Bluetooth & devices: USB: Connection notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Name 'NotifyOnUsbErrors' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Active hours: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'SmartActiveHoursState' -PropertyType DWord -Value 0 -Force

# Settings: System: Display: Graphics settings: Hardware-accelerated GPU scheduling: On
if (Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript { ($_.AdapterDACType -ne 'Internal') -and ($null -ne $_.AdapterDACType) }) {
	if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch 'Virtual') {
		$WddmVersion_Min = [Microsoft.Win32.Registry]::GetValue('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\FeatureSetUsage', 'WddmVersion_Min', $null)
		if ($WddmVersion_Min -ge 2700) {
			New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name HwSchMode -PropertyType DWord -Value 2 -Force
		}
	}
}

# Settings: Personalization: Taskbar: Combine taskbar buttons and hide labels: Always
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -PropertyType DWord -Value 0 -Force

# Control Panel: Large Icons
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'AllItemsIconView' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'StartupPage' -PropertyType DWord -Value 1 -Force

# When I grab a windows's title bar and shake it, don't minimize all other windows
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DisallowShaking' -PropertyType DWord -Value 1 -Force

# Control Panel: Ease of Access Center: Make the computer easier to see: Turn off all unnecessary animations (when possible): On
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x07, 0x80, 0x91, 0x00, 0x00, 0x00)) -PropertyType Binary -Force

# Do not group files and folder in the Downloads folder
Get-ChildItem -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell' -Recurse -ErrorAction SilentlyContinue | Where-Object -FilterScript {
	$_.PSChildName -eq '{885A186E-A440-4ADA-812B-DB871B942259}'
} | Remove-Item -Force
# https://learn.microsoft.com/en-us/windows/win32/properties/props-system-null
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'ColumnList' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'GroupBy' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'LogicalViewMode' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Name' -PropertyType String -Value NoName -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Order' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'PrimaryProperty' -PropertyType String -Value 'System.ItemNameDisplay' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'SortByList' -PropertyType String -Value 'prop:System.ItemNameDisplay' -Force

# Settings: System: Storage: Storage Sense: Keep Windows running smoothly by automatically cleaning up temporary system and app files: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '04' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Automatic User content cleanup: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '01' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Run Storage Sense: Every day
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '2048' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Delete files in my recycle bin if they have been there for over: 60 days
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '256' -PropertyType DWord -Value 60 -Force
# Delete files in my Downloads folder if they haven't been opened for more than: 60 days
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '32' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '512' -PropertyType DWord -Value 60 -Force

# Turn off Delivery Optimization
New-ItemProperty -Path 'Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings' -Name 'DownloadMode' -PropertyType DWord -Value 0 -Force
Delete-DeliveryOptimizationCache -Force

# Disable Scheduled Tasks
$TasksToDisable = @(
	'Consolidator',
	'DmClient',
	'DmClientOnScenarioDownload',
	'FamilySafetyMonitor',
	'FamilySafetyRefreshTask',
	'MapsToastTask',
	'MapsUpdateTask',
	'MareBackup',
	'Microsoft Compatibility Appraiser',
	'Microsoft-Windows-DiskDiagnosticDataCollector',
	'PcaPatchDbTask',
	'PcaWallpaperAppDetect',
	'ProgramDataUpdater',
	'Proxy',
	'QueueReporting',
	'StartupAppTask',
	'UsbCeip',
	'WinSAT',
	'XblGameSaveTask'
)

foreach ($Task in $TasksToDisable) {
	if (Get-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue) {
		Get-ScheduledTask -TaskName $Task | Disable-ScheduledTask
	}
}

# Disable Windows features
$FeaturesToDisable = @(
	'WindowsMediaPlayer',
	'WorkFolders-Client',
	'Recall',
	'MediaPlayback'
)

foreach ($Feature in $FeaturesToDisable) {
	$EnabledFeatures = Get-WindowsOptionalFeature -Online | Where-Object {
		$_.State -eq 'Enabled' -and
		$_.FeatureName -match $Feature
	}

	foreach ($EnabledFeature in $EnabledFeatures) {
		Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $EnabledFeature.FeatureName
	}
}

# Disable Windows Capabilities
# $AppsToRemove = @(
# 	'Hello.Face',
# 	'InternetExplorer',
# 	'MathRecognizer',
# 	'OpenSSH',
# 	'QuickAssist',
# 	'StepsRecorder',
# 	'Wallpapers',
# 	'WindowsMediaPlayer',
# 	'WordPad',
# 	'Narrator',
# 	'Print.Management.Console'
# )

# foreach ($App in $AppsToRemove) {
# 	$Capabilities = Get-WindowsCapability -Online | Where-Object {
# 		$_.State -eq 'Installed' -and
# 		$_.Name -match $App
# 	}

# 	foreach ($Capability in $Capabilities) {
# 		Remove-WindowsCapability -Online -Name $Capability.Name
# 	}
# }

# Add Windows Capabilities
$AppsToInstall = @(
	'Print.Fax.Scan',
	'MSPaint',
	'Notepad',
	'SnippingTool'
)

foreach ($AppInstall in $AppsToInstall) {
	$CapabilitiesInstall = Get-WindowsCapability -Online | Where-Object { $_.State -ne 'Installed' -and $_.Name -match $AppInstall }

	foreach ($CapabilityInstall in $CapabilitiesInstall) {
		Add-WindowsCapability -Online -Name $CapabilityInstall.Name
	}
}

# Settings: Windows Update: Get the latest updates as soon as they're available: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsContinuousInnovationOptedIn' -PropertyType DWord -Value 0 -Force

# Override for default input method: English
Set-WinDefaultInputMethodOverride -InputTip '0409:00000409'

# Let me use a different input method for each app window
Set-WinLanguageBarOption -UseLegacySwitchMode

# Use the latest installed .NET runtime for all apps
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force

# Disable and delete reserved storage after the next update installation
Set-WindowsReservedStorageState -State Disabled

# Disable help lookup via F1
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64')) {
	New-Item -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Name '(default)' -PropertyType String -Value '' -Force

# Enable Num Lock at startup
New-ItemProperty -Path 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -PropertyType String -Value 2147483650 -Force

# Use AutoPlay for all media and devices
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -PropertyType DWord -Value 0 -Force

# Enable thumbnail cache removal
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force

# Do not back up the system registry to %SystemRoot%\System32\config\RegBack folder
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager' -Name 'EnablePeriodicBackup' -Force -ErrorAction Ignore

# Disable Microsoft Defender Exploit Guard network protection
Set-MpPreference -EnableNetworkProtection Disabled

# Disable detection for potentially unwanted applications and block them
Set-MpPreference -PUAProtection Disabled

# Disable sandboxing for Microsoft Defender
& "$env:SystemRoot\System32\setx.exe" /M MP_FORCE_USE_SANDBOX 0

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows Security Health\State')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected' -PropertyType DWord -Value 1 -Force

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_EdgeSmartScreenOff' -PropertyType DWord -Value 0 -Force

# Microsoft Defender: App & browser control: SmartScreen for Microsoft Store apps: Dismiss offer
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_StoreAppsSmartScreenOff' -Value 0 -PropertyType DWord -Force

# Disable apps and files checking within Microsoft Defender SmartScreen
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SmartScreenEnabled' -PropertyType String -Value 'Off' -Force

# Disable Windows Script Host
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -PropertyType DWord -Value 0 -Force

# Disable DNS-over-HTTPS for IPv4
if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
	$InterfaceGuids = @((Get-NetAdapter -Physical).InterfaceGuid)
}
else {
	$InterfaceGuids = @((Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript { $_.DestinationPrefix -eq '0.0.0.0/0' } | Get-NetAdapter).InterfaceGuid)
}
if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
	Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ResetServerAddresses
}
else {
	Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq '0.0.0.0/0' } | Get-NetAdapter | Set-DnsClientServerAddress -ResetServerAddresses
}
foreach ($InterfaceGuid in $InterfaceGuids) {
	Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$InterfaceGuid\DohInterfaceSettings\Doh" -Recurse -Force -ErrorAction Ignore
}
Clear-DnsClientCache
Register-DnsClient

# Hide the "Extract all" item from the Windows Installer (.msi) context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract' -Recurse -Force -ErrorAction Ignore

# Hide the "Install" item from the Cabinet (.cab) filenames extensions context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas' -Recurse -Force -ErrorAction Ignore

# Hide the "Print" item from the .bat and .cmd context menu
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\batfile\shell\print' -Name 'ProgrammaticAccessOnly' -PropertyType String -Value '' -Force
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print' -Name 'ProgrammaticAccessOnly' -PropertyType String -Value '' -Force

# Hide the "Compressed (zipped) Folder" item from the "New" context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew' -Force -ErrorAction Ignore

# Enable the "Open", "Print", and "Edit" items if more than 15 files selected
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'MultipleInvokePromptMinimum' -PropertyType DWord -Value 300 -Force

# Settings: Update & Security: Troubleshoot: Don't run any troubleshooters
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation' -Name 'UserPreference' -PropertyType DWord -Value 1 -Force

# Settings: Devices: Typing: Typing Insights: Disabling
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Name 'InsightsEnabled' -Value 0 -PropertyType DWord -Force

# Settings: Windows Security: Virus & threat protection: Manage settings: Change notification settings: Recent activity and scan results: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection' -Name 'SummaryNotificationDisabled' -Value 1 -PropertyType DWord -Force

# On-Screen Keyboard: Options: Use click sound: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Osk' -Name 'ClickSound' -Value 0 -PropertyType DWord -Force

# On-Screen Keyboard: Options: Use Text Prediction: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Osk' -Name 'UseTextPrediction' -Value 0 -PropertyType DWord -Force

# Context menu: Remove 'Rotate right', 'Rotate left'
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force -ErrorAction SilentlyContinue
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force

# Context Menu: Remove 'Set as desktop background'
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avci\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avcs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avifs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dib\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heic\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heics\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heifs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.hif\Shell\setdesktopwallpaper' -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jfif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.wdp\Shell\setdesktopwallpaper' -Force -Recurse

# File Explorer: Ribbon: Details View and Size all columms to fit
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'QatItems' -Value ([byte[]](0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x73, 0x69, 0x71, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x73, 0x63, 0x68, 0x65, 0x6d, 0x61, 0x73, 0x2e, 0x6d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x77, 0x69, 0x6e, 0x64, 0x6f, 0x77, 0x73, 0x2f, 0x32, 0x30, 0x30, 0x39, 0x2f, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x2f, 0x71, 0x61, 0x74, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x20, 0x6d, 0x69, 0x6e, 0x69, 0x6d, 0x69, 0x7a, 0x65, 0x64, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3d, 0x22, 0x30, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x38, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x39, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x32, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x38, 0x34, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x33, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x37, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x35, 0x37, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x34, 0x38, 0x35, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x3e)) -PropertyType Binary -Force

# Performance Options: Advanced: Processor scheduling: Adjust for best performance of: Programs
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 38 -PropertyType DWord -Force

# Enable MSI and High Priority
$PciDevicesPath = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'
Get-ChildItem -Path $PciDevicesPath -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
	Get-ChildItem -Path $_.PSPath -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
		$InterruptManagementPath = Join-Path -Path $_.PSPath -ChildPath 'Device Parameters\Interrupt Management'
		$DeviceParametersPath = Join-Path -Path $InterruptManagementPath -ChildPath 'MessageSignaledInterruptProperties'
		$AffinityPolicyPath = Join-Path -Path $InterruptManagementPath -ChildPath 'Affinity Policy'

		@($InterruptManagementPath, $DeviceParametersPath, $AffinityPolicyPath) | ForEach-Object {
			if (-not (Test-Path $_)) {
				New-Item -Path $_ -ItemType Directory -Force
			}
		}

		New-ItemProperty -Path $DeviceParametersPath -Name 'MSISupported' -Value 1 -PropertyType DWord -Force
		New-ItemProperty -Path $AffinityPolicyPath -Name 'DevicePriority' -Value 3 -PropertyType DWord -Force
	}
}

# Control Panel: Ease of Access: Ease of Access Center: Always read this section aloud: off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Name 'selfvoice' -Value 0 -PropertyType DWord -Force

# Control Panel: Ease of Access: Ease of Access Center: Always scan this section: off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Name 'selfscan' -Value 0 -PropertyType DWord -Force

# File Explorer: Remove pinned quick access items
Remove-Item -Path "$env:USERPROFILE\Documents" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Music" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Pictures" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Videos" -Recurse -Force
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Force -Recurse
Stop-Process -Name explorer -Force

$HostsPath = "$env:WINDIR\System32\drivers\etc\hosts"
$Urls = 'mobile.events.data.microsoft.com', 'r.bing.comms-appx-web'
$Urls | ForEach-Object {
	$Line = '0.0.0.0 ' + $_
	if (-not (Select-String -Path $HostsPath -Pattern $Line)) {
		Add-Content -Path $HostsPath -Value $Line
	} }

# Open as Notepad
$NotepadDefaultExts = @('.lua', '.conf', '.json', '.glsl', '.xml')
foreach ($NotepadDefaultExt in $NotepadDefaultExts) {
	New-Item "HKCU:\Software\Classes\$NotepadDefaultExt\shell\open\command" -Force | Set-ItemProperty -Name '(default)' -Value 'notepad.exe %1' 
}

# Narrator: Do not show again
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Narrator' -Name 'ShortcutKeysDialogState' -Value 1 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Keyboard shortcut for Narrator: Off
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Narrator\NoRoam' -Name 'WinEnterLaunchEnabled' -Value 0 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Volume: 1
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Narrator\NoRoam' -Name 'SpeechVolume' -Value 1 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Enable Narrator extenstions: Off
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Narrator\NoRoam' -Name 'ScriptingEnabled' -Value 0 -PropertyType DWord -Force

<#
	Setting:
	GPU Priority

	Description:
	Defines the GPU scheduling priority for the specified multimedia task—in this case, for games.

	Values:
	0–31 (decimal) - Higher values indicate higher GPU scheduling priority.
	Default - Typically 6 for games.
	8 - Gives the game task higher priority access to GPU resources.

	Note:
	This setting affects how the Multimedia Class Scheduler Service (MMCSS) allocates GPU time. Increasing the value can improve responsiveness and performance in games, but excessive values may starve other GPU-using tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'GPU Priority' -Value 8 -PropertyType DWord -Force

<#
	Setting:
	Priority

	Description:
	Sets the CPU scheduling priority for the specified multimedia task—in this case, games—under the Multimedia Class Scheduler Service (MMCSS).

	Values:
	1–8 (decimal) - Higher numbers give higher CPU scheduling priority.
	Default - Typically 6 for games.
	8 - Maximum priority within MMCSS-managed range.

	Note:
	This influences how much CPU time is given to games compared to other multimedia tasks. Higher values improve responsiveness but may reduce performance of background tasks or services.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Priority' -Value 6 -PropertyType DWord -Force

<#
	Setting:
	Scheduling Category

	Description:
	Defines the type of scheduling behavior applied to the task under the Multimedia Class Scheduler Service (MMCSS), influencing how aggressively it receives CPU time.

	Values:
	Low - Lowest priority for background tasks.
	Medium - Balanced CPU access.
	High - Higher CPU priority; suitable for latency-sensitive tasks like games.
	Exclusive - Highest priority; reserves CPU time exclusively (used with caution).

	Note:
	Setting this to "High" ensures games get faster CPU response compared to normal or background tasks. "Exclusive" may impact overall system responsiveness and is generally reserved for critical media tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Scheduling Category' -Value 'High' -PropertyType String -Force

<#
	Setting:
	SFIO Priority

	Description:
	Defines the background I/O (Slow File I/O) priority level for the task, affecting how Windows schedules disk operations for that task.

	Values:
	Idle - Lowest disk I/O priority.
	Low - Lower than normal I/O.
	Normal - Default priority for standard tasks.
	High - Elevated disk I/O priority for performance-critical tasks.

	Note:
	Setting this to "High" gives games higher priority access to disk resources, reducing I/O latency during gameplay. Useful for minimizing stutters from background disk activity.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'SFIO Priority' -Value 'High' -PropertyType String -Force
