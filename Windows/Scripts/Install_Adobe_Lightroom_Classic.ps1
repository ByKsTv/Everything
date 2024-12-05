$Lightroom_Form = New-Object System.Windows.Forms.Form
$Lightroom_Form.Text = 'Adobe Lightroom Classic Selection'
$Lightroom_Form.StartPosition = 'CenterScreen'
$Lightroom_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$Lightroom_Form.Topmost = $true
$Lightroom_Form.MaximizeBox = $false
$Lightroom_Form.MinimizeBox = $false
$Lightroom_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$Lightroom_DropDown = New-Object System.Windows.Forms.ComboBox
$Lightroom_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$Lightroom_DropDown.DropDownStyle = 'DropDownList'

$Lightroom_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Lightroom').Links | Where-Object { $_.outerHTML -match 'Classic' -and $_.outerHTML -notmatch '#more' }

$Lightroom_nnmclub_Array = @{}
$Lightroom_graphics = [System.Drawing.Graphics]::FromHwnd($Lightroom_Form.Handle)
$Lightroom_maxWidth = 0
foreach ($Lightroom_nnmclub_post in $Lightroom_nnmclub_search) {
    $Lightroom_nnmclub_title = ($Lightroom_nnmclub_post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $Lightroom_nnmclub_url = $Lightroom_nnmclub_post.href
    $Lightroom_nnmclub_Array[$Lightroom_nnmclub_title] = $Lightroom_nnmclub_url
    $null = $Lightroom_DropDown.Items.Add($Lightroom_nnmclub_title)
    $Lightroom_Width = [int]$Lightroom_graphics.MeasureString($Lightroom_nnmclub_title, $Lightroom_Form.Font).Width
    if ($Lightroom_Width -gt $Lightroom_maxWidth) {
        $Lightroom_maxWidth = $Lightroom_Width 
    }
}
$Lightroom_DropDown.Width = $Lightroom_maxWidth + 10
$Lightroom_FormWidth = $Lightroom_DropDown.Width + 25
$Lightroom_Form.Size = New-Object System.Drawing.Size($Lightroom_FormWidth, 90)

$Lightroom_Form.Controls.Add($Lightroom_DropDown)

$Lightroom_Form_OK = New-Object System.Windows.Forms.Button
$Lightroom_Form_OK.Text = 'OK'
$Lightroom_Form_OK.Location = New-Object System.Drawing.Size((($Lightroom_Form.Width) / 3 ), (($Lightroom_Form.height) - 60))
$Lightroom_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$Lightroom_Form_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Lightroom_Form.Controls.Add($Lightroom_Form_OK)
$Lightroom_Form.AcceptButton = $Lightroom_Form_OK

$Lightroom_Form_Cancel = New-Object System.Windows.Forms.Button
$Lightroom_Form_Cancel.Location = New-Object System.Drawing.Size((($Lightroom_Form.Width) / 2 ), (($Lightroom_Form.height) - 60))
$Lightroom_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Lightroom_Form_Cancel.Text = 'Cancel'
$Lightroom_Form_Cancel.Add_Click({ $Lightroom_Form.Close() })
$Lightroom_Form.Controls.Add($Lightroom_Form_Cancel)

if ($Lightroom_Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $Lightroom_SelectedVersion = $Lightroom_DropDown.SelectedItem
    $Lightroom_SelectedHREF = $Lightroom_nnmclub_Array[$Lightroom_SelectedVersion]
        
    $AdobeLightroomClassic_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -First 1).href
    if ($null -eq $AdobeLightroomClassic_Forum) {
        $AdobeLightroomClassic_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -First 1).href
    }
    $AdobeLightroomClassic_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $AdobeLightroomClassic_Forum).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $AdobeLightroomClassic_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $AdobeLightroomClassic_qBittorrent_LOG) {
        Remove-Item $AdobeLightroomClassic_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*Classic*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $AdobeLightroomClassic_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($AdobeLightroomClassic_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Lightroom_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeLightroomClassic_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $AdobeLightroomClassic_qBittorrent_Argument
    while (-not ($AdobeLightroomClassic_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Classic*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeLightroomClassic_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $AdobeLightroomClassic_TempDir

    while (-not ($AdobeLightroomClassic_TempISO = (Get-ChildItem $AdobeLightroomClassic_TempDir -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $AdobeLightroomClassic_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Classic*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Software/7-Zip/Download.ps1')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Lightroom_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeLightroomClassic_TempISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeLightroomClassic_TempDir'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $AdobeLightroomClassic_TempISO -o"$AdobeLightroomClassic_TempDir" -y

    $AdobeLightroomClassic_TempInstaller = (Get-ChildItem -Path $AdobeLightroomClassic_TempDir -Recurse -Filter 'autoplay.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Lightroom_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeLightroomClassic_TempInstaller'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AdobeLightroomClassic_TempInstaller
}