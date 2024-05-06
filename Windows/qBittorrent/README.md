# Information

> [!NOTE]
> Everything about qBittorrent.

## qBittorrent Setup - Auto Install

1. PowerShell (Admin):

```powershell
#Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1 | Invoke-Expression
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

```
