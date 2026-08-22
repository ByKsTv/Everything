Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'SketchUp Pro Selection'
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

$Source = (Invoke-WebRequest -UseBasicParsing -Uri 'https://nnmclub.to/forum/tracker.php?nm=SketchUp%20KpoJIuK').Links | Where-Object { $_.class -match 'genmed topictitle' }

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
    Remove-Item -Path "$env:TEMP\*SketchUp*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()

    Start-Process qBittorrent.exe -ArgumentList $Argument
    while (-not ($TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*SketchUp*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $TempDir

    $InstallDir = "$env:ProgramFiles\SketchUp"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InstallDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $InstallDir

    while (-not ($TempEXE = (Get-ChildItem $TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent download finished. Torrent: .*SketchUp*')

    $Argument = '/S /EN'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Unblock-File $TempEXE
    Start-Process $TempEXE -ArgumentList $Argument -Wait

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $TempDir
}
