# Table Of Contents

- [Television](#television)
  - [Android TV](#android-tv)
    - [Setup](#android-tv---setup)
    - [Apps](#android-tv---apps)
      - [Setup](#android-tv---apps---setup)
    - [Notes](#android-tv---notes)
  - [Samsung](#samsung)
    - [Notes](#samsung-tv---notes)
  - [LG](#lg)
    - [Setup](#lg-tv---setup)
    - [Notes](#lg-tv---notes)
  - [More - TV](#more)
  - [Clean](#clean)
- [Cancel](#cancel)

## Television

### Android TV

#### Android TV - Setup

1. TODO

#### Android TV - Apps

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

#### Android TV - Apps - Setup

1. Open `UniFi Protect` > Login using QR Code
1. Install `SmartTube`:

   ```bash
   adb install SmartTube_stable_27.37_arm64-v8a.apk
   ```

1. Open `SmartTube` > Restore settings using file (TODO)
1. Open `Netflix` > Login
1. Install `Spotify`:

   ```bash
   adb install Spotify+-+Music+and+Podcasts_1.91.8_mod.apk
   ```

1. Open `Spotify` > Login
1. Open `Plex` > [Link TV](https://www.plex.tv/link/)
1. Plex > Settings TODO
1. Open `UAD-ng`

#### Android TV - Notes

- When using `UAD-ng` - Don't uninstall the following:

  - `com.google.android.tv.remote.service` - Android TV Remote Service.
  - `com.netflix.ninja` - Netflix.
  - A Package on the `Recommended` list - Disconnects the WiFi.
  - A Package on the `Recommended` list - Can't control TV from Google Home.

- TCL has issues playing Next TV channels, zoom-in when selecting a channel, temporary fix is the toggle overscan picture settings, but when chagning to different channel this fix needs to be re-applaied.

### Samsung

#### Samsung TV - Update

1. `Settings` > `Support` > `Software Update` > `Update Now`.

   > Update TV Firmware at night hours to avoid power loss.
   >
   > Update takes 1 minute and 25 seconds.

#### Samsung TV - Initial Setup

| Menu                                  | Setting              | Value                      | Notes                              |
| ------------------------------------- | -------------------- | -------------------------- | ---------------------------------- |
| Settings -> General                   | Reset                | 0000                       | Factory reset, duration 20 seconds |
| SmartThings                           |                      | Left                       | Pairs remote control to the TV     |
| SmartThings                           |                      | Left                       | Next                               |
| Connection Guide                      |                      | Left                       | Next                               |
| WiFi                                  |                      | Left                       | Skip                               |
| Source                                |                      | No signal                  |                                    |
| Summery                               |                      | Left                       | Next                               |
| Smart Mode                            |                      | Left                       | Skip                               |
| Tap View                              |                      | Left                       | Next                               |
| Remote Control Test                   |                      | Left                       | Skip                               |
| Ready To Use                          |                      | Left                       | Next                               |
| Settings -> General -> System Manager | Language             | English                    |                                    |
| Settings -> General -> System Manager | Auto Protection Time | Off                        |                                    |
| Source                                |                      | Switch to the current HDMI |                                    |
| Source                                | Edit                 | Blu-ray player             |                                    |

#### Samsung TV - SDR Setup

| Menu                                                               | Setting                      | Value          | Notes                                                                                    |
| ------------------------------------------------------------------ | ---------------------------- | -------------- | ---------------------------------------------------------------------------------------- |
| Settings -> Picture                                                | Picture Mode                 | FILMMAKER MODE |                                                                                          |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Picture Clarity              | Custom         |                                                                                          |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Blur Reduction               | 0              |                                                                                          |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Judder Reduction             | 0              |                                                                                          |
| Settings -> Picture -> Expert Settings                             | Local Dimming                | Low            | Default value `Standard` clips whites on `AVS HD 709` and flickering on black background |
| Settings -> General -> External Device Manager                     | Input Signal Plus            | Current HDMI   | Enables 4k60p                                                                            |
| Settings -> General -> Eco Solution                                | Ambient Light Detection      | Off            |                                                                                          |
| Settings -> General -> Smart Features                              | Autorun Smart Hub            | Off            |                                                                                          |
| Settings -> General -> Smart Features                              | Autorun Last App             | Off            |                                                                                          |
| Settings -> General -> Smart Features                              | Autorun Multi View Mirroring | Off            |                                                                                          |
| Settings -> General -> Smart Features                              | Autorun Multi View Casting   | Off            |                                                                                          |

#### Samsung TV - HDR Setup

| Menu                                                               | Setting          | Value  | Notes       |
| ------------------------------------------------------------------ | ---------------- | ------ | ----------- |
|                                                                    |                  |        | Enable HDR  |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Picture Clarity  | Custom |             |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Blur Reduction   | 0      |             |
| Settings -> Picture -> Expert Settings -> Picture Clarity Settings | Judder Reduction | 0      |             |
| Settings -> Picture -> Expert Settings                             | Local Dimming    | Low    |             |
|                                                                    |                  |        | Disable HDR |

#### Samsung TV - Game mode Setup

| Menu                                                                 | Setting           | Value | Notes              |
| -------------------------------------------------------------------- | ----------------- | ----- | ------------------ |
| Settings                                                             | Game Mode         | On    | Enables Game Mode  |
| Settings -> General -> External Device Manager -> Game Mode Settings | Surround Sound    | Off   |                    |
| Settings -> Picture -> Expert Settings                               | Sharpness         | 0     |                    |
| Settings -> Picture -> Expert Settings                               | Local Dimming     | Low   |                    |
| Settings -> Picture -> Expert Settings                               | Contrast Enhancer | Off   |                    |
| Settings                                                             | Game Mode         | Off   | Disables Game Mode |

#### Samsung TV - Notes

- Uses TizenOS instead of Android, so you can't sideload APKs.
- Panning shot issue where the first frame of the panning shot will be stuck.
- Can't turn off the bluethooth even if the TV is only used as a monitor.
- [Firmware Update Changelog](https://eu.community.samsung.com/t5/tv/tv-firmware-changelogs-on-german-community/td-p/1846870)

### LG

#### LG TV - Setup

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

#### LG TV - Notes

- Uses webOS instead of Android, so you can't sideload APKs.

### More

- Most TVs have a network (RJ45) port limited to 100Mbps. To get faster speeds, you can use a USB-to-Ethernet adapter:

  - Buy a USB 3.0 to RJ45 adapter (1000Mbps).
  - Do not buy a USB 2.0 to RJ45 adapter (100Mbps).
  - Disable USB Debugging if enabled to make the adapter work.
  - Samsung and Haier TVs don't work with USB-to-Ethernet adapters.

- Most TVs are not Android-based (LG / Samsung / older TVs). To get Android apps, you can use a Android streaming device:

  - Google TV Streamer 4K
  - Xiaomi TV Box S 3rd Gen 4K

- Cable TV is outdated. Providers now sell a bundle that includes:

  - Router (Internet + WiFi) – rented monthly.
    - Instead - Buy your own (Recommended: Ubiquiti), choose the best CPU and highest GHz.
  - Android TV box (with their app) – rented monthly.
    - Instead - Buy your own (Recommended: Google TV Streamer 4K).
  - Access to channels via their app – monthly fee.
    - Instead - Subscribe directly (same as Netflix).

- Consider mounting the TV at an angle (up/down) so that if there's a dead pixel it won't bother you since it will be hidden by nearby pixels.

- Local dimming has a big downside which is the latency is a variable depending on the content, which may cause video to be out of sync with the audio.
- Haier TV do not auto power on after a power outage https://www.haier.com/my/service-support/self-service/20250402_259024.shtml

### Clean

- Do not use paper towel.
- Plug off power cable.
- Buy 2 Microfiber towels.
- Wet one with a bit of distilled water and ring it.
- Gently wipe the screen.
- Dry with the dry microfiber towel.

## Cancel

- Use [Netek](https://www.netek.co.il/)

- Next TV - you will have to contact their WhatsApp support team (3), and request to cancel, they will call you back within 2 working days.
