$TaskName = '7-Zip Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'DisplayVersion'
$LatestVersion = Invoke-RestMethod -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest' | Select-Object -ExpandProperty 'tag_name'

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
    $DDL = Invoke-RestMethod -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest' | Select-Object -ExpandProperty 'assets' | Where-Object { $_.name -match 'x64.exe' } | Select-Object -ExpandProperty 'browser_download_url'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SavePath -ArgumentList $Argument -Wait
}

$Destination = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match '7-Zip' } | Select-Object -ExpandProperty 'InstallLocation'
$OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
if (-not ($OLD_PATH.Contains($Destination))) {
    $NEW_PATH = "$OLD_PATH;$Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Environment]::SetEnvironmentVariable('Path', $NEW_PATH, [EnvironmentVariableTarget]::User)
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + '; ' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('7-Zip: Tools: Options: 7-Zip: Icons in context menus: On'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\7-Zip\Options')) {
    New-Item 'HKCU:\SOFTWARE\7-Zip\Options' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\7-Zip\Options' -Name 'MenuIcons' -Value 1 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('7-Zip: Tools: Options: System: Assosiate 7-Zip with: Current User'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\7-Zip\FM')) {
    New-Item -Path 'HKCU:\SOFTWARE\7-Zip\FM' -Force
}
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\7-Zip\FM\Columns')) {
    New-Item -Path 'HKCU:\SOFTWARE\7-Zip\FM\Columns' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\7-Zip\FM\Columns' -Name 'RootFolder' -Value 'hex(3):01, 00, 00, 00, 00, 00, 00, 00, 01, 00, 00, 00, 04, 00, 00, 00, 01, 00, 00, 00, A0, 00, 00, 00' -PropertyType String -Force

$Extensions = @(
    @{Extension = '.001'; IconIndex = 9; Description = '001 Archive' },
    @{Extension = '.7z'; IconIndex = 0; Description = '7z Archive' },
    @{Extension = '.apfs'; IconIndex = 25; Description = 'apfs Archive' },
    @{Extension = '.arj'; IconIndex = 4; Description = 'arj Archive' },
    @{Extension = '.bz2'; IconIndex = 2; Description = 'bz2 Archive' },
    @{Extension = '.bzip2'; IconIndex = 2; Description = 'bzip2 Archive' },
    @{Extension = '.cab'; IconIndex = 7; Description = 'cab Archive' },
    @{Extension = '.cpio'; IconIndex = 12; Description = 'cpio Archive' },
    @{Extension = '.deb'; IconIndex = 11; Description = 'deb Archive' },
    @{Extension = '.dmg'; IconIndex = 17; Description = 'dmg Archive' },
    @{Extension = '.esd'; IconIndex = 15; Description = 'esd Archive' },
    @{Extension = '.fat'; IconIndex = 21; Description = 'fat Archive' },
    @{Extension = '.gz'; IconIndex = 14; Description = 'gz Archive' },
    @{Extension = '.gzip'; IconIndex = 14; Description = 'gzip Archive' },
    @{Extension = '.hfs'; IconIndex = 18; Description = 'hfs Archive' },
    @{Extension = '.iso'; IconIndex = 8; Description = 'iso Archive' },
    @{Extension = '.lha'; IconIndex = 6; Description = 'lha Archive' },
    @{Extension = '.lzh'; IconIndex = 6; Description = 'lzh Archive' },
    @{Extension = '.lzma'; IconIndex = 16; Description = 'lzma Archive' },
    @{Extension = '.ntfs'; IconIndex = 22; Description = 'ntfs Archive' },
    @{Extension = '.rar'; IconIndex = 3; Description = 'rar Archive' },
    @{Extension = '.rpm'; IconIndex = 10; Description = 'rpm Archive' },
    @{Extension = '.squashfs'; IconIndex = 24; Description = 'squashfs Archive' },
    @{Extension = '.swm'; IconIndex = 15; Description = 'swm Archive' },
    @{Extension = '.tar'; IconIndex = 13; Description = 'tar Archive' },
    @{Extension = '.taz'; IconIndex = 5; Description = 'taz Archive' },
    @{Extension = '.tbz'; IconIndex = 2; Description = 'tbz Archive' },
    @{Extension = '.tbz2'; IconIndex = 2; Description = 'tbz2 Archive' },
    @{Extension = '.tgz'; IconIndex = 14; Description = 'tgz Archive' },
    @{Extension = '.tpz'; IconIndex = 14; Description = 'tpz Archive' },
    @{Extension = '.txz'; IconIndex = 23; Description = 'txz Archive' },
    @{Extension = '.tzst'; IconIndex = 26; Description = 'tzst Archive' },
    @{Extension = '.vhd'; IconIndex = 20; Description = 'vhd Archive' },
    @{Extension = '.vhdx'; IconIndex = 20; Description = 'vhdx Archive' },
    @{Extension = '.wim'; IconIndex = 15; Description = 'wim Archive' },
    @{Extension = '.xar'; IconIndex = 19; Description = 'xar Archive' },
    @{Extension = '.xz'; IconIndex = 23; Description = 'xz Archive' },
    @{Extension = '.z'; IconIndex = 5; Description = 'z Archive' },
    @{Extension = '.zip'; IconIndex = 1; Description = 'zip Archive' },
    @{Extension = '.zst'; IconIndex = 26; Description = 'zst Archive' }
)

$RegKey = 'HKCU:\SOFTWARE\Classes'
$Path = $Destination.TrimEnd('\')

foreach ($Extension in $Extensions) {
    $ExtensionName = $Extension.Extension
    $IconIndex = $Extension.IconIndex
    $ExtensionDescription = $Extension.Description

    $DotExtensionName = Join-Path $RegKey $ExtensionName
    if (-not (Test-Path -Path $DotExtensionName)) {
        New-Item -Path $RegKey -Name $ExtensionName -Force
    }
    New-ItemProperty -Path $DotExtensionName -Name '(default)' -Value "7-Zip$ExtensionName" -PropertyType String -Force

    $ExtInd = "7-Zip$ExtensionName"
    $ExtReg = Join-Path $RegKey $ExtInd
    if (-not (Test-Path -Path $ExtReg)) {
        New-Item -Path $RegKey -Name $ExtInd -Force
    }

    $DefaultIconKey = Join-Path $ExtReg 'DefaultIcon'
    $ShellKey = Join-Path $ExtReg 'shell'
    $OpenKey = Join-Path $ShellKey 'open'
    $CommandKey = Join-Path $OpenKey 'command'

    foreach ($Key in @($DefaultIconKey, $ShellKey, $OpenKey, $CommandKey)) {
        if (-not (Test-Path -Path $Key)) {
            $ParentKey = Split-Path -Parent $Key
            $NameKey = Split-Path -Leaf $Key
            New-Item -Path $ParentKey -Name $NameKey -Force
        }
    }

    New-ItemProperty -Path $ExtReg -Name '(default)' -Value $ExtensionDescription -PropertyType String -Force

    $IconPath = "$Path\7z.dll,$IconIndex"
    New-ItemProperty -Path $DefaultIconKey -Name '(default)' -Value $IconPath -PropertyType String -Force

    New-ItemProperty -Path $ShellKey -Name '(default)' -Value '' -PropertyType String -Force
    New-ItemProperty -Path $OpenKey -Name '(default)' -Value '' -PropertyType String -Force

    $CommandPath = "$Path\7zFM.exe"
    $CommandValue = "`"$CommandPath`" `"%1`""
    New-ItemProperty -Path $CommandKey -Name '(default)' -Value $CommandValue -PropertyType String -Force
}