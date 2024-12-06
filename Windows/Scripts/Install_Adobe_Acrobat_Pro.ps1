[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: User Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Display splash screen at launch: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'bDisplayAboutDialog' -Value 0 -PropertyType DWord -Force
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Preferences: Catalog: Enable Logging: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Name 'bCreateLog' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Preferences: Page Display: Zoom: Fit Visible'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'iDefaultZoomType' -Value '4' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: General: Show me messages when I launch Adobe Acrobat: Disable'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Name 'bShowMsgAtLaunch' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Edit: Prefrences: Security (Enhanced): Protected View: All Files'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force

$AcrobatPro_Form = New-Object System.Windows.Forms.Form
$AcrobatPro_Form.Text = 'Adobe Acrobat Pro Selection'
$AcrobatPro_Form.StartPosition = 'CenterScreen'
$AcrobatPro_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$AcrobatPro_Form.Topmost = $true
$AcrobatPro_Form.MaximizeBox = $false
$AcrobatPro_Form.MinimizeBox = $false
$AcrobatPro_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$AcrobatPro_DropDown = New-Object System.Windows.Forms.ComboBox
$AcrobatPro_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$AcrobatPro_DropDown.DropDownStyle = 'DropDownList'

$AcrobatPro_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Acrobat').Links | Where-Object { $_.outerHTML -match 'x64' -and $_.outerHTML -notmatch '#more' }

$AcrobatPro_nnmclub_Array = @{}
$AcrobatPro_graphics = [System.Drawing.Graphics]::FromHwnd($AcrobatPro_Form.Handle)
$AcrobatPro_maxWidth = 0
foreach ($AcrobatPro_nnmclub_post in $AcrobatPro_nnmclub_search) {
    $AcrobatPro_nnmclub_title = ($AcrobatPro_nnmclub_post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $AcrobatPro_nnmclub_url = $AcrobatPro_nnmclub_post.href
    $AcrobatPro_nnmclub_Array[$AcrobatPro_nnmclub_title] = $AcrobatPro_nnmclub_url
    $null = $AcrobatPro_DropDown.Items.Add($AcrobatPro_nnmclub_title)
    $AcrobatPro_Width = [int]$AcrobatPro_graphics.MeasureString($AcrobatPro_nnmclub_title, $AcrobatPro_Form.Font).Width
    if ($AcrobatPro_Width -gt $AcrobatPro_maxWidth) {
        $AcrobatPro_maxWidth = $AcrobatPro_Width 
    }
}
$AcrobatPro_DropDown.Width = $AcrobatPro_maxWidth + 10
$AcrobatPro_FormWidth = $AcrobatPro_DropDown.Width + 25
$AcrobatPro_Form.Size = New-Object System.Drawing.Size($AcrobatPro_FormWidth, 90)

$AcrobatPro_Form.Controls.Add($AcrobatPro_DropDown)

$AcrobatPro_Form_OK = New-Object System.Windows.Forms.Button
$AcrobatPro_Form_OK.Text = 'OK'
$AcrobatPro_Form_OK.Location = New-Object System.Drawing.Size((($AcrobatPro_Form.Width) / 3 ), (($AcrobatPro_Form.height) - 60))
$AcrobatPro_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$AcrobatPro_Form_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$AcrobatPro_Form.Controls.Add($AcrobatPro_Form_OK)
$AcrobatPro_Form.AcceptButton = $AcrobatPro_Form_OK

$AcrobatPro_Form_Cancel = New-Object System.Windows.Forms.Button
$AcrobatPro_Form_Cancel.Location = New-Object System.Drawing.Size((($AcrobatPro_Form.Width) / 2 ), (($AcrobatPro_Form.height) - 60))
$AcrobatPro_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$AcrobatPro_Form_Cancel.Text = 'Cancel'
$AcrobatPro_Form_Cancel.Add_Click({ $AcrobatPro_Form.Close() })
$AcrobatPro_Form.Controls.Add($AcrobatPro_Form_Cancel)

if ($AcrobatPro_Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $AcrobatPro_SelectedVersion = $AcrobatPro_DropDown.SelectedItem
    $AcrobatPro_SelectedHREF = $AcrobatPro_nnmclub_Array[$AcrobatPro_SelectedVersion]

    $AcrobatPro_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $AcrobatPro_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -First 1).href
    if ($null -eq $AcrobatPro_Forum) {
        $AcrobatPro_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $AcrobatPro_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -First 1).href
    }
    $AcrobatPro_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $AcrobatPro_Forum).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $AcrobatPro_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $AcrobatPro_qBittorrent_LOG) {
        Remove-Item $AcrobatPro_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*Acrobat*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $AcrobatPro_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($AcrobatPro_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $AcrobatPro_qBittorrent_Argument
    while (-not ($AcrobatPro_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Acrobat*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $AcrobatPro_TempDir

    while (-not ($AcrobatPro_TempISO = (Get-ChildItem $AcrobatPro_TempDir -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $AcrobatPro_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Acrobat*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Software/7-Zip/Download.ps1')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_TempISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_TempDir'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $AcrobatPro_TempISO -o"$AcrobatPro_TempDir" -y

    $AcrobatPro_TempInstaller = (Get-ChildItem -Path $AcrobatPro_TempDir -Recurse -Filter 'autoplay.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AcrobatPro_TempInstaller'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AcrobatPro_TempInstaller
}