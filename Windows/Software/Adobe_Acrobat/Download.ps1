Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Group_Policy_Templates.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Adobe_Acrobat/Settings.ps1')

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Adobe_Acrobat_Form = New-Object System.Windows.Forms.Form -Property @{
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

$Adobe_Acrobat_Form_DropDownList = New-Object System.Windows.Forms.ComboBox -Property @{
    DropDownStyle = 'DropDownList'
    Location      = [Drawing.Point]::new(5, 0)
}

$Adobe_Acrobat_Source = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w16.monkrus.ws/search/label/Acrobat').Links | Where-Object {
    $_.outerHTML -notmatch '#more' -and
    $_.outerHTML -match 'x64'
}

$Adobe_Acrobat_Source_Array = @{}

$Adobe_Acrobat_Form_Graphics = [Drawing.Graphics]::FromHwnd($Adobe_Acrobat_Form.Handle)
$Adobe_Acrobat_Form_DropDownList_MaxWidth = 0

foreach ($Adobe_Acrobat_Source_Post in $Adobe_Acrobat_Source) {
    $Adobe_Acrobat_Source_PostTitle = ($Adobe_Acrobat_Source_Post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $Adobe_Acrobat_Source_PostHREF = $Adobe_Acrobat_Source_Post.href
    $Adobe_Acrobat_Source_Array[$Adobe_Acrobat_Source_PostTitle] = $Adobe_Acrobat_Source_PostHREF

    $Adobe_Acrobat_Form_DropDownList.Items.Add($Adobe_Acrobat_Source_PostTitle) | Out-Null
    
    $Adobe_Acrobat_Form_Source_Post_Width = [int]$Adobe_Acrobat_Form_Graphics.MeasureString($Adobe_Acrobat_Source_PostTitle, $Adobe_Acrobat_Form.Font).Width
    if ($Adobe_Acrobat_Form_Source_Post_Width -gt $Adobe_Acrobat_Form_DropDownList_MaxWidth) {
        $Adobe_Acrobat_Form_DropDownList_MaxWidth = $Adobe_Acrobat_Form_Source_Post_Width 
    }
}

$Adobe_Acrobat_Form_DropDownList.Width = $Adobe_Acrobat_Form_DropDownList_MaxWidth + 10
$Adobe_Acrobat_Form.Width = $Adobe_Acrobat_Form_DropDownList.Width + 25

$Adobe_Acrobat_Form.Controls.Add($Adobe_Acrobat_Form_DropDownList)

$Adobe_Acrobat_Form_ButtonSpacer = 15
$Adobe_Acrobat_Form_ButtonWidth = 57
$Adobe_Acrobat_Form_ButtonWidthTotal = $Adobe_Acrobat_Form_ButtonSpacer + $Adobe_Acrobat_Form_ButtonWidth + $Adobe_Acrobat_Form_ButtonWidth
$Adobe_Acrobat_Form_ButtonCenterX = [math]::Round(($Adobe_Acrobat_Form.ClientSize.Width - $Adobe_Acrobat_Form_ButtonWidthTotal) / 2)
$Adobe_Acrobat_Form_ButtonHeight = 20
$Adobe_Acrobat_Form_ButtonYLocation = $Adobe_Acrobat_Form.Height - 60

$Adobe_Acrobat_Form_OK = New-Object System.Windows.Forms.Button -Property @{
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
    Width        = $Adobe_Acrobat_Form_ButtonWidth
    Height       = $Adobe_Acrobat_Form_ButtonHeight
    Location     = [Drawing.Point]::new($Adobe_Acrobat_Form_ButtonCenterX, $Adobe_Acrobat_Form_ButtonYLocation)
    Add_Click    = ({ $Adobe_Acrobat_Form.Close() })
}

$Adobe_Acrobat_Form_Cancel_ButtonXLocation = $Adobe_Acrobat_Form_ButtonCenterX + $Adobe_Acrobat_Form_ButtonWidth + $Adobe_Acrobat_Form_ButtonSpacer
$Adobe_Acrobat_Form_Cancel = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Cancel'
    Width     = $Adobe_Acrobat_Form_ButtonWidth
    Height    = $Adobe_Acrobat_Form_ButtonHeight
    Location  = [Drawing.Point]::new($Adobe_Acrobat_Form_Cancel_ButtonXLocation, $Adobe_Acrobat_Form_ButtonYLocation)
    Add_Click = ({ $Adobe_Acrobat_Form.Close() })
}

$Adobe_Acrobat_Form.Controls.Add($Adobe_Acrobat_Form_OK)
$Adobe_Acrobat_Form.Controls.Add($Adobe_Acrobat_Form_Cancel)

if ($Adobe_Acrobat_Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $Adobe_Acrobat_Form_DropDownList_SelectedItem = $Adobe_Acrobat_Form_DropDownList.SelectedItem
    $Adobe_Acrobat_Form_DropDownList_SelectedItemHREF = $Adobe_Acrobat_Source_Array[$Adobe_Acrobat_Form_DropDownList_SelectedItem]

    $Adobe_Acrobat_Source_Forum_Post = ((Invoke-WebRequest -UseBasicParsing -Uri $Adobe_Acrobat_Form_DropDownList_SelectedItemHREF).Links | Where-Object {
            $_.outerHTML -match 'uniondht.org'
        }).href | Select-Object -First 1

    if ($null -eq $Adobe_Acrobat_Source_Forum_Post) {
        $Adobe_Acrobat_Source_Forum_Post = ((Invoke-WebRequest -UseBasicParsing -Uri $Adobe_Acrobat_Form_DropDownList_SelectedItemHREF).Links | Where-Object {
                $_.outerHTML -match 'pb.wtf'
            }).href | Select-Object -First 1
    }

    $Adobe_Acrobat_Source_Forum_Post_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $Adobe_Acrobat_Source_Forum_Post).Links | Where-Object {
            $_.outerHTML -match 'magnet'
        }).href | Select-Object -First 1
    
    $Adobe_Acrobat_Source_Forum_Post_Magnet_UnEscape = [Uri]::UnescapeDataString($Adobe_Acrobat_Source_Forum_Post_Magnet)

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

    $Adobe_Acrobat_qBittorrent_Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Adobe_Acrobat_qBittorrent_Log) {
        Remove-Item $Adobe_Acrobat_qBittorrent_Log -Force -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$env:TEMP\*Acrobat*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

    $Adobe_Acrobat_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Adobe_Acrobat_Source_Forum_Post_Magnet_UnEscape)"""

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()

    Start-Process qBittorrent.exe -ArgumentList $Adobe_Acrobat_qBittorrent_Argument

    while (-not ($Adobe_Acrobat_Temporary_Directory = (Get-ChildItem $env:TEMP -Directory -Filter '*Acrobat*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Temporary_Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $Adobe_Acrobat_Temporary_Directory

    while (-not ($Adobe_Acrobat_Temporary_ISO = (Get-ChildItem $Adobe_Acrobat_Temporary_Directory -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Adobe_Acrobat_qBittorrent_Log -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Acrobat*')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Temporary_ISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Temporary_Directory'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $Adobe_Acrobat_Temporary_ISO -o"$Adobe_Acrobat_Temporary_Directory" -y
    
    $Adobe_Acrobat_Temporary_AutoPlayEXE = (Get-ChildItem -Path $Adobe_Acrobat_Temporary_Directory -Recurse -Filter 'autoplay.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Adobe_Acrobat_Temporary_AutoPlayEXE'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Adobe_Acrobat_Temporary_AutoPlayEXE
}