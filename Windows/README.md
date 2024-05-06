# Information

> [!NOTE]
> Everything about Windows.

## Backup

> [!WARNING]
> Backup everything including usernames, passwords, videos, photos, software, desktop layout, macros, mpv settings, firefox profile folder, app data, wallpaper engine, servers.

## Download

1. Download [Windows 10 Iot Enterprise LTSC 2021](https://massgrave.dev/windows_ltsc_links#win10-iot-enterprise-ltsc-2021).
1. Connect USB with at least 8GB.
1. Download and Open [Rufus](https://github.com/pbatard/rufus/releases/latest) > `SELECT` > .ISO File > `Open` > `START` > Enable all except `Set regional options to the same values as this user's` > `OK` > `OK`.
1. Download Motherboard LAN driver to USB.

> [!TIP]
> Motherboard model can be found on `System Information` > `BaseBoard Product`.

## Pre Installation

1. Power off PC.
1. Disconnect Ethernet Cable.
1. Disconnect Every Hard Drive Except Windows Drive.
1. Boot to UEFI USB (F12/DEL/F11).

> [!TIP]
> Restart to BIOS using CMD (Admin):
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
#Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Step1.ps1 | Invoke-Expression
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Step1.ps1')


```

> [!NOTE]
> Total time to finish initial setup: 45 minutes.

### NVCleanstall

1. Download and Install [NVCleanstall](https://www.techpowerup.com/download/techpowerup-nvcleanstall/) `On this machine` + `Check for updates`.
2. Download [Display Driver Uninstaller](https://www.wagnardsoft.com/display-driver-uninstaller-DDU-) `Portable`.
3. Restart to Safe Mode (Shift+Restart) `Troubleshoot` > `Advanced options` > `Startup Settings` > `Restart` > Disconnect Ethernet Cable > Open Display Driver Uninstaller (Admin) > `OK` > Disable `Show offers from out partners` > Enable `Remove PhysX` > `Close` > `OK` > `---Select device type---` > `GPU` > `Clean and restart`.
4. Open NVCleanstall (Admin) > Connect Ethernet Cable > `Refresh` > `Manually select a driver version` > `Studio` > `Next` > `Recommended` > `Next` > Disable `Installer Telemetry & Advertising` > Enable `Unattended Express Installation` > `Next` > `Install`.

### NVIDIA Control Panel

1. `NVIDIA Control Panel` > `3D Settings` > `Manage 3D settings`:
2. `Texture filtering - Quality` > `High quality`.
3. `Texture filtering - Negative LOD bais` > `Clamp`.
4. `Shader Cache Size` > `Unlimited`.
5. `Power managment mode` > `Perfer maximum performance`.
6. `NVIDIA Control Panel` > `Display` > `Change resolution`:
7. `Output color format` > `YCbCr444` (TV) / `RGB` (Gaming).
8. `Output dynamic range` > `Limited` (TV) / `Full` (Gaming).
9. `Change resolution` > `Output color depth` > `12bpc`.
10. `Adjust desktop size and postion` > `Full-Screen`.

### Sounds

1. Speaker setup > `5.1 (side)`.
2. Default Format > `24 bit, 192000 Hz (Studio Quality)`.

### Drivers

1. Download and Install Motherboard Drivers.

> [!NOTE]
> Download and Install only what's needed such as LAN and Chipset drivers.

### Printers

1. `Settings` > `Devices` > `Printers & scanners` > `Add a printer or scanner` > `The printer that I want isn't listed` > `My printer is a little older. Help me find it.` > `Next`.
2. Select the correct printer > `Next` > `Windows Update`.
3. Select the correct manufacturer > Select the correct printer > `Next` > `Next` > `Next` > `Finish`.
4. To scan pages use `Windows Fax and Scan` software.
5. Set up scan profile.
6. Set up print quality and print size.

> [!NOTE]
> HP Printer: Original Ink Cartridges.

## Extra Software

- [Office](https://github.com/ByKsTv/Everything/tree/main/Windows/Office)
- [7-Zip](https://github.com/ByKsTv/Everything/tree/main/Windows/7Zip)
- [mpv](https://github.com/ByKsTv/Everything/tree/main/Windows/mpv)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp/releases/latest)
- [Razer Synapse](https://www.razer.com/synapse-3)
- [Logitech G HUB](https://www.logitechg.com/en-us/innovation/g-hub.html)
- [HyperX NGENUITY](https://hyperx.com/pages/ngenuity)
- [Discord](https://github.com/ByKsTv/Everything/tree/main/Windows/Discord)
- [qBittorrent](https://github.com/ByKsTv/Everything/tree/main/Windows/qBittorrent)
- [Telegram](https://github.com/ByKsTv/Everything/tree/main/Windows/Telegram)
- [NordVPN](https://github.com/ByKsTv/Everything/tree/main/Windows/NordVPN)
- [AnyDesk](https://anydesk.com/en/downloads)
- [CrystalDiskInfo](https://crystalmark.info/en/download/#CrystalDiskInfo)
- [CrystalDiskMark](https://crystalmark.info/en/download/#CrystalDiskMark)
- [MediaInfo](https://github.com/ByKsTv/Everything/tree/main/Windows/MediaInfo)
- [Python](https://github.com/ByKsTv/Everything/tree/main/Windows/Python)
- [Notepad++](https://github.com/ByKsTv/Everything/tree/main/Windows/Notepad_Plus_Plus)
- [Steam](https://github.com/ByKsTv/Everything/tree/main/Windows/Steam)
- [Microsoft PowerToys](https://github.com/microsoft/PowerToys/releases/latest)
- [Sysinternals](https://learn.microsoft.com/sysinternals/downloads/)
- [Battle.net](https://download.battle.net/?product=bnetdesk)
- [Valorant](https://playvalorant.com/en-us/download/)
- [JitBit Macro Recorder](https://rutracker.org/forum/tracker.php?nm=JitBit)
- [Microsoft Visual Studio](https://rutracker.org/forum/tracker.php?nm=Microsoft%20Visual%20Studio)
- [Microsoft Visual Studio Code](https://code.visualstudio.com/download)
- [Lumion](https://rutracker.org/forum/tracker.php?nm=Lumion)
- [Image-Line - FL Studio](https://rutracker.org/forum/tracker.php?nm=Image-Line%20-%20FL%20Studio)
- [RegistryChangesView](https://www.nirsoft.net/utils/registry_changes_view.html)
- [UAD-ng](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest) - Android Debloater
- HWMonitor Pro [Diakov](https://diakov.net/10934-cpuid-hwmonitor-pro-153-portable.html) / [RuTracker.org](https://rutracker.org/forum/tracker.php?nm=HWMonitor)
- Adobe Acrobat Pro [m0nkrus](https://www.monkrus.ws/) / [RuTracker.org](https://rutracker.org/forum/tracker.php?nm=Adobe%20Acrobat) / [RuTracker.ru](http://rutracker.ru/viewforum.php?f=220)
- [VMware Workstation](https://rutracker.org/forum/tracker.php?nm=VMware%20Workstation) (Download 17.0.2 to avoid [High CPU Usage](https://communities.vmware.com/t5/VMware-Workstation-Pro/High-CPU-usage-by-vmnat-exe-after-upgrade-to-VMware-Workstation/m-p/2992080/highlight/true#M183202))
- [Plex](https://www.plex.tv/media-server-downloads/#plex-media-server)
- [Jellyfin](https://jellyfin.org/downloads/windows)
- [eM Client](https://github.com/ByKsTv/Everything/tree/main/Windows/eM_Client)

## Plex Settings

1. `Got it!`.
2. `Plex Pass` > `X`.
3. `Allow me to access my media outside my home` > Off.
4. `Add Library` > `Movies` > `Language` > `Hebrew` > `Next` > `Browse for media folder` > `Add Library` > `Next` > `Done`.
5. `Settings` > `General` > `Send crash reports to Plex` > Off.
6. `Settings` > `General` > `Support Away Mode when preventing system sleep` > Off.
7. `Settings` > `General` > `Enable Plex Media Server debug logging` > Off.
8. `Settings` > `General` > `Enable Plex Media Server debug logging` > Off.
9. `Settings` > `General` > `Server version updates` > `Automatically during scheduled maintenance` > `Save Changes`.
10. `Settings` > `Library` > `Scan my library automatically` > On.
11. `Settings` > `Library` > `Run a partial scan when changes are detected` > On.
12. `Settings` > `Library` > `Scan my library periodically` > `every 15 minutes` > `Save Changes`.
13. `Settings` > `Network` > `List of IP addresses and networks that are allowed without auth` > `192.168.1.0/24` > `Save Changes`.
14. `Settings` > `Transcoder` > `Transcoder quality` > `Make my CPU hurt`.
15. `Settings` > `Transcoder` > `Background transcoding x264 preset` > `Very slow` > `Save Changes`.
16. `Settings` > `Scheduled Tasks` > `Update all libraries during maintenance` > On > `Save Changes`.
17. [Optional Playback Data](https://www.plex.tv/about/privacy-legal/privacy-preferences/#opd) > `Send playback data to Plex` > Off.

## Jellyfin Settings

1. Use OpenSubtitles Plugin to Auto Download Subtitles Hebrew
