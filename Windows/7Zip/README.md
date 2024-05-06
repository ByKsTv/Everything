# Information

> [!NOTE]
> Everything about 7-Zip.

## 7-Zip Setup - Auto Install

1. PowerShell (Admin):

```powershell
#Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1 | Invoke-Expression
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')

```
