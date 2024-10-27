# Information

Everything about Android apps.

## APKs

- [4pda](https://4pda.to/forum/index.php?showforum=212)
- [mobilism](https://forum.mobilism.me/viewforum.php?f=398)

## Android Apps

- [UAD-ng](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest) - Android Debloater
- [Mull](https://f-droid.org/packages/us.spotco.fennec_dos/) - Firefox mobile browser
- [Nova Launcher](https://4pda.to/forum/index.php?act=findpost&pid=10706661&anchor=Spoil-10706661-8) - Prime by Balatan
- [Sesame Shortcuts](https://4pda.to/forum/index.php?showtopic=921566#entry77882334) - Search add-ons for Nova Launcher
- ~~[WhatsApp](https://4pda.to/forum/index.php?showtopic=186375#Spoil-5125511-12) - FouadWhatsApp~~ + [Contacts Sync (requires ROOT)](https://play.google.com/store/apps/details?id=com.lb.contacts_sync)
- [Friendly for Facebook](https://4pda.to/forum/index.php?showtopic=819152&view=findpost&p=60515623) - Premium by Balatan
- [YouTube ReVanced](https://4pda.to/forum/index.php?showtopic=1050118&view=findpost&p=115638129) + [GmsCore](https://github.com/microg/GmsCore/releases/latest)
- [Spotify](https://4pda.to/forum/index.php?act=findpost&pid=8030514&anchor=Spoil-8030514-11) - Mod Lite by Balatan.
- [Truecaller](https://4pda.to/forum/index.php?showtopic=417409#Spoil-18455027-5) - Mod by Balatan
- [Wheres My Droid](https://forum.mobilism.me/search.php?keywords=Wheres+My+Droid&sr=topics&sf=titleonly)
- [Instagram](https://4pda.to/forum/index.php?showtopic=326697#Spoil-12392478-7) - AeroInsta
- [FX File Explorer](https://4pda.to/forum/index.php?showtopic=268117#entry9048468) - Plus/Root by Balatan
- [aRDP](https://4pda.to/forum/index.php?showtopic=658880#entry39545784)
- [Adobe Acrobat Reader](https://4pda.to/forum/index.php?showtopic=171588#Spoil-4535663-3) - Pro by Derrin
- [FolderSync](https://4pda.to/forum/index.php?showtopic=258965#Spoil-8586413-7) - Mod Lite by Number one
- [Network Analyzer](https://4pda.to/forum/index.php?showtopic=969002&view=findpost&p=89769375)
- [Shazam](https://4pda.to/forum/index.php?showtopic=128657#Spoil-2955496-4) - Mod by Balatan
- [Google Camera](https://www.celsoazevedo.com/files/android/google-camera/links/) - Use official telegram groups instead.
- [Lockwatch](https://4pda.to/forum/index.php?showtopic=677900#entry41610679)
- [Deliveries Package Tracker](https://4pda.to/forum/index.php?showtopic=805869#entry58797224)
- [Vocalizer](https://4pda.to/forum/index.php?showtopic=987292#apk) - Latest [3.8.2](https://4pda.to/forum/index.php?showtopic=987292&view=findpost&p=132720887)
- [MacroDroid](https://4pda.to/forum/index.php?act=findpost&pid=15401143) - Pro by Balatan
- Moovit: Bus & Train Schedules - [4pda](https://4pda.to/forum/index.php?act=findpost&pid=46361566&anchor=Spoil-46361566-4) / [mobilism](https://forum.mobilism.me/search.php?keywords=Moovit&sr=topics&sf=titleonly)
- [Symbolab: AI Math Photo Solver](https://4pda.to/forum/index.php?showtopic=702296&view=findpost&p=44337245)
- [Autel MaxiAP200](https://4pda.to/forum/index.php?showtopic=961129&st=2400#entry93164749) + [AliExpress](https://www.aliexpress.com/item/32991837323.html)
- [HeliBoard](https://github.com/Helium314/HeliBoard/releases/latest) + [Dictionary](https://codeberg.org/Helium314/aosp-dictionaries) - Keyboard App
- [TikTok](https://4pda.to/forum/index.php?showtopic=1057582&view=findpost&p=88888432) - TikTokModCloud
- [AccuBattery](https://4pda.to/forum/index.php?act=findpost&pid=52860795&anchor=Spoil-52860795-5) - Mod by Balatan
- [StudyGe - World Geography Quiz](https://4pda.to/forum/index.php?act=findpost&pid=119912812&anchor=Spoil-119912812-4) - Premium

> [Registration guide for 4pda](https://www.youtube.com/watch?v=3XOut-lgHRc)

## Mull Settings

1. `Set as default browser` > `Sign in` > `Not Now`.
2. `Settings` > `Search` > `Default search engine` > `Google`.
3. `Settings` > `Search` > Disable all except `Search browsing history` and `Search bookmarks`.
4. `Settings` > `Tabs` > `List`.
5. `Settings` > `Tabs` > `Tabs you haven't viewed for two weeks get moved to the inactive section.` > Off.
6. `Settings` > `Homepage` > Disable all.
7. `Settings` > `Homepage` > `Last tab`.
8. `Settings` > `Customise` > `Buttom`.
9. `Settings` > `Add-ons` > Add `uBlock Origin` > `Settings` > [Restore from file](https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Website_Debloater.txt).
10. `Settings` > `Add-ons` > Add `ClearURLs`.
11. `about:config` > `browser.cache.disk.enable` > `false`.
12. `about:config` > `webgl.disabled` > `false`.

## ADB Commands

Connect USB to PC

```bash
adb tcpip 5555
```

adb connect {DeviceIP}
adb install us.spotco.fennec_dos_21210020.apk
adb pull /data/app/com.example.someapp-2.apk
adb push test.txt /storage/emulated/0/download
adb shell cmd package install-existing tv.alphonso.alphonso_eula
adb shell pm list packages
adb shell pm path com.miui.tv.analytics
adb shell pm reset-permissions
adb shell pm uninstall -k --user 0 com.miui.tv.analytics
adb shell pm uninstall org.skvalex.cr

## Install LineageOS + Magisk (ROOT) + Lucky Patcher + Call Recorder + Play Intergrity + Google Apps

> This process will wipe the data of your device so make sure to back up.

1. Charge phone.
1. Enable OEM Unlock in Developer Options.
1. Enable USB Debugging in Developer Options.
1. Connect USB Cable to PC.
1. Download latest `.zip` and `.img` files for [Lineageos](https://download.lineageos.org/devices) (Select your device and follow their wiki of installation).
1. Download [Google Apps](https://wiki.lineageos.org/gapps/#mobile) (Select `ARM64`).
1. Download [Magisk](https://github.com/topjohnwu/Magisk/releases/latest).
1. Download [PlayIntegrityFix](https://github.com/chiteroman/PlayIntegrityFix/releases).
1. Download [Basic Call Recorder](https://github.com/chenxiaolong/BCR/releases).
1. Download [Lucky Patcher](https://www.luckypatchers.com/apps/LP_Installer.apk).
1. Connect using ADB to the phone:

   ```bash
   adb devices
   ```

1. One the phone click "Allow".

1. Install Magisk App using ADB to the phone:

   ```bash
   adb install [Magisk apk]
   ```

1. Push `boot.img` from PC to phone using ADB:

   ```bash
   adb push boot.img /storage/emulated/0/Download
   ```

1. Open `Magisk` App, On `Magisk` Click `Install`, Click `Select and Patch a File`, Select the latest `boot.img`, Click `Let's Go`.
1. Pull the patched `boot.img` file from phone to PC (Change the file name):

   ```bash
   adb pull /storage/emulated/0/Download/[Patched file]
   ```

1. Reboot to `bootloader` using ADB:

   ```bash
   adb -d reboot bootloader
   ```

1. Connect to device using fastboot:

   ```bash
   fastboot devices
   ```

> if not found anything, download [usb drviers](https://developer.android.com/studio/run/win-usb) and install using "have disk"

1. Unlock OEM Bootloader using fastboot:

   ```bash
   fastboot oem unlock
   ```

1. Select `UNLOCK THE BOOTLOADER` (This will wipe the device)
1. Enable USB Debugging in Developer Options.
1. Install the latest android updates if available.
1. Reboot to `bootloader` using ADB:

   ```bash
   adb -d reboot bootloader
   ```

1. Use fastboot to install new ROM:

   ```bash
   fastboot flash dtbo dtbo.img
   fastboot flash vbmeta vbmeta.img
   fastboot flash boot boot.img
   fastboot flash boot magisk_patched-27000_ChangeThis.img
   ```

1. `Reboot into recovery`.
1. `Factory Reset` > `Format data / factory reset` > `Format data`
1. `Main menu` > `Apply Update` > `Apply from ADB`

   ```bash
   adb -d sideload lineage-ChangeThis.zip
   ```

1. `Reboot to recovery` > `Yes`
1. `Apply Update` > `Apply from ADB`

   ```bash
   adb -d sideload GoogleApps.zip
   ```

1. `Signature verification failed, install anyway?` > `Yes`
1. `Reboot system now`

### Update LineageOS + Reinstall Magisk (ROOT)

> Everytime LineageOS updates we need to reinstall Magisk (ROOT).

1. `System` > `System updates` > `Preferences` > `Delete updates when installed` > Disabled
1. Once there's an update click `Download`.
