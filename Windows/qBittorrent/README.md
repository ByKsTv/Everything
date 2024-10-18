# Information

Everything about qBittorrent.

## qBittorrent Setup - Auto Install

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

   ```

   > Custom settings which are not included:
   >
   > ```ini
   > [Preferences]Downloads\ScanDirsLastPath
   > [BitTorrent]Session\TempPath
   > [BitTorrent]Session\DefaultSavePath
   > [BitTorrent]Session\InterfaceName
   > [BitTorrent]Session\Interface
   > [Application]FileLogger\Path
   > [Network]Cookies
   > [GUI]RSSWidget\OpenedFolders
   > ```
