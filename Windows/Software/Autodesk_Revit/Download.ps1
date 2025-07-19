Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Autodesk Revit Selection'
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

$Source = Invoke-WebRequest -UseBasicParsing -Uri 'https://w16.monkrus.ws/search/label/Revit' | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -notmatch '#more' -and $_.outerHTML -match 'Multilingual' -and $_.outerHTML -match 'Revit' }

$Array = @{}
$GFX = [Drawing.Graphics]::FromHwnd($Form.Handle)
$TitleWidth = 0

$Source | ForEach-Object {
    $Title = $_.outerHTML -replace '.*?>(.*?)</a>', '$1'
    if (-not $Array.ContainsKey($Title)) {
        $Array[$Title] = $_.href
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

    $ForumPost = Invoke-WebRequest -UseBasicParsing -Uri $TitleHREF | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -ExpandProperty 'href' | Select-Object -First 1

    if (-not ($ForumPost)) {
        $ForumPost = Invoke-WebRequest -UseBasicParsing -Uri $TitleHREF | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -ExpandProperty 'href' | Select-Object -First 1
    }

    $Magnet = [Uri]::UnescapeDataString((Invoke-WebRequest -UseBasicParsing -Uri $ForumPost | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -ExpandProperty 'href' | Select-Object -First 1))
    
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

    $Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Log) {
        Remove-Item $Log -Force -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$env:TEMP\*Revit*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

    $Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $Argument

    while (-not ($Directory = Get-ChildItem $env:TEMP -Directory -Filter '*Revit*' | Select-Object -First 1 | Select-Object -ExpandProperty 'FullName')) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $Directory

    while (-not ($ISO = Get-ChildItem $Directory -Filter '*.iso' | Select-Object -First 1 | Select-Object -ExpandProperty 'FullName')) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Revit*')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Directory'"); [Console]::ResetColor(); [Console]::WriteLine()
    & 7z.exe x $ISO -o"$Directory" -y
    
    $SetupEXE = Get-ChildItem -Path $Directory -Recurse -Filter 'setup.exe' | Select-Object -ExpandProperty 'FullName'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SetupEXE'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SetupEXE

    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -match 'Revit' -and $_.MainWindowTitle -match 'Installer' })) {
        Start-Sleep -Milliseconds 1000
    }
    while ((Get-Process | Where-Object { $_.MainWindowTitle -match 'Revit' -and $_.MainWindowTitle -match 'Installer' })) {
        Start-Sleep -Milliseconds 1000
    }

    $Crack = Get-ChildItem -Path $Directory -Recurse -Filter 'AdskNLM.exe' | Select-Object -ExpandProperty 'FullName'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Cracking '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Crack'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Crack

    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -match 'crack' })) {
        Start-Sleep -Milliseconds 1000
    }
    (Get-Process | Where-Object { $_.MainWindowTitle -match 'crack' }).CloseMainWindow() | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $Directory

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Please open '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' and select '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Use a network license'"); [Console]::ResetColor(); [Console]::WriteLine()

    $Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
    $Popup_Text = "Run AutoDesk Revit and Select 'Use a network license'"
    [Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null
}