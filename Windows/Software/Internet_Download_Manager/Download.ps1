if (-not (Test-Path -Path 'HKCU:\SOFTWARE\DownloadManager')) {
    New-Item 'HKCU:\SOFTWARE\DownloadManager' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Compressed' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Documents' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Music' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Programs' -Force
    New-Item 'HKCU:\SOFTWARE\DownloadManager\FoldersTree\Video' -Force
}

# Options -> General -> Launch Internet Download Manager on startup -> On
New-ItemProperty -Path 'HKCU:\SOFTWARE\DownloadManager' -Name 'LaunchOnStart' -PropertyType DWord -Value 1 -Force

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

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Internet Download Manager Selection'
    Font            = [Drawing.Font]::new('Tahoma', 11)
    Height          = 90
    StartPosition   = 'CenterScreen'
    FormBorderStyle = 'FixedDialog'
    Topmost         = $true
    MaximizeBox     = $false
    MinimizeBox     = $false
    ControlBox      = $false
}

$DropDownList = New-Object System.Windows.Forms.ComboBox -Property @{
    DropDownStyle = 'DropDownList'
    Location      = [Drawing.Point]::new(5, 0)
}

$Source = (Invoke-WebRequest -UseBasicParsing -Uri 'https://nnmclub.to/forum/tracker.php?nm=Internet%20Download%20Manager%20elchupacabra').Links | Where-Object { $_.class -match 'genmed topictitle' }


$Array = @{}
$GFX = [Drawing.Graphics]::FromHwnd($Form.Handle)
$TitleWidth = 0

$Source | ForEach-Object {
    $Title = $_.outerHTML -replace '.*?<b>(.*?)</b></a>', '$1'
    if (-not $Array.ContainsKey($Title)) {
        $Array[$Title] = 'https://nnmclub.to/forum/' + $_.href
        $DropDownList.Items.Add($Title) | Out-Null

        $Width = [int]$GFX.MeasureString($Title, $Form.Font).Width
        $TitleWidth = [math]::Max($TitleWidth, $Width)
    }
}

$DropDownList.SelectedIndex = 0
$DropDownList.Width = $TitleWidth + 10
$Form.Width = $DropDownList.Width + 25

$ButtonWidth = 57
$ButtonSpacer = 15
$ButtonY = $Form.Height - 60
$ButtonX = [math]::Round(($Form.ClientSize.Width - (2 * $ButtonWidth + $ButtonSpacer)) / 2)

$Ok = New-Object System.Windows.Forms.Button -Property @{
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
    Width        = $ButtonWidth
    Height       = 20
    Location     = [Drawing.Point]::new($ButtonX, $ButtonY)
    Add_Click    = { $Form.Close() }
}

$Cancel = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Cancel'
    Width     = $ButtonWidth
    Height    = 20
    Location  = [Drawing.Point]::new($ButtonX + $ButtonWidth + $ButtonSpacer, $ButtonY)
    Add_Click = { $Form.Close() }
}

$Form.Controls.AddRange(@($DropDownList, $Ok, $Cancel))
if ($Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $Title = $DropDownList.SelectedItem
    $TitleHREF = $Array[$DropDownList.SelectedItem]

    $Magnet = [Uri]::UnescapeDataString((((Invoke-WebRequest -UseBasicParsing -Uri $TitleHREF).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href))

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Log) {
        Remove-Item $Log -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*Manager*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()

    Start-Process qBittorrent.exe -ArgumentList $Argument
    while (-not ($TempDir = (Get-ChildItem -LiteralPath $env:TEMP -Directory -Filter '*Manager*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $TempDir

    while (-not ($TempEXE = (Get-ChildItem -LiteralPath $TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent download finished. Torrent: .*Manager*')

    $Argument = '/SILENT'
    $InstalledSoftware = (Get-Package).Name
    if ($InstalledSoftware -match 'Internet Download Manager') {
        $Argument += ' /UPDATE=1'
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Unblock-File -LiteralPath $TempEXE
    Start-Process $TempEXE -ArgumentList $Argument # Do not add `-Wait`

    # [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    # Remove-MpPreference -ExclusionPath $TempDir
}
