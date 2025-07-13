# Information

- [BIOS Search](#bios-search)
- [BIOS Update](#bios-update)
- [BIOS Settings](#bios-settings)
  - [Asus](#asus)
- [Additional Information](#additional-information)

## BIOS Search

1. PowerShell (Admin):

   ```powershell
   ($Motherboard = Get-CimInstance -ClassName 'Win32_BaseBoard' | Select-Object -ExpandProperty 'Product') | Set-Clipboard; $Motherboard

   ```

1. Paste from clipboard the motherboard model to Google.
1. Use the official manufacter website to download the latest BIOS.

## BIOS Update

1. Insert a USB drive.
1. Format the USB drive as `FAT32`.
1. Move BIOS file to the USB.
1. Boot to BIOS:

   ```powershell
   shutdown /r /fw /t 00

   ```

1. Prefer to update at night hours to avoid sudden power outage.
1. BIOS Update estimated completion time is 8 minutes.
1. Update BIOS Firmware.
1. Press `F1` to enter BIOS setup.
1. Press `F5` to `Reset to Defaults`.

## BIOS Settings

### Asus

| Menu       | Setting                                                                                    | Value        | Notes                 |
| ---------- | ------------------------------------------------------------------------------------------ | ------------ | --------------------- |
| `Advanced` | `Platform Misc Configuration` > `PCI Express Native Power Management`                      | Enabled      | Wake-on-Lan (default) |
| `Advanced` | `Platform Misc Configuration` > `ASPM`                                                     | Disabled     |                       |
| `Advanced` | `CPU Configuration` > `Intel (VMX) Virtualization Technology`                              | Disabled     |                       |
| `Advanced` | `System Agent (SA) Configuration` > `VT-d`                                                 | Disabled     |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `M.2_2 Link Speed`       | Gen4         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `PCIEX16(G5)`            | Gen5         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `M.2_1 Link Speed`       | Gen5         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `PCIEX1(G3) Link Speed`  | Gen3         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `PCIEX16(G3) Link Speed` | Gen3         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `M.2_3 Link Speed`       | Gen4         |                       |
| `Advanced` | `System Agent (SA) Configuration` > `PCI Express Configuration` > `PCIEX16(G4) Link Speed` | Gen4         |                       |
| `Advanced` | `ThunderBolt(TM) Configuration` > `PCIE Tunneling over USB4`                               | Disabled     |                       |
| `Advanced` | `APM Configuration` > `Power On By PCI-E`                                                  | Enabled      | Wake-on-Lan           |
| `Advanced` | `Onboard Devices Configuration` > `Wi-Fi Controller`                                       | Disabled     |                       |
| `Advanced` | `Onboard Devices Configuration` > `Bluetooth Controller`                                   | Disabled     |                       |
| `Advanced` | `Onboard Devices Configuration` > `LED lighting When system is in working state`           | Stealth Mode |                       |
| `Advanced` | `Onboard Devices Configuration` > `ASM1061 Configuration` > `ASMedia Storage Controller`   | Disabled     |                       |
| `Boot`     | `Boot Configuration` > `Fast Boot`                                                         | Disabled     |                       |
| `Boot`     | `Boot Configuration` > `Boot Logo Display`                                                 | Disabled     |                       |
| `Boot`     | `Boot Configuration` > `POST Report`                                                       | 1 sec        |                       |
| `Tool`     | `ASUS Armoury Crate` > `Download & Install ARMOURY CRATE app`                              | Disabled     |                       |

1. Press `F10` to `Save Changes`.

## Additional Information

- [djdallmann Guide](https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/DOCS/BIOS)
- [fujitsu Guide](https://sp.ts.fujitsu.com/dmsp/Publications/public/wp-bios-settings-primergy-ww-en.pdf)
- [congatec Guide](https://www.congatec.com/fileadmin/user_upload/Documents/Application_Notes/AN40_BIOS_Optimization_For_Real-time_Applications.pdf)
