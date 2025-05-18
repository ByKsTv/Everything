if (Test-Path -Path 'C:\Program Files (x86)\Internet Download Manager\Uninstall.exe') {
    Start-Process -FilePath 'C:\Program Files (x86)\Internet Download Manager\Uninstall.exe' -Wait
}

if ((Test-Path -Path 'HKCU:\SOFTWARE\DownloadManager') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\DownloadManager' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Compressed' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Documents' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Music' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Programs' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Video' -Force
}

# Options > Save to
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Compressed' -Name 'pathW' -PropertyType None -Value (
    [System.Text.Encoding]::Unicode.GetBytes(
        [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads'
        ) + [char]0
    )
) -Force

New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Documents' -Name 'pathW' -PropertyType None -Value (
    [System.Text.Encoding]::Unicode.GetBytes(
        [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads'
        ) + [char]0
    )
) -Force

New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Music' -Name 'pathW' -PropertyType None -Value (
    [System.Text.Encoding]::Unicode.GetBytes(
        [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads'
        ) + [char]0
    )
) -Force

New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Programs' -Name 'pathW' -PropertyType None -Value (
    [System.Text.Encoding]::Unicode.GetBytes(
        [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads'
        ) + [char]0
    )
) -Force

New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Video' -Name 'pathW' -PropertyType None -Value (
    [System.Text.Encoding]::Unicode.GetBytes(
        [System.IO.Path]::Combine($env:USERPROFILE, 'Downloads'
        ) + [char]0
    )
) -Force

# Options > Connection > Default maximum connection number > 32
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'MaxConnectionsNumber' -PropertyType DWord -Value 32 -Force

# View > Language > English
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'LanguageID' -PropertyType DWord -Value 9 -Force

# Don't show tips
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'TipStartUp' -PropertyType DWord -Value 1 -Force

# Options > Downloads > Show start download dialog > Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'StartDlgShowing' -PropertyType DWord -Value 0 -Force

# Options > Downloads > Show download complete dialog > Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'ComplDlgShowing' -PropertyType DWord -Value 0 -Force

# Options > Downloads > Customize "Download progress" dialog > Start view > Show minimized
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'PrgrDlgVisiblity' -PropertyType DWord -Value 1 -Force

# Hide warning window when running as admin
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'bShVistaAsAdmWarn' -PropertyType DWord -Value 1 -Force

$InternetDownloadManager_Label = 'https://rutracker.org/forum/viewtopic.php?t=5913474'

$InternetDownloadManager_Title = (
    (
        Invoke-WebRequest -UseBasicParsing -Uri $InternetDownloadManager_Label
    ).Links | Where-Object {
        $_.outerHTML -match 'Internet Download Manager'
    } | Select-Object -First 1
).outerHTML -replace '.*?>(.*?)</a>', '$1'

$InternetDownloadManager_Magnet = [Uri]::UnescapeDataString(
    (
        (
            Invoke-WebRequest -UseBasicParsing -Uri $InternetDownloadManager_Label
        ).Links | Where-Object {
            $_.outerHTML -match 'magnet'
        } | Select-Object -First 1
    ).href
)

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

$InternetDownloadManager_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
if (Test-Path $InternetDownloadManager_qBittorrent_LOG) {
    Remove-Item $InternetDownloadManager_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
}

Remove-Item -Path "$env:TEMP\*Internet Download Manager*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

$InternetDownloadManager_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($InternetDownloadManager_Magnet)"""

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process qBittorrent.exe -ArgumentList $InternetDownloadManager_qBittorrent_Argument

while (
    -not (
        $InternetDownloadManager_TempDir = (
            Get-ChildItem $env:TEMP -Directory -Filter '*Internet Download Manager*' | Select-Object -First 1
        ).FullName
    )
) {
    Start-Sleep -Milliseconds 1000
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
Add-MpPreference -ExclusionPath $InternetDownloadManager_TempDir

while (
    -not (
        $InternetDownloadManager_TempEXE = (
            Get-ChildItem $InternetDownloadManager_TempDir -Filter '*.exe' | Select-Object -First 1
        ).FullName
    )
) {
    Start-Sleep -Milliseconds 1000
}

do {
    Start-Sleep -Milliseconds 1000
} until (
    (
        Get-Content $InternetDownloadManager_qBittorrent_LOG -ErrorAction SilentlyContinue
    ) -match 'Torrent removed. Torrent: .*Internet Download Manager*'
)

$InternetDownloadManager_Argument = '/skipdlgs'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Unblock-File $InternetDownloadManager_TempEXE
Start-Process $InternetDownloadManager_TempEXE -ArgumentList $InternetDownloadManager_Argument

do {
    Start-Sleep -Milliseconds 500
} until (Get-Process | Where-Object { $_.MainWindowTitle -eq 'Internet Download Manager Registration' })
Stop-Process -Name 'IDMan' -Force -ErrorAction SilentlyContinue

$InternetDownloadManager_DesktopShortcut = "$($env:USERPROFILE)\Desktop\Internet Download Manager.lnk"
if (Test-Path -Path $InternetDownloadManager_DesktopShortcut) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Internet Download Manager'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-Item -Path $InternetDownloadManager_DesktopShortcut
}

Start-Process regedit.exe -ArgumentList "/s `"$InternetDownloadManager_TempDir\Crack\idm.reg`""
Copy-Item -Path "$InternetDownloadManager_TempDir\Crack\IDMan.exe" -Destination 'C:\Program Files (x86)\Internet Download Manager\IDMan.exe' -Force
Unblock-File -Path 'C:\Program Files (x86)\Internet Download Manager\IDMan.exe'
Start-Process -FilePath 'C:\Program Files (x86)\Internet Download Manager\IDMan.exe' -WindowStyle Minimized

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InternetDownloadManager_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
Remove-MpPreference -ExclusionPath $InternetDownloadManager_TempDir