$Revit_Form = New-Object System.Windows.Forms.Form
$Revit_Form.Text = 'Autodesk Revit Selection'
$Revit_Form.StartPosition = 'CenterScreen'
$Revit_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$Revit_Form.Topmost = $true
$Revit_Form.MaximizeBox = $false
$Revit_Form.MinimizeBox = $false
$Revit_Form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog

$Revit_DropDown = New-Object System.Windows.Forms.ComboBox
$Revit_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$Revit_DropDown.DropDownStyle = 'DropDownList'

$Revit_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Revit').Links | Where-Object { $_.outerHTML -match 'Multilingual' -and $_.outerHTML -notmatch '#more' -and $_.outerHTML -match 'Revit' }

$Revit_nnmclub_Array = @{}
$Revit_graphics = [Drawing.Graphics]::FromHwnd($Revit_Form.Handle)
$Revit_maxWidth = 0
foreach ($Revit_nnmclub_post in $Revit_nnmclub_search) {
    $Revit_nnmclub_title = ($Revit_nnmclub_post.outerHTML -replace '.*?>(.*?)</a>', '$1')
    $Revit_nnmclub_url = $Revit_nnmclub_post.href
    $Revit_nnmclub_Array[$Revit_nnmclub_title] = $Revit_nnmclub_url
    $null = $Revit_DropDown.Items.Add($Revit_nnmclub_title)
    $Revit_Width = [int]$Revit_graphics.MeasureString($Revit_nnmclub_title, $Revit_Form.Font).Width
    if ($Revit_Width -gt $Revit_maxWidth) {
        $Revit_maxWidth = $Revit_Width 
    }
}
$Revit_DropDown.Width = $Revit_maxWidth + 10
$Revit_FormWidth = $Revit_DropDown.Width + 25
$Revit_Form.Size = New-Object System.Drawing.Size($Revit_FormWidth, 90)

$Revit_Form.Controls.Add($Revit_DropDown)

$Revit_Form_OK = New-Object System.Windows.Forms.Button
$Revit_Form_OK.Text = 'OK'
$Revit_Form_OK.Location = New-Object System.Drawing.Size((($Revit_Form.Width) / 3 ), (($Revit_Form.height) - 60))
$Revit_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$Revit_Form_OK.DialogResult = [Windows.Forms.DialogResult]::OK
$Revit_Form.Controls.Add($Revit_Form_OK)
$Revit_Form.AcceptButton = $Revit_Form_OK

$Revit_Form_Cancel = New-Object System.Windows.Forms.Button
$Revit_Form_Cancel.Location = New-Object System.Drawing.Size((($Revit_Form.Width) / 2 ), (($Revit_Form.height) - 60))
$Revit_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Revit_Form_Cancel.Text = 'Cancel'
$Revit_Form_Cancel.Add_Click({ $Revit_Form.Close() })
$Revit_Form.Controls.Add($Revit_Form_Cancel)

if ($Revit_Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $Revit_SelectedVersion = $Revit_DropDown.SelectedItem
    $Revit_SelectedHREF = $Revit_nnmclub_Array[$Revit_SelectedVersion]

    $AutodeskRevit_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Revit_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'uniondht.org' } | Select-Object -First 1).href
    if ($null -eq $AutodeskRevit_Forum) {
        $AutodeskRevit_Forum = ((Invoke-WebRequest -UseBasicParsing -Uri $Revit_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'pb.wtf' } | Select-Object -First 1).href
    }
    $AutodeskRevit_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $AutodeskRevit_Forum).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $AutodeskRevit_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $AutodeskRevit_qBittorrent_LOG) {
        Remove-Item $AutodeskRevit_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*Revit*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $AutodeskRevit_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($AutodeskRevit_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Revit_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $AutodeskRevit_qBittorrent_Argument
    while (-not ($AutodeskRevit_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Revit*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $AutodeskRevit_TempDir

    while (-not ($AutodeskRevit_TempISO = (Get-ChildItem $AutodeskRevit_TempDir -Filter '*.iso' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $AutodeskRevit_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*Revit*')

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Revit_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempISO'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempDir'"); [Console]::ResetColor(); [Console]::WriteLine()
    7z.exe x $AutodeskRevit_TempISO -o"$AutodeskRevit_TempDir" -y

    $AutodeskRevit_TempInstaller = (Get-ChildItem -Path $AutodeskRevit_TempDir -Recurse -Filter 'setup.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Revit_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempInstaller'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AutodeskRevit_TempInstaller
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*Revit*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }
    while ((Get-Process | Where-Object { $_.MainWindowTitle -Like '*Revit*Installer' })) {
        Start-Sleep -Milliseconds 1000
    }

    $AutodeskRevit_TempCrack = (Get-ChildItem -Path $AutodeskRevit_TempDir -Recurse -Filter 'AdskNLM.exe').FullName
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Cracking '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Revit_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempCrack'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $AutodeskRevit_TempCrack
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' })) {
        Start-Sleep -Seconds 1 
    }
    (Get-Process | Where-Object { $_.MainWindowTitle -Like '*crack*' }).CloseMainWindow() | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AutodeskRevit_TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $AutodeskRevit_TempDir

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Please open '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Revit_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' and select '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Use a network license'"); [Console]::ResetColor(); [Console]::WriteLine()
}