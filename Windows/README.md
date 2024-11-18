# Information

Everything about Windows.

## Backup

Usernames, passwords, videos, photos, files, software, desktop layout, macros, mpv settings, chrome sync turn on, firefox profile folder, app data.

## Download ISO

1. Connect USB with at least 8GB.
   > Make sure there's only 1 USB connected.
1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/ISO.ps1')

   ```

1. `START` > Uncheck every box > `OK` > `OK` > When finished close the program.
1. Download LAN drivers matching the motherboard to the USB.
1. Download Chipset drivers matching the motherboard to the USB.
1. Download Serial IO drivers matching the motherboard to the USB.
   > Find Motherboard - PowerShell (Admin):
   >
   > ```powershell
   > (wmic baseboard get product)
   >
   > ```
   >
   > [Update BIOS](https://github.com/ByKsTv/Everything/tree/main/BIOS).

## Pre Installation

1. Power off PC.
1. Disconnect Ethernet Cable.
1. Disconnect Every Hard Drive Except Windows Drive.
   > This is to ensure you don't delete data from other drives, but if you know which drive partition belongs to which drive then you don't have to.
1. Boot to UEFI USB (F12/DEL/F11).
   > Restart to BIOS - CMD (Admin):
   >
   > ```cmd
   > shutdown /r /fw /t 00
   >
   > ```

## Installation

1. `Delete all` > `Next`.
   > If drives not found - Use `Load Driver` and extract `Intel Rapid Storage Technology (IRST)` driver matching to the motherboard.
1. Add a name.
1. Don't use password.
1. Connect Ethernet Cable (After Windows Boots Up).
   > If there's no internet connection - install LAN driver.
1. `Do you want to allow your PC to be discoverable by other PCs and devices on this network?` > `Yes`.

## Drivers

1. Install LAN drivers matching the motherboard from the USB.
1. Install Chipset drivers matching the motherboard from the USB.
1. Install Serial IO drivers matching the motherboard from the USB.

## Initial Setup - Auto Install

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Step1.ps1')

   ```

## Software Selection

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')

   ```

### NVCleanstall

1. Restart to Safe Mode (SHIFT+RESTART) `Troubleshoot` > `Advanced options` > `Startup Settings` > `Restart` > `Safe mode` (4) > Disconnect Ethernet Cable > Open Display Driver Uninstaller (Admin) > `---Select device type---` > `GPU` > `Clean and restart`.
1. Open NVCleanstall (Admin) > Connect Ethernet Cable > `Refresh` > `Manually select a driver version` > `Studio` > `Next` > `Recommended` > `Next` > `Use Previous Settings` > `Next` > `Install` > Restart.

### NVIDIA Control Panel

1. `3D Settings` > `Manage 3D settings` > `Power managment mode` > `Perfer maximum performance`.
1. `Display` > `Change resolution` > `Output color format` > `YCbCr444` (TV) / `RGB` (Gaming) > `Output dynamic range` > `Limited` (TV) / `Full` (Gaming) > `Output color depth` > `12bpc`.

### Sounds

1. `Sounds`: `Playback`: Select Device: Set default.
1. `Sounds`: `Playback`: Select Device: `Configure Speakers`: `5.1 Surround (Side)`.
1. `Sounds`: `Playback`: Select Device: `Properties`: `Advanced`: Default Format: `24 bit, 192000 Hz (Studio Quality)`.
1. `Sounds`: `Playback`: Select Device: `Properties`: `Enhancements`: Disable all.

### Printers

1. `Settings` > `Devices` > `Printers & scanners` > `Add a printer or scanner` > `The printer that I want isn't listed` > `My printer is a little older. Help me find it.` > `Next`.
1. Select the correct printer > `Next` > `Windows Update`.
1. Select the correct manufacturer > Select the correct printer > `Next` > `Next` > `Next` > `Finish`.
1. To scan pages use `Windows Fax and Scan` software.
1. Set up scan profile.
1. Set up print quality and print size.

   > Note: HP Printer: Only Original Ink Cartridges.

### Reset Password to Windows 10 Local Account

1. Connect USB with Windows Installation to the PC.
1. Boot to UEFI USB (F12/DEL/F11).
1. `Next` > `Repair your computer` > `Troubleshoot` > `Command Prompt`

   ```cmd
   C:
   cd Windows
   cd System32
   rename osk.exe osk.old
   copy cmd.exe osk.exe
   shutdown /r /t 00
   ```

1. `Ease of Access` > `On-Screen Keyboard`

   ```cmd
   control userpasswords2
   ```

1. `Reset Password...` > `OK`

1. Boot to UEFI USB (F12/DEL/F11).
1. `Next` > `Repair your computer` > `Troubleshoot` > `Command Prompt`

   ```cmd
   C:
   cd Windows
   cd System32
   del osk.exe
   rename osk.old osk.exe
   shutdown /r /t 00
   ```
