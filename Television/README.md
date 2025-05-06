# Information

- [Android TV](#android-tv)
  - [Setup](#android-tv---setup)
  - [Apps](#android-tv---apps)
  - [Apps Settings](#android-tv---apps-settings)
  - [Notes](#android-tv---notes)
- [Samsung](#samsung)
  - [Setup](#samsung-tv---setup)
  - [Notes](#samsung-tv---notes)
- [LG](#lg)
  - [Setup](#lg-tv---setup)
  - [Notes](#lg-tv---notes)
- [More](#more)

## Android TV

### Android TV - Setup

1. TODO

### Android TV - Apps

| Name                     | Links                                                                                                                 | Mod to download    |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- | ------------------ |
| UniFi Protect            | [Google Play](https://play.google.com/store/apps/details?id=com.ubnt.unifi.protect)                                   |                    |
| NEXT TV                  | [Google Play](https://play.google.com/store/apps/details?id=com.hotnext)                                              |                    |
| SmartTube                | [GitHub](https://github.com/yuliskov/SmartTube/releases/latest)                                                       |                    |
| Netflix                  | [Google Play](https://play.google.com/store/apps/details?id=com.netflix.mediaclient)                                  |                    |
| Spotify                  | [4pda](https://4pda.to/forum/index.php?showtopic=248440#Spoil-8030514-11)                                             | Android TV         |
| Plex: Stream Movies & TV | [Google Play](https://play.google.com/store/apps/details?id=com.plexapp.android)                                      |                    |
| Kan11                    | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.il.ch1)                                   |                    |
| N12                      | [Google Play](https://play.google.com/store/apps/details?id=com.channel2.mobile.ui)                                   |                    |
| Reshet 13                | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.iReshet)                                  |                    |
| TV Bro                   | [Google Play](https://play.google.com/store/apps/details?id=com.phlox.tvwebbrowser)                                   |                    |
| UAD-ng                   | [GitHub](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest) | uad-ng-windows.exe |

### Android TV - Apps Settings

1. Open `UniFi Protect` > Login using QR Code
1. Install `SmartTube`:

   ```bash
   adb install SmartTube_stable_27.37_arm64-v8a.apk
   ```

1. Open `SmartTube` > Restore settings using file
1. Open `Netflix` > Login
1. Install `Spotify`:

   ```bash
   adb install Spotify+-+Music+and+Podcasts_1.91.8_mod.apk
   ```

1. Open `Spotify` > Login
1. Open `Plex` > [Link TV](https://www.plex.tv/link/)
1. Plex > Settings TODO
1. Open `UAD-ng`

### Android TV - Notes

- When using `UAD-ng` - Don't uninstall the following:
  - `com.google.android.tv.remote.service` - Android TV Remote Service
  - `com.netflix.ninja` - Netflix
    Some random package on the `Recommended` list once removed it disconnects the WiFi
    Also another package when removed doesn't show up the TV on Google Home anymore
- When using `Pi-Hole` and `Kan11` Android TV app - a pop-up will say "No Connection" when first watching live.

## Samsung

### Samsung TV - Setup

1. `Settings` > `Support` > `Software Update` > `Update Now`.

   > Update TV Firmware at night hours to avoid power loss.
   >
   > Update takes 1 minute and 25 seconds.
   >
   > [Firmware Update Changelog](https://eu.community.samsung.com/t5/tv/tv-firmware-changelogs-on-german-community/td-p/1846870)

1. `Settings` > `General` > `Reset` > `0000` > `Reset`
1. (SmartThings Setup) Remote Control > Left arrow > Left arrow.
1. (Connection Guide Setup) `Next`.
1. (WiFi Setup) `Skip` > `Skip`.
1. (Source Setup) `No signal` > `Next`.
1. (Smart Mode Setup) `Skip`.
1. `Skip`
1. (Tap View Setup) `Next`.
1. (Remote Control Testing Setup) > `Skip`.
1. (TV Ready To Use Setup) `Finish`.
1. `Settings` > `General` > `System Manager` > `Language` > `English`.
1. `Settings` > `General` > `System Manager` > `Auto Protection Time` > `Off`.
1. `Source` > Switch to the current HDMI source.
1. `Source` > `Edit` > `Blu-ray player` > `Ok`.
1. `Settings` > `Picture` > `Picture Mode` > `FILMMAKER MODE`.
1. `Settings` > `Picture` > `Expert Settings` > `Picture Clarity Settings` > `Custom` > `Blur Reduction: 0` > `Judder Reduction: 0`.
1. `Settings` > `General` > `External Device Manager` > `Anynet+ (HDMI-CEC)` > `Off`.
1. `Settings` > `General` > `External Device Manager` > `Input Signal Plus` > Select current HDMI > `Close`.
1. `Settings`> `General` > `Eco Solution` > `Ambient Light Detection` > `Off`
1. `Settings` > `General` > `Smart Features` > `Autorun Smart Hub: Off` > `Autorun Last App: Off` > `Autorun Multi View Casting: Off`.
1. Enable HDR in Windows.
1. `Settings` > `Picture` > `Expert Settings` > `Picture Clarity Settings` > `Custom` > `Blur Reduction: 0` > `Judder Reduction: 0`.
1. Disable HDR in Windows.
1. Enable Game Mode.
1. `Settings` > `General` > `External Device Manager` > `Game Mode Settings` > `On`
1. `Surround Sound` > `Off`

### Samsung TV - Notes

- Uses TizenOS instead of Android, so you can't sideload APKs.
- Panning shot issue where the first frame of the panning shot will be stuck.

## LG

## LG TV - Setup

1. `Settings` > `Picture` > `Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `White Balance` > `Colour Temperature` > `Warm 50` (2024-) / `Warm 40` (2025+)`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `Color Gamut` > `Auto Detect`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Super Resolution` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Noise Reduction` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `MPEG Noise Reduction` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Smooth Gradation` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Real Cinema` > `On`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `TruMotion` > `Off`
1. `Settings` > `Picture` > `Select Mode` > `1113111` > `EOTF` > `ST2084`
1. `Settings` > `Picture` > `HDR Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `White Balance` > `Colour Temperature` > `Warm 50` (2024-) / `Warm 40` (2025+)`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Smooth Gradation` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Real Cinema` > `On`
1. `Settings` > `Picture` > `Select Mode` > `1113111` > `EOTF` > `AUTO`
1. Open `Netflix` > Play `Dolby Vision` Content > Pause Video
1. `Settings` > `Picture` > `Dolby Vision Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `General` > `System` > `Additional Settings` > `Settings Help` > `Off`
1. `Settings` > `General` > `Enegry Saving` > `Energy Saving Step` > `Off`

Source: [𝗟𝗚 𝗢𝗟𝗘𝗗 𝗧𝗩 𝗦𝗲𝘁𝘁𝗶𝗻𝗴𝘀 𝗧𝗵𝗲 𝗣𝗿𝗼𝘀 𝗨𝘀𝗲: SDR, HDR & Dolby Vision](https://www.youtube.com/watch?v=YQ9E7RK0gDM)

### LG TV - Notes

- Uses webOS instead of Android, so you can't sideload APKs.

## More

- Most TVs have a network (RJ45) port limited to 100Mbps. To get faster speeds, you can use a USB-to-Ethernet adapter:

  - If your TV has a USB 3.0 port - Buy a USB 3.0 to RJ45 adapter.
  - If your TV has a USB 2.0 port - Buy a USB 2.0 to RJ45 adapter.

- Most TVs are not Android-based (LG / Samsung / older TVs). To get Android apps, you can use a Android streaming device:

  - Google TV Streamer 4K
  - Xiaomi TV Box S 3rd Gen 4K

- Cable TV is outdated. Providers now sell a bundle that includes:

  - Router (Internet + WiFi) – rented monthly.
    - Instead - Buy your own (Recommended: Ubiquiti).
  - Android TV box (with their app) – rented monthly
    - Instead - Buy your own (Recommended: Google TV Streamer 4K).
  - Access to channels via their app – monthly fee.
    - Instead - Subscribe directly (same as Netflix).
