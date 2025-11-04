# Table Of Contents

- [Find Motherboard Model](#find-motherboard-model)
- [Update BIOS](#update-bios)
- [BIOS Settings](#bios-settings)
  - [Asus motherboard](#asus-motherboard)
- [Additional Information](#additional-information)

## Find Motherboard Model

1. PowerShell:

   ```powershell
   Set-Clipboard ($Motherboard=(Get-CimInstance Win32_BaseBoard).Product);$Motherboard

   ```

   > This will output the motherboard model and copy it to the clipboard.

1. Paste the motherboard model to Google.
1. Use the offical manufacturer website to download the latest BIOS.

## Update BIOS

> [!TIP]
> Do not update during daytime.
>
>
> [!NOTE]
> Duration of BIOS Update is 8 minutes.

1. Insert a USB drive.
1. Format the USB drive as `FAT32`.
1. Move BIOS file to the USB.
1. Safely Eject the USB.
   > Taskbar -> USB Icon -> Right Click -> `Eject`.
1. Boot to BIOS (PowerShell/CMD):

   ```bat
   shutdown /r /fw /t 00

   ```

1. Update BIOS Firmware.
   > Asus motherboard: `Tool` -> `Asus EZ Flash 3 Utility` -> Select storage device -> Select BIOS file -> `Yes`.
1. Press `F1` to enter BIOS setup.
1. Press `F5` to `Reset to Defaults`.

## BIOS Settings

### Asus motherboard

| Menu     | Setting                                                                       | Value             | Notes       |
| -------- | ----------------------------------------------------------------------------- | ----------------- | ----------- |
| Advanced | Platform Misc Configuration -> PCI Express Native Power Management            | Disabled          |             |
| Advanced | Platform Misc Configuration -> ASPM                                           | Disabled          |             |
| Advanced | APM Configuration -> Power On By PCI-E                                        | Enabled           | Wake-on-Lan |
| Advanced | Onboard Devices Configuration -> Wi-Fi Controller                             | Disabled          |             |
| Advanced | Onboard Devices Configuration -> Bluetooth Controller                         | Disabled          |             |
| Advanced | Onboard Devices Configuration -> LED lighting When system is in working state | Stealth Mode      |             |
| Boot     | Secure Boot -> OS Type                                                        | Windows UEFI mode |             |
| Boot     | Secure Boot -> Secure Boot Mode                                               | Standard          |             |
| Boot     | Boot Configuration -> Fast Boot                                               | Disabled          |             |
| Boot     | Boot Configuration -> Boot Logo Display                                       | Disabled          |             |
| Boot     | Boot Configuration -> POST Report                                             | 1 sec             |             |
| Tool     | ASUS Armoury Crate -> Download & Install ARMOURY CRATE app                    | Disabled          |             |
|          | Press `F10` to `Save Changes`                                                 |                   |             |

## Additional Information

- [djdallmann](https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/DOCS/BIOS)
- [fujitsu](https://sp.ts.fujitsu.com/dmsp/Publications/public/wp-bios-settings-primergy-ww-en.pdf)
- [congatec](https://www.congatec.com/fileadmin/user_upload/Documents/Application_Notes/AN40_BIOS_Optimization_For_Real-time_Applications.pdf)
