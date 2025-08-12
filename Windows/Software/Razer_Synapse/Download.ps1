[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Razer Synapse: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://rzr.to/synapse-3-pc-download', "$env:TEMP\Synapse.exe")
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Razer Synapse: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $env:TEMP\Synapse.exe