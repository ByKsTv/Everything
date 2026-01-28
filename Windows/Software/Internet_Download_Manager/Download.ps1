# if already installed - manually uninstall and restart pc
if (-not (Test-Path -Path "${env:ProgramFiles(x86)}\Internet Download Manager\Uninstall.exe")) {
    if (-not (Test-Path -Path 'HKCU:\SOFTWARE\DownloadManager')) {
        New-Item 'HKCU:\SOFTWARE\DownloadManager' -Force
        New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Compressed' -Force
        New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Documents' -Force
        New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Music' -Force
        New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Programs' -Force
        New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Video' -Force
    }

    # Options > Save to
    $encodedPath = [Text.Encoding]::Unicode.GetBytes([IO.Path]::Combine($env:USERPROFILE, 'Downloads') + [char]0)
    $basePath = 'HKCU:\SOFTWARE\DownloadManager\FoldersTree'

    foreach ($subKey in 'Compressed', 'Documents', 'Music', 'Programs', 'Video') {
        New-ItemProperty -Path "$basePath\$subKey" -Name 'pathW' -PropertyType None -Value $encodedPath -Force
    }

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

    # Options > Downloads > If a duplicate download link is added > Add the duplicate with a numbered file name
    New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'RememberDuplLinksA' -PropertyType DWord -Value 1 -Force

    # Hide warning window when running as admin
    New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'bShVistaAsAdmWarn' -PropertyType DWord -Value 1 -Force

    # Options > General > Customize IDM Download panels in browsers > Panel view > Mini mode
    if (-not (Test-Path -Path 'HKCU:\SOFTWARE\DownloadManager\DwnlPanel')) {
        New-Item 'HKCU:\SOFTWARE\DownloadManager\DwnlPanel' -Force
    }
    if (-not (Test-Path -Path 'HKCU:\SOFTWARE\DownloadManager\DwnlSelPanel')) {
        New-Item 'HKCU:\SOFTWARE\DownloadManager\DwnlSelPanel' -Force
    }
    New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\DwnlPanel' -Name 'PanelView' -PropertyType DWord -Value 2 -Force
    New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager\DwnlSelPanel' -Name 'PanelView' -PropertyType DWord -Value 2 -Force

    $DDL = 'https://rutracker.org/forum/viewtopic.php?t=5913474'

    $Title = ((Invoke-WebRequest -UseBasicParsing -Uri $DDL).Links | Where-Object { $_.outerHTML -match 'Internet Download Manager' } | Select-Object -First 1).outerHTML -replace '.*?>(.*?)</a>', '$1'

    $Magnet = [Uri]::UnescapeDataString((((Invoke-WebRequest -UseBasicParsing -Uri $DDL).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href))

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

    $Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Log) {
        Remove-Item $Log -Force -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$env:TEMP\*Internet Download Manager*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

    $Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $Argument

    while (-not ($TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Internet Download Manager*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $TempDir

    while (-not ($TempEXE = (Get-ChildItem $TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent download finished. Torrent: .*Internet Download Manager*')

    $Argument = '/skipdlgs'

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Unblock-File $TempEXE
    Start-Process $TempEXE -ArgumentList $Argument -Wait

    # do {
    #     Start-Sleep -Milliseconds 500
    # } until (
    #     $IDM_Process = Get-Process | Where-Object { $_.MainWindowTitle -eq 'Internet Download Manager Registration' }
    # )
    # Stop-Process -Id $IDM_Process.Id -Force

    $DesktopShortcut = "$($env:USERPROFILE)\Desktop\Internet Download Manager.lnk"
    if (Test-Path -Path $DesktopShortcut) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Internet Download Manager'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item -Path $DesktopShortcut
    }

    $IDMan_InstallLocation = "${env:ProgramFiles(x86)}\Internet Download Manager\IDMan.exe"
    $RegFile = (Get-ChildItem -Path $TempDir -Filter '*.reg' -Recurse -File | Select-Object -First 1).FullName
    $IDMan_New = (Get-ChildItem -Path $TempDir -Filter 'IDMan.exe' -Recurse -File | Select-Object -First 1).FullName
    Start-Process regedit.exe -ArgumentList "/s ""$RegFile""" -Wait
    Copy-Item -Path $IDMan_New -Destination $IDMan_InstallLocation -Force
    Unblock-File -Path $IDMan_InstallLocation
    Start-Process -FilePath $IDMan_InstallLocation -WindowStyle Minimized -Wait

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $TempDir
}