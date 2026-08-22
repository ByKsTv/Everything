while ($true) {
    $devices = & adb.exe devices 2>$null | Out-String

    if ($devices -match '(?m)^.+\s+device\s*$') {
        break
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Waiting for a connected device...'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Sleep -Seconds 2
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Device connected'); [Console]::ResetColor(); [Console]::WriteLine()

Add-Type -AssemblyName PresentationFramework

$dialog = New-Object Microsoft.Win32.OpenFileDialog
$dialog.Title = 'Select the folder containing the APK files'
$dialog.CheckFileExists = $false
$dialog.CheckPathExists = $true
$dialog.ValidateNames = $false
$dialog.FileName = 'Select Folder'

if ($dialog.ShowDialog() -ne $true) {
    exit
}

$apkPath = [IO.Path]::GetDirectoryName($dialog.FileName)

if (-not [IO.Directory]::Exists($apkPath)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Selected directory does not exist'); [Console]::ResetColor(); [Console]::WriteLine()
    exit
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('APK directory: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$apkPath'"); [Console]::ResetColor(); [Console]::WriteLine()

$apks = [IO.Directory]::EnumerateFiles($apkPath, '*.apk')

foreach ($apk in $apks) {
    [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('APK: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$([IO.Path]::GetFileName($apk))'"); [Console]::ResetColor(); [Console]::WriteLine()

    $badging = & aapt2.exe dump badging $apk 2>&1 | Out-String

    if ($badging -notmatch "package: name='([^']+)' versionCode='(\d+)'") {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Could not read APK info'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Yellow'; [Console]::Write($badging.Trim()); [Console]::ResetColor(); [Console]::WriteLine()
        continue
    }

    $package = $Matches[1]
    $apkVersionCode = [int64]$Matches[2]

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Package: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$package'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('APK versionCode: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$apkVersionCode'"); [Console]::ResetColor(); [Console]::WriteLine()

    $dump = & adb.exe shell dumpsys package $package 2>$null | Out-String

    if ($dump -notmatch 'versionCode=(\d+)') {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Not installed'); [Console]::ResetColor(); [Console]::WriteLine()
        continue
    }

    $deviceVersionCode = [int64]$Matches[1]

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Device versionCode: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$deviceVersionCode'"); [Console]::ResetColor(); [Console]::WriteLine()

    if ($deviceVersionCode -lt $apkVersionCode -or $deviceVersionCode -eq 999999999 -or $package -match 'youtube' -or $package -match 'wppenhacer') {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Action: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Update'); [Console]::ResetColor(); [Console]::WriteLine()

        $install = & adb.exe install -r $apk 2>&1 | Out-String

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Yellow'; [Console]::Write($install.Trim()); [Console]::ResetColor(); [Console]::WriteLine()
    } else {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Action: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Skip'); [Console]::ResetColor(); [Console]::WriteLine()
    }
}
