# Table Of Contents

- [Backup](#backup)
- [Download ISO](#download-iso)
- [Pre Installation](#pre-installation)
- [Installation](#installation)
- [Software Selection](#software-selection)
- [NVCleanstall](#nvcleanstall)
- [NVIDIA Control Panel](#nvidia-control-panel)
- [Sounds](#sounds)
- [Printers](#printers)
- [Reset Password to Windows 10 Local Account](#reset-password-to-windows-10-local-account)

## Backup

Usernames, passwords, videos, photos, files, software, desktop layout, macros, mpv settings, chrome sync turn on, firefox profile folder, app data, quick access pinned items, ublock filters.

## Download ISO

1. Connect USB with at least 8GB.

   > Make sure there's only 1 USB connected.

1. Select which ISO to download:

   Windows 10 IoT Enterprise LTSC 2021 - PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_10_IoT_Enterprise_LTSC_2021/ISO.ps1')

   ```

   Windows 11 IoT Enterprise LTSC 2024 - PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_11_IoT_Enterprise_LTSC_2024/ISO.ps1')

   ```

   Windows Server 2025 Datacenter - PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_Server_2025_Datacenter/ISO.ps1')

   ```

1. `START` > Uncheck every box > `OK` > `OK` > When finished close the program.
1. A folder called `Drivers` has been opened, download and extract all of your motherboard drivers to this folder.
1. To find which motherboard is installed - PowerShell (Admin):

   ```powershell
   Set-Clipboard ($Motherboard=(Get-CimInstance Win32_BaseBoard).Product);$Motherboard

   ```

## Pre Installation

1. Power off PC.
1. Disconnect Every Hard Drive Except Windows Drive.
   > This is to ensure you don't delete data from other drives, but if you know which drive partition belongs to which drive then you don't have to.
1. Boot to UEFI USB (DEL/F12/F11).

   > Restart to BIOS - CMD (Admin):
   >
   > ```cmd
   > shutdown /r /fw /t 00
   >
   > ```

1. `Boot` > `Boot Override` > `UEFI`

## Installation

1. `Delete` all partitions from the drive you want to install windows on > `Next`.
   > If drives not found - Use `Load Driver` and extract `Intel Rapid Storage Technology (IRST)` driver matching to the motherboard.

## Software Selection

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Software_Selection.ps1')

   ```

### NVCleanstall

1. Restart to Safe Mode (SHIFT+RESTART) `Troubleshoot` > `Advanced options` > `Startup Settings` > `Restart` > `Safe mode` (4) > Open Display Driver Uninstaller > `---Select device type---` > `GPU` > `Clean and restart`.
1. Open NVCleanstall > `Manually select a driver version` > `Studio` > `Next` > `Recommended` > `Next` > `Use Previous Settings` > `Next` > `Install` > Restart.

### NVIDIA Control Panel

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/nvidiaProfileInspector/Download.ps1')

   ```

1. `Display` > `Change resolution` > `Output color format` > `YCbCr444` (TV) / `RGB` (Gaming) > `Output dynamic range` > `Limited` (TV) / `Full` (Gaming) > `Output color depth` > `12bpc`.

### Sounds

1. `Sounds`: `Playback`: Select Device: Set default.
1. `Sounds`: `Playback`: Select Device: `Configure Speakers`: `5.1 Surround (Side)`.
1. `Sounds`: `Playback`: Select Device: `Properties`: `Advanced`: Default Format: `24 bit, 192000 Hz (Studio Quality)`.

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
