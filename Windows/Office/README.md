# Information

> [!NOTE]
> Everything about Office.

## Office Setup - Auto Install

1. PowerShell (Admin):

```powershell
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1')

```

## Office Setup - Manual Install

1. Choose [Office Version](https://gravesoft.dev/download_windows_office/office_c2r_links/#english-en-us)
1. Activate Office - PowerShell (Admin):

   ```powershell
   & ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://massgrave.dev/get')))) /Ohook

   ```

1. Disable Telemetry - PowerShell (Admin):

   ```powershell
   #Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_DisableTelemetry.ps1')
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Disable_Telemetry.ps1')

   ```
