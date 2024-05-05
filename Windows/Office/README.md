# Information

> [!NOTE]
> Everything about Office.

## Office Setup (Auto Install)

1. PowerShell (Admin):

```powershell
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1 | Invoke-Expression

```

## Office Setup (Manual Install)

1. Choose [Office Version](https://gravesoft.dev/download_windows_office/office_c2r_links/#english-en-us)
1. Activate Office - PowerShell (Admin):

   ```powershell
   & ([ScriptBlock]::Create((Invoke-RestMethod https://massgrave.dev/get))) /Ohook

   ```

1. Disable Telemetry - PowerShell (Admin):

   ```powershell
   Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Disable_Telemetry.ps1 | Invoke-Expression

   ```
