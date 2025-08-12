[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Valorant: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.ap.exe', "$env:TEMP\VALORANT.exe")
                
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Valorant: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:TEMP\VALORANT.exe -ArgumentList '--skip-to-install'