$AutoCAD_Form = New-Object System.Windows.Forms.Form
$AutoCAD_Form.Text = 'Autodesk AutoCAD Selection'
$AutoCAD_Form.StartPosition = 'CenterScreen'
$AutoCAD_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$AutoCAD_Form.Topmost = $true
$AutoCAD_Form.MaximizeBox = $false
$AutoCAD_Form.MinimizeBox = $false
$AutoCAD_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$AutoCAD_DropDown = New-Object System.Windows.Forms.ComboBox
$AutoCAD_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$AutoCAD_DropDown.DropDownStyle = 'DropDownList'

$AutoCAD_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/AutoCAD').Links | Where-Object { $_.outerHTML -match 'AutoCAD' -and $_.outerHTML -notmatch 'LT' -and $_.outerHTML -notmatch 'Addon' -and $_.outerHTML -notmatch '#more' }

$AutoCAD_nnmclub_Array = @{}
$AutoCAD_graphics = [System.Drawing.Graphics]::FromHwnd($AutoCAD_Form.Handle)
$AutoCAD_maxWidth = 0
foreach ($AutoCAD_nnmclub_post in $AutoCAD_nnmclub_search) {
    $AutoCAD_nnmclub_title = ($AutoCAD_nnmclub_post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $AutoCAD_nnmclub_url = $AutoCAD_nnmclub_post.href
    $AutoCAD_nnmclub_Array[$AutoCAD_nnmclub_title] = $AutoCAD_nnmclub_url
    $null = $AutoCAD_DropDown.Items.Add($AutoCAD_nnmclub_title)
    $AutoCAD_Width = [int]$AutoCAD_graphics.MeasureString($AutoCAD_nnmclub_title, $AutoCAD_Form.Font).Width
    if ($AutoCAD_Width -gt $AutoCAD_maxWidth) {
        $AutoCAD_maxWidth = $AutoCAD_Width 
    }
}
$AutoCAD_DropDown.Width = $AutoCAD_maxWidth + 10
$AutoCAD_FormWidth = $AutoCAD_DropDown.Width + 25
$AutoCAD_Form.Size = New-Object System.Drawing.Size($AutoCAD_FormWidth, 90)

$AutoCAD_Form.Controls.Add($AutoCAD_DropDown)

$AutoCAD_Form_OK = New-Object System.Windows.Forms.Button
$AutoCAD_Form_OK.Text = 'OK'
$AutoCAD_Form_OK.Location = New-Object System.Drawing.Size((($AutoCAD_Form.Width) / 3 ), (($AutoCAD_Form.height) - 60))
$AutoCAD_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$AutoCAD_Form_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$AutoCAD_Form.Controls.Add($AutoCAD_Form_OK)
$AutoCAD_Form.AcceptButton = $AutoCAD_Form_OK

$AutoCAD_Form_Cancel = New-Object System.Windows.Forms.Button
$AutoCAD_Form_Cancel.Location = New-Object System.Drawing.Size((($AutoCAD_Form.Width) / 2 ), (($AutoCAD_Form.height) - 60))
$AutoCAD_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$AutoCAD_Form_Cancel.Text = 'Cancel'
$AutoCAD_Form_Cancel.Add_Click({ $AutoCAD_Form.Close() })
$AutoCAD_Form.Controls.Add($AutoCAD_Form_Cancel)

if ($AutoCAD_Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $AutoCAD_SelectedVersion = $AutoCAD_DropDown.SelectedItem
    $AutoCAD_SelectedHREF = $AutoCAD_nnmclub_Array[$AutoCAD_SelectedVersion]

    $AutodeskAutoCAD_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $AutoCAD_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -First 1).href
    if ($null -eq $AutodeskAutoCAD_Forum) {
        $AutodeskAutoCAD_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $AutoCAD_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -First 1).href
    }
    $AutodeskAutoCAD_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $AutodeskAutoCAD_Forum).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $AutodeskAutoCAD_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $AutodeskAutoCAD_qBittorrent_LOG) {
        Remove-Item $AutodeskAutoCAD_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*AutoCAD*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $AutodeskAutoCAD_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($AutodeskAutoCAD_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoCAD_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $AutodeskAutoCAD_qBittorrent_Argument
    while (-not ($AutodeskAutoCAD_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*AutoCAD*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $AutodeskAutoCAD_TempDir

    while (-not ($AutodeskAutoCAD_TempISO = (Get-ChildItem $AutodeskAutoCAD_TempDir -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $AutodeskAutoCAD_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*AutoCAD*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Software/7-Zip/Download.ps1')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoCAD_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempDir'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $AutodeskAutoCAD_TempISO -o"$AutodeskAutoCAD_TempDir" -y

    $AutodeskAutoCAD_TempInstaller = (Get-ChildItem -Path $AutodeskAutoCAD_TempDir -Recurse -Filter 'setup.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoCAD_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempInstaller'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AutodeskAutoCAD_TempInstaller -ArgumentList '/silent'
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*AutoCAD*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }
    while ((Get-Process | Where-Object { $_.MainWindowTitle -Like '*AutoCAD*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }

    $AutodeskAutoCAD_TempCrack = (Get-ChildItem -Path $AutodeskAutoCAD_TempDir -Recurse -Filter 'AdskNLM.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Cracking '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoCAD_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempCrack'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AutodeskAutoCAD_TempCrack
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' })) {
        Start-Sleep -Seconds 1 
    }
            (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' }).CloseMainWindow() | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskAutoCAD_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $AutodeskAutoCAD_TempDir

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Please open '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutoCAD_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' and select '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Use a network license'"); [Console]::ResetColor(); [Console]::WriteLine()
}