Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Adobe Acrobat Pro Selection'
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

$Source = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w16.monkrus.ws/search/label/Acrobat').Links | Where-Object { $_.outerHTML -notmatch '#more' -and $_.outerHTML -match 'x64' }

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

    $ForumPost = ((Invoke-WebRequest -UseBasicParsing -Uri $TitleHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' }).href | Select-Object -First 1

    if (-not ($ForumPost)) {
        $ForumPost = ((Invoke-WebRequest -UseBasicParsing -Uri $TitleHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' }).href | Select-Object -First 1
    }

    $Magnet = [Uri]::UnescapeDataString((((Invoke-WebRequest -UseBasicParsing -Uri $ForumPost).Links | Where-Object { $_.outerHTML -match 'magnet' }).href | Select-Object -First 1))
    
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

    $Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Log) {
        Remove-Item $Log -Force -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$env:TEMP\*Acrobat*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

    $Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $Argument

    while (-not ($Directory = (Get-ChildItem $env:TEMP -Directory -Filter '*Acrobat*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $Directory

    while (-not ($ISO = (Get-ChildItem $Directory -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Acrobat*')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Directory'"); [Console]::ResetColor(); [Console]::WriteLine()
    & 7z.exe x $ISO -o"$Directory" -y
    
    $AutoPlayEXE = (Get-ChildItem -Path $Directory -Recurse -Filter 'autoplay.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoPlayEXE'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AutoPlayEXE

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Group_Policy_Templates.ps1')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Group_Policy.ps1')
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Settings.ps1')
}