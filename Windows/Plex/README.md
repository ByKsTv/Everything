# Information

Everything about Plex.

## Plex Setup - Auto Install

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')

   ```

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
