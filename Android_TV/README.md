# Information

Everything about Android TV apps.

## Android TV Apps

| Name                     | Links                                                                                                                 | Mod to download    |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- | ------------------ |
| UniFi Protect            | [Google Play](https://play.google.com/store/apps/details?id=com.ubnt.unifi.protect)                                   |                    |
| SmartTube                | [GitHub](https://github.com/yuliskov/SmartTube/releases/latest)                                                       |                    |
| Netflix                  | [Google Play](https://play.google.com/store/apps/details?id=com.netflix.mediaclient)                                  |                    |
| Spotify                  | [4pda](https://4pda.to/forum/index.php?showtopic=248440#Spoil-8030514-11)                                             | Android TV         |
| Plex: Stream Movies & TV | [Google Play](https://play.google.com/store/apps/details?id=com.plexapp.android)                                      |                    |
| Kan11                    | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.il.ch1)                                   |                    |
| N12                      | [Google Play](https://play.google.com/store/apps/details?id=com.channel2.mobile.ui)                                   |                    |
| Reshet 13                | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.iReshet)                                  |                    |
| TV Bro                   | [Google Play](https://play.google.com/store/apps/details?id=com.phlox.tvwebbrowser)                                   |                    |
| UAD-ng                   | [GitHub](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest) | uad-ng-windows.exe |

## Setting each app

### UniFi Protect

1. Login using QR Code

### SmartTube

```bash
adb install SmartTube_stable_27.37_arm64-v8a.apk
```

1. Restore settings using file

### Netflix

1. Login

### Spotify

```bash
adb install Spotify+-+Music+and+Podcasts_1.91.8_mod.apk
```

1. Login

### Plex

1. [Link TV](https://www.plex.tv/link/)
1. Change some settings (TODO)

### Kan11

Known issue with Pi-Hole is no connection pop up shows up when first watching live

## UAD-ng

Don't uninstall the following:

1. `com.google.android.tv.remote.service` - Android TV Remote Service
1. `com.netflix.ninja` - Netflix

Some random package on the `Recommended` list once removed it disconnects the WiFi
Also another package when removed doesn't show up the TV on Google Home anymore
