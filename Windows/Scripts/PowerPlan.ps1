# Power Plan: Restore default schemes
& powercfg.exe /restoredefaultschemes
$PowerPlanUltimate = & powercfg.exe -list | Select-String -Pattern 'Ultimate Performance'
$PowerPlanHigh = & powercfg.exe -list | Select-String -Pattern 'High performance'
if ($PowerPlanUltimate) {
    $PowerPlanGUID = ($PowerPlanUltimate.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
    & powercfg.exe /setactive $PowerPlanGUID
} elseif ($PowerPlanHigh) {
    $PowerPlanGUID = ($PowerPlanHigh.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
    & powercfg.exe /setactive $PowerPlanGUID
}

# Disable hibernation
& powercfg.exe /HIBERNATE OFF

# Power Plan: Showing all hidden options
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'CSEnabled' -Value 0 -Force
$PowerCfg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings' -Recurse).Name -notmatch '\bDefaultPowerSchemeValues|(\\[0-9]|\b255)$'
foreach ($item in $PowerCfg) {
    New-ItemProperty -Path $item.Replace('HKEY_LOCAL_MACHINE', 'HKLM:') -Name 'Attributes' -Value 2 -Force
}

# Power Plan: Require a password on wakeup: No
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 0

# Power Plan: Power plan type: High performance
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 245d8541-3943-4422-b025-13a784f679b7 1

# Power Plan: Device idle policy: High performance
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 4faab71a-92e5-4726-b531-224559672d19 0

# Power Plan: Disconnected Standby Mode: Normal
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 68afb2d9-ee95-47a8-8f50-4115088073b1 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 68afb2d9-ee95-47a8-8f50-4115088073b1 0

# Power Plan: Networking connectivity in Standby: Enable
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT fea3413e-7e05-4911-9a71-700331f1c294 f15576e8-98b7-4186-b944-eafa664402d9 1

# Power Plan: Hard disk: AHCI Link Power Management - HIPM/DIPM: Active
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 0

# Power Plan: Hard disk: Maximum Power Level: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 51dea550-bb38-4bc4-991b-eacf37be5ec8 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 51dea550-bb38-4bc4-991b-eacf37be5ec8 100

# Power Plan: Hard disk: Turn off hard disk after: 0 Seconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0

# Power Plan: Hard disk: Hard disk burst ignore time: 0 Minutes
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 0

# Power Plan: Hard disk: Secondary NVMe Idle Timeout: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 0

# Power Plan: Hard disk: Primary NVMe Idle Timeout: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 0

# Power Plan: Hard disk: AHCI Link Power Management - Adaptive: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 0

#Power Plan: Hard disk: Secondary NVMe Power State Transition Latency Tolerance: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dbc9e238-6de9-49e3-92cd-8c2b4946b472 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 dbc9e238-6de9-49e3-92cd-8c2b4946b472 0

# Power Plan: Hard disk: NVMe NOPPME: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc7372b6-ab2d-43ee-8797-15e9841f2cca 0

# Power Plan: Hard disk: Primary NVMe Power State Transition Latency Tolerance: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 fc95af4d-40e7-4b6d-835a-56d131dbc80e 0

# Power Plan: Internet Explorer mode: JavaScript Timer Frequency: Maximum Performance
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 02f815b5-a5cf-4c84-bf20-649d1f75d3d8 4c793e7d-a264-42e1-87d3-7a0d2f523ccd 1

# Power Plan: Desktop background settings: Slide show: Paused
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 1

# Power Plan: Wireless Adapter Settings: Power Saving Mode: Maximum Performance
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0

#Power Plan: Sleep: Legacy RTC mitigations: Disable
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 1a34bdc3-7e6b-442e-a9d0-64b6ef378e84 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 1a34bdc3-7e6b-442e-a9d0-64b6ef378e84 0

# Power Plan: Sleep: Allow Away Mode Policy: Yes
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1

# Power Plan: Sleep: Sleep after: 0 Minutes (Never)
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

# Power Plan: System unattended sleep timeout: 0 Seconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0

# Power Plan: Sleep: Allow hybrid sleep: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0

# Power Plan: Sleep: Hibernate after: 0 Seconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0

# Power Plan: Sleep: Allow system required policy: Yes
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 a4b195f5-8225-47d8-8012-9d41369786e2 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 a4b195f5-8225-47d8-8012-9d41369786e2 1

# Power Plan: Sleep: Allow Standby States: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0

# Power Plan: Sleep: Allow wake timers: Important Wake Timers Only
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 2

# Power Plan: Sleep: Allow sleep with remote opens: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d 0

# Power Plan: USB settings: Hub Selective Suspend Timeout: 0 Millisecond
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 0

# Power Plan: USB settings: USB selective suspend setting: Disabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

# Power Plan: USB settings: Setting IOC on all TDs: Enabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 498c044a-201b-4631-a522-5c744ed4e678 1

# Power Plan: USB settings: USB 3 Link Power Mangement: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0

# Power Plan: Idle Resiliency: Execution Required power request timeout: 4294967295 Seconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 4294967295
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 3166bc41-7e98-4e03-b34e-ec0f5f2b218e 4294967295

# Power Plan: Idle Resiliency: IO coalescing timeout: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c36f0eb4-2988-4a70-8eee-0884fc2c2433 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c36f0eb4-2988-4a70-8eee-0884fc2c2433 0

# Power Plan: Idle Resiliency: Processor Idle Resiliency Timer Resolution: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c42b79aa-aa3a-484b-a98f-2cf32aa90a28 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 c42b79aa-aa3a-484b-a98f-2cf32aa90a28 0

# Power Plan: Idle Resiliency: Deep Sleep Enabled/Disabled: Deep Sleep Disabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 2e601130-5351-4d9d-8e04-252966bad054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 0

# Power Plan: Interrupt Steering Settings: Interrupt Steering Mode: Any unparked processor
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 2bfc24f9-5ea2-4801-8213-3dbae01aa39d 3

# Power Plan: Interrupt Steering Settings: Target Load: 10 Tenths of a percent
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 73cde64d-d720-4bb2-a860-c755afe77ef2 10
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e 73cde64d-d720-4bb2-a860-c755afe77ef2 10

# Power Plan: Interrupt Steering Settings: Unparked time trigger: 0 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 48672f38-7a9a-4bb2-8bf8-3d85be19de4e d6ba4903-386f-4c2c-8adb-5c21b3328d25 0

# Power Plan: Power buttons and lid: Lid close action: Do nothing
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

# Power Plan: Power buttons and lid: Power button action: Shutdown
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

# Power Plan: Power buttons and lid: Enable forced button/lid shutdown: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 833a6b62-dfa4-46d1-82f8-e09e34d029d6 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 833a6b62-dfa4-46d1-82f8-e09e34d029d6 0

# Power Plan: Power buttons and lid: Sleep button action: Do nothing
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0

# Power Plan: Power buttons and lid: Lid open action: Do nothing
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 0

# Power Plan: Power buttons and lid: Start menu power button: Shut down
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 a7066653-8d6c-40a8-910e-a1f54b84c7e5 2

# Power Plan: PCI Express: Link State Power Management: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 0

# Power Plan: Processor power management: Processor performance increase threshold: 1%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35d 1

# Power Plan: Processor power management: Processor performance increase threshold for Processor Power Efficiency Class 1: 1%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 06cadf0e-64ed-448a-8927-ce7bf90eb35e 1

# Power Plan: Processor power management: Processor performance core parking min cores: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 100

# Power Plan: Processor power management: Processor performance core parking min cores for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318584 100

# Power Plan: Processor power management: Processor performance decrease threshold: 1%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 1

# Power Plan: Processor power management: Processor performance decrease threshold for Processor Power Efficiency Class 1: 1%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 12a0ab44-fe28-4fa9-b3bd-4b64f44960a7 1

# Power Plan: Processor power management: Initial performance for Processor Power Efficiency Class 1 when unparked: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 1facfc65-a930-4bc5-9f38-504ec097bbc0 100

# Power Plan: Processor power management: Processor performance core parking concurrency threshold: 10%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 10
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2430ab6f-a520-44a2-9601-f7f23b5134b1 10

# Power Plan: Processor power management: Processor performance core parking increase time: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 2ddd5a84-5a71-437e-912a-db0b8c788732 1

# Power Plan: Processor power management: Processor energy performance preference policy: 0%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0

# Power Plan: Processor power management: Processor energy performance preference policy for Processor Power Efficiency Class 1: 0%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0

# Power Plan: Processor power management: Allow Throttle States: Off
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb 0

# Power Plan: Processor power management: Processor performance increase time for Processor Power Efficiency Class 1: 1 Tme check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4009efa7-e72d-4cba-9edf-91084ea8cbc3 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4009efa7-e72d-4cba-9edf-91084ea8cbc3 1

# Power Plan: Processor power management: Processor performance decrease policy: Single
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac6 1

# Power Plan: Processor power management: Processor performance decrease policy for Processor Power Efficiency Class 1: Single
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 40fbefc7-2e9d-4d25-a185-0cfd8574bac7 1

# Power Plan: Processor power management: Processor performance core parking parked performance state: Lightest Performance State
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2b 2

# Power Plan: Processor power management: Processor performance core parking parked performance state for Processor Power Efficiency Class 1: Lightest Performance State
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 447235c7-6a8d-4cc0-8e24-9eaf70b96e2c 2

# Power Plan: Processor power management: Processor performance boost policy: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 45bcc044-d885-43e2-8605-ee0ec6e96b59 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 45bcc044-d885-43e2-8605-ee0ec6e96b59 100

# Power Plan: Processor power management: Processor performance increase policy: Rocket
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 2

# Power Plan: Processor power management: Processor performance increase policy for Processor Power Efficiency Class 1: Rocket
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc419 2

# Power Plan: Processor power management: Processor idle demote threshold: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4b92d758-5a24-4851-a470-815d78aee119 100

# Power Plan: Processor power management: Processor performance core parking distribution threshold: 10%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 10
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4bdaf4e9-d103-46d7-a5f0-6280121616ef 10

# Power Plan: Processor power management: Processor performance time check interval: 15 Milliseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 15
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 15

# Power Plan: Processor power management: Processor duty cycling: Disabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4e4450b3-6179-4e91-b8f1-5bb9938f81a1 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 4e4450b3-6179-4e91-b8f1-5bb9938f81a1 0

# Power Plan: Processor power management: Processor idle disable: Enable Idle
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad 0

# Power Plan: Processor power management: Latency sensitivity hint min unparked cores/packages: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd88 100

# Power Plan: Processor power management: Latency sensitivity hint min unparked cores/packages for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 616cdaa5-695e-4545-97ad-97dc2d1bdd89 100

# Power Plan: Processor power management: Latency sensitivity hint processor performance: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300971 100

# Power Plan: Processor power management: Latency sensitivity hint processor performance for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 619b7505-003b-4e82-b7a6-4dd29c300972 100

# Power Plan: Processor power management: Processor idle threshold scaling: Disable scaling
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 6c2993b0-8f48-481f-bcc6-00dd2742aa06 0

# Power Plan: Processor power management: Processor performance core parking decrease policy: Single core
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 71021b41-c749-4d21-be74-a00f335d582b 1

# Power Plan: Processor power management: Maximum processor frequency: 0 MHz
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e100 0

# Power Plan: Processor power management: Maximum processor frequency for Processor Power Efficiency Class 1: 0 MHz
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e101 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 75b0ae3f-bce0-45a7-8c89-c9611c25e101 0

# Power Plan: Processor power management: Processor idle promote threshold: 0%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7b224883-b3cc-4d79-819f-8374152cbe7c 0

# Power Plan: Processor power management: Processor performance history count: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f5f 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f5f 1

# Power Plan: Processor power management: Processor performance history count for Processor Power Efficiency Class 1: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f60 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7d24baa7-0b84-480f-840c-1b0743c00f60 1

# Power Plan: Processor power management: Processor performance decrease time for Processor Power Efficiency Class 1: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2492b6-60b1-45e5-ae55-773f8cd5caec 1

# Power Plan: Processor power management: Heterogeneous policy in effect: Use heterogeneous policy 4
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 4
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 7f2f5cfa-f10c-4823-b5e1-e93ae85f46b5 4

# Power Plan: Processor power management: Minimum processor state: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100

# Power Plan: Processor power management: Minimum processor state for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964d 100

# Power Plan: Processor power management: Processor performance autonomous mode: Disabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 0

# Power Plan: Processor power management: Heterogeneous thread scheduling policy: Performant processors
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d 1

# Power Plan: Processor power management: Processor performance core parking overutilization threshold: 90%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 90
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 943c8cb6-6f93-4227-ad87-e9a3feec08d1 90

# Power Plan: Processor power management: System cooling policy: Active
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 1

# Power Plan: Processor power management: Processor performance core parking soft park latency: 0 Microseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 97cfac41-2217-47eb-992d-618b1977c907 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 97cfac41-2217-47eb-992d-618b1977c907 0

# Power Plan: Processor power management: Processor performance increase time: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5aa 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5aa 1

# Power Plan: Processor power management: Processor performance increase time for Processor Power Efficiency Class 1: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5ab 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5ab 1

# Power Plan: Processor power management: Processor idle state maximum: 0
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 9943e905-9a30-4ec1-9b99-44dd3b76f7a2 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 9943e905-9a30-4ec1-9b99-44dd3b76f7a2 0

# Power Plan: Processor power management: Processor performance level increase threshold for Processor Power Efficiency Class 1 processor count increase:
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b000397d-9b0b-483d-98c9-692a6060cfbf 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 b000397d-9b0b-483d-98c9-692a6060cfbf 0

# Power Plan: Processor power management: Heterogeneous short running thread scheduling policy: Performant processors
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b 1

# Power Plan: Processor power management: Maximum processor state: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100

# Power Plan: Processor power management: Maximum processor state for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ed 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ed 100

# Power Plan: Processor power management: Processor performance boost mode: Aggresive
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 2

# Power Plan: Processor power management: Processor idle time check: 10000 Microseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 10000
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c4581c31-89ab-4597-8e2b-9c9cab440e6b 10000

# Power Plan: Processor power management: Processor performance core parking increase policy: Single core
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 c7be0679-2817-4d69-9d02-519a537ed0c6 1

# Power Plan: Processor power management: Processor autonomous activity window: 10000 Microseconds
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 10000
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa 10000

# Power Plan: Processor power management: Processor performance decrease time: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c8 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c8 1

# Power Plan: Processor power management: Processor performance decrease time for Processor Power Efficiency Class 1: 1 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 d8edeb9b-95cf-4f95-a73c-b061973693c9 1

# Power Plan: Processor power management: Processor performance core parking decrease time: 20 Time check intervals
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 20
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 dfd10d17-d5eb-45dd-877a-9a34ddd15c82 20

# Power Plan: Processor power management: Processor performance core parking utility distribution: Enabled
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 e0007330-f589-42ed-a401-5ddb10e785d3 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 e0007330-f589-42ed-a401-5ddb10e785d3 1

# Power Plan: Processor power management: Processor performance core parking max cores: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100

# Power Plan: Processor power management: Processor performance core parking max cores for Processor Power Efficiency Class 1: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334029 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334029 100

# Power Plan: Processor power management: Processor performance core parking concurrency headroom threshold: 10%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 10
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f735a673-2066-4f80-a0c5-ddee0cf1bf5d 10

# Power Plan: Processor power management: Processor performance level decrease threshold for Processor Power Efficiency Class 1 processor count decrease: 0
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f8861c27-95e7-475c-865b-13c0cb3f9d6b 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 f8861c27-95e7-475c-865b-13c0cb3f9d6b 0

# Power Plan: Processor power management: A floor performance for Processor Power Efficiency Class 0 when there are Processor Power Efficiency Class 1 processors unparked: 100%
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 fddc842b-8364-4edc-94cf-c17f60de1c80 100
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 fddc842b-8364-4edc-94cf-c17f60de1c80 100

# Power Plan: Graphics settings: GPU preference policy: None
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 5fb4938d-1ee8-4b0f-9a3c-5036b0ab995c dd848b2a-8a5d-4451-9ae2-39cd41658f6c 0

# Write-Host 'Power Plan: Display: Dim display after: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

Write-Host 'Power Plan: Display: Turn off display after: 0 Seconds (Never)' -ForegroundColor green -BackgroundColor black
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

Write-Host 'Power Plan: Display: Advanced Color quality bias: Advanced Color visual quality bias' -ForegroundColor green -BackgroundColor black
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 684c3e69-a4f7-4014-8754-d45179a56167 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 684c3e69-a4f7-4014-8754-d45179a56167 1

# Write-Host 'Power Plan: Display: Console lock display off timeout: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 8ec4b3a5-6868-48c2-be75-4f3044be88a7 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 8ec4b3a5-6868-48c2-be75-4f3044be88a7 0

# Write-Host 'Power Plan: Display: Adaptive display: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 90959d22-d6a1-49b9-af93-bce885ad335b 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 90959d22-d6a1-49b9-af93-bce885ad335b 0

Write-Host 'Power Plan: Display: Allow display required policy: No' -ForegroundColor green -BackgroundColor black
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 a9ceb8da-cd46-44fb-a98b-02af69de4623 0

# Write-Host 'Power Plan: Display: Display brightness: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 0

# Write-Host 'Power Plan: Display: Dimmed display brightness: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 f1fbfde2-a960-4165-9f88-50667911ce96 0

# Write-Host 'Power Plan: Display: Enable adaptive brightness: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 fbd9aa66-9553-4097-ba44-ed6e9d65eab8 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reserve Time: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 468fe7e5-1158-46ec-88bc-5b96c9e44fd0 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 468fe7e5-1158-46ec-88bc-5b96c9e44fd0 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reset Percentage: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 49cb11a5-56e2-4afb-9d38-3df47872e21b 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 49cb11a5-56e2-4afb-9d38-3df47872e21b 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Non-sensor Input Presence Timeout: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 5adbbfbc-074e-4da1-ba38-db8b36b2c8f3 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 5adbbfbc-074e-4da1-ba38-db8b36b2c8f3 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Budget Grace Period: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 60c07fe1-0556-45cf-9903-d56e32210242 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 60c07fe1-0556-45cf-9903-d56e32210242 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: User Presence Prediction mode: Disabled=0/Enabled=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 82011705-fb95-4d46-8d35-4042b1d20def 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 82011705-fb95-4d46-8d35-4042b1d20def 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Budget Percent: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 9fe527be-1b70-48da-930d-7bcf17b44990 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 9fe527be-1b70-48da-930d-7bcf17b44990 0

# Write-Host 'Power Plan: Presence Aware Power Behavior: Standby Reserve Grace Period: 0 Seconds' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 c763ee92-71e8-4127-84eb-f6ed043a3e3d 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 8619b916-e004-4dd8-9b66-dae86f806698 c763ee92-71e8-4127-84eb-f6ed043a3e3d 0

# Write-Host 'Power Plan: Multimedia settings: When sharing media: Allow the computer to sleep=0/Prevent idling to sleep=1/Allow the computer to enter Away Mode=2' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 03680956-93bc-4294-bba6-4e0f09bb717f 0

Write-Host 'Power Plan: Multimedia settings: Video playback quality bias: Video playback performance bias' -ForegroundColor green -BackgroundColor black
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 10778347-1370-4ee0-8bbd-33bdacaade49 1

Write-Host 'Power Plan: Multimedia settings: When playing video: Optimize video quality' -ForegroundColor green -BackgroundColor black
& powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0
& powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 9596fb26-9850-41fd-ac3e-f7c3c00afd4b 34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4 0

# Write-Host 'Power Plan: Energy Saver settings: Display brightness weight: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 13d09884-f74e-474a-a852-b6bde8ad03a8 0

# Write-Host 'Power Plan: Energy Saver settings: Energy Saver Policy: 0=User/Aggresive=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 5c5bb349-ad29-4ee2-9d0b-2b25270f7a81 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da 5c5bb349-ad29-4ee2-9d0b-2b25270f7a81 0

# Write-Host 'Power Plan: Energy Saver settings: Charge level: 0 Percent battery charge' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT de830923-a562-41af-a086-e3a2c6bad2da e69653ca-cf7f-4f05-aa73-cb833fa90ad4 0

# Write-Host 'Power Plan: Battery: Critical battery notification: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f 0

# Write-Host 'Power Plan: Battery: Critical battery action: DoNothing=0/Sleep=1/Hibernate=2/Shutdown=3' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 637ea02f-bbcb-4015-8e2c-a1c7b9c0b546 0

# Write-Host 'Power Plan: Battery: Low battery level: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 8183ba9a-e910-48da-8769-14ae6dc1170a 0

# Write-Host 'Power Plan: Battery: Critical battery level: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f 9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469 0

# Write-Host 'Power Plan: Battery: Low battery notification: Off=0/On=1' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f bcded951-187b-4d05-bccc-f7e51960c258 0

# Write-Host 'Power Plan: Battery: Low battery action: DoNothing=0/Sleep=1/Hibernate=2/Shutdown=3' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f d8742dcb-3e6a-4b3c-b3fe-374623cdcf06 0

# Write-Host 'Power Plan: Battery: Reserve battery level: 0%' -ForegroundColor green -BackgroundColor black
# & powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0
# & powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT e73a048d-bf27-4f12-9731-8b2076e8891f f3c5027d-cd16-4930-aa6b-90db844a8f00 0

# Apply all changes
& powercfg.exe /SETACTIVE SCHEME_CURRENT
