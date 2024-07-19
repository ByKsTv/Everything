# Information

Everything about Windows.

## Backup

Usernames, passwords, videos, photos, files, software, desktop layout, macros, mpv settings, firefox profile folder, app data.

## Download

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/ISO.ps1')

   ```

1. Connect USB with at least 8GB.
1. `START` > Enable all except `Set regional options to the same values as this user's` > `OK` > `OK`.
1. Download Motherboard LAN driver, Chipset drivers and Intel(R) Rapid Storage Technology to USB.

> Copy the initial setup powershell command to text file on the USB.
> Find Motherboard Model - PowerShell (Admin):
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
1. Boot to UEFI USB (F12/DEL/F11).

> Restart to BIOS - CMD (Admin):
>
> ```cmd
> shutdown /r /fw /t 00
>
> ```

## Installation

1. `Next` > `Install now` > `I don't have a product key` > `Windows 10 IoT Enterprise LTSC` > `Next` > `I accept the license terms` > `Next` > `Custom: Install Windows only (advanced)` > Delete all > `Next`.
   > If drives not found - Extract `Intel Rapid Storage Technology (IRST)` driver matching to the motherboard.
1. `Yes` > `Yes` > `Skip` > `I don't have internet` > `Continue with limited setup`.
1. Connect Ethernet Cable (After Windows Boots Up).
1. `Do you want to allow your PC to be discoverable by other PCs and devices on this network?` > Yes.
1. Install Motherboard LAN driver, Chipset drivers and Intel(R) Rapid Storage Technology from USB.

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

1. Restart to Safe Mode (SHIFT+RESTART) `Troubleshoot` > `Advanced options` > `Startup Settings` > `Restart` > Disconnect Ethernet Cable > Open Display Driver Uninstaller (Admin) > `---Select device type---` > `GPU` > `Clean and restart`.
1. Open NVCleanstall (Admin) > Connect Ethernet Cable > `Refresh` > `Manually select a driver version` > `Studio` > `Next` > `Recommended` > `Next` > `Use Previous Settings` > `Next` > `Install`.

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
