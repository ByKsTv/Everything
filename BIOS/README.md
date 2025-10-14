# Table Of Contents

- [Search](#search)
- [Update](#update)
- [Settings](#settings)
  - [Asus](#asus)
- [Additional Information](#additional-information)

## Search

1. PowerShell (Admin):

   ```powershell
   Set-Clipboard ($Motherboard=(Get-CimInstance Win32_BaseBoard).Product);$Motherboard

   ```

1. Paste from clipboard the motherboard model to Google.
1. Use the offical manufacter website to download the latest BIOS.

## Update

1. Insert a USB drive.
1. Format the USB drive as `FAT32`.
1. Move BIOS file to the USB.
1. Boot to BIOS:

   ```bat
   shutdown /r /fw /t 00

   ```

1. Prefer to update at night hours to avoid sudden power outage.
1. BIOS Update estimated completion time is 8 minutes.
1. Update BIOS Firmware.
1. Press `F1` to enter BIOS setup.
1. Press `F5` to `Reset to Defaults`.

## Settings

### Asus

| Menu     | Setting                                                                      | Value             | Notes       |
| -------- | ---------------------------------------------------------------------------- | ----------------- | ----------- |
| Advanced | Platform Misc Configuration > PCI Express Native Power Management            | Disabled          |             |
| Advanced | Platform Misc Configuration > ASPM                                           | Disabled          |             |
| Advanced | APM Configuration > Power On By PCI-E                                        | Enabled           | Wake-on-Lan |
| Advanced | Onboard Devices Configuration > Wi-Fi Controller                             | Disabled          |             |
| Advanced | Onboard Devices Configuration > Bluetooth Controller                         | Disabled          |             |
| Advanced | Onboard Devices Configuration > LED lighting When system is in working state | Stealth Mode      |             |
| Boot     | Secure Boot > OS Type                                                        | Windows UEFI mode |             |
| Boot     | Secure Boot > Secure Boot Mode                                               | Standard          |             |
| Boot     | Boot Configuration > Fast Boot                                               | Disabled          |             |
| Boot     | Boot Configuration > Boot Logo Display                                       | Disabled          |             |
| Boot     | Boot Configuration > POST Report                                             | 1 sec             |             |
| Tool     | ASUS Armoury Crate > Download & Install ARMOURY CRATE app                    | Disabled          |             |

1. Press `F10` to `Save Changes`.

## Additional Information

- [djdallmann Guide](https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/DOCS/BIOS)
- [fujitsu Guide](https://sp.ts.fujitsu.com/dmsp/Publications/public/wp-bios-settings-primergy-ww-en.pdf)
- [congatec Guide](https://www.congatec.com/fileadmin/user_upload/Documents/Application_Notes/AN40_BIOS_Optimization_For_Real-time_Applications.pdf)
