# Table Of Contents

- [Setup](#setup)
- [Arkenfox](#arkenfox)
- [Extensions](#extensions)
- [Group Policy Templates](#group-policy-templates)
- [Group Policies](#group-policies)
- [Theme](#theme)

## Setup

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Download.ps1')

   ```

## Arkenfox

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Arkenfox.ps1')

   ```

## Extensions

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Extensions.ps1')

   ```

## Group Policy Templates

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Group_Policy_Templates.ps1')

   ```

## Group Policies

1. PowerShell (Admin):

   ```powershell
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Group_Policy.ps1')
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

   ```

## Theme

1. Enable `devtools.chrome.enabled`.
1. Enable `devtools.debugger.remote-enabled`.
1. Press `Ctrl + Alt + Shift + I`.
1. In Browser Toolbox, click the element picker (mouse pointer icon).
