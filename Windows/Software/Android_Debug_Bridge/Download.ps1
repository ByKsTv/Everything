$Install = [IO.Path]::Combine($env:USERPROFILE, 'adb')
if (-not (Test-Path $Install)) {
    $DDL = 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        
    if (Test-Path $Install) {
        Remove-Item -Path $Install -Recurse -Force
    }
            
    $ExtractPath = [IO.Path]::Combine($env:TEMP, 'platform-tools')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
    Expand-Archive -Path $SavePath -DestinationPath $env:TEMP -Force
            
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Install'"); [Console]::ResetColor(); [Console]::WriteLine()
    Move-Item -Path $ExtractPath -Destination $Install -Force
}
        
$ADB_OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
if (-not ($ADB_OLD_PATH.Contains($Install))) {
    $ADB_NEW_PATH = "$ADB_OLD_PATH;$Install"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Install'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Environment]::SetEnvironmentVariable('Path', $ADB_NEW_PATH, [EnvironmentVariableTarget]::User)
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}