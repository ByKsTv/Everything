# Information

Everything about Scripts.

## Python: Convert HEIC to PNG (Batch)

1. CMD (Admin):

   ```bash
   pip install pillow pillow-heif
   ```

1. Use [Convert_HEIC_to_PNG.py](Convert_HEIC_to_PNG.py)
1. Edit `directory_path`.

## Python: Convert PNG to ICO (Single file)

1. CMD (Admin):

   ```bash
   pip install pillow
   ```

1. Use [Convert_PNG_to_ICO.py](Convert_PNG_to_ICO.py)
1. Edit `input_path`.

## Python: Sorting subtitles and fonts to the current video files

### Directory Layout

- **TV Show Name/**: This is the main parent folder.
- **Subs/**: This is a subfolder inside **TV Show Name/**.
- **Episode 1/**, **Episode 2/**, etc.: These are subfolders within **Subs/**.

1. Use [Subtitles_Sorting.py](Subtitles_Sorting.py)
1. Edit `ExtractFontsFrom`.

## Powershell: Sort Subtitles

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Subtitles_Sorting.ps1')

   ```

## Powershell: Extract BDMV PLAYLIST

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Extract_BDMV_PLAYLIST.ps1')

   ```

## Powershell: Search Group Policy

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Search.ps1')

   ```

## Powershell: Extract Base64 from file

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Extract_Base64.ps1')

   ```

## FFmpeg: Convert to FLAC (Requires FFmpeg in Path)

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Convert_to_FLAC.ps1')

   ```

## YT-DLP: Download Audio Only (Requires YT-DLP in Path)

1. PowerShell (Admin):

   ```powershell
   Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Audio_Downloader.ps1')

   ```

## FFmpeg: Cut audio from mm:ss to mm:ss (Requires FFmpeg in Path)

```bash
ffmpeg -ss 00:00 -to 00:00 -y -i input.opus -c copy output.opus
```

## Python: SSID QR Code

1. Open CMD:

```cmd
pip install qrcode[pil]
```

1. Use [WiFi_QR_Code](WiFi_QR_Code.py)
1. Edit `WiFi_Name` and `WiFi_Password`.

## Extract .WIM

```bash
dism /Get-WimInfo /WimFile:"path\install.wim"
```
