# Table Of Contents

- [PowerShell](#powershell)
  - [Sort Subtitles](#sort-subtitles)
  - [Extract BDMV PLAYLIST](#extract-bdmv-playlist)
  - [Search Group Policy](#search-group-policy)
  - [Extract Base64](#extract-base64)
  - [Convert to FLAC](#convert-to-flac-requires-ffmpeg-in-path)
  - [Download Audio Only](#download-audio-only-requires-yt-dlp-in-path)
- [Python](#python)
  - [SSID QR Code](#ssid-qr-code)
  - [Convert Batch HEIC to PNG](#convert-batch-heic-to-png)
  - [Convert PNG to ICO](#convert-png-to-ico)
- [Extra](#extra)
  - [Cut audio](#cut-audio-requires-ffmpeg-in-path)
  - [Extract .WIM](#extract-wim)
  - [Fix Windows Files]

## PowerShell

### Sort Subtitles

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Subtitles_Sorting.ps1')

   ```

### Extract BDMV PLAYLIST

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Extract_BDMV_PLAYLIST.ps1')

   ```

### Search Group Policy

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Search.ps1')

   ```

### Extract Base64

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Extract_Base64.ps1')

   ```

### Convert to FLAC (Requires FFmpeg in Path)

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Convert_to_FLAC.ps1')

   ```

### Download Audio Only (Requires YT-DLP in Path)

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Audio_Downloader.ps1')

   ```

## Python

### SSID QR Code

1. Open CMD:

```cmd
pip install qrcode[pil]
```

1. Use [WiFi_QR_Code](WiFi_QR_Code.py)
1. Edit `WiFi_Name` and `WiFi_Password`.

### Convert Batch HEIC to PNG

1. CMD (Admin):

   ```bash
   pip install pillow pillow-heif
   ```

1. Use [Convert_HEIC_to_PNG.py](Convert_HEIC_to_PNG.py)
1. Edit `directory_path`.

### Convert PNG to ICO

1. CMD (Admin):

   ```bash
   pip install pillow
   ```

1. Use [Convert_PNG_to_ICO.py](Convert_PNG_to_ICO.py)
1. Edit `input_path`.

## Extra

### Cut audio (Requires FFmpeg in Path)

```bash
ffmpeg -ss 00:00 -to 00:00 -y -i input.opus -c copy output.opus
```

### Extract .WIM

```bash
dism /Get-WimInfo /WimFile:"path\install.wim"
```

### Fix Windows Files

```powershell
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
SFC /ScanNow

```
