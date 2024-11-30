$ADB_Destination = [IO.Path]::Combine($env:USERPROFILE, 'adb')
if (-not (Test-Path $ADB_Destination)) {
    $ADB_DDL = 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip'
    $ADB_Filename = [IO.Path]::GetFileName(([URI]$ADB_DDL).AbsolutePath)
    $ADB_SavePath = [IO.Path]::Combine($env:TEMP, $ADB_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($ADB_DDL, $ADB_SavePath)
        
    if (Test-Path $ADB_Destination) {
        Remove-Item -Path $ADB_Destination -Recurse -Force
    }
            
    $ADB_ExtractPath = [IO.Path]::Combine($env:TEMP, 'platform-tools')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
    Expand-Archive -Path $ADB_SavePath -DestinationPath $env:TEMP -Force
            
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_ExtractPath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
    Move-Item -Path $ADB_ExtractPath -Destination $ADB_Destination
}
        
$ADB_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($ADB_OLD_PATH -notlike "*$ADB_Destination*") {
    $ADB_NEW_PATH = "$ADB_OLD_PATH;$ADB_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'ADB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ADB_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Environment]::SetEnvironmentVariable('Path', $ADB_NEW_PATH, [System.EnvironmentVariableTarget]::User)
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}