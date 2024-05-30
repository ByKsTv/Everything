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
1. Download Motherboard LAN driver to USB.

   > Note: Motherboard model can be found on `System Information` > `BaseBoard Product`

## Pre Installation

1. Power off PC.
1. Disconnect Ethernet Cable.
1. Disconnect Every Hard Drive Except Windows Drive.
1. Boot to UEFI USB (F12/DEL/F11).

   > Note: Restart to BIOS using CMD (Admin):
   >
   > ```cmd
   > shutdown /r /fw /t 00
   >
   > ```

## Installation

1. `Next` > `Install now` > `I don't have a product key` > `Windows 10 IoT Enterprise LTSC` > `Next` > `I accept the license terms` > `Next` > `Custom: Install Windows only (advanced)` > Delete all > `Next`.
1. `Yes` > `Yes` > `Skip` > `I don't have internet` > `Continue with limited setup`.
1. Connect Ethernet Cable (After Windows Boots Up).
1. `Do you want to allow your PC to be discoverable by other PCs and devices on this network?` > Yes.

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
1. Open NVCleanstall (Admin) > Connect Ethernet Cable > `Refresh` > `Manually select a driver version` > `Studio` > `Next` > `Next` > `Next` > `Use Previous Settings` > `Next` > `Install`.

### NVIDIA Control Panel

1. `NVIDIA Control Panel` > `3D Settings` > `Manage 3D settings`:
1. `Power managment mode` > `Perfer maximum performance`.
1. `NVIDIA Control Panel` > `Display` > `Change resolution`:
1. `Output color format` > `YCbCr444` (TV) / `RGB` (Gaming).
1. `Output dynamic range` > `Limited` (TV) / `Full` (Gaming).
1. `Change resolution` > `Output color depth` > `12bpc`.

### Sounds

1. Speaker setup > `5.1 (side)`.
1. Default Format > `24 bit, 192000 Hz (Studio Quality)`.
1. Enhancements: Disable all.
1. Set default.

### Drivers

1. Download and Install Motherboard Drivers.

   > Note: Download and Install only what's needed such as LAN and Chipset drivers.

### Printers

1. `Settings` > `Devices` > `Printers & scanners` > `Add a printer or scanner` > `The printer that I want isn't listed` > `My printer is a little older. Help me find it.` > `Next`.
1. Select the correct printer > `Next` > `Windows Update`.
1. Select the correct manufacturer > Select the correct printer > `Next` > `Next` > `Next` > `Finish`.
1. To scan pages use `Windows Fax and Scan` software.
1. Set up scan profile.
1. Set up print quality and print size.

   > Note: HP Printer: Only Original Ink Cartridges.

## Extra Software

- [Valorant](https://playvalorant.com/en-us/download/)
- [JitBit Macro Recorder](https://rutracker.org/forum/tracker.php?nm=JitBit)
- [Microsoft Visual Studio](https://rutracker.org/forum/tracker.php?nm=Microsoft%20Visual%20Studio)
- [Lumion](https://rutracker.org/forum/tracker.php?nm=Lumion)
- [Image-Line - FL Studio](https://rutracker.org/forum/tracker.php?nm=Image-Line%20-%20FL%20Studio)
- [RegistryChangesView](https://www.nirsoft.net/utils/registry_changes_view.html)
- HWMonitor Pro [Diakov](https://diakov.net/10934-cpuid-hwmonitor-pro-153-portable.html) / [RuTracker.org](https://rutracker.org/forum/tracker.php?nm=HWMonitor)
- Adobe Acrobat Pro [m0nkrus](http://www.monkrus.ws/) / [RuTracker.org](https://rutracker.org/forum/tracker.php?nm=Adobe%20Acrobat) / [RuTracker.ru](http://rutracker.ru/viewforum.php?f=220)
- [VMware Workstation](https://rutracker.org/forum/tracker.php?nm=VMware%20Workstation) (Download 17.0.2 to avoid [High CPU Usage](https://communities.vmware.com/t5/VMware-Workstation-Pro/High-CPU-usage-by-vmnat-exe-after-upgrade-to-VMware-Workstation/m-p/2992080/highlight/true#M183202))
