$7Zip_TaskName = '7-Zip Updater'
if (-not (Get-ScheduledTask -TaskName $7Zip_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $7Zip_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')"
    $7Zip_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $7Zip_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $7Zip_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $7Zip_TaskName -Action $7Zip_TaskAction -Trigger $7Zip_TaskTrigger -Principal $7Zip_TaskPrincipal -Settings $7Zip_TaskSettings -Force
}

$7Zip_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' -ErrorAction SilentlyContinue).DisplayVersion
$7Zip_LatestVersion = (Invoke-RestMethod -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').tag_name

if ($null -eq $7Zip_InstalledVersion -or $7Zip_InstalledVersion -notmatch $7Zip_LatestVersion) {
    $7Zip_DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').assets | Where-Object name -Like '*-x64.exe*').browser_download_url
    $7Zip_Filename = [IO.Path]::GetFileName(([URI]$7Zip_DDL).AbsolutePath)
    $7Zip_SavePath = [IO.Path]::Combine($env:TEMP, $7Zip_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($7Zip_DDL, $7Zip_SavePath)

    $7Zip_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $7Zip_SavePath -ArgumentList $7Zip_Argument -Wait
}

$7Zip_Destination = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '7-Zip*' }).InstallLocation
$7Zip_OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
if ($7Zip_OLD_PATH -notlike "*$7Zip_Destination*") {
    $7Zip_NEW_PATH = "$7Zip_OLD_PATH;$7Zip_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Environment]::SetEnvironmentVariable('Path', $7Zip_NEW_PATH, [EnvironmentVariableTarget]::User)
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('7-Zip: Tools: Options: 7-Zip: Icons in context menus: On'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\7-Zip\Options') -ne $true) {
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
New-ItemProperty -Path 'HKCU:\SOFTWARE\7-Zip\FM\Columns' -Name 'RootFolder' -Value 'hex(3):01,00,00,00,00,00,00,00,01,00,00,00,04,00,00,00,01,00,00,00,A0,00,00,00' -PropertyType String -Force

$7Zip_Extensions = @(
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

$7Zip_RegKey = 'HKCU:\SOFTWARE\Classes'
$7Zip_Path = $7Zip_Destination.TrimEnd('\')

foreach ($7Zip_Extension in $7Zip_Extensions) {
    $7Zip_ExtensionName = $7Zip_Extension.Extension
    $7Zip_IconIndex = $7Zip_Extension.IconIndex
    $7Zip_ExtensionDescription = $7Zip_Extension.Description

    $7Zip_DotExtensionName = Join-Path $7Zip_RegKey $7Zip_ExtensionName
    if (-not (Test-Path -Path $7Zip_DotExtensionName)) {
        New-Item -Path $7Zip_RegKey -Name $7Zip_ExtensionName -Force
    }
    New-ItemProperty -Path $7Zip_DotExtensionName -Name '(default)' -Value "7-Zip$7Zip_ExtensionName" -PropertyType String -Force

    $7Zip_ExtInd = "7-Zip$7Zip_ExtensionName"
    $7Zip_ExtReg = Join-Path $7Zip_RegKey $7Zip_ExtInd
    if (-not (Test-Path -Path $7Zip_ExtReg)) {
        New-Item -Path $7Zip_RegKey -Name $7Zip_ExtInd -Force
    }

    $7Zip_DefaultIconKey = Join-Path $7Zip_ExtReg 'DefaultIcon'
    $7Zip_ShellKey = Join-Path $7Zip_ExtReg 'shell'
    $7Zip_OpenKey = Join-Path $7Zip_ShellKey 'open'
    $7Zip_CommandKey = Join-Path $7Zip_OpenKey 'command'

    foreach ($7Zip_Key in @($7Zip_DefaultIconKey, $7Zip_ShellKey, $7Zip_OpenKey, $7Zip_CommandKey)) {
        if (-not (Test-Path -Path $7Zip_Key)) {
            $7Zip_ParentKey = Split-Path -Parent $7Zip_Key
            $7Zip_NameKey = Split-Path -Leaf $7Zip_Key
            New-Item -Path $7Zip_ParentKey -Name $7Zip_NameKey -Force
        }
    }

    New-ItemProperty -Path $7Zip_ExtReg -Name '(default)' -Value $7Zip_ExtensionDescription -PropertyType String -Force

    $7Zip_IconPath = "$7Zip_Path\7z.dll,$7Zip_IconIndex"
    New-ItemProperty -Path $7Zip_DefaultIconKey -Name '(default)' -Value $7Zip_IconPath -PropertyType String -Force

    New-ItemProperty -Path $7Zip_ShellKey -Name '(default)' -Value '' -PropertyType String -Force
    New-ItemProperty -Path $7Zip_OpenKey -Name '(default)' -Value '' -PropertyType String -Force

    $7Zip_CommandPath = "$7Zip_Path\7zFM.exe"
    $7Zip_CommandValue = "`"$7Zip_CommandPath`" `"%1`""
    New-ItemProperty -Path $7Zip_CommandKey -Name '(default)' -Value $7Zip_CommandValue -PropertyType String -Force
}