Write-Host 'TranslucentTB: Getting latest release' -ForegroundColor green -BackgroundColor black
$TranslucentTBURL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest').assets | Where-Object name -Like '*appinstaller*').browser_download_url

Write-Host 'TranslucentTB: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile("$TranslucentTBURL", "$env:TEMP\TranslucentTB.appinstaller")

Write-Host 'TranslucentTB: Installing' -ForegroundColor green -BackgroundColor black
Add-AppxPackage -AppInstallerFile "$env:TEMP\TranslucentTB.appinstaller"

Write-Host 'TranslucentTB: Using custom settings' -ForegroundColor green -BackgroundColor black
$TranslucentTBSettings = @'
// See https://TranslucentTB.github.io/config for more information
{
  "$schema": "https://TranslucentTB.github.io/settings.schema.json",
  "desktop_appearance": {
    "accent": "clear",
    "color": "#00000000",
    "show_peek": false,
    "show_line": false
  },
  "visible_window_appearance": {
    "enabled": true,
    "accent": "clear",
    "color": "#00000000",
    "show_peek": false,
    "show_line": false,
    "rules": {
      "window_class": {},
      "window_title": {},
      "process_name": {}
    }
  },
  "maximized_window_appearance": {
    "enabled": true,
    "accent": "clear",
    "color": "#00000000",
    "show_peek": false,
    "show_line": true,
    "rules": {
      "window_class": {},
      "window_title": {},
      "process_name": {}
    }
  },
  "start_opened_appearance": {
    "enabled": false,
    "accent": "normal",
    "color": "#00000000",
    "show_peek": true,
    "show_line": true
  },
  "search_opened_appearance": {
    "enabled": false,
    "accent": "normal",
    "color": "#00000000",
    "show_peek": true,
    "show_line": true
  },
  "task_view_opened_appearance": {
    "enabled": false,
    "accent": "clear",
    "color": "#00000000",
    "show_peek": false,
    "show_line": true
  },
  "battery_saver_appearance": {
    "enabled": false,
    "accent": "opaque",
    "color": "#00000000",
    "show_peek": true,
    "show_line": false
  },
  "ignored_windows": {
    "window_class": [],
    "window_title": [],
    "process_name": []
  },
  "hide_tray": true,
  "disable_saving": false,
  "verbosity": "warn"
}
'@
$TranslucentTBLoc = Get-Item -Path "$env:LOCALAPPDATA\Packages\*TranslucentTB*\RoamingState\"
$TranslucentTBSettingsLoc = "$TranslucentTBLoc\settings.json"
New-Item -Path $TranslucentTBSettingsLoc -ItemType File -Value $TranslucentTBSettings -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\*TranslucentTB*' -Name 'WasEverActivated' -Value 1 -PropertyType DWord -Force