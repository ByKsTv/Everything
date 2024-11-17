$7Zip_TaskName = '7-Zip Updater'
if (-not (Get-ScheduledTask -TaskName $7Zip_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $7Zip_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')"
    $7Zip_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $7Zip_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $7Zip_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $7Zip_TaskName -Action $7Zip_TaskAction -Trigger $7Zip_TaskTrigger -Principal $7Zip_TaskPrincipal -Settings $7Zip_TaskSettings -Force
}

$7Zip_InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' -ErrorAction SilentlyContinue).DisplayVersion
$7Zip_LatestVersion = (Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').tag_name

if ($null -eq $7Zip_InstalledVersion -or $7Zip_InstalledVersion -notmatch $7Zip_LatestVersion) {
    $7Zip_DDL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/ip7z/7zip/releases/latest').assets | Where-Object name -Like '*-x64.exe*').browser_download_url
    $7Zip_Filename = [IO.Path]::GetFileName(([URI]$7Zip_DDL).AbsolutePath)
    $7Zip_SavePath = [IO.Path]::Combine($env:TEMP, $7Zip_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
	(New-Object System.Net.WebClient).DownloadFile($7Zip_DDL, $7Zip_SavePath)

    $7Zip_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $7Zip_SavePath -ArgumentList $7Zip_Argument -Wait
}

$7Zip_Destination = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '7-Zip*' }).InstallLocation
$7Zip_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($7Zip_OLD_PATH -notlike "*$7Zip_Destination*") {
    $7Zip_NEW_PATH = "$7Zip_OLD_PATH;$7Zip_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'7-Zip'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Environment]::SetEnvironmentVariable('Path', $7Zip_NEW_PATH, [System.EnvironmentVariableTarget]::User)
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('7-Zip: Tools: Options: 7-Zip: Icons in context menus: On'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\7-Zip\Options') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\7-Zip\Options' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\7-Zip\Options' -Name 'MenuIcons' -Value 1 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('7-Zip: Tools: Options: System: Assosiate 7-Zip with: Current User'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\7-Zip\FM') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\7-Zip\FM' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\7-Zip\FM\Columns') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\7-Zip\FM\Columns' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.001') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.001' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.7z') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.7z' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.apfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.apfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.arj') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.arj' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.bz2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.bz2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.bzip2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.bzip2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.cab') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.cab' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.cpio') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.cpio' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.deb') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.deb' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.dmg') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.dmg' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.esd') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.esd' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.fat') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.fat' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.gz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.gz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.gzip') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.gzip' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.hfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.hfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.iso') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.iso' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.lha') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.lha' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.lzh') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.lzh' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.lzma') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.lzma' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.ntfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.ntfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.rar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.rar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.rpm') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.rpm' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.squashfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.squashfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.swm') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.swm' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.taz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.taz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tbz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tbz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tbz2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tbz2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tgz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tgz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tpz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tpz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.txz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.txz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.tzst') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.tzst' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.vhd') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.vhd' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.vhdx') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.vhdx' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.wim') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.wim' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.xar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.xar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.xz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.xz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.z') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.z' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.zip') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.zip' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\.zst') -ne $true) {
    New-Item 'HKCU:\Software\Classes\.zst' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.001') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.001' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.001\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.001\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.001\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.001\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.7z' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.7z\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.7z\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.7z\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.7z\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.apfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.apfs\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.apfs\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.apfs\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.apfs\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.arj' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.arj\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.arj\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.arj\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.arj\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bz2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bz2\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bz2\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bz2\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bz2\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bzip2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bzip2\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bzip2\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cab' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cab\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cab\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cab\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cab\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cpio' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cpio\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cpio\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cpio\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.cpio\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.deb' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.deb\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.deb\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.deb\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.deb\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.dmg' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.dmg\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.dmg\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.dmg\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.dmg\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.esd' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.esd\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.esd\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.esd\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.esd\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.fat' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.fat\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.fat\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.fat\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.fat\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gzip' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gzip\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gzip\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gzip\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.gzip\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.hfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.hfs\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.hfs\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.hfs\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.hfs\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.iso' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.iso\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.iso\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.iso\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.iso\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lha' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lha\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lha\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lha\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lha\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzh' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzh\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzh\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzh\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzh\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzma' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzma\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzma\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzma\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.lzma\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.ntfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.ntfs\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.ntfs\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rar\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rar\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rar\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rar\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rpm' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rpm\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rpm\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rpm\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.rpm\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.squashfs' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.squashfs\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.squashfs\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.swm' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.swm\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.swm\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.swm\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.swm\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tar\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tar\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tar\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tar\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.taz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.taz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.taz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.taz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.taz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz2' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz2\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz2\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tbz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tgz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tgz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tgz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tgz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tgz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tpz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tpz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tpz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tpz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tpz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.txz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.txz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.txz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.txz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.txz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tzst' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tzst\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tzst\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tzst\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.tzst\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhd' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhd\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhd\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhd\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhd\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhdx' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhdx\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhdx\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.wim' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.wim\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.wim\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.wim\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.wim\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xar' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xar\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xar\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xar\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xar\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xz' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xz\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xz\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xz\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.xz\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.z') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.z' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.z\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.z\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.z\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.z\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zip' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zip\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zip\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zip\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zip\shell\open\command' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zst' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\DefaultIcon') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zst\DefaultIcon' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zst\shell' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell\open') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zst\shell\open' -Force
}
if ((Test-Path -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell\open\command') -ne $true) {
    New-Item 'HKCU:\Software\Classes\7-Zip.zst\shell\open\command' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\7-Zip\FM\Columns' -Name 'RootFolder' -Value 'hex(3):01,00,00,00,00,00,00,00,01,00,00,00,04,00,00,00,01,00,00,00,A0,00,00,00' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.001' -Name '(default)' -Value '7-Zip.001' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.7z' -Name '(default)' -Value '7-Zip.7z' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.apfs' -Name '(default)' -Value '7-Zip.apfs' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.arj' -Name '(default)' -Value '7-Zip.arj' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.bz2' -Name '(default)' -Value '7-Zip.bz2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.bzip2' -Name '(default)' -Value '7-Zip.bzip2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.cab' -Name '(default)' -Value '7-Zip.cab' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.cpio' -Name '(default)' -Value '7-Zip.cpio' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.deb' -Name '(default)' -Value '7-Zip.deb' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.dmg' -Name '(default)' -Value '7-Zip.dmg' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.esd' -Name '(default)' -Value '7-Zip.esd' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.fat' -Name '(default)' -Value '7-Zip.fat' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.gz' -Name '(default)' -Value '7-Zip.gz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.gzip' -Name '(default)' -Value '7-Zip.gzip' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.hfs' -Name '(default)' -Value '7-Zip.hfs' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.iso' -Name '(default)' -Value '7-Zip.iso' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.lha' -Name '(default)' -Value '7-Zip.lha' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.lzh' -Name '(default)' -Value '7-Zip.lzh' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.lzma' -Name '(default)' -Value '7-Zip.lzma' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.ntfs' -Name '(default)' -Value '7-Zip.ntfs' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.rar' -Name '(default)' -Value '7-Zip.rar' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.rpm' -Name '(default)' -Value '7-Zip.rpm' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.squashfs' -Name '(default)' -Value '7-Zip.squashfs' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.swm' -Name '(default)' -Value '7-Zip.swm' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tar' -Name '(default)' -Value '7-Zip.tar' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.taz' -Name '(default)' -Value '7-Zip.taz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tbz' -Name '(default)' -Value '7-Zip.tbz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tbz2' -Name '(default)' -Value '7-Zip.tbz2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tgz' -Name '(default)' -Value '7-Zip.tgz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tpz' -Name '(default)' -Value '7-Zip.tpz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.txz' -Name '(default)' -Value '7-Zip.txz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tzst' -Name '(default)' -Value '7-Zip.tzst' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.vhd' -Name '(default)' -Value '7-Zip.vhd' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.vhdx' -Name '(default)' -Value '7-Zip.vhdx' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.wim' -Name '(default)' -Value '7-Zip.wim' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.xar' -Name '(default)' -Value '7-Zip.xar' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.xz' -Name '(default)' -Value '7-Zip.xz' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.z' -Name '(default)' -Value '7-Zip.z' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.zip' -Name '(default)' -Value '7-Zip.zip' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.zst' -Name '(default)' -Value '7-Zip.zst' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.001' -Name '(default)' -Value '001 Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,9' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.001\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z' -Name '(default)' -Value '7z Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,0' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.7z\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs' -Name '(default)' -Value 'apfs Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,25' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.apfs\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj' -Name '(default)' -Value 'arj Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,4' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.arj\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2' -Name '(default)' -Value 'bz2 Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bz2\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2' -Name '(default)' -Value 'bzip2 Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.bzip2\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab' -Name '(default)' -Value 'cab Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,7' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cab\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio' -Name '(default)' -Value 'cpio Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,12' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.cpio\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb' -Name '(default)' -Value 'deb Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,11' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.deb\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg' -Name '(default)' -Value 'dmg Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,17' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.dmg\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd' -Name '(default)' -Value 'esd Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,15' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.esd\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat' -Name '(default)' -Value 'fat Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,21' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.fat\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz' -Name '(default)' -Value 'gz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,14' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip' -Name '(default)' -Value 'gzip Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,14' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.gzip\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs' -Name '(default)' -Value 'hfs Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,18' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.hfs\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso' -Name '(default)' -Value 'iso Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,8' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.iso\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha' -Name '(default)' -Value 'lha Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,6' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lha\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh' -Name '(default)' -Value 'lzh Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,6' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzh\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma' -Name '(default)' -Value 'lzma Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,16' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.lzma\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs' -Name '(default)' -Value 'ntfs Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,22' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.ntfs\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar' -Name '(default)' -Value 'rar Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,3' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rar\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm' -Name '(default)' -Value 'rpm Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,10' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.rpm\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs' -Name '(default)' -Value 'squashfs Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,24' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.squashfs\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm' -Name '(default)' -Value 'swm Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,15' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.swm\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar' -Name '(default)' -Value 'tar Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,13' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tar\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz' -Name '(default)' -Value 'taz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,5' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.taz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz' -Name '(default)' -Value 'tbz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2' -Name '(default)' -Value 'tbz2 Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz2\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,2' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tbz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz' -Name '(default)' -Value 'tgz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,14' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tgz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz' -Name '(default)' -Value 'tpz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,14' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tpz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz' -Name '(default)' -Value 'txz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,23' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.txz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst' -Name '(default)' -Value 'tzst Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,26' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.tzst\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd' -Name '(default)' -Value 'vhd Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,20' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhd\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx' -Name '(default)' -Value 'vhdx Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,20' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.vhdx\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim' -Name '(default)' -Value 'wim Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,15' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.wim\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar' -Name '(default)' -Value 'xar Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,19' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xar\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz' -Name '(default)' -Value 'xz Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,23' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.xz\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.z' -Name '(default)' -Value 'z Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,5' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.z\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip' -Name '(default)' -Value 'zip Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,1' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zip\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst' -Name '(default)' -Value 'zst Archive' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\DefaultIcon' -Name '(default)' -Value 'C:\Program Files\7-Zip\7z.dll,26' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell\open' -Name '(default)' -Value '' -PropertyType String -Force
New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\7-Zip.zst\shell\open\command' -Name '(default)' -Value '"C:\Program Files\7-Zip\7zFM.exe" "%1"' -PropertyType String -Force