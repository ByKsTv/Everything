$Photoshop_Form = New-Object System.Windows.Forms.Form
$Photoshop_Form.Text = 'Adobe Photoshop Selection'
$Photoshop_Form.StartPosition = 'CenterScreen'
$Photoshop_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$Photoshop_Form.Topmost = $true
$Photoshop_Form.MaximizeBox = $false
$Photoshop_Form.MinimizeBox = $false
$Photoshop_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$Photoshop_DropDown = New-Object System.Windows.Forms.ComboBox
$Photoshop_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$Photoshop_DropDown.DropDownStyle = 'DropDownList'

$Photoshop_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Photoshop').Links | Where-Object { $_.outerHTML -notmatch 'Elements' -and $_.outerHTML -notmatch 'Collection' -and $_.outerHTML -match 'Multilingual' -and $_.outerHTML -notmatch '#more' -and $_.outerHTML -match 'Photoshop' }

$Photoshop_nnmclub_Array = @{}
$Photoshop_graphics = [System.Drawing.Graphics]::FromHwnd($Photoshop_Form.Handle)
$Photoshop_maxWidth = 0
foreach ($Photoshop_nnmclub_post in $Photoshop_nnmclub_search) {
    $Photoshop_nnmclub_title = ($Photoshop_nnmclub_post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $Photoshop_nnmclub_url = $Photoshop_nnmclub_post.href
    $Photoshop_nnmclub_Array[$Photoshop_nnmclub_title] = $Photoshop_nnmclub_url
    $null = $Photoshop_DropDown.Items.Add($Photoshop_nnmclub_title)
    $Photoshop_Width = [int]$Photoshop_graphics.MeasureString($Photoshop_nnmclub_title, $Photoshop_Form.Font).Width
    if ($Photoshop_Width -gt $Photoshop_maxWidth) {
        $Photoshop_maxWidth = $Photoshop_Width 
    }
}
$Photoshop_DropDown.Width = $Photoshop_maxWidth + 10
$Photoshop_FormWidth = $Photoshop_DropDown.Width + 25
$Photoshop_Form.Size = New-Object System.Drawing.Size($Photoshop_FormWidth, 90)

$Photoshop_Form.Controls.Add($Photoshop_DropDown)

$Photoshop_Form_OK = New-Object System.Windows.Forms.Button
$Photoshop_Form_OK.Text = 'OK'
$Photoshop_Form_OK.Location = New-Object System.Drawing.Size((($Photoshop_Form.Width) / 3 ), (($Photoshop_Form.height) - 60))
$Photoshop_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$Photoshop_Form_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Photoshop_Form.Controls.Add($Photoshop_Form_OK)
$Photoshop_Form.AcceptButton = $Photoshop_Form_OK

$Photoshop_Form_Cancel = New-Object System.Windows.Forms.Button
$Photoshop_Form_Cancel.Location = New-Object System.Drawing.Size((($Photoshop_Form.Width) / 2 ), (($Photoshop_Form.height) - 60))
$Photoshop_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Photoshop_Form_Cancel.Text = 'Cancel'
$Photoshop_Form_Cancel.Add_Click({ $Photoshop_Form.Close() })
$Photoshop_Form.Controls.Add($Photoshop_Form_Cancel)

if ($Photoshop_Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $Photoshop_SelectedVersion = $Photoshop_DropDown.SelectedItem
    $Photoshop_SelectedHREF = $Photoshop_nnmclub_Array[$Photoshop_SelectedVersion]
    
    $AdobePhotoshop_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Photoshop_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -First 1).href
    if ($null -eq $AdobePhotoshop_Forum) {
        $AdobePhotoshop_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Photoshop_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -First 1).href
    }
    $AdobePhotoshop_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $AdobePhotoshop_Forum).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $AdobePhotoshop_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $AdobePhotoshop_qBittorrent_LOG) {
        Remove-Item $AdobePhotoshop_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*Photoshop*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $AdobePhotoshop_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($AdobePhotoshop_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Photoshop_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobePhotoshop_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $AdobePhotoshop_qBittorrent_Argument
    while (-not ($AdobePhotoshop_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Photoshop*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobePhotoshop_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $AdobePhotoshop_TempDir

    while (-not ($AdobePhotoshop_TempISO = (Get-ChildItem $AdobePhotoshop_TempDir -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $AdobePhotoshop_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Photoshop*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Software/7-Zip/Download.ps1')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Photoshop_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobePhotoshop_TempISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobePhotoshop_TempDir'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $AdobePhotoshop_TempISO -o"$AdobePhotoshop_TempDir" -y

    $AdobePhotoshop_TempInstaller = (Get-ChildItem -Path $AdobePhotoshop_TempDir -Recurse -Filter 'autoplay.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Photoshop_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobePhotoshop_TempInstaller'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AdobePhotoshop_TempInstaller
}