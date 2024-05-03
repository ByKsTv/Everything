# Information

> [!NOTE]
> Everything about BIOS.

## BIOS Update

1. Search the motherboard model on Google.

> [!TIP]
> Motherboard model Can be found on `System Information` > `BaseBoard Product`.

2. Use the official manufacter site to download the latest BIOS.
3. Move BIOS to USB.

> [!NOTE]
> Some motherboard manufacturers require users to rename the BIOS using a renamer included with the downwload.

4. Plug the USB to the motherboard (If exists - to the USB marked as `BIOS`).
5. Boot to BIOS.

> [!TIP]
> Restart to BIOS using CMD (Admin):
>
> ```cmd
> shutdown /r /fw /t 00
>
> ```

6. Update BIOS Firmware.

> [!CAUTION]
> Update PC BIOS at night hours to avoid power loss.

## BIOS Settings

### Asus Motherboard

1. `Ai Tweaker` > `ASUS MultiCore Enhancement` > `Disabled - Enforce All limits`.
1. `Advanced` > `Platform Misc Configuration` > `PCI Express Native Power Management` > `Enabled` (Wake-On-Lan).
1. `Advanced` > `APM Configuration` > `Restore AC Power Loss` > `Power Off`.
1. `Advanced` > `APM Configuration` > `Power On By PCI-E` > `Enabled` (Wake-On-Lan).
1. `Advanced` > `Onboard Devices Configuration` > `Wi-Fi Controller` > `Disabled`.
1. `Advanced` > `Onboard Devices Configuration` > `Bluetooth Controller` > `Disabled`.
1. `Advanced` > `Onboard Devices Configuration` > `LED lighting When system is in working state` > `Stealth Mode`.
1. `Tool` > `ASUS Armoury Crate` > `Download & Install ARMOURY CRATE app` > `Disabled`.
