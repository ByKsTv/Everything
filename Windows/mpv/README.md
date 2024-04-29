# Information

> [!NOTE]
> Everything about mpv.

## Install & Auto Update

1. PowerShell (Admin) (Same folder as mpv):

   ```powershell
   Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Install_Update.ps1 | Invoke-Expression

   ```

## Scripts included

- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua)
- [delete_file](https://github.com/zenyd/mpv-scripts/blob/master/delete_file.lua)
- [oled-screensaver](https://github.com/Akemi/mpv-oled-screensaver/blob/master/oled-screensaver.lua)
- [celebi](https://github.com/po5/celebi/blob/master/celebi.lua)
- [trackselect](https://github.com/po5/trackselect/blob/master/trackselect.lua)
- [mpv_sponsorblock](https://github.com/po5/mpv_sponsorblock)
- Custom scripts

## Cookies Setup

1. Download [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/) extension.
2. Open incognito window.
3. Login to `youtube.com` and export `Current Site` cookies.
4. Move `cookies-youtube-private.txt` to mpv folder.
5. Whitelist `s.youtube.com` on Pi-Hole.

## Summery

1. YouTube videos will be marked as watched on `youtube.com`
2. mpv will ALT+TAB when 1 seconds remained to the end of the video.
3. mpv will delete videos when 15 seconds remained to the end of the video (You might want to delete this script).
4. YouTube videos will skip sponsors and ads ([Python](https://www.python.org/downloads/) required).
