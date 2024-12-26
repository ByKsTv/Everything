Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Autodesk_AutoCAD_Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Autodesk AutoCAD Selection'
    Font            = [Drawing.Font]::new('Tahoma', 11)
    Height          = 90
    StartPosition   = 'CenterScreen'
    FormBorderStyle = 'FixedDialog'
    Topmost         = $true
    MaximizeBox     = $false
    MinimizeBox     = $false
    ControlBox      = $false
}

$Autodesk_AutoCAD_Form_DropDownList = New-Object System.Windows.Forms.ComboBox -Property @{
    DropDownStyle = 'DropDownList'
    Location      = [Drawing.Point]::new(5, 0)
}

$Autodesk_AutoCAD_Source = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w16.monkrus.ws/search/label/AutoCAD').Links | Where-Object {
    $_.outerHTML -notmatch '#more' -and
    $_.outerHTML -match 'AutoCAD' -and
    $_.outerHTML -notmatch 'LT' -and
    $_.outerHTML -notmatch 'Addon'
}

$Autodesk_AutoCAD_Source_Array = @{}

$Autodesk_AutoCAD_Form_Graphics = [Drawing.Graphics]::FromHwnd($Autodesk_AutoCAD_Form.Handle)
$Autodesk_AutoCAD_Form_DropDownList_MaxWidth = 0

foreach ($Autodesk_AutoCAD_Source_Post in $Autodesk_AutoCAD_Source) {
    $Autodesk_AutoCAD_Source_PostTitle = ($Autodesk_AutoCAD_Source_Post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $Autodesk_AutoCAD_Source_PostHREF = $Autodesk_AutoCAD_Source_Post.href
    $Autodesk_AutoCAD_Source_Array[$Autodesk_AutoCAD_Source_PostTitle] = $Autodesk_AutoCAD_Source_PostHREF

    $Autodesk_AutoCAD_Form_DropDownList.Items.Add($Autodesk_AutoCAD_Source_PostTitle) | Out-Null
    
    $Autodesk_AutoCAD_Form_Source_Post_Width = [int]$Autodesk_AutoCAD_Form_Graphics.MeasureString($Autodesk_AutoCAD_Source_PostTitle, $Autodesk_AutoCAD_Form.Font).Width
    if ($Autodesk_AutoCAD_Form_Source_Post_Width -gt $Autodesk_AutoCAD_Form_DropDownList_MaxWidth) {
        $Autodesk_AutoCAD_Form_DropDownList_MaxWidth = $Autodesk_AutoCAD_Form_Source_Post_Width 
    }
}

$Autodesk_AutoCAD_Form_DropDownList.Width = $Autodesk_AutoCAD_Form_DropDownList_MaxWidth + 10
$Autodesk_AutoCAD_Form.Width = $Autodesk_AutoCAD_Form_DropDownList.Width + 25

$Autodesk_AutoCAD_Form.Controls.Add($Autodesk_AutoCAD_Form_DropDownList)

$Autodesk_AutoCAD_Form_ButtonSpacer = 15
$Autodesk_AutoCAD_Form_ButtonWidth = 57
$Autodesk_AutoCAD_Form_ButtonWidthTotal = $Autodesk_AutoCAD_Form_ButtonSpacer + $Autodesk_AutoCAD_Form_ButtonWidth + $Autodesk_AutoCAD_Form_ButtonWidth
$Autodesk_AutoCAD_Form_ButtonCenterX = [math]::Round(($Autodesk_AutoCAD_Form.ClientSize.Width - $Autodesk_AutoCAD_Form_ButtonWidthTotal) / 2)
$Autodesk_AutoCAD_Form_ButtonHeight = 20
$Autodesk_AutoCAD_Form_ButtonYLocation = $Autodesk_AutoCAD_Form.Height - 60

$Autodesk_AutoCAD_Form_OK = New-Object System.Windows.Forms.Button -Property @{
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
    Width        = $Autodesk_AutoCAD_Form_ButtonWidth
    Height       = $Autodesk_AutoCAD_Form_ButtonHeight
    Location     = [Drawing.Point]::new($Autodesk_AutoCAD_Form_ButtonCenterX, $Autodesk_AutoCAD_Form_ButtonYLocation)
    Add_Click    = ({ $Autodesk_AutoCAD_Form.Close() })
}

$Autodesk_AutoCAD_Form_Cancel_ButtonXLocation = $Autodesk_AutoCAD_Form_ButtonCenterX + $Autodesk_AutoCAD_Form_ButtonWidth + $Autodesk_AutoCAD_Form_ButtonSpacer
$Autodesk_AutoCAD_Form_Cancel = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Cancel'
    Width     = $Autodesk_AutoCAD_Form_ButtonWidth
    Height    = $Autodesk_AutoCAD_Form_ButtonHeight
    Location  = [Drawing.Point]::new($Autodesk_AutoCAD_Form_Cancel_ButtonXLocation, $Autodesk_AutoCAD_Form_ButtonYLocation)
    Add_Click = ({ $Autodesk_AutoCAD_Form.Close() })
}

$Autodesk_AutoCAD_Form.Controls.Add($Autodesk_AutoCAD_Form_OK)
$Autodesk_AutoCAD_Form.Controls.Add($Autodesk_AutoCAD_Form_Cancel)

if ($Autodesk_AutoCAD_Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $Autodesk_AutoCAD_Form_DropDownList_SelectedItem = $Autodesk_AutoCAD_Form_DropDownList.SelectedItem
    $Autodesk_AutoCAD_Form_DropDownList_SelectedItemHREF = $Autodesk_AutoCAD_Source_Array[$Autodesk_AutoCAD_Form_DropDownList_SelectedItem]

    $Autodesk_AutoCAD_Source_Forum_Post = ((Invoke-WebRequest -UseBasicParsing -Uri $Autodesk_AutoCAD_Form_DropDownList_SelectedItemHREF).Links | Where-Object {
            $_.outerHTML -match 'uniondht.org'
        }).href | Select-Object -First 1

    if ($null -eq $Autodesk_AutoCAD_Source_Forum_Post) {
        $Autodesk_AutoCAD_Source_Forum_Post = ((Invoke-WebRequest -UseBasicParsing -Uri $Autodesk_AutoCAD_Form_DropDownList_SelectedItemHREF).Links | Where-Object {
                $_.outerHTML -match 'pb.wtf'
            }).href | Select-Object -First 1
    }

    $Autodesk_AutoCAD_Source_Forum_Post_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $Autodesk_AutoCAD_Source_Forum_Post).Links | Where-Object {
            $_.outerHTML -match 'magnet'
        }).href | Select-Object -First 1
    
    $Autodesk_AutoCAD_Source_Forum_Post_Magnet_UnEscape = [Uri]::UnescapeDataString($Autodesk_AutoCAD_Source_Forum_Post_Magnet)

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')

    $Autodesk_AutoCAD_qBittorrent_Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $Autodesk_AutoCAD_qBittorrent_Log) {
        Remove-Item $Autodesk_AutoCAD_qBittorrent_Log -Force -ErrorAction SilentlyContinue
    }

    Remove-Item -Path "$env:TEMP\*AutoCAD*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue

    $Autodesk_AutoCAD_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Autodesk_AutoCAD_Source_Forum_Post_Magnet_UnEscape)"""

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()

    Start-Process qBittorrent.exe -ArgumentList $Autodesk_AutoCAD_qBittorrent_Argument

    while (-not ($Autodesk_AutoCAD_Temporary_Directory = (Get-ChildItem $env:TEMP -Directory -Filter '*AutoCAD*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $Autodesk_AutoCAD_Temporary_Directory

    while (-not ($Autodesk_AutoCAD_Temporary_ISO = (Get-ChildItem $Autodesk_AutoCAD_Temporary_Directory -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $Autodesk_AutoCAD_qBittorrent_Log -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*AutoCAD*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_ISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_Directory'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $Autodesk_AutoCAD_Temporary_ISO -o"$Autodesk_AutoCAD_Temporary_Directory" -y
    
    $Autodesk_AutoCAD_Temporary_SetupEXE = (Get-ChildItem -Path $Autodesk_AutoCAD_Temporary_Directory -Recurse -Filter 'setup.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_SetupEXE'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Autodesk_AutoCAD_Temporary_SetupEXE -ArgumentList '/silent'
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*AutoCAD*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }
    while ((Get-Process | Where-Object { $_.MainWindowTitle -Like '*AutoCAD*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }

    $Autodesk_AutoCAD_Temporary_Crack = (Get-ChildItem -Path $Autodesk_AutoCAD_Temporary_Directory -Recurse -Filter 'AdskNLM.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Cracking '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_Crack'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Autodesk_AutoCAD_Temporary_Crack
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' })) {
        Start-Sleep -Seconds 1 
    }
            (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' }).CloseMainWindow() | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Temporary_Directory'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $Autodesk_AutoCAD_Temporary_Directory

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Please open '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Autodesk_AutoCAD_Form_DropDownList_SelectedItem'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' and select '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Use a network license'"); [Console]::ResetColor(); [Console]::WriteLine()

    $Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{
        TopMost = $true
    }
    $Popup_Text = "Run AutoDesk AutoCAD and Select 'Use a network license'"
    [Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null
    $Popup_Usermanual.Dispose()
}