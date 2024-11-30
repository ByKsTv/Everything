$VMWare_Form = New-Object System.Windows.Forms.Form
$VMWare_Form.Text = 'VMWare Workstation Pro Selection'
$VMWare_Form.StartPosition = 'CenterScreen'
$VMWare_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$VMWare_Form.Topmost = $true
$VMWare_Form.MaximizeBox = $false
$VMWare_Form.MinimizeBox = $false
$VMWare_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$VMWare_DropDown = New-Object System.Windows.Forms.ComboBox
$VMWare_DropDown.Location = New-Object System.Drawing.Point(5, 0)
$VMWare_DropDown.DropDownStyle = 'DropDownList'

$VMWare_nnmclub_search = (Invoke-WebRequest -UseBasicParsing -Uri 'https://nnmclub.to/forum/tracker.php?nm=VMware%20KpoJIuK').Links | Where-Object { $_.class -match 'genmed topictitle' }

$VMWare_nnmclub_Array = @{}
$VMWare_graphics = [System.Drawing.Graphics]::FromHwnd($VMWare_Form.Handle)
$VMWare_maxWidth = 0
foreach ($VMWare_nnmclub_post in $VMWare_nnmclub_search) {
    $VMWare_nnmclub_title = ($VMWare_nnmclub_post.outerHTML -replace '.*?<b>(.*?)</b></a>', '$1')
    $VMWare_nnmclub_url = 'https://nnmclub.to/forum/' + $VMWare_nnmclub_post.href
    $VMWare_nnmclub_Array[$VMWare_nnmclub_title] = $VMWare_nnmclub_url
    $null = $VMWare_DropDown.Items.Add($VMWare_nnmclub_title)
    $VMWare_Width = [int]$VMWare_graphics.MeasureString($VMWare_nnmclub_title, $VMWare_Form.Font).Width
    if ($VMWare_Width -gt $VMWare_maxWidth) {
        $VMWare_maxWidth = $VMWare_Width 
    }
}
$VMWare_DropDown.Width = $VMWare_maxWidth + 10
$VMWare_FormWidth = $VMWare_DropDown.Width + 25
$VMWare_Form.Size = New-Object System.Drawing.Size($VMWare_FormWidth, 90)

$VMWare_Form.Controls.Add($VMWare_DropDown)

$VMWare_Form_OK = New-Object System.Windows.Forms.Button
$VMWare_Form_OK.Text = 'OK'
$VMWare_Form_OK.Location = New-Object System.Drawing.Size((($VMWare_Form.Width) / 3 ), (($VMWare_Form.height) - 60))
$VMWare_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$VMWare_Form_OK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$VMWare_Form.Controls.Add($VMWare_Form_OK)
$VMWare_Form.AcceptButton = $VMWare_Form_OK

$VMWare_Form_Cancel = New-Object System.Windows.Forms.Button
$VMWare_Form_Cancel.Location = New-Object System.Drawing.Size((($VMWare_Form.Width) / 2 ), (($VMWare_Form.height) - 60))
$VMWare_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$VMWare_Form_Cancel.Text = 'Cancel'
$VMWare_Form_Cancel.Add_Click({ $VMWare_Form.Close() })
$VMWare_Form.Controls.Add($VMWare_Form_Cancel)

if ($VMWare_Form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $VMWare_SelectedVersion = $VMWare_DropDown.SelectedItem
    $VMWare_SelectedHREF = $VMWare_nnmclub_Array[$VMWare_SelectedVersion]

    $VMware_Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $VMWare_SelectedHREF).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
    $VMware_qBittorrent_LOG = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
    if (Test-Path $VMware_qBittorrent_LOG) {
        Remove-Item $VMware_qBittorrent_LOG -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -Path "$env:TEMP\*VMware*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
    $VMware_qBittorrent_Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($VMware_Magnet)"""
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VMWare_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VMware_qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process qBittorrent.exe -ArgumentList $VMware_qBittorrent_Argument
    while (-not ($VMware_TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*VMware*' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-MpPreference -ExclusionPath $env:TEMP
    
    while (-not ($VMware_TempEXE = (Get-ChildItem $VMware_TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
        Start-Sleep -Milliseconds 1000
    }
    do {
        Start-Sleep -Milliseconds 1000
    } until ((Get-Content $VMware_qBittorrent_LOG -ErrorAction SilentlyContinue) -match 'Torrent removed. Torrent: .*VMware*')
    
    $VMware_Argument = '/S /QE'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VMWare_SelectedVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VMware_TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VMware_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Unblock-File $VMware_TempEXE
    Start-Process $VMware_TempEXE -ArgumentList $VMware_Argument -Wait
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$env:TEMP'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-MpPreference -ExclusionPath $env:TEMP
}