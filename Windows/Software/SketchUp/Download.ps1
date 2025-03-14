Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$SketchUp_Form = New-Object System.Windows.Forms.Form
$SketchUp_Form.Text = 'SketchUp Pro Selection'
$SketchUp_Form.StartPosition = 'CenterScreen'
$SketchUp_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$SketchUp_Form.Topmost = $true
$SketchUp_Form.MaximizeBox = $false
$SketchUp_Form.MinimizeBox = $false
$SketchUp_Form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog
        
$SketchUp_DropDown = New-Object System.Windows.Forms.ComboBox
$SketchUp_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$SketchUp_DropDown.DropDownStyle = 'DropDownList'
        
$SketchUp_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://nnmclub.to/forum/tracker.php?nm=SketchUp%20KpoJIuK').Links | Where-Object { $_.class -match 'genmed topictitle' }
        
$SketchUp_nnmclub_Array = @{}
$SketchUp_graphics = [Drawing.Graphics]::FromHwnd($SketchUp_Form.Handle)
$SketchUp_maxWidth = 0
foreach ($SketchUp_nnmclub_post in $SketchUp_nnmclub_search) {
    $SketchUp_nnmclub_title = ($SketchUp_nnmclub_post.outerHTML -replace '.*?<b>(.*?)</b></a>', '$1')
    $SketchUp_nnmclub_url = 'https://nnmclub.to/forum/' + $SketchUp_nnmclub_post.href
    $SketchUp_nnmclub_Array[$SketchUp_nnmclub_title] = $SketchUp_nnmclub_url
    $null = $SketchUp_DropDown.Items.Add($SketchUp_nnmclub_title)
    $SketchUp_Width = [int]$SketchUp_graphics.MeasureString($SketchUp_nnmclub_title, $SketchUp_Form.Font).Width
    if ($SketchUp_Width -gt $SketchUp_maxWidth) {
        $SketchUp_maxWidth = $SketchUp_Width 
    }
}
$SketchUp_DropDown.Width = $SketchUp_maxWidth + 10
$SketchUp_FormWidth = $SketchUp_DropDown.Width + 25
$SketchUp_Form.Size = New-Object System.Drawing.Size($SketchUp_FormWidth, 90)
        
$SketchUp_Form.Controls.Add($SketchUp_DropDown)
        
$SketchUp_Form_OK = New-Object System.Windows.Forms.Button
$SketchUp_Form_OK.Text = 'OK'
$SketchUp_Form_OK.Location = New-Object System.Drawing.Size((($SketchUp_Form.Width) / 3 ), (($SketchUp_Form.height) - 60))
$SketchUp_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$SketchUp_Form_OK.DialogResult = [Windows.Forms.DialogResult]::OK
$SketchUp_Form.Controls.Add($SketchUp_Form_OK)
$SketchUp_Form.AcceptButton = $SketchUp_Form_OK
        
$SketchUp_Form_Cancel = New-Object System.Windows.Forms.Button
$SketchUp_Form_Cancel.Location = New-Object System.Drawing.Size((($SketchUp_Form.Width) / 2 ), (($SketchUp_Form.height) - 60))
$SketchUp_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$SketchUp_Form_Cancel.Text = 'Cancel'
$SketchUp_Form_Cancel.Add_Click({ $SketchUp_Form.Close() })
$SketchUp_Form.Controls.Add($SketchUp_Form_Cancel)
        
if ($SketchUp_Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $SketchUp_SelectedVersion = $SketchUp_DropDown.SelectedItem
    $SketchUp_SelectedHREF = $SketchUp_nnmclub_Array[$SketchUp_SelectedVersion]

    $SketchUp_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $SketchUp_SelectedHREF).Links | Where-Object {
            $_.outerHTML -match 'magnet'
        } | Select-Object -First 1).href

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
    $SketchUp_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $SketchUp_qBittorrent_LOG) {
        Remove-Item $SketchUp_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*SketchUp*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $SketchUp_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($SketchUp_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SketchUp_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SketchUp_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()

    Start-Process qBittorrent.exe -ArgumentList $SketchUp_qBittorrent_Argument
    while (-not ($SketchUp_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*SketchUp*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $env:TEMP

    while (-not ($SketchUp_TempEXE = (Get-ChildItem $SketchUp_TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $SketchUp_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*SketchUp*')

    $SketchUp_Argument = '/S /EN'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SketchUp_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SketchUp_TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SketchUp_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Unblock-File $SketchUp_TempEXE
    Start-Process $SketchUp_TempEXE -ArgumentList $SketchUp_Argument -Wait

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $env:TEMP
}