# Information

Everything about BIOS.

## BIOS Update

1. Search the motherboard model on Google.

   > Note: Motherboard model can be found on `System Information` > `BaseBoard Product`

1. Use the official manufacter site to download the latest BIOS.
1. Move BIOS to USB.
1. Plug the USB to the motherboard.
1. Boot to BIOS.

   > Note: Restart to BIOS using CMD (Admin):
   >
   > ```cmd
   > shutdown /r /fw /t 00
   >
   > ```

1. Update BIOS Firmware.

   > Note: Update PC BIOS at night hours to avoid power loss.

BIOS Update can take around 8 minutes.

## BIOS Settings

### Asus Motherboard

1. `Ai Tweaker` > `Intel(R) Adaptive Boost Technology` > `Disabled`.
1. `Ai Tweaker` > `ASUS MultiCore Enhancement` > `Disabled - Enforce All limits`.
1. `Advanced` > `Platform Misc Configuration` > `PCI Express Native Power Management` > `Enabled` (Wake-On-Lan). (default)
1. `Advanced` > `Platform Misc Configuration` > `ASPM` > `Disabled`.
1. `Advanced` > `CPU Configuration` > `Intel (VMX) Virtualization Technology` > `Disabled`.
1. `Advanced` > `CPU Configuration` > `CPU - Power Management Control` > `Intel(R) SpeedStep(tm)` > `Disabled`.
1. `Advanced` > `CPU Configuration` > `CPU - Power Management Control` > `Intel(R) Speed Shift Technology` > `Disabled`.
1. `Advanced` > `CPU Configuration` > `CPU - Power Management Control` > `CPU C-states` > `Disabled`.
1. `Advanced` > `System Agent (SA) Configuration` > `VT-d` > `Disabled`.
1. `Advanced` > `System Agent (SA) Configuration` > `PCI Express Configuration` > `M.2_2 Link Speed` > `Gen4`.
1. `Advanced` > `System Agent (SA) Configuration` > `PCI Express Configuration` > `PCIEX16(G5)` > `Gen5`.
1. `Advanced` > `System Agent (SA) Configuration` > `PCI Express Configuration` > `M.2_1 Link SPeed` > `Gen5`.
1. `Advanced` > `PCH Configuration` > `PCI Express Configuration` > `PCIEX1(G3) Link Speed` > `Gen3`.
1. `Advanced` > `PCH Configuration` > `PCI Express Configuration` > `PCIEX16(G3) Link Speed` > `Gen3`.
1. `Advanced` > `PCH Configuration` > `PCI Express Configuration` > `M.2_3 Link Speed` > `Gen4`.
1. `Advanced` > `PCH Configuration` > `PCI Express Configuration` > `PCIEX16(G4) Link Speed` > `Gen4`.
1. `Advanced` > `ThunderBolt(TM) Configuration` > `PCIE Tunneling over USB4` > `Disabled`.
1. `Advanced` > `Trusted Computing` > `Security Device Support` > `Disable`.
1. `Advanced` > `APM Configuration` > `Power On By PCI-E` > `Enabled` (Wake-On-Lan).
1. `Advanced` > `Onboard Devices Configuration` > `Wi-Fi Controller` > `Disabled`.
1. `Advanced` > `Onboard Devices Configuration` > `Bluetooth Controller` > `Disabled`.
1. `Advanced` > `Onboard Devices Configuration` > `LED lighting When system is in working state` > `Stealth Mode`.
1. `Advanced` > `Onboard Devices Configuration` > `ASM1061 Configuration` > `ASMedia Storage Controller` > `Disabled`.
1. `Boot` > `Boot Configuration` > `Fast Boot` > `Disabled`.
1. `Boot` > `Boot Configuration` > `Boot Logo Display` > `Disabled`.
1. `Boot` > `Boot Configuration` > `Bootup NumLock State` > `Off`.
1. `Tool` > `ASUS Armoury Crate` > `Download & Install ARMOURY CRATE app` > `Disabled`.

   > Note: [djdallmann Guide](https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/DOCS/BIOS)
   >
   > Note: [fujitsu Guide](https://sp.ts.fujitsu.com/dmsp/Publications/public/wp-bios-settings-primergy-ww-en.pdf)
   >
   > Note: [congatec Guide](https://www.congatec.com/fileadmin/user_upload/Documents/Application_Notes/AN40_BIOS_Optimization_For_Real-time_Applications.pdf)
