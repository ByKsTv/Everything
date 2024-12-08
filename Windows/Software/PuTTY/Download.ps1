$PuTTY_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html').Links | Where-Object { $_.outerHTML -match 'putty-64bit' } | Select-Object -First 1).href
$PuTTY_Filename = [IO.Path]::GetFileName(([URI]$PuTTY_DDL).AbsolutePath)
$PuTTY_SavePath = [IO.Path]::Combine($env:TEMP, $PuTTY_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PuTTY'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PuTTY_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PuTTY_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($PuTTY_DDL, $PuTTY_SavePath)

$PuTTY_Argument = '/quiet'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PuTTY'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PuTTY_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PuTTY_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $PuTTY_SavePath -ArgumentList $PuTTY_Argument