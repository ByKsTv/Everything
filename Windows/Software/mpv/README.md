# Information

Everything about mpv.

## mpv Setup - Auto Install

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/Download.ps1')

   ```

## Scripts included

- [delete_file](https://github.com/zenyd/mpv-scripts/blob/master/delete_file.lua)
- [oled-screensaver](https://github.com/Akemi/mpv-oled-screensaver/blob/master/oled-screensaver.lua)
- [celebi](https://github.com/po5/celebi/blob/master/celebi.lua)
- [trackselect](https://github.com/po5/trackselect/blob/master/trackselect.lua)
- [mpv_sponsorblock](https://github.com/po5/mpv_sponsorblock)
- Custom scripts

## Cookies Setup

1. Download [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/) extension.
1. Open incognito window.
1. Login to `youtube.com` and export `Current Site` cookies.
1. Move `cookies.firefox-private.txt` to mpv folder.
1. Whitelist `s.youtube.com` on Pi-Hole.

## Summery

1. mpv will wait for untill you copy a url and then it will play it.
1. YouTube videos will be marked as watched on `youtube.com`
1. mpv will ALT+TAB when 1 seconds remained to the end of the video.
1. mpv will delete videos when 15 seconds remained to the end of the video (You might want to delete this script).
1. YouTube videos will skip sponsors and ads ([Python](https://www.python.org/downloads/) required).
