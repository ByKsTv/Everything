[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('nvidiaProfileInspector: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/Orbmu2k/nvidiaProfileInspector/releases/latest').assets.browser_download_url, "$env:TEMP\nvidiaProfileInspector.zip")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('nvidiaProfileInspector: Extracting'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path $env:TEMP\nvidiaProfileInspector)) {
  Expand-Archive "$env:TEMP\nvidiaProfileInspector.zip" -DestinationPath "$env:TEMP\nvidiaProfileInspector"
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('nvidiaProfileInspector: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/nvidiaProfileInspector/Settings.xml', "$env:TEMP\nvidiaProfileInspector\Settings.nip")
Start-Process -Wait "$env:TEMP\nvidiaProfileInspector\nvidiaProfileInspector.exe" -ArgumentList "$env:TEMP\nvidiaProfileInspector\Settings.nip -silent"