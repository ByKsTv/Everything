Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_SoftwareSelection = New-Object System.Windows.Forms.Form
$Form_SoftwareSelection.width = 350
$Form_SoftwareSelection.height = 600
$Form_SoftwareSelection.Text = 'Software Selection'
$Form_SoftwareSelection.StartPosition = 'CenterScreen'
$Form_SoftwareSelection.Font = New-Object System.Drawing.Font('Tahoma', 11)

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
$CheckBox_X_Axis = 5
$CheckBox_Y_Axis = 0
$CheckBox_Size_X = (($Form_SoftwareSelection.width) - 50)
$CheckBox_Size_Y = 26
# Icons size 16x16, format .ico from .exe file use 7zip
# [Convert]::ToBase64String((Get-Content "path" -Encoding Byte)) | Clip

$Panel_SoftwareSelection = New-Object System.Windows.Forms.Panel
$Panel_SoftwareSelection.Location = New-Object System.Drawing.Size(0, 0)
$Panel_SoftwareSelection.Size = New-Object System.Drawing.Size((($Form_SoftwareSelection.width) - 17), (($Form_SoftwareSelection.Height) - 65))
$Panel_SoftwareSelection.AutoScroll = $true
$Panel_SoftwareSelection.AutoSize = $false
$Form_SoftwareSelection.Controls.Add($Panel_SoftwareSelection)

$CheckBox_DotNET = New-Object System.Windows.Forms.CheckBox
$CheckBox_DotNET.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_DotNET.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Resized from Official ICO from Website
$CheckBox_DotNET_Icon64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAFaSURBVDhPYwjUvvKfEjzcDAjQAuHLUPZlvBimB24ASLO/5uX/tsLn//tpXP7vrXLpv6fipf9Okhf+u8peBLNdZS7+dxA7/99D4SLcELgBIM3eqpf/gwBIU1vuw/9Tap78f3r/x//TBz79n9327P/lk1/A8luWvPnvLn8R0wB/oCuunv7y/9zhT/8Lgu787y159P/Gha//Mz1v/Q/Ru/LfWeri/wvHPv235DsH1oNiAMiJIAMOb/vwf1r90/+717z735bzEGxAd9Gj//E21//7qV8GW+AsdQHVAG/lS/8nVT35n+V16//1c1/+6zCcBju1M//h/ydALyzofv6/Lunef1+1y/8f3PyGaYA/MNAS7W/8D9a98j/a/BpYISiQQM4G8XN8bv2Ps4a4IMbyGjiQUQyAGRIADAeYJDhMQHygJpCBYHmgociaQRhuALmYcgMgqY98TKELrvwHAGRka8PdqgvVAAAAAElFTkSuQmCC'
$CheckBox_DotNET_IconBytes = [Convert]::FromBase64String($CheckBox_DotNET_Icon64)
$CheckBox_DotNET_IconStream = [System.IO.MemoryStream]::new($CheckBox_DotNET_IconBytes, 0, $CheckBox_DotNET_IconBytes.Length)
$CheckBox_DotNET.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_DotNET_IconStream).GetHIcon()))
$CheckBox_DotNET.ImageAlign = 'MiddleLeft'
$CheckBox_DotNET.Text = '    .NET'
$CheckBox_DotNET.TextAlign = 'MiddleLeft'
$CheckBox_DotNET.CheckAlign = 'MiddleLeft'
$CheckBox_DotNET.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_DotNET)

$DotNET = '.NET Updater'
$DotNET_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $DotNET }
if (($DotNET_Exists)) {
    $CheckBox_DotNET.Enabled = $false
    $CheckBox_DotNET.Text += ' (Installed)'
}

$CheckBox_7Zip = New-Object System.Windows.Forms.CheckBox
$CheckBox_7Zip.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_7Zip.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_7Zip_Icon64 = 'AAABAAEAEBAQAAAAAAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICAgAAAAP8AAP8AAAD//wD/AAAA/wD/AP//AAD///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/////////APAAAADwAA8A8A/wAPAP/wDwD/AA/wD/APAP8AD/AP8A8AD/AP/wDwDwAA/w8AAPAPD///D///8A8AAAAP///wD/////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//AAD//wAA'
$CheckBox_7Zip_IconBytes = [Convert]::FromBase64String($CheckBox_7Zip_Icon64)
$CheckBox_7Zip_IconStream = [System.IO.MemoryStream]::new($CheckBox_7Zip_IconBytes, 0, $CheckBox_7Zip_IconBytes.Length)
$CheckBox_7Zip.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_7Zip_IconStream).GetHIcon()))
$CheckBox_7Zip.ImageAlign = 'MiddleLeft'
$CheckBox_7Zip.Text = '    7-Zip'
$CheckBox_7Zip.TextAlign = 'MiddleLeft'
$CheckBox_7Zip.CheckAlign = 'MiddleLeft'
$CheckBox_7Zip.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_7Zip)

$7Zip = '7-Zip Updater'
$7Zip_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $7Zip }
if (($7Zip_Exists)) {
    $CheckBox_7Zip.Enabled = $false
    $CheckBox_7Zip.Text += ' (Installed)'
}

$CheckBox_AdobeAcrobat = New-Object System.Windows.Forms.CheckBox
$CheckBox_AdobeAcrobat.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_AdobeAcrobat.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_AdobeAcrobat_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAACMuAAAjLgAAAAAAAAAAAAAAAAAGAAAATQAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAE0AAAAGAAIgWAAKn9kAC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8ACp/ZAAIgWAAKn9kAC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wAKn9kAC7P/AAuz/4CF2f/g4fb/0NLx/yAqvf8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs//Aw+z/EBq4/7Cz5//Q0vH/EBq4/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/ICq9/7Cz5//Q0vH//////5CV3v8AC7P/AAuz/wALs/9gZ9D/8PH7/8DD7P8gKr3/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/ICq9/8DD7P//////4OH2/5CV3v+Ahdn/0NLx/xAauP/g4fb/sLPn/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8gKr3//////yAqvf+gpOP/8PH7/8DD7P/Aw+z/sLPn/zA5wf8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/6Ck4/+gpOP//////zA5wf8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/9QWMv//////5CV3v8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/QEjG//////+gpOP/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/6Ck4//Aw+z/wMPs/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs//Aw+z/ICq9/7Cz5/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/cHbU//Dx+/8gKr3/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALssEAC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALssEAC7MQAAuzwAALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs/8AC7P/AAuz/wALs8AAC7MQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_AdobeAcrobat_IconBytes = [Convert]::FromBase64String($CheckBox_AdobeAcrobat_Icon64)
$CheckBox_AdobeAcrobat_IconStream = [System.IO.MemoryStream]::new($CheckBox_AdobeAcrobat_IconBytes, 0, $CheckBox_AdobeAcrobat_IconBytes.Length)
$CheckBox_AdobeAcrobat.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_AdobeAcrobat_IconStream).GetHIcon()))
$CheckBox_AdobeAcrobat.ImageAlign = 'MiddleLeft'
$CheckBox_AdobeAcrobat.Text = '    Adobe Acrobat Pro'
$CheckBox_AdobeAcrobat.TextAlign = 'MiddleLeft'
$CheckBox_AdobeAcrobat.CheckAlign = 'MiddleLeft'
$CheckBox_AdobeAcrobat.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_AdobeAcrobat)

# if ($InstalledSoftware -match 'Adobe Acrobat') {
#     $CheckBox_AdobeAcrobat.Enabled = $false
#     $CheckBox_AdobeAcrobat.Text += ' (Installed)'
# }

$CheckBox_AdobeLightroomClassic = New-Object System.Windows.Forms.CheckBox
$CheckBox_AdobeLightroomClassic.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_AdobeLightroomClassic.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_AdobeLightroomClassic_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAAAAAAGAAAATQAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAE0AAAAGCgUAWDAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP8wGwDZCgUAWDAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP+bYxn//6gx//+oMf//qDH/86Au/zYeAP//qDH/m2MZ/zYeAP82HgD/Ty8G/7R1H//nlyv/zYYl/zYeAP82HgD/m2MZ//+oMf/NhiX/zYYl/82GJf82HgD//6gx/5tjGf82HgD/Nh4A/7R1H///qDH/tHUf/8F9Iv82HgD/Nh4A/5tjGf//qDH/Nh4A/zYeAP82HgD/Nh4A//+oMf+bYxn/Nh4A/zYeAP/zoC7/m2MZ/zYeAP82HgD/Nh4A/zYeAP+bYxn//6gx/zYeAP82HgD/Nh4A/zYeAP//qDH/qGwc/zYeAP82HgD/86Au/2hBDP82HgD/Nh4A/zYeAP82HgD/m2MZ//+oMf82HgD/Nh4A/zYeAP82HgD//6gx//+oMf/NhiX/Nh4A/7R1H//BfSL/Nh4A/zYeAP82HgD/Nh4A/5tjGf//qDH/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP9DJwP/wX0i//OgLv//qDH/Nh4A/zYeAP+bYxn//6gx/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAME2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAME2HgAQNh4AwDYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAMA2HgAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_AdobeLightroomClassic_IconBytes = [Convert]::FromBase64String($CheckBox_AdobeLightroomClassic_Icon64)
$CheckBox_AdobeLightroomClassic_IconStream = [System.IO.MemoryStream]::new($CheckBox_AdobeLightroomClassic_IconBytes, 0, $CheckBox_AdobeLightroomClassic_IconBytes.Length)
$CheckBox_AdobeLightroomClassic.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_AdobeLightroomClassic_IconStream).GetHIcon()))
$CheckBox_AdobeLightroomClassic.ImageAlign = 'MiddleLeft'
$CheckBox_AdobeLightroomClassic.Text = '    Adobe Lightroom Classic'
$CheckBox_AdobeLightroomClassic.TextAlign = 'MiddleLeft'
$CheckBox_AdobeLightroomClassic.CheckAlign = 'MiddleLeft'
$CheckBox_AdobeLightroomClassic.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_AdobeLightroomClassic)

# if ($InstalledSoftware -match 'Adobe Lightroom Classic') {
#     $CheckBox_AdobeLightroomClassic.Enabled = $false
#     $CheckBox_AdobeLightroomClassic.Text += ' (Installed)'
# }

$CheckBox_AdobePhotoshop = New-Object System.Windows.Forms.CheckBox
$CheckBox_AdobePhotoshop.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_AdobePhotoshop.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
$CheckBox_AdobePhotoshopt_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAAAAAAGAAAATQAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAGYAAABmAAAAZgAAAE0AAAAGCgUAWDAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP8wGwDZCgUAWDAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zAbANk2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP//qDH/Nh4A/zYeAP82HgD/Nh4A//OgLv//qDH/55cr/1w4Cf82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD//6gx/zYeAP82HgD/Nh4A/zYeAP+CUhL/dUkP//OgLv/NhiX/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A//+oMf/NhiX/tHUf/1w4Cf82HgD/QycD/8F9Iv//qDH/wX0i/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP//qDH/zYYl/+eXK//zoC7/Nh4A/9qPKP/zoC7/jlsW/1w4Cf82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD//6gx/zYeAP9PLwb//6gx/zYeAP/nlyv/86Au//OgLv//qDH/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A//+oMf+bYxn/wX0i//+oMf82HgD/QycD/45bFv+bYxn/glIS/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP//qDH//6gx//+oMf+obBz/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAME2HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAME2HgAQNh4AwDYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAP82HgD/Nh4A/zYeAMA2HgAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_AdobePhotoshop_IconBytes = [Convert]::FromBase64String($CheckBox_AdobePhotoshopt_Icon64)
$CheckBox_AdobePhotoshop_IconStream = [System.IO.MemoryStream]::new($CheckBox_AdobePhotoshop_IconBytes, 0, $CheckBox_AdobePhotoshop_IconBytes.Length)
$CheckBox_AdobePhotoshop.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_AdobePhotoshop_IconStream).GetHIcon()))
$CheckBox_AdobePhotoshop.ImageAlign = 'MiddleLeft'
$CheckBox_AdobePhotoshop.Text = '    Adobe Photoshop'
$CheckBox_AdobePhotoshop.TextAlign = 'MiddleLeft'
$CheckBox_AdobePhotoshop.CheckAlign = 'MiddleLeft'
$CheckBox_AdobePhotoshop.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_AdobePhotoshop)

# if ($InstalledSoftware -match 'Adobe Photoshop') {
#     $CheckBox_AdobePhotoshop.Enabled = $false
#     $CheckBox_AdobePhotoshop.Text += ' (Installed)'
# }

$CheckBox_AnyDesk = New-Object System.Windows.Forms.CheckBox
$CheckBox_AnyDesk.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_AnyDesk.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_AnyDesk_Icon64 = 'AAABAAEAEBAQAAAAAAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAvQfwANkH8AD5E/gA/S/0ARk3+AE9b+wBeaf4Adn3+AJmc/wCboP0AqKv/AKyy/QDU1/8A+fv/APz//gAAAAAAEwEQMRATERARMRMREwERExERERERExERERERAREDEREREQRzRzERERERS9lcowERERS+7ZbKMRERO+3e2WyzETA77u7ZbLEBERO+7ZbKMTEREUvZXKQBERERFHNHQCEREQEAAAAAEBETExMTExMTEREREREREREREREREREREREAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
$CheckBox_AnyDesk_IconBytes = [Convert]::FromBase64String($CheckBox_AnyDesk_Icon64)
$CheckBox_AnyDesk_IconStream = [System.IO.MemoryStream]::new($CheckBox_AnyDesk_IconBytes, 0, $CheckBox_AnyDesk_IconBytes.Length)
$CheckBox_AnyDesk.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_AnyDesk_IconStream).GetHIcon()))
$CheckBox_AnyDesk.ImageAlign = 'MiddleLeft'
$CheckBox_AnyDesk.Text = '    AnyDesk'
$CheckBox_AnyDesk.TextAlign = 'MiddleLeft'
$CheckBox_AnyDesk.CheckAlign = 'MiddleLeft'
$CheckBox_AnyDesk.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_AnyDesk)

if ($InstalledSoftware -match 'AnyDesk') {
    $CheckBox_AnyDesk.Enabled = $false
    $CheckBox_AnyDesk.Text += ' (Installed)'
}

$CheckBox_BattleNet = New-Object System.Windows.Forms.CheckBox
$CheckBox_BattleNet.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_BattleNet.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_BattleNet_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABMLAAATCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA33AAIN9zAKDgdADP4HQA/+B0AP/gdQDf33MAkN9zAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADfcAAQ33MAkOB0AP/gdAD/4HQA/+B0AP/gdAD/4HQA/+B0AP/gdAD/33UAkN9wABAAAAAAAAAAAAAAAADfcAAQ4HQAz+B0AP/gdAD/4HQA/+B0AP/gdAD/5IUg/+B0AP/gdAD/4HQA/+B0AP/gdADP33AAEAAAAAAAAAAA33MAkOB0AP/gdAD/8cOQ//XTr//wuoD/6JdA/+uoX//gdAD/4HQA/+B0AP/gdAD/4HQA/991AJAAAAAA33MAQOB0AP/gdAD/5o4w///////55c//+eXP//327//mjjD/4HQA/+B0AP/gdAD/4HQA/+B0AP/gdAD/33AAIN9zAJDgdAD/4HQA/+aOMP//////4n0Q//XTr//pn1D/+eXP/+iXQP/zyp//7rFv/+iXQP/gdAD/4HQA/+BzAJ/gdQDf4HQA/+B0AP/gdAD/++7f/+uoYP/vuYD/4HQA/+SFIP/55c//66hf//XUr///////7Khf/+B0AP/gdADP4HQA/+B0AP/gdAD/4HQA/+mfUP/zy6D/5IUg/+B0AP/gdAD/5IUg//fcv//gdAD///////PKn//gdAD/4HQA/+B0AP/gdAD/4HQA/+B0AP/gdAD/++3f/+B0AP/gdAD/4HQA/+B0AP/rqGD/+eXP//vu3//khSD/4HQA/+B0AP/gdADP4HQA/+aOMP/ol0D/5o4w//nlz//gdAD/4HQA/+aOMP/xwpD/++7f//nlz//khSD/4HQA/+B0AP/gdQDf33MAoOB0AP/gdAD/4nwQ//HCj//77t//88qf//XTr//zyp//66hf/+SFIP/usXD/4HQA/+B0AP/gdAD/33UAkN93ACDgdAD/4HQA/+B0AP/ol0D//////+aOMP/sqGD/+eXP/+J9EP/gdAD/6JdA/+B0AP/gdAD/4HQA/99zAEAAAAAA4XQAj+B0AP/gdAD/4HQA//vu3////////fbv/+aOMP/gdAD/4HQA/+J8EP/gdAD/4HQA/+F0AI8AAAAAAAAAAN9wABDgdADP4HQA/+B0AP/mjjD/77mA/+SFIP/gdAD/4HQA/+B0AP/gdAD/4HQA/+B0AM/fcAAQAAAAAAAAAAAAAAAA33AAEOF0AI/gdAD/4HQA/+B0AP/gdAD/4HQA/+B0AP/gdAD/4HQA/+F0AI/fcAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA33MAQN9zAJDgdQDf4HQA/+B0AP/gdADP4HMAn993ACAAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAwAA8A8AAA=='
$CheckBox_BattleNet_IconBytes = [Convert]::FromBase64String($CheckBox_BattleNet_Icon64)
$CheckBox_BattleNet_IconStream = [System.IO.MemoryStream]::new($CheckBox_BattleNet_IconBytes, 0, $CheckBox_BattleNet_IconBytes.Length)
$CheckBox_BattleNet.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_BattleNet_IconStream).GetHIcon()))
$CheckBox_BattleNet.ImageAlign = 'MiddleLeft'
$CheckBox_BattleNet.Text = '    Battle.net'
$CheckBox_BattleNet.TextAlign = 'MiddleLeft'
$CheckBox_BattleNet.CheckAlign = 'MiddleLeft'
$CheckBox_BattleNet.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_BattleNet)

if ($InstalledSoftware -match 'Battle.net') {
    $CheckBox_BattleNet.Enabled = $false
    $CheckBox_BattleNet.Text += ' (Installed)'

}

$CheckBox_BetterDiscord = New-Object System.Windows.Forms.CheckBox
$CheckBox_BetterDiscord.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_BetterDiscord.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from Website
$CheckBox_BetterDiscord_Icon64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAPxQTFRFDA0QDA0QDA0QDA0QCwwOCwsMDAwOCgsOCQoNCwwPGChCHjheHjdcGzFSFiEyQUJERkZIFhcaCgsPDA4RLFmaP4ToPoLlPoPmPoLkN3PLVnCV2dnZrKytIyQnLVmbP4XrMWWwIkFuLlygPoPnNW2+qa+3////fX5/LVqcQIbtJ02EDA0RHDNWPYDhNXHIlp6rp6epDQ4RDAwPHzpiPHzbLVqdL16jOXfQLFqfkpSYq6usDg8SHzhfKE6HL1+lOXfRCwwNDxMbDQ8TqKipGy9OI0JxIkFvqa63f4CBCQoOP4XqVm+Vrq+wJSYoGClCHjddHDJTQEFERkdJFxgaMbsuLQAAAAN0Uk5TcOrp08DtNAAAAAFiS0dEJloImLUAAAAJcEhZcwAALiMAAC4jAXilP3YAAACgSURBVBjTY2BgZEYCjAwMTMwogIkBSLCwAgEbOwcnSAQkwMXNw8PLxy8gKAQREBYRFROXkJSSlpHlhAjIySsoKimrqKqpc0AENDS1tHV09fTVDAzBAkbGJqZm5qIWlmpW1hBDhW1s7eyRBRwcHJ3AWpwhWrRdXN3cgIa6q3l4Qg31Egda6y3t4wuxltmP298/gC8wKJgd6lJUp2N4Dt37APFbFIzkV97FAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIwLTEwLTI2VDA2OjUzOjIxKzAwOjAwMIFgwgAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMC0xMC0yNlQwNjo1MzoyMSswMDowMEHc2H4AAABGdEVYdHNvZnR3YXJlAEltYWdlTWFnaWNrIDYuNy44LTkgMjAxNC0wNS0xMiBRMTYgaHR0cDovL3d3dy5pbWFnZW1hZ2ljay5vcmfchu0AAAAAGHRFWHRUaHVtYjo6RG9jdW1lbnQ6OlBhZ2VzADGn/7svAAAAGHRFWHRUaHVtYjo6SW1hZ2U6OmhlaWdodAAxOTIPAHKFAAAAF3RFWHRUaHVtYjo6SW1hZ2U6OldpZHRoADE5MtOsIQgAAAAZdEVYdFRodW1iOjpNaW1ldHlwZQBpbWFnZS9wbmc/slZOAAAAF3RFWHRUaHVtYjo6TVRpbWUAMTYwMzY5NTIwMavz8FgAAAAPdEVYdFRodW1iOjpTaXplADBCQpSiPuwAAABWdEVYdFRodW1iOjpVUkkAZmlsZTovLy9tbnRsb2cvZmF2aWNvbnMvMjAyMC0xMC0yNi81YjgxZWQ1ZDE4ZTdhOWFmMmI4NDY3NjljN2YzZDZmOC5pY28ucG5nKmIUaAAAAABJRU5ErkJggg=='
$CheckBox_BetterDiscord_IconBytes = [Convert]::FromBase64String($CheckBox_BetterDiscord_Icon64)
$CheckBox_BetterDiscord_IconStream = [System.IO.MemoryStream]::new($CheckBox_BetterDiscord_IconBytes, 0, $CheckBox_BetterDiscord_IconBytes.Length)
$CheckBox_BetterDiscord.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_BetterDiscord_IconStream).GetHIcon()))
$CheckBox_BetterDiscord.ImageAlign = 'MiddleLeft'
$CheckBox_BetterDiscord.Text = '    BetterDiscord'
$CheckBox_BetterDiscord.TextAlign = 'MiddleLeft'
$CheckBox_BetterDiscord.CheckAlign = 'MiddleLeft'
$CheckBox_BetterDiscord.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_BetterDiscord)

$BetterDiscord = 'BetterDiscord Updater'
$BetterDiscord_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $BetterDiscord }
if (($BetterDiscord_Exists)) {
    $CheckBox_BetterDiscord.Enabled = $false
    $CheckBox_BetterDiscord.Text += ' (Installed)'
}

$CheckBox_Chrome = New-Object System.Windows.Forms.CheckBox
$CheckBox_Chrome.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Chrome.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from Website
$CheckBox_Chrome_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQI8gIECPIKA/jx/PPo4e/hysqf8HvfrfB7z6kAi7+0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAjyAQQJEgkECQIP9AkSD/QJEg/0CRIP46lzz/C777/wu++/8Kvvv/C737kBC//xAAAAAAAAAAAAAAAABAjyAQQZMiz0KTIv9CkyP/QpMi/0KTIv9BkiL/QpMi/yWsnf8Pv/z+Dr/7/w6++/8OvvvPEL//EAAAAAAAAAAARJYkj0OWI/5EliT+RJUk/0SVJP9DlSP+Q5Uj/kSVJP89mj7/GLrg/xPA/P8SwPv/Er/7/xLA/Y8AAAAARJcoQEWXJv9GmCb/RZcm/0aYJv9dpEH/xd67//738v/x6Nf/0OXI/0u0kf8Wwfv/FsH8/xXA+/8VwPv/GL//IEeZKY9Hmij/SJoo/0iaKP9epkL/8ejX/++TUP/seSj/7Hko//GbXv/y6Nf/Nsn7/xrB+/8Zwfv/GcL8/xrC/J9JnCrfSZ0q/kmcKf9JnCr/0ebJ//GbX//teir/7Xoq/+16Kv/teiv/8JNS/7js/v8ew/z/HsP8/x3D/P8cw/vPS54s/0ueK/9Lniv/QHxi/u/i4v/ufC3/7Xst/+57Lf/ufC3/7nwt/+57Lf/+9/L/IsT8/yLE/P8hxPz/IcT8/02gLf9MoS3+Spk4/y9DyP/97+X/7n0v/+59L//vfTD/7n0w/+59MP/ufS//7+vk/ybF+/8lxfz+JcX7/yXE+/9Poi/PT6Mw/z1tiP8rOOD/vcH1//GOTP/wfjL/734y/+9+Mv/vfjL/855l/8nw/v8qxvz/Ksb8/ynG/P4pxvzfUKUwn0yXR/8vQdf/LTri/0dT5f/w4+T/9J9n//B/Nf/wfzX/85da//Ds5f9Izvz/Lcf7/y7H/P8tx/z+LMb7kFCnMCA9ZKH/Lzzj/y885P4uO+L/SFTn/8vO+P/w4+T//vfy/7/v/v9Nz/3/Msn8/jLJ/f4xyPz/Mcn9/jDH+0AAAAAAMD7mjzA95f8wPeX/MD3l/zA95f8wPOT/MD3k/zA85P8uO+T+Ljvj/y884/8uO+P/Ljvj/y474o8AAAAAAAAAADBA3xAyQObPMj/n/jJA5/8yQOb/MT/m/zE+5v4xP+b/MD3m/jA95f4wPeX+MD3l/i885M8wQN8QAAAAAAAAAAAAAAAAMEDfEDRA6I8zQej/M0Ho/zNA6P4yQOf/MkDn/zJA5/8yQOf/Mj/m/zI+5o8wQN8QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANEDrQDNB6JAzQunfNELp/zRC6v40QejPM0DonzBA5yAAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAwAA8A8AAA=='
$CheckBox_Chrome_IconBytes = [Convert]::FromBase64String($CheckBox_Chrome_Icon64)
$CheckBox_Chrome_IconStream = [System.IO.MemoryStream]::new($CheckBox_Chrome_IconBytes, 0, $CheckBox_Chrome_IconBytes.Length)
$CheckBox_Chrome.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Chrome_IconStream).GetHIcon()))
$CheckBox_Chrome.ImageAlign = 'MiddleLeft'
$CheckBox_Chrome.Text = '    Chrome'
$CheckBox_Chrome.TextAlign = 'MiddleLeft'
$CheckBox_Chrome.CheckAlign = 'MiddleLeft'
$CheckBox_Chrome.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Chrome)

if ($InstalledSoftware -match 'Google Chrome') {
    $CheckBox_Chrome.Enabled = $false
    $CheckBox_Chrome.Text += ' (Installed)'
}

$CheckBox_ChromeExtensions = New-Object System.Windows.Forms.CheckBox
$CheckBox_ChromeExtensions.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_ChromeExtensions.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from Website
$CheckBox_ChromeExtensions_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQI8gIECPIKA/jx/PPo4e/hysqf8HvfrfB7z6kAi7+0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAjyAQQJEgkECQIP9AkSD/QJEg/0CRIP46lzz/C777/wu++/8Kvvv/C737kBC//xAAAAAAAAAAAAAAAABAjyAQQZMiz0KTIv9CkyP/QpMi/0KTIv9BkiL/QpMi/yWsnf8Pv/z+Dr/7/w6++/8OvvvPEL//EAAAAAAAAAAARJYkj0OWI/5EliT+RJUk/0SVJP9DlSP+Q5Uj/kSVJP89mj7/GLrg/xPA/P8SwPv/Er/7/xLA/Y8AAAAARJcoQEWXJv9GmCb/RZcm/0aYJv9dpEH/xd67//738v/x6Nf/0OXI/0u0kf8Wwfv/FsH8/xXA+/8VwPv/GL//IEeZKY9Hmij/SJoo/0iaKP9epkL/8ejX/++TUP/seSj/7Hko//GbXv/y6Nf/Nsn7/xrB+/8Zwfv/GcL8/xrC/J9JnCrfSZ0q/kmcKf9JnCr/0ebJ//GbX//teir/7Xoq/+16Kv/teiv/8JNS/7js/v8ew/z/HsP8/x3D/P8cw/vPS54s/0ueK/9Lniv/QHxi/u/i4v/ufC3/7Xst/+57Lf/ufC3/7nwt/+57Lf/+9/L/IsT8/yLE/P8hxPz/IcT8/02gLf9MoS3+Spk4/y9DyP/97+X/7n0v/+59L//vfTD/7n0w/+59MP/ufS//7+vk/ybF+/8lxfz+JcX7/yXE+/9Poi/PT6Mw/z1tiP8rOOD/vcH1//GOTP/wfjL/734y/+9+Mv/vfjL/855l/8nw/v8qxvz/Ksb8/ynG/P4pxvzfUKUwn0yXR/8vQdf/LTri/0dT5f/w4+T/9J9n//B/Nf/wfzX/85da//Ds5f9Izvz/Lcf7/y7H/P8tx/z+LMb7kFCnMCA9ZKH/Lzzj/y885P4uO+L/SFTn/8vO+P/w4+T//vfy/7/v/v9Nz/3/Msn8/jLJ/f4xyPz/Mcn9/jDH+0AAAAAAMD7mjzA95f8wPeX/MD3l/zA95f8wPOT/MD3k/zA85P8uO+T+Ljvj/y884/8uO+P/Ljvj/y474o8AAAAAAAAAADBA3xAyQObPMj/n/jJA5/8yQOb/MT/m/zE+5v4xP+b/MD3m/jA95f4wPeX+MD3l/i885M8wQN8QAAAAAAAAAAAAAAAAMEDfEDRA6I8zQej/M0Ho/zNA6P4yQOf/MkDn/zJA5/8yQOf/Mj/m/zI+5o8wQN8QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANEDrQDNB6JAzQunfNELp/zRC6v40QejPM0DonzBA5yAAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAwAA8A8AAA=='
$CheckBox_ChromeExtensions_IconBytes = [Convert]::FromBase64String($CheckBox_ChromeExtensions_Icon64)
$CheckBox_ChromeExtensions_IconStream = [System.IO.MemoryStream]::new($CheckBox_ChromeExtensions_IconBytes, 0, $CheckBox_ChromeExtensions_IconBytes.Length)
$CheckBox_ChromeExtensions.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_ChromeExtensions_IconStream).GetHIcon()))
$CheckBox_ChromeExtensions.ImageAlign = 'MiddleLeft'
$CheckBox_ChromeExtensions.Text = '    Chrome - Extensions'
$CheckBox_ChromeExtensions.TextAlign = 'MiddleLeft'
$CheckBox_ChromeExtensions.CheckAlign = 'MiddleLeft'
$CheckBox_ChromeExtensions.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_ChromeExtensions)

$CheckBox_CrystalDiskInfo = New-Object System.Windows.Forms.CheckBox
$CheckBox_CrystalDiskInfo.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_CrystalDiskInfo.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_CrystalDiskInfo_Icon64 = 'AAABAAEAEBAAAAAAAABoBQAAFgAAACgAAAAQAAAAIAAAAAEACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU1BQAF1ZWQBjZGIAaGdnAGxrbAB6cnIAeHh6AP8gEgCAfX0Ahn9+AP96cQCIhIUAiIiIAI+LjACTjY0AmJGMAJOSkwCemJgAmpudAKGamgCjnpoAr6CPALKgjwCnoqQAqKOlAKapqwCvrasAq6utALWuqACwq60AubCpALSvsAC1sLEAu7e4AL65uQD/l5EAwbKiAM26qADeybMA68inAOvOsgDpzbQA/9m1AP/cugDCv8AAxsXEAM7DwgDbz8AA0MvJANLOywDY1M4A1tTTAN7S0QDZ1tYA393fAOPRwQDg2MwA9t3DAOTb0gDl2dgA/9TRAP3gxAD/48sA/+nRAPXp2wD66toA5uXmAP/u4QD/8OIA//XlAP/z6QD/+PIA////AFH/hwBx/50Akf+yALH/yQDR/98A////AAAAAAACLwAABFAAAAZwAAAIkAAACrAAAAvPAAAO8AAAIP8SAD3/MQBb/1EAef9xAJj/kQC1/7EA1P/RAP///wAAAAAAFC8AACJQAAAwcAAAPZAAAEywAABZzwAAZ/AAAHj/EQCK/zEAnP9RAK7/cQDA/5EA0v+xAOT/0QD///8AAAAAACYvAABAUAAAWnAAAHSQAACOsAAAqc8AAMLwAADR/xEA2P8xAN7/UQDj/3EA6f+RAO//sQD2/9EA////AAAAAAAvJgAAUEEAAHBbAACQdAAAsI4AAM+pAADwwwAA/9IRAP/YMQD/3VEA/+RxAP/qkQD/8LEA//bRAP///wAAAAAALxQAAFAiAABwMAAAkD4AALBNAADPWwAA8GkAAP95EQD/ijEA/51RAP+vcQD/wZEA/9KxAP/l0QD///8AAAAAAC8DAABQBAAAcAYAAJAJAACwCgAAzwwAAPAOAAD/IBIA/z4xAP9cUQD/enEA/5eRAP+2sQD/1NEA////AAAAAAAvAA4AUAAXAHAAIQCQACsAsAA2AM8AQADwAEkA/xFaAP8xcAD/UYYA/3GcAP+RsgD/scgA/9HfAP///wAAAAAALwAgAFAANgBwAEwAkABiALAAeADPAI4A8ACkAP8RswD/Mb4A/1HHAP9x0QD/kdwA/7HlAP/R8AD///8AAAAAACwALwBLAFAAaQBwAIcAkAClALAAxADPAOEA8ADwEf8A8jH/APRR/wD2cf8A95H/APmx/wD70f8A////AAAAAAAbAC8ALQBQAD8AcABSAJAAYwCwAHYAzwCIAPAAmRH/AKYx/wC0Uf8AwnH/AM+R/wDcsf8A69H/AP///wAAAAAACAAvAA4AUAAVAHAAGwCQACEAsAAmAM8ALADwAD4R/wBYMf8AcVH/AIxx/wCmkf8Av7H/ANrR/wD///8AAA8GBgYGBgYGBgYGBgYSABQCICAgICAgICAgPSAgAhQGDgkvPDw8PDw8JAskPCEGBhgHCjU8PDw8PQsICz0gBgYZQwQUPDw8PDwkCyQ8IQYGIx5DAzZJSUlJST1JSS4GACIYIDcBEgcFBQwgISEiAAAANB4iEBMvQzsfByI0AAAAAAAALREzMTIzOScNAAAAAAAAAAA4QkhISEhIJQAAAAAAAAAYPkhFSEdFRSoSAAAAAAAAGCxISEJEREUpHAAAAAAAABooSEVAPz9AJgAAAAAAAAAAFitFSEdGOhUAAAAAAAAAAAAXOEVBMBUAAAAAAAAAAAAAABkdHRsAAAAAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIABAADAAwAA8AcAAPgHAADwAwAA8AMAAPAHAAD4BwAA/A8AAP4fAAA='
$CheckBox_CrystalDiskInfo_IconBytes = [Convert]::FromBase64String($CheckBox_CrystalDiskInfo_Icon64)
$CheckBox_CrystalDiskInfo_IconStream = [System.IO.MemoryStream]::new($CheckBox_CrystalDiskInfo_IconBytes, 0, $CheckBox_CrystalDiskInfo_IconBytes.Length)
$CheckBox_CrystalDiskInfo.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_CrystalDiskInfo_IconStream).GetHIcon()))
$CheckBox_CrystalDiskInfo.ImageAlign = 'MiddleLeft'
$CheckBox_CrystalDiskInfo.Text = '    CrystalDiskInfo'
$CheckBox_CrystalDiskInfo.TextAlign = 'MiddleLeft'
$CheckBox_CrystalDiskInfo.CheckAlign = 'MiddleLeft'
$CheckBox_CrystalDiskInfo.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_CrystalDiskInfo)

if ($InstalledSoftware -match 'CrystalDiskInfo') {
    $CheckBox_CrystalDiskInfo.Enabled = $false
    $CheckBox_CrystalDiskInfo.Text += ' (Installed)'
}

$CheckBox_CrystalDiskMark = New-Object System.Windows.Forms.CheckBox
$CheckBox_CrystalDiskMark.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_CrystalDiskMark.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_CrystalDiskMark_Icon64 = 'AAABAAEAEBAAAAAAAABoBQAAFgAAACgAAAAQAAAAIAAAAAEACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU1BQAF1ZWQBjZGIAenJyAAWaDAAGng4ACKYTAAm/KwAzujsAPLFhAEa0SwBIvVEAYI5tABvJQAAhzUYAM8FFADPFSQAwwF8APs1aADPVWQAJ6lMAQtFfAEPRYABM1moARdprAEncbwBP3nUAVdp0AFzdegBY4H0AX+KDAGfhhgBq4YkAaOSMAHHjjgBv5pEAduaVAHnmlwB26JgAfuqdAJONjQCemJgAoZqaALSvsAC1sLEAu7e4AL24uQDEv78Al8alAIbpowCJ6qUAke2tAJrutADGwsEAyMXEAM7MywDW1NMA2NbVANza2QDl2dgAyffZAOHg4QDr6+0A7OzuAP///wAAUBgAAHAiAACQLAAAsDYAAM9AAADwSgAR/1sAMf9xAFH/hwBx/50Akf+yALH/yQDR/98A////AAAAAAACLwAABFAAAAZwAAAIkAAACrAAAAvPAAAO8AAAIP8SAD3/MQBb/1EAef9xAJj/kQC1/7EA1P/RAP///wAAAAAAFC8AACJQAAAwcAAAPZAAAEywAABZzwAAZ/AAAHj/EQCK/zEAnP9RAK7/cQDA/5EA0v+xAOT/0QD///8AAAAAACYvAABAUAAAWnAAAHSQAACOsAAAqc8AAMLwAADR/xEA2P8xAN7/UQDj/3EA6f+RAO//sQD2/9EA////AAAAAAAvJgAAUEEAAHBbAACQdAAAsI4AAM+pAADwwwAA/9IRAP/YMQD/3VEA/+RxAP/qkQD/8LEA//bRAP///wAAAAAALxQAAFAiAABwMAAAkD4AALBNAADPWwAA8GkAAP95EQD/ijEA/51RAP+vcQD/wZEA/9KxAP/l0QD///8AAAAAAC8DAABQBAAAcAYAAJAJAACwCgAAzwwAAPAOAAD/IBIA/z4xAP9cUQD/enEA/5eRAP+2sQD/1NEA////AAAAAAAvAA4AUAAXAHAAIQCQACsAsAA2AM8AQADwAEkA/xFaAP8xcAD/UYYA/3GcAP+RsgD/scgA/9HfAP///wAAAAAALwAgAFAANgBwAEwAkABiALAAeADPAI4A8ACkAP8RswD/Mb4A/1HHAP9x0QD/kdwA/7HlAP/R8AD///8AAAAAACwALwBLAFAAaQBwAIcAkAClALAAxADPAOEA8ADwEf8A8jH/APRR/wD2cf8A95H/APmx/wD70f8A////AAAAAAAbAC8ALQBQAD8AcABSAJAAYwCwAHYAzwCIAPAAmRH/AKYx/wC0Uf8AwnH/AM+R/wDcsf8A69H/AP///wAAAAAACAAvAA4AUAAVAHAAGwCQACEAsAAmAM8ALADwAD4R/wBYMf8AcVH/AIxx/wCmkf8Av7H/ANrR/wD///8AACkEBAQEBAQEBAQEBAQqACsCLCwsLCwsLCwsLDEsAisELDo8PDw8PDw8PAQKAi0EBCw6PDw8PDw8PDwNFQEsBAQvOjw8PDw8PDw8BBIDLQQEMDpBQUFBQUFBQUE9OjYEAC4sLCwsLCwsLCwsLSwuAAAAOTc+Pz9AQEA/Pjc5AAAAAAAAOzk4ODg4OTsAAAAABQYGBgYGBwcHBwcMAAAAAAU0MzMmIB0YExEJBwAAAAAGJSclIh4ZFA4IEAcAAAAACwYFBgYFBgYFBgYGBgYHDAUYDhQZHyQoKCciGxQPEwcGFhcYHSElMzQ1NTQyJR0HCwYFBgYFBgYFBgYGBgYHDIAB//8AAP//AAD//wAA//8AAP//AAD//4AB///AA///8A///wAP//8AD///AA///wAA//8AAP//AAD//wAA//8='
$CheckBox_CrystalDiskMark_IconBytes = [Convert]::FromBase64String($CheckBox_CrystalDiskMark_Icon64)
$CheckBox_CrystalDiskMark_IconStream = [System.IO.MemoryStream]::new($CheckBox_CrystalDiskMark_IconBytes, 0, $CheckBox_CrystalDiskMark_IconBytes.Length)
$CheckBox_CrystalDiskMark.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_CrystalDiskMark_IconStream).GetHIcon()))
$CheckBox_CrystalDiskMark.ImageAlign = 'MiddleLeft'
$CheckBox_CrystalDiskMark.Text = '    CrystalDiskMark'
$CheckBox_CrystalDiskMark.TextAlign = 'MiddleLeft'
$CheckBox_CrystalDiskMark.CheckAlign = 'MiddleLeft'
$CheckBox_CrystalDiskMark.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_CrystalDiskMark)

if ($InstalledSoftware -match 'CrystalDiskMark') {
    $CheckBox_CrystalDiskMark.Enabled = $false
    $CheckBox_CrystalDiskMark.Text += ' (Installed)'
}

$CheckBox_Discord = New-Object System.Windows.Forms.CheckBox
$CheckBox_Discord.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Discord.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Discord_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9WFVMvVhVZj1YVXa9WFV+vVhVfr1YVXa9WFVmPVhVTIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD1YVYK9WFVnPZhVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/1YVX/9WFVmvVhVQoAAAAAAAAAAAAAAAD1YVUK9WFVwvZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/1YVXC9mFVCgAAAAAAAAAA9WFVmvZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//VhVZwAAAAA9WFVMvVhVf/2Ylb/9mJW//eEev/5p6D/9mJW//ZiVv/2Ylb/9mJW//mnoP/3g3n/9mJW//ZiVv/2YVX/9mFVMvVhVZj2Ylb/9mJW//vKxv/+/v7//eLf//u8t//81NH//NTR//u8t//94uD//v7+//vJxf/2Ylb/9mJW//ZhVZj1YVXa9mJW//ZiVv/+/v7///////77+//95OL////////////95OL//vv6///////+/v7/9mJW//ZiVv/1YVXa9WFV+vZiVv/2Ylb//vT0///////6sqz/9mJW//3k4v/95eP/9mJW//qxq////////vT0//ZiVv/2Ylb/9WFV+vVhVfr2Ylb/9mJW//zX1P///////NnW//iVjf/+9vX//vb2//iWjv/82db///////zX1P/2Ylb/9mJW//VhVfr1YVXa9mJW//ZiVv/5o5z////////////////////////////////////////////5o5z/9mJW//ZiVv/1YVXa9WFVmPZiVv/2Ylb/9mhc//7u7f/////////////////////////////////+7u3/9mhc//ZiVv/2Ylb/9WFVmPVhVTL1YVb/9mJW//ZiVv/3f3b/+8K9//zQzP/5o5z/+aOc//zQzf/7wr7/9391//ZiVv/2Ylb/9WFV//VhVTIAAAAA9WFWnPZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//VhVZoAAAAAAAAAAPVhVgr2YlXC9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9mJW//ZhVcL1YVUKAAAAAAAAAAAAAAAA9WFVCvVhVZr1YVX/9mJW//ZiVv/2Ylb/9mJW//ZiVv/2Ylb/9WFV//VhVZz1YVUKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9WFVMvVhVZj1YVXa9WFV+vVhVfr1YVXa9WFVmPZiVTIAAAAAAAAAAAAAAAAAAAAA+B8AAOAHAADAAwAAgAEAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAQAAgAEAAMADAADgBwAA+B8AAA=='
$CheckBox_Discord_IconBytes = [Convert]::FromBase64String($CheckBox_Discord_Icon64)
$CheckBox_Discord_IconStream = [System.IO.MemoryStream]::new($CheckBox_Discord_IconBytes, 0, $CheckBox_Discord_IconBytes.Length)
$CheckBox_Discord.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Discord_IconStream).GetHIcon()))
$CheckBox_Discord.ImageAlign = 'MiddleLeft'
$CheckBox_Discord.Text = '    Discord'
$CheckBox_Discord.TextAlign = 'MiddleLeft'
$CheckBox_Discord.CheckAlign = 'MiddleLeft'
$CheckBox_Discord.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Discord)

if ($InstalledSoftware -match 'Discord') {
    $CheckBox_Discord.Enabled = $false
    $CheckBox_Discord.Text += ' (Installed)'
}

$CheckBox_DisplayDriverUninstaller = New-Object System.Windows.Forms.CheckBox
$CheckBox_DisplayDriverUninstaller.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_DisplayDriverUninstaller.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Resized from Official ICO from Website
$CheckBox_DisplayDriverUninstaller_Icon64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJdSURBVDhPjVK/b9pQEPaznw1GCkx1BwSlEg0gpQtKyFI6MNEBUYY0BaX/Qfd0bqS2QzqkEsoaVUlL82+ABGphKJBQqiBhIFBUfplgG2zHzoH/gZylp/ed797dfd8hRVG1W83CMIZBwKepy7uqabquI0QgkiQRiRCCGPhNMzQ6+5Y5Pk5PBeHmZibL88PPhwcH76PRF+JMbLVbF9XKmt0RiUTOz3/QNP3xwyf062fx5OuJx/N4OBi8TCTOTk/dbvcDjvN6n2Qy38PPwqIoGoZRrVY3tzY5jkNXV43O9fWyKiIXysLC0Lpu3K7MYrGomkoQiDAMjLEoSQG/jwiFtoh7297eG3Jn5xVUNK3Vanm93slkYsJOp2O1WtPptBkNNR2ONVJRlPF4/HZlLpcrHo+Xy+VkMgnQ6XRGo1EIMBNmsxkwiWGmXC5nPpNKpSC5VCplMhmAEM2y7Hw+X8UTPM/DScqyXKvVTFc2m63X641Gw4T5fB66Go1GJiwUCiAKliS51+v5/X5wQXK/3wfJ1tfXl4oh1G63QYRgMAhwMBiAyBiotNnYRCIBLsgE8/l8drudoihoutlsgicWi8FzUJ/jHhLboe1VwXvZ7u5r1OT5Xu8fa7WCNMbKC52AUkAi3JYnQdCYpihSmAqeRx5UrlxMhWm58vvysmZjrZimAeqGDlMNh8ONjaewgcVS8W/9z/7+O5phsKaqFKa+HB0FAoFKpeJyu7rdbjj8nOdh86pAMczO801REueLBbSA/g+GkiQ67A54FVMYKILpFVU1dJ3CGHqDloAAWChBmFoY+g6NAldmasGCvgAAAABJRU5ErkJggg=='
$CheckBox_DisplayDriverUninstaller_IconBytes = [Convert]::FromBase64String($CheckBox_DisplayDriverUninstaller_Icon64)
$CheckBox_DisplayDriverUninstaller_IconStream = [System.IO.MemoryStream]::new($CheckBox_DisplayDriverUninstaller_IconBytes, 0, $CheckBox_DisplayDriverUninstaller_IconBytes.Length)
$CheckBox_DisplayDriverUninstaller.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_DisplayDriverUninstaller_IconStream).GetHIcon()))
$CheckBox_DisplayDriverUninstaller.ImageAlign = 'MiddleLeft'
$CheckBox_DisplayDriverUninstaller.Text = '    Display Driver Uninstaller'
$CheckBox_DisplayDriverUninstaller.TextAlign = 'MiddleLeft'
$CheckBox_DisplayDriverUninstaller.CheckAlign = 'MiddleLeft'
$CheckBox_DisplayDriverUninstaller.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_DisplayDriverUninstaller)

if ($InstalledSoftware -match 'Display Driver Uninstaller') {
    $CheckBox_DisplayDriverUninstaller.Enabled = $false
    $CheckBox_DisplayDriverUninstaller.Text += ' (Installed)'
}

$CheckBox_EdgeWebView2 = New-Object System.Windows.Forms.CheckBox
$CheckBox_EdgeWebView2.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_EdgeWebView2.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_EdgeWebView2_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANR4APDUeQD/1XoB/9V7Av/GdQ30fUIP/45MEP+RThD/k08P/5VQD/+XUQ//mVMO/5tUDv+eVQ3/oFYN/6JYDPDTdwD/1HkA/9V6Af/VewL/1n0E/59bDPqERg7/kE4Q/5NPD/+VUA//l1EP/5lTDv+bVA7/nlUN/6BWDf+iWAz/68A9+dB3AP/VegH/1XsC/9Z9BP/XfwX/mVgM+YhJD/+STg//lVAP/5dRD/+ZUw7/m1QO/55VDf+gVg3/olgM///mUP/110z50oML/9N6Av/WfQT/138F/9eBB/+ZWQz5hkcO/5JOD/+XUQ//mVMO/5tUDv+eVQ3/oFYN/6JYDP//5lD//eZQ//bjU/vbqCr80nsE/9Z/Bf/XgQf/2IMI/7NuEPOFSAz/jkwO/5VRDv+aUw7/nVUN/6BWDf+iWAz//+ZQ//3mUP/45lH/8uZS/+jfU/rWpSf70n4H/9aCCP/Zhgr/1YcS96BeD/mBRgz/jUwN/5VQDP+aUwz/nlYM///mUP/95lD/+OZR//LmUv/r51P/5OdU/9rfVfrNrzT4zYYO/9SEDP/YiQ7/2o0U+sN+Ge+eXg3/mFcN/49NC///5lD//eZQ//jmUf/y5lL/6+dT/+TnVP/c51X/0+hX/8roWP/C1lb1wLtA98OdI//Kixb/z4kT/9WPFf/ZlRj//+ZQ//3mUP/45lH/8uZS/+vnU//k51T/3OdV/9PoV//K6Fj/wOha/7XpW/+q6V3/n+lf/5PqYP+S32H3jt5j8v/mUP/95lD/+OZR//LmUv/r51P/5OdU/9znVf/T6Ff/yuhY/8DoWv+16Vv/quld/5/pX/+T6mD/h+pi/3vrZP+iWAz/oVcN/6BXDf+fVg3/nVUN/5xUDv+bUw7/mVMO/5hSDv+XUQ//llAP/5RQD/+TTw//kk4Q/5BNEP+PTRD/pFkM8KNZDP+iWAz/oVcN/59WDf+eVg3/nVUN/5xUDv+aUw7/mVIO/5hSDv+XUQ//lVAP/5RPD/+TTw//kU4Q8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//9G9f//RPgAACb/AAAo/wAAUP8AAFD/AABR/wAAUf8AAFL/AABT/wAAVP8AAFX/AABW/wAAV////1j///9Z/w=='
$CheckBox_EdgeWebView2_IconBytes = [Convert]::FromBase64String($CheckBox_EdgeWebView2_Icon64)
$CheckBox_EdgeWebView2_IconStream = [System.IO.MemoryStream]::new($CheckBox_EdgeWebView2_IconBytes, 0, $CheckBox_EdgeWebView2_IconBytes.Length)
$CheckBox_EdgeWebView2.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_EdgeWebView2_IconStream).GetHIcon()))
$CheckBox_EdgeWebView2.ImageAlign = 'MiddleLeft'
$CheckBox_EdgeWebView2.Text = '    Edge WebView2'
$CheckBox_EdgeWebView2.TextAlign = 'MiddleLeft'
$CheckBox_EdgeWebView2.CheckAlign = 'MiddleLeft'
$CheckBox_EdgeWebView2.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_EdgeWebView2)

if ($InstalledSoftware -match 'Microsoft Edge WebView2 Runtime') {
    $CheckBox_EdgeWebView2.Enabled = $false
    $CheckBox_EdgeWebView2.Text += ' (Installed)'
}

$CheckBox_EpicGames = New-Object System.Windows.Forms.CheckBox
$CheckBox_EpicGames.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_EpicGames.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_EpicGames_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAACUAAABxAAAAwwAAAMUAAAB0AAAAJwAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMAAAAPgAAAJQGBgTdPT09/KWkpP+joqL/PT09/AYGBt8AAACXAAAAQAAAAA0AAAAAAAAAAAAAAAIAAABMAAAAtQAAAO4AAAD+DAwM/zY3N/9APj7/Pz4+/zg3N/8ODg7/AAAA/gAAAO8AAAC3AAAAUAAAAAMAAAAPAAAAxQAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAMoAAAASAAAAEgAAAM0AAAD/XVxc/3p5ef9aWFj/VVVW/1NSUv8jIiL/VVRU/3h3d/9LSkr/f39//wAAAP8AAADRAAAAFQAAABIAAADNAAAA/66sqv+JiIj/eHl3/7a0tP+sq6v/4N3d/7Wysv+zsrL/iYiI/62rq/8AAAD/AAAA0QAAABUAAAASAAAAzQAAAP8QERH/DA0N/wAAAP8AAAD/AAEB/wAAAP8GBwf/GBYW/wQFBf8bGxv/AAAA/wAAANEAAAAVAAAAEgAAAM0AAAD/Kikp/zAvL/8HCAj/HyAg/wAAAP8AAAD/CwwM/wAAAP84Nzf/Dw4O/wAAAP8AAADRAAAAFQAAABIAAADNAAAA//v4+P+2s7P/enl5/8fFxf8AAAD/SkhI/7+9vf/CwcH/u7q6/+Ti4v8AAAD/AAAA0QAAABUAAAASAAAAzQAAAP/a1tb/AAAA/xUUFP+6ubn/AAAA/yYlJf+oqKj/trS0/w0MDP/l5OT/AAAA/wAAANEAAAAVAAAAEgAAAM0AAAD/8u/v/5OSkv9UU1P///7+/8bExP9hYGD/np2d/7++vv8AAAD/JCUl/wAAAP8AAADRAAAAFQAAABIAAADNAAAA/+fk5P9BQED/Ojk5/5CPj/+DgID/gX9//5aVlf+9vLz/AAAA/1dVVf8AAAD/AAAA0QAAABUAAAASAAAAzQAAAP/i39//AAAA/ygmJv+dnJz/k5KS/4iHh/+hoKD/urq6/y8uLv/v6+v/AAAA/wAAANEAAAAVAAAAEgAAAM0AAAD/1tLS/9rY2P9ycHD/7Orq/8jGx/9YV1f/jo2L/5GOjv/h3t7/qqmp/wAAAP8AAADRAAAAFQAAABEAAADMAAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA0AAAABQAAAAIAAAAlQAAAN4AAADfAAAA3wAAAN8AAADfAAAA3wAAAN8AAADfAAAA3wAAAN8AAADfAAAA3gAAAJoAAAAJ8A8AAMADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_EpicGames_IconBytes = [Convert]::FromBase64String($CheckBox_EpicGames_Icon64)
$CheckBox_EpicGames_IconStream = [System.IO.MemoryStream]::new($CheckBox_EpicGames_IconBytes, 0, $CheckBox_EpicGames_IconBytes.Length)
$CheckBox_EpicGames.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_EpicGames_IconStream).GetHIcon()))
$CheckBox_EpicGames.ImageAlign = 'MiddleLeft'
$CheckBox_EpicGames.Text = '    Epic Games Launcher'
$CheckBox_EpicGames.TextAlign = 'MiddleLeft'
$CheckBox_EpicGames.CheckAlign = 'MiddleLeft'
$CheckBox_EpicGames.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_EpicGames)

if ($InstalledSoftware -match 'Epic Games Launcher') {
    $CheckBox_EpicGames.Enabled = $false
    $CheckBox_EpicGames.Text += ' (Installed)'
}

$CheckBox_eMClientLicenseFix = New-Object System.Windows.Forms.CheckBox
$CheckBox_eMClientLicenseFix.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_eMClientLicenseFix.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_eMClientLicenseFix_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAACwAAAA8AAAANAAAADwAAABwAAAAtAAAAOAAAADsAAAA7AAAANgAAACoAAAAXAAAABwAAAAEAAAAAAAAACwAAACQAAAAzAAAAMwAAADUAQXNHAITilwCQ9tEAk/ztAJP76QCP9ckAgNuIACdJOwAAAB8AAAAIAAAAAAAAAAsAjPGpAInqtQCG5KgAheKYAJP76ACU/vwAkfq6AJH4iwCQ+o8Ak/vIAJT+/wCS+NsAXaVSAAAAHAAAAAUAAAAEAI3zkQCU/v8Ak/zzAJT+/ACU/MwAiO0rAAAAAQAAAAAAAAAAAAAAAQCL70AAk/zkAJL76ABRk0IAAAAQAAAAAQBywyYAlP35AIbmlgAAABQAgP8CAAAAAAAAAAUAAAANAAAADAAAAAQAAAABAIPgKQCT/O4AjPG6AAAAHwAAAAAAAAAQAIzwrQCT/OwALE4XAAAAAQAAAAgAAAAcAAAAMQAAAC8AAAAYAAAABgAAAAQAiex3AJT+/gBkskIAAAAAAAAAEQCL7qcAkvrgAAAAFAAAAA0AAAAkAEV8RgCN8cQAiOqtACpRPAAAAB8AAAALAFWTIQCU/fkAg+SCAAAAAAAAABEAj/XEAIzxuwAAACQAAAArAGi1YACS+uIAlP32AJT+/QCQ9tEAWJpRAAAAJwAAACUAkfndAIvtngAAAAAAAAAOAJD2xQCM774AAABCAH3ZhQCU/fcAk/vaAIjpLwCK8EYAlP3rAJP87QB0xnAAAABCAJD32wCM76IAAAAAAAAACACO86cAj/fgAIfotQCU/v8AkvuvAIfhEQAAAAAAAAABAITmHwCS+8kAlP79AIDeowCU/fkAi+1/AAAAAAAAAAIAiOleAJT+/wCU/vwAiOyFAAAACQAAAAEAAAAAAAAAAAAAAAEAWpYRAIzvogCU/v8AlP7/AIDeNgAAAAAAAAAAAFWVDACT/N4AkfjZAC1WPgAAACIAAAASAAAADQAAAA0AAAAUAAAAJQBPikoAk/ztAJD6vQAAAAYAAAAAAAAAAAAAAAEAie1FAJT++wCO9MgATolOAAAANwAAADIAAAAyAAAAOQBfqFsAkfjaAJT97wCG5igAAAABAAAAAAAAAAAAAAAAAAAAAgCN81MAlP3xAJT99wCL8LUAhOKTAIXklgCO88AAlP78AJT95ACJ8DQAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAI3tHQCS+pMAlP3fAJT+/wCU/v0Ak/vWAJD5gQCH4REAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_eMClientLicenseFix_IconBytes = [Convert]::FromBase64String($CheckBox_eMClientLicenseFix_Icon64)
$CheckBox_eMClientLicenseFix_IconStream = [System.IO.MemoryStream]::new($CheckBox_eMClientLicenseFix_IconBytes, 0, $CheckBox_eMClientLicenseFix_IconBytes.Length)
$CheckBox_eMClientLicenseFix.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_eMClientLicenseFix_IconStream).GetHIcon()))
$CheckBox_eMClientLicenseFix.ImageAlign = 'MiddleLeft'
$CheckBox_eMClientLicenseFix.Text = '    eM Client - License Fix'
$CheckBox_eMClientLicenseFix.TextAlign = 'MiddleLeft'
$CheckBox_eMClientLicenseFix.CheckAlign = 'MiddleLeft'
$CheckBox_eMClientLicenseFix.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_eMClientLicenseFix)

$eM_Client_License_Fix = 'eM Client License Fix'
$eM_Client_License_Fix_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $eM_Client_License_Fix }
if (($eM_Client_License_Fix_Exists)) {
    $CheckBox_eMClientLicenseFix.Enabled = $false
    $CheckBox_eMClientLicenseFix.Text += ' (Installed)'
}

$CheckBox_Firefox = New-Object System.Windows.Forms.CheckBox
$CheckBox_Firefox.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Firefox.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Firefox_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcQvlYG0M479qDeL/aA7h/2kO4f9tDeP/cAvlr3QK52AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABxC+UQbQzjv2MT4v9YIu3/Uirz/00x+v9LM/v/TC72/1Mm8P9iF+n/bBLrv2se8BAAAAAAAAAAAAAAAAByCuUQbA3jz1ki7v9OMvz/STb+/0U5//9DPf//QUH//z9D//8+Rf//QET9/1I28/9hOPPPYU33EAAAAAAAAAAAbQ/mv1Ms9/9JNv7/RDv//0FB//89R///O0v//zhP//83Uv//NVX//zZd//85a///TWH3/1ti+K8AAAAAcwrmQFkj8v9FOf//QUH//z1I//8xY///XlfB/4dFjf+JQ4//UlHZ/zNj//8zdf//NIb//zeS//9Rfvr/Von8QGUY7Z9EPP//P0X//zpN//8sbf//d2KX/7ZBWP/ASlr/xEVj/8I2cP9iY83/M4j//zyM/v81qP//Q6P9/1Kd/Z9KNvu/PUf//zdR//8yWv//Ooni/7w+Yf/PUmH/21pm/+BVcv/cRH//wTeN/ymr//86n///QqX+/z28/v9PsP6/Sjn5/zdS//8wXf//Kmf//ymo9v+9VIX/51h2//Jeff/2V4j/7UqQ/9c3kf8swv//Nbn//0qm//88zv//TMT+vztN/c8wXf//I33//xyr//8jtv//K8D//2Ov4f+zhrz/+FGc/+9IoP/ITKr/NtD//zvE//9HvP//RtD//0nV/r8wXf+vKmj//xyN//8dpf//IK3//x2t//8jtf//XaPr/9dUuf/gS7T/Xr/v/z3Y//8/yv//Rs3//0jY//9F3P+vKmj/YCRy//8cgP//FY3//xOd//8opPr/tVrE/+k+uP/oPLv/zk69/3Gh4v860///Qdf//0bZ//9I2///ReH/YAAAAAAefP/fFor//xqU/+8rmv//R5X2j942sI/AWcXfpHTQ/3yg4P8+2///QN7//0Lf//9G3f//S+L/30jj/xAAAAAAGIb/MBSZ/+8Xpf9gO57/jzu0/4AAAAAANc7/QDjT//9A3///Reb//0Xm//9D4v//SuL/j0/m/zAAAAAAAAAAAAAAAAAaqP8wHq7/IAAAAAAAAAAAAAAAAAAAAABB4f/vSOr//0rt//9I6f//ReX/YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASOr/cEzv//9M8P//Sez/jwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABN8f+PTfH/3wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_Firefox_IconBytes = [Convert]::FromBase64String($CheckBox_Firefox_Icon64)
$CheckBox_Firefox_IconStream = [System.IO.MemoryStream]::new($CheckBox_Firefox_IconBytes, 0, $CheckBox_Firefox_IconBytes.Length)
$CheckBox_Firefox.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Firefox_IconStream).GetHIcon()))
$CheckBox_Firefox.ImageAlign = 'MiddleLeft'
$CheckBox_Firefox.Text = '    Firefox'
$CheckBox_Firefox.TextAlign = 'MiddleLeft'
$CheckBox_Firefox.CheckAlign = 'MiddleLeft'
$CheckBox_Firefox.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Firefox)

if ($InstalledSoftware -match 'Mozilla Firefox') {
    $CheckBox_Firefox.Enabled = $false
    $CheckBox_Firefox.Text += ' (Installed)'
}

$CheckBox_FirefoxArkenfox = New-Object System.Windows.Forms.CheckBox
$CheckBox_FirefoxArkenfox.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_FirefoxArkenfox.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_FirefoxArkenfox_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcQvlYG0M479qDeL/aA7h/2kO4f9tDeP/cAvlr3QK52AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABxC+UQbQzjv2MT4v9YIu3/Uirz/00x+v9LM/v/TC72/1Mm8P9iF+n/bBLrv2se8BAAAAAAAAAAAAAAAAByCuUQbA3jz1ki7v9OMvz/STb+/0U5//9DPf//QUH//z9D//8+Rf//QET9/1I28/9hOPPPYU33EAAAAAAAAAAAbQ/mv1Ms9/9JNv7/RDv//0FB//89R///O0v//zhP//83Uv//NVX//zZd//85a///TWH3/1ti+K8AAAAAcwrmQFkj8v9FOf//QUH//z1I//8xY///XlfB/4dFjf+JQ4//UlHZ/zNj//8zdf//NIb//zeS//9Rfvr/Von8QGUY7Z9EPP//P0X//zpN//8sbf//d2KX/7ZBWP/ASlr/xEVj/8I2cP9iY83/M4j//zyM/v81qP//Q6P9/1Kd/Z9KNvu/PUf//zdR//8yWv//Ooni/7w+Yf/PUmH/21pm/+BVcv/cRH//wTeN/ymr//86n///QqX+/z28/v9PsP6/Sjn5/zdS//8wXf//Kmf//ymo9v+9VIX/51h2//Jeff/2V4j/7UqQ/9c3kf8swv//Nbn//0qm//88zv//TMT+vztN/c8wXf//I33//xyr//8jtv//K8D//2Ov4f+zhrz/+FGc/+9IoP/ITKr/NtD//zvE//9HvP//RtD//0nV/r8wXf+vKmj//xyN//8dpf//IK3//x2t//8jtf//XaPr/9dUuf/gS7T/Xr/v/z3Y//8/yv//Rs3//0jY//9F3P+vKmj/YCRy//8cgP//FY3//xOd//8opPr/tVrE/+k+uP/oPLv/zk69/3Gh4v860///Qdf//0bZ//9I2///ReH/YAAAAAAefP/fFor//xqU/+8rmv//R5X2j942sI/AWcXfpHTQ/3yg4P8+2///QN7//0Lf//9G3f//S+L/30jj/xAAAAAAGIb/MBSZ/+8Xpf9gO57/jzu0/4AAAAAANc7/QDjT//9A3///Reb//0Xm//9D4v//SuL/j0/m/zAAAAAAAAAAAAAAAAAaqP8wHq7/IAAAAAAAAAAAAAAAAAAAAABB4f/vSOr//0rt//9I6f//ReX/YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASOr/cEzv//9M8P//Sez/jwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABN8f+PTfH/3wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_FirefoxArkenfox_IconBytes = [Convert]::FromBase64String($CheckBox_FirefoxArkenfox_Icon64)
$CheckBox_FirefoxArkenfox_IconStream = [System.IO.MemoryStream]::new($CheckBox_FirefoxArkenfox_IconBytes, 0, $CheckBox_FirefoxArkenfox_IconBytes.Length)
$CheckBox_FirefoxArkenfox.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_FirefoxArkenfox_IconStream).GetHIcon()))
$CheckBox_FirefoxArkenfox.ImageAlign = 'MiddleLeft'
$CheckBox_FirefoxArkenfox.Text = '    Firefox - Arkenfox'
$CheckBox_FirefoxArkenfox.TextAlign = 'MiddleLeft'
$CheckBox_FirefoxArkenfox.CheckAlign = 'MiddleLeft'
$CheckBox_FirefoxArkenfox.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_FirefoxArkenfox)

$Arkenfox_Update = 'Arkenfox Update'
$Arkenfox_Update_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Arkenfox_Update }
if (($Arkenfox_Update_Exists)) {
    $CheckBox_FirefoxArkenfox.Enabled = $false
    $CheckBox_FirefoxArkenfox.Text += ' (Installed)'
}

$CheckBox_FirefoxExtensions = New-Object System.Windows.Forms.CheckBox
$CheckBox_FirefoxExtensions.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_FirefoxExtensions.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_FirefoxExtensions_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcQvlYG0M479qDeL/aA7h/2kO4f9tDeP/cAvlr3QK52AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABxC+UQbQzjv2MT4v9YIu3/Uirz/00x+v9LM/v/TC72/1Mm8P9iF+n/bBLrv2se8BAAAAAAAAAAAAAAAAByCuUQbA3jz1ki7v9OMvz/STb+/0U5//9DPf//QUH//z9D//8+Rf//QET9/1I28/9hOPPPYU33EAAAAAAAAAAAbQ/mv1Ms9/9JNv7/RDv//0FB//89R///O0v//zhP//83Uv//NVX//zZd//85a///TWH3/1ti+K8AAAAAcwrmQFkj8v9FOf//QUH//z1I//8xY///XlfB/4dFjf+JQ4//UlHZ/zNj//8zdf//NIb//zeS//9Rfvr/Von8QGUY7Z9EPP//P0X//zpN//8sbf//d2KX/7ZBWP/ASlr/xEVj/8I2cP9iY83/M4j//zyM/v81qP//Q6P9/1Kd/Z9KNvu/PUf//zdR//8yWv//Ooni/7w+Yf/PUmH/21pm/+BVcv/cRH//wTeN/ymr//86n///QqX+/z28/v9PsP6/Sjn5/zdS//8wXf//Kmf//ymo9v+9VIX/51h2//Jeff/2V4j/7UqQ/9c3kf8swv//Nbn//0qm//88zv//TMT+vztN/c8wXf//I33//xyr//8jtv//K8D//2Ov4f+zhrz/+FGc/+9IoP/ITKr/NtD//zvE//9HvP//RtD//0nV/r8wXf+vKmj//xyN//8dpf//IK3//x2t//8jtf//XaPr/9dUuf/gS7T/Xr/v/z3Y//8/yv//Rs3//0jY//9F3P+vKmj/YCRy//8cgP//FY3//xOd//8opPr/tVrE/+k+uP/oPLv/zk69/3Gh4v860///Qdf//0bZ//9I2///ReH/YAAAAAAefP/fFor//xqU/+8rmv//R5X2j942sI/AWcXfpHTQ/3yg4P8+2///QN7//0Lf//9G3f//S+L/30jj/xAAAAAAGIb/MBSZ/+8Xpf9gO57/jzu0/4AAAAAANc7/QDjT//9A3///Reb//0Xm//9D4v//SuL/j0/m/zAAAAAAAAAAAAAAAAAaqP8wHq7/IAAAAAAAAAAAAAAAAAAAAABB4f/vSOr//0rt//9I6f//ReX/YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASOr/cEzv//9M8P//Sez/jwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABN8f+PTfH/3wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_FirefoxExtensions_IconBytes = [Convert]::FromBase64String($CheckBox_FirefoxExtensions_Icon64)
$CheckBox_FirefoxExtensions_IconStream = [System.IO.MemoryStream]::new($CheckBox_FirefoxExtensions_IconBytes, 0, $CheckBox_FirefoxExtensions_IconBytes.Length)
$CheckBox_FirefoxExtensions.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_FirefoxExtensions_IconStream).GetHIcon()))
$CheckBox_FirefoxExtensions.ImageAlign = 'MiddleLeft'
$CheckBox_FirefoxExtensions.Text = '    Firefox - Extensions'
$CheckBox_FirefoxExtensions.TextAlign = 'MiddleLeft'
$CheckBox_FirefoxExtensions.CheckAlign = 'MiddleLeft'
$CheckBox_FirefoxExtensions.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_FirefoxExtensions)

$CheckBox_Git = New-Object System.Windows.Forms.CheckBox
$CheckBox_Git.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Git.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Git_Icon64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAB3klEQVQ4jXWTMWtTURTHfzc0VQqVoqjwimkzVF1ejIOOVroIhRrwC0QHNwdLJrcz6RRqv4CSRXAQCQGLoGiriyA2Gm100EaLQYzRWl/bh6Eeh9zXviYvZ7mXc8/vf//33HsNEaEiAHuB10ALOAm0TDu/K0wPGOAXMGTnX4FklEgsAt4HHAPClcPAMhDXXgJSUqz6O2AJuAdcBO7bEgd4ZUTIV7K7jyAlBXvmTK14Od0szwMrRiRhnVWB0QenG5Pvj3i3gTGglXMLmBD8GTgI/M3UiufSzfJTIGlEaioyPXeqUa0mvDlAgXrQk1gIPmQd7SmOZh6WD6TPAtdU5LwRmakmvBOAb2u2e2KkpB+Ao3RHS6ZMf9a7MJBaHlwHBnNuwctXsreAS7ZmKUb7njtDFVZVMZ/ebGzZ3HE7rgQ1gYO4tTMcLPxTfkynZq8M9a9OAo8XNn7WXm7+fgQ8ByYs3ABG+qyDpBVxQvBdYBz4fmZg/9st1fFFf+1ZGAb88DXGFeavurM3LfzFODICoHV5AaSfrDcnFv21O7Qfmp9zCztPWUqKTBm0Lt+AwzZ9A/gDXLc7fzSOjOUrWXJuAej4C1oXgM6eBA3bse3I9kL3Z+oW6QlHCnSIlO2YioIB/gOPdMuwrBJwHQAAAABJRU5ErkJggg=='
$CheckBox_Git_IconBytes = [Convert]::FromBase64String($CheckBox_Git_Icon64)
$CheckBox_Git_IconStream = [System.IO.MemoryStream]::new($CheckBox_Git_IconBytes, 0, $CheckBox_Git_IconBytes.Length)
$CheckBox_Git.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Git_IconStream).GetHIcon()))
$CheckBox_Git.ImageAlign = 'MiddleLeft'
$CheckBox_Git.Text = '    Git'
$CheckBox_Git.TextAlign = 'MiddleLeft'
$CheckBox_Git.CheckAlign = 'MiddleLeft'
$CheckBox_Git.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Git)

$GitUpdater = 'Git Updater'
$GitUpdater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $GitUpdater }
if (($GitUpdater_Exists)) {
    $CheckBox_Git.Enabled = $false
    $CheckBox_Git.Text += ' (Installed)'
}

$CheckBox_HyperXNGENUITY = New-Object System.Windows.Forms.CheckBox
$CheckBox_HyperXNGENUITY.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_HyperXNGENUITY.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_HyperXNGENUITY_Icon64 = 'AAABAAEAEBAAAAAAAABoBQAAFgAAACgAAAAQAAAAIAAAAAEACAAAAAAAQAEAAAAAAAAAAAAAAAEAAAAAAAAAAAD/gAAA/wCAAP+AgAD/AACA/4AAgP8AgID/wMDA/8DcwP+myvD/8PDw////mf+Z1Jn/mdT////M////mZn/IiIw/wAAEf8AACL/AABE/wAAVf8AAHf/AACI/wAAqv8AAN3/AADu/wARAP8AIgD/AEQA/wBVAP8AdwD/AIgA/wCqAP8A3QD/AO4A/xEAAP8iAAD/RAAA/1UAAP93AAD/kAAA/6oAAP/dAAD/7gAA/wAAM/8AAGb/AACZ/wAAzP8AMwD/ADMz/wAzZv8AM6H/ADPM/wAz//8AZgD/AGYz/wBmZv8AZpn/AGbM/wBm//8AmQD/AJkz/wCZZv8AmZn/AJnM/wCZ//8AzAD/AMwz/wDMZv8AzJn/AMzM/wDM//8A/zP/AP9m/wD/mf8A/8z/MwAA/zMAM/8zAGb/MwCZ/zMAzP8zAP//MzMA/zMzO/8zM2b/MzOZ/zMzzP8zM///M2YA/zNuM/8zZmb/M2aZ/zNmzP8zZv//M5kA/zOZM/8zmWb/M5mZ/zOZzP8zmf//M8wA/zPMM/8zzGb/M8yZ/zPMzP8zzP//M/8A/zP/M/8z/2b/M/+Z/zP/zP8z////ZgAA/2YAM/9mAGb/ZgCZ/2YAzP9mAP//ZjMA/2YzM/9mM2b/ZjOZ/2YzzP9mM///ZmYA/2ZmM/9mZmb/ZmaZ/2ZmzP9mZv//ZpkA/2aZM/9mmWb/ZpmZ/2aZzP9mmf//ZswA/2bMM/9mzGb/ZsyZ/2bMzP9mzP//Zv8A/2b/M/9m/2b/Zv+Z/2b/zP9m////mQAA/5kAM/+ZAGb/mQCZ/5kAzP+ZAP//mTMA/5kzM/+ZM2b/mTOZ/5kzzP+ZM///oWYA/5lmM/+ZZmb/mWaZ/5lmzP+ZZv//mZkA/5mZM/+ZmWb/mZmZ/5mZzP+Zmf//mcwA/5nMM/+ZzGb/mcyZ/5nMzP+ZzP//mf8A/5n/M/+Z/2b/mf+Z/5n/zP+Z////zAAA/8wAM//MAGb/zACZ/8wAzP/UCP//zDMA/8wzM//MM2b/zDOZ/8wzzP/MM///zGYA/8xmM//MZmb/zGaZ/8xmzP/MZv//zJkA/8yZM//MmWb/zJmZ/8yZzP/Mmf//zMwA/8zMM//MzGb/zMyZ/8zMzP/MzP//zP8A/8z/M//M/2b/zP+Z/8z/zP/M/////wAz//8AZv//AJn//wDM//8zAP//MzP//zNm//8zmf//M8z//zP///9mAP//ZjP//2Zm//9mmf//Zsz//2b///+ZAP/d3d3//5nM///MZv+IAAD/zAD//wAzmf8zZjP/mWYA/zMzM///+/D/oKCk/4CAgP//AAD/AP8A////AP8AAP///wD//wD/////////AAAAAAAAAAAAAAAAAAAAAAAAABH1ECwtLRMAAAAAAAAAAPWp+Kl+VRcXLjIAAAAAABr3fql++H+qhlYXTgAAAAD1qfUH+H74VYDPVjQtAAAAEPcQ+PV+f1aAVtRWLwAAABN+qX5+qU+GCheBpFYUAAAVVVv4f/iAzqtWVoA1FQAALVeAVlarq4GwgIFWVk4AABRXpIFW7asYgavUqxkyAAAAVlyrVqtWVlZWq1ZWAAAAABVXgM+AV1aAz4A1TgAAAAAAVRlWq6qrq1ZXVQAAAAAAAABUVldWVxhWBAAAAAAAAAAAAAAUFlQUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//AADgPwAAwA8AAIAHAACAAwAAgAMAAIABAACAAQAAgAEAAIABAADAAwAAwAMAAOAHAADwDwAA/D8AAP//AAA='
$CheckBox_HyperXNGENUITY_IconBytes = [Convert]::FromBase64String($CheckBox_HyperXNGENUITY_Icon64)
$CheckBox_HyperXNGENUITY_IconStream = [System.IO.MemoryStream]::new($CheckBox_HyperXNGENUITY_IconBytes, 0, $CheckBox_HyperXNGENUITY_IconBytes.Length)
$CheckBox_HyperXNGENUITY.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_HyperXNGENUITY_IconStream).GetHIcon()))
$CheckBox_HyperXNGENUITY.ImageAlign = 'MiddleLeft'
$CheckBox_HyperXNGENUITY.Text = '    HyperX NGENUITY'
$CheckBox_HyperXNGENUITY.TextAlign = 'MiddleLeft'
$CheckBox_HyperXNGENUITY.CheckAlign = 'MiddleLeft'
$CheckBox_HyperXNGENUITY.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_HyperXNGENUITY)

if ((Get-ChildItem $env:ProgramFiles\WindowsApps -ErrorAction SilentlyContinue) -like '*NGENUITY*') {
    $CheckBox_HyperXNGENUITY.Enabled = $false
    $CheckBox_HyperXNGENUITY.Text += ' (Installed)'
}

$CheckBox_Jellyfin = New-Object System.Windows.Forms.CheckBox
$CheckBox_Jellyfin.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Jellyfin.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Jellyfin_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAACMuAAAjLgAAAAAAAAAAAADJbn0AzHF2AMlufgjKcXYdzHZsNM16YUbPf1ZU0YNMWtKIQVrUjDdU1ZEtRteVIjTYmRkd2p0PCNKGQADbogUAxWOYC8dnj2LIa4WyynB62Mt0b+vNeWX1z31a+tCCT/zShkX804s6+tWPMPXWlCXr2Jgb2NmcEbPboAll26MCDcVim0bGZJXwx2mK/8ltgP/LcnX0zHZq4M57X9HPgFXK0YRKytKJP9HUjTXg1pEr9NeWIP/Zmhb/2p8L89uhBk7EYKA7xWKa7cdmkP/Ia4ajynB5PMx1bh7NemERz4BVC9GESQvSiEAR1Iw3HtWQLjvWlCSe2Jgc/9mcEvDanwtCxF6kE8Rgn8bGZJf/x2aQWcdnjwDKcXgFy3RvIM15ZTHOfVsx0IFRIdGESwbWkioA1pIoUdeVIv7YmRnM2ZwRF8RhngDEXqR+xWGd/8ZklZHJbn8AynB5Sstzc+HNd2jvznxd79CAU+LRg01R0ohAANWPMInWkij/15YghNSLOQDDXaYAw12nLsRfoujFYpnZxmOXHMlvfDLKcXjrzHVu/815Y//Pflnu0IFSONOJPRfUjDjU1ZAv69aTJzPWkikAw1ypAMJZsAPDXaaYxGCe/8ZjmHHLdHADyW98nstydP/Md2n/zntgpc57YATRhUdq04k//9SMNp7WlCYE1ZAvAMNZsADDXKgAw1ypNsReo+vFYpvVxmOYHclufS/KcHnhy3Rw5cx3aDXPf1UZ0IJPz9KGRu7TiT470ohAANOLOAAAAAAAw1yqAMJZsgLDXaeQxGCg/8VjmYXHZo8Cym97U8pxd1fKcHkBzntefs9/Vv/Qg02X04s7BNKGRQAAAAAAAAAAAAAAAADDXKkAw1yqKMRepdvFYZzsxmSWQsVimgDMd2kAzHVvPM14ZujOfFzgz4BULM9/VgDSe18AAAAAAAAAAAAAAAAAw1yrAMRgngDDXKhsxF+h/MVjmcnGZZMlyW1/IMpxdsPMdW3+zXlkcsZmkgDOfFwAAAAAAAAAAAAAAAAAAAAAAAAAAADDXKkAw1urDsNdpa3FYZ3/xmWUz8hqiMzJbn3/y3J0s8x3ahHMdmwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAw1qtAMNdpgDDXacsxF+i1cVjmf/HZ47/yGyE2cpvezHJbn4AynF3AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADCXKkAxWGdAMRepEPFYZ7XxmWU28dpi0jFYZ0AyWyEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMRepQDCV7YBxGCfK8Vimi3IaYoBxmWUAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAMAAAAAAAAAAAAAAAAAAAgQAACIEQAAgAEAAIABAADAAwAAwAMAAOGHAADwDwAA8A8AAPgfAAD8PwAA/D8AAA=='
$CheckBox_Jellyfin_IconBytes = [Convert]::FromBase64String($CheckBox_Jellyfin_Icon64)
$CheckBox_Jellyfin_IconStream = [System.IO.MemoryStream]::new($CheckBox_Jellyfin_IconBytes, 0, $CheckBox_Jellyfin_IconBytes.Length)
$CheckBox_Jellyfin.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Jellyfin_IconStream).GetHIcon()))
$CheckBox_Jellyfin.ImageAlign = 'MiddleLeft'
$CheckBox_Jellyfin.Text = '    Jellyfin'
$CheckBox_Jellyfin.TextAlign = 'MiddleLeft'
$CheckBox_Jellyfin.CheckAlign = 'MiddleLeft'
$CheckBox_Jellyfin.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Jellyfin)

if ($InstalledSoftware -match 'Jellyfin') {
    $CheckBox_Jellyfin.Enabled = $false
    $CheckBox_Jellyfin.Text += ' (Installed)'
}

$CheckBox_JitBit_Macro_Recorder = New-Object System.Windows.Forms.CheckBox
$CheckBox_JitBit_Macro_Recorder.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_JitBit_Macro_Recorder.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_JitBit_Macro_Recorder_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgAAACoAAAA/AgICSQICAkoAAABCAAAAMAAAABUAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABUVFTdfXFijcGxnt4N9dsZwa2e3a2dksHVyb64+OzmAAAAAEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWFRUVVlNPZVVQS4laU0uuTEI4sEE6M5lMRT93PTgyUQICAgUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAABwAAABkwIxGgdV4184tzRf9yWzHuKB4NjgAAABMAAAAHAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAEHhoWXygjHnggGA6BhXdo/7mzrv/Mx8T/p56X/3dnVf4WDwhtMiwmihMQDkYAAAABAAAAAAAAAAAAAAAAAAAAA3RsY7KdkXz2Qzszuayjmf/Z1M//5uPg/8W+tf+ZjYH/PjUqvrSpl/9RS0SGAAAAAQAAAAAAAAAAAAAAAAAAAAAwJAZvnHwD/1JIOti0qqD/2tXP/+bi3//Gvrb/oZWI/1JFK+Kjggb/FhADQAAAAAAAAAAAAAAAAAAAAAAAAAAAFA4CPKSCBv9lVzr2lYyg/9rVz/+9zbD/xb21/52Ndf9qWSv8nHsJ+AIBABQAAAAAAAAAAAAAAAAAAAAAAAAAAAYEASR0WSb+c2BF/62il/+3rqX/tq6l/62il/+dkIT/blo5/2xVKuYAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAOCwQYvrCH6p+Oa/9dTT7/ZVdL/3BjWP9kVkr/ZFRF/6iYcv+uo4fOBgUDBQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABoWDAwwKiF2dWhe/5KFef+ckIP/k4d8/3hsYv4jHhZWGhcOBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIOy0buaeelv9waGH/sqqh/4B5cv+nn5j/KBsLmgAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgEAA11NL6rMx8L/c25o/8XAu/+Mh4L/y8bC/0k6HIoCAQABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANDAobs6+t4/Du7f/y8e//8O/u/5qWlM4HBgULAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABw0MCzFua2mgrqWX73ZtYcElHRBeAwICAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQNBREzKRlIKh8KPT42IToUDgIKFQ8EBAAAAAAAAAAAAAAAAAAAAAAAAAAA8AesQfAHrEHwB6xB4AOsQcABrEHAAaxB4AOsQeADrEHgA6xB4AOsQfAHrEHwB6xB8AesQfgPrEH4D6xB+B+sQQ=='
$CheckBox_JitBit_Macro_Recorder_IconBytes = [Convert]::FromBase64String($CheckBox_JitBit_Macro_Recorder_Icon64)
$CheckBox_JitBit_Macro_Recorder_IconStream = [System.IO.MemoryStream]::new($CheckBox_JitBit_Macro_Recorder_IconBytes, 0, $CheckBox_JitBit_Macro_Recorder_IconBytes.Length)
$CheckBox_JitBit_Macro_Recorder.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_JitBit_Macro_Recorder_IconStream).GetHIcon()))
$CheckBox_JitBit_Macro_Recorder.ImageAlign = 'MiddleLeft'
$CheckBox_JitBit_Macro_Recorder.Text = '    JitBit Macro Recorder'
$CheckBox_JitBit_Macro_Recorder.TextAlign = 'MiddleLeft'
$CheckBox_JitBit_Macro_Recorder.CheckAlign = 'MiddleLeft'
$CheckBox_JitBit_Macro_Recorder.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_JitBit_Macro_Recorder)

if ($InstalledSoftware -match 'Macro Recorder') {
    $CheckBox_JitBit_Macro_Recorder.Enabled = $false
    $CheckBox_JitBit_Macro_Recorder.Text += ' (Installed)'
}

$CheckBox_LogitechGHUB = New-Object System.Windows.Forms.CheckBox
$CheckBox_LogitechGHUB.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_LogitechGHUB.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_LogitechGHUB_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGBgYARgYGAIAAAAAGBgYOBgYGKUYGBjkGBgY/BgYGPwYGBjkGBgYpRgYGDgAAAAAGBgYAhgYGAEAAAAAGBgYAQAAAAAYGBgIGBgYlhcXF/4ZGRn+Gxsb/hoaGv8YGBj/FxcX/hgYGP4YGBj+GBgYlhgYGAgAAAAAGBgYAQAAAAAYGBgIGBgYvhcXF/8aGhr7FBQU/AYGBv0KCgr+FxcX/hcXF/0aGhr8Gxsb+xgYGP8XFxe+GRkZCAAAAAAAAAAAGBgYlRcXF/8aGhr4DQ0N/iUlJf+BgYH+oKCg/yAgIP8WFhb+DQ0N/wcHB/4UFBT4GBgY/xcXF5UAAAAAGBgYPBcXF/saGhr9DQ0N/khISP7o6Oj+/////+np6f8mJib/EhIS/1NTU/5ycnL+Kioq/hMTE/0YGBj7GBgYPBgYGKIZGRn/ExMT/CkpKf/m5ub+/////7e3t/9UVFT/FhYW/wQEBP+4uLj//////kpKSv8MDAz8Ghoa/xgYGKIXFxfhGxsb/wcHB/6CgoL+/////7Ozs/8ICAj/DAwM/zQ0NP8rKyv/vr6+//////9JSUn+DAwM/hoaGv8YGBjhGBgY+xoaGv8LCwv+tbW1//////9VVVX/CAgI/yoqKv/q6ur///////z8/P//////TU1N/wwMDP4aGhr/GBgY+xgYGPsaGhr/CwsL/rW1tf//////VVVV/wgICP8oKCj/xcXF/9ra2v/T09P/29vb/0NDQ/8ODg7+Ghoa/xgYGPsXFxfhGxsb/wcHB/6CgoL+/////7Ozs/8JCQn/CgoK/xUVFf8UFBT/FRUV/xUVFf8XFxf+GBgY/hcXF/8YGBjhGBgYohkZGf8TExP8KSkp/+bm5v7/////t7e3/1VVVf8aGhr/FxcX/xgYGP8YGBj+GBgY/xcXF/wYGBj/GBgYohgYGDwXFxf7Ghoa/Q0NDf5ISEj+6Ojo/v/////p6en/IyMj/xUVFf8ZGRn+GBgY/hgYGP4XFxf9GBgY+xgYGDwAAAAAGBgYlRcXF/8aGhr4DQ0N/iUlJf+BgYH+oKCg/yAgIP8VFRX+GBgY/xgYGP4YGBj4GBgY/xgYGJUAAAAAAAAAABgYGAgYGBi+FxcX/xoaGvsUFBT8BgYG/QoKCv4XFxf+GBgY/RcXF/wYGBj7GBgY/xgYGL4YGBgIAAAAABgYGAEAAAAAGBgYCBgYGJYXFxf+GRkZ/hsbG/4aGhr/GBgY/xcXF/4YGBj+GBgY/hgYGJYYGBgIAAAAABgYGAEAAAAAGBgYARgYGAIAAAAAGBgYOBgYGKUYGBjkGBgY/BgYGPwYGBjkGBgYpRgYGDgAAAAAGBgYAhgYGAEAAAAA+B8AAOAHAADAAwAAgAEAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAQAAgAEAAMADAADgBwAA+B8AAA=='
$CheckBox_LogitechGHUB_IconBytes = [Convert]::FromBase64String($CheckBox_LogitechGHUB_Icon64)
$CheckBox_LogitechGHUB_IconStream = [System.IO.MemoryStream]::new($CheckBox_LogitechGHUB_IconBytes, 0, $CheckBox_LogitechGHUB_IconBytes.Length)
$CheckBox_LogitechGHUB.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_LogitechGHUB_IconStream).GetHIcon()))
$CheckBox_LogitechGHUB.ImageAlign = 'MiddleLeft'
$CheckBox_LogitechGHUB.Text = '    Logitech G HUB'
$CheckBox_LogitechGHUB.TextAlign = 'MiddleLeft'
$CheckBox_LogitechGHUB.CheckAlign = 'MiddleLeft'
$CheckBox_LogitechGHUB.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_LogitechGHUB)

if ($InstalledSoftware -match 'Logitech G HUB') {
    $CheckBox_LogitechGHUB.Enabled = $false
    $CheckBox_LogitechGHUB.Text += ' (Installed)'
}

$CheckBox_MediaInfo = New-Object System.Windows.Forms.CheckBox
$CheckBox_MediaInfo.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_MediaInfo.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_MediaInfo_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAADFubuQ7AA+/8MEq0AAAAAAAAAAAAAAAAAAAAAAAAABAAAABcAAAA3AAAAPQAAAAAAAAAAAAAAAAAAAAAAAAAAAxbm+0OwAPv/DBK5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACoAAACmAAAANQAAAAAAAAAAAAAAAAMW5vtDsAD7/wwSuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADwAAANQAAABmAAAAAAAAAAADFub7Q7AA+/8MErgAAAAAAAAAAAAAAAAAAAAAAAAABwAAAD0AAABaAAAAAgAAAAAAAAAkAAAA+wAAAFYAAAAAAxbm+0OwAPv/DBK4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQgAAAMwAAAAXAAAAAAAAAJAAAADzAAAAFAMW5vtDsAD7/wwSuAAAAAAAAAAAAAAAKAAAAG4AAAA3AAAAAAAAAAAAAACCAAAAywAAAAAAAAArAAAA/wAAAIIDFub7Q7AA+/8MErgAAAAAAAAAOwAAAPwnJyf/AAAA/wAAAFoAAAAAAAAAFwAAAP8AAABIAAAAAAAAAO4AAADQAxbm+0OwAPv/DBK4AAAAAAAAAKcNDQ3/bGxs/wICAv8AAADLAAAAAAAAAAAAAADsAAAAgwAAAAAAAADPAAAA9gMW5vtDsAD7/wwSuAAAAAAPEBCebm5u/42Njf9iYmL/AAAAwwAAAAAAAAAAAAAA6wAAAIMAAAAAAAAAzwAAAPYDFub7Q7AA+/8MErgAAAAAIiMjJ15eXu5kZGT/BQUF+QAAAEAAAAAAAAAAFwAAAP8AAABJAAAAAAAAAO4AAADQAxbm+0OwAPv/DBK4AAAAAAAAAAAmJiYOFBQURQAAABcAAAAAAAAAAAAAAIEAAADMAAAAAAAAACoAAAD/AAAAggMW5vtDsAD7/wwSuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEEAAADNAAAAGAAAAAAAAACPAAAA9AAAABQDFub7Q7AA+/8MErgAAAAAAAAAAAAAAAAAAAAAAAAABwAAAD0AAABaAAAAAgAAAAAAAAAkAAAA+wAAAFcAAAAAAxbm+0OwAPv/DBK4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAA0wAAAGcAAAAAAAAAAAMW5vtDsAD7/wwSuQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAqAAAApwAAADYAAAAAAAAAAAAAAAADFubuQ7AA+/8MEq0AAAAAAAAAAAAAAAAAAAAAAAAABAAAABcAAAA3AAAAPQAAAAAAAAAAAAAAAAAAAAAAAAAAHh8AAB/HAAAf4wAAHhEAAB+IAAAYyAAAEEQAABBkAAAQZAAAEEQAABjIAAAfiAAAHhEAAB/jAAAfxwAAHh8AAA=='
$CheckBox_MediaInfo_IconBytes = [Convert]::FromBase64String($CheckBox_MediaInfo_Icon64)
$CheckBox_MediaInfo_IconStream = [System.IO.MemoryStream]::new($CheckBox_MediaInfo_IconBytes, 0, $CheckBox_MediaInfo_IconBytes.Length)
$CheckBox_MediaInfo.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_MediaInfo_IconStream).GetHIcon()))
$CheckBox_MediaInfo.ImageAlign = 'MiddleLeft'
$CheckBox_MediaInfo.Text = '    MediaInfo'
$CheckBox_MediaInfo.TextAlign = 'MiddleLeft'
$CheckBox_MediaInfo.CheckAlign = 'MiddleLeft'
$CheckBox_MediaInfo.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_MediaInfo)

$Mediainfo = 'Mediainfo Updater'
$Mediainfo_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Mediainfo }
if (($Mediainfo_Exists)) {
    $CheckBox_MediaInfo.Enabled = $false
    $CheckBox_MediaInfo.Text += ' (Installed)'
}

$CheckBox_MicrosoftStore = New-Object System.Windows.Forms.CheckBox
$CheckBox_MicrosoftStore.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_MicrosoftStore.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from Website
$CheckBox_MicrosoftStore_Icon64 = 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAACBSxkQfUkawHpIG/93Rhz/dUUd/3JDHv9vQh//bEAg/2k/If9mPSL/Yzwj/2A6JP9fOiT/XzokwF86JBD///8Ahk4YwIJMGf9/Shr/fUka/3pHG/93Rhz/dEUd/3FDHv9uQh//a0Ag/2g+If9lPSL/Yjsj/186JP9fOiTA////AItQFv+ITxf/hU0Y/3ZFF/9yQhf/b0IY/21AGf9qPxr/Zz0b/2U8G/9iOh3/YDod/2c+If9kPSL/YTsj/////wCQUxT/jVEV/4pQFv95RhX/76QA/++kAP/vpAD/bkEY/wC5//8Auf//ALn//2Q7HP9sQSD/aT8h/2Y+Iv////8AlVUT/5JUFP+PUhT/fkkU/++kAP/vpAD/76QA/3NDFv8Auf//ALn//wC5//9oPhr/cUMe/25CH/9rQCD/////AJpYEf+XVhL/lFUT/4JLEv/vpAD/76QA/++kAP93RRb/ALn//wC5//8Auf//bkAY/3ZGHP9zRB3/cUMe/////wCfWg//nFkQ/5lXEf+HTRD/hUwR/4FLEv9/SRP/fEgU/3lGFf93RRb/dUQW/3JCF/97SBv/eUcc/3ZFHf////8ApF0O/6FcD/+eWhD/jFAO/yJQ8v8iUPL/IlDy/4FLEv8Aun//ALp//wC6f/93RRb/gUsZ/35JGv97SBv/////AKlgDP+mXg3/pF0O/5FSDf8iUPL/IlDy/yJQ8v+GTBH/ALp//wC6f/8Aun//e0cU/4ZOF/+DTBj/gEsZ/////wCvYgr/rGEL/6lfDP+VVAz/IlDy/yJQ8v8iUPL/ik8P/wC6f/8Aun//ALp//4BKE/+LUBb/iE8X/4VNGP////8AtGUJ/7FjCv+uYgv/m1cL/5dVC/+UVAz/kVMN/49RDf+MUA7/iU4P/4dNEP+FTBH/kFMU/41RFf+KUBb/////ALlnB/+2Zgj/s2QJ/7BjCv+tYQv/qmAM/6deDf+kXQ7/oVsP/55aEP+bWBH/mFcS/5VVEv+SVBP/kFMU/////wC8aQagu2gG/7hnB//hqRP/smQJ/69jCv+sYQv/qWAM/6ZeDf+jXA7/oFsP/9WaC/+aWBH/mFcS/5VVE6D///8A////AP///wD///8A+9Mr/////wD///8A////AP///wD///8A////AP///wDxwyD/////AP///wD///8A////AP///wD///8A////APPWTq3/vCL//7wi//+8Iv//vCL//7wi//+8Iv//vCL//9owoP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAO/vAADgDwAA//8AAA=='
$CheckBox_MicrosoftStore_IconBytes = [Convert]::FromBase64String($CheckBox_MicrosoftStore_Icon64)
$CheckBox_MicrosoftStore_IconStream = [System.IO.MemoryStream]::new($CheckBox_MicrosoftStore_IconBytes, 0, $CheckBox_MicrosoftStore_IconBytes.Length)
$CheckBox_MicrosoftStore.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_MicrosoftStore_IconStream).GetHIcon()))
$CheckBox_MicrosoftStore.ImageAlign = 'MiddleLeft'
$CheckBox_MicrosoftStore.Text = '    Microsoft Store'
$CheckBox_MicrosoftStore.TextAlign = 'MiddleLeft'
$CheckBox_MicrosoftStore.CheckAlign = 'MiddleLeft'
$CheckBox_MicrosoftStore.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_MicrosoftStore)

if ($null -ne (Get-AppxPackage -Name Microsoft.WindowsStore)) {
    $CheckBox_MicrosoftStore.Enabled = $false
    $CheckBox_MicrosoftStore.Text += ' (Installed)'
}

$CheckBox_mpv = New-Object System.Windows.Forms.CheckBox
$CheckBox_mpv.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_mpv.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_mpv_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABMLAAATCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAIAAAAFAAAACMAAAAtAAAAMwAAADMAAAAtAAAAIwAAABQAAAAIAAAAAQAAAAAAAAAAAAAAAAAAAAEAAAAKAAAAHSMAI0pLAEulVwBX3lsAW/hbAFv4VwBX3ksAS6UjACNKAAAAHQAAAAoAAAABAAAAAAAAAAAAAAAIAAAAHkAAQHxbAFv2XABc/1wAXP9cAFz/XABc/1wAXP9cAFz/WwBb9kAAQHwAAAAeAAAACAAAAAAAAAADAAAAFkEAQXtcAFz+XABc/1wAXP96NHr/l2WX/5Vklf94MXj/XABc/1wAXP9cAFz+QQBBegAAABYAAAADAAAACSgAKD1bAFv2XABc/2QOZP++pL7/4uLi/9/f3//d3d3/29vb/7Wbtf9jDGP/XABc/1sAW/YoACg9AAAACQAAABBOAE6gXABc/1wAXP/ApsD/5ubm/4FVgf/Px8//4ODg/93d3f/b29v/tJq0/1wAXP9cAFz/TgBOoAAAABAAAAAUWABY3VwAXP99Nn3/6+vr/+np6f9fHV//Wx5b/5p6mv/a2Nr/3d3d/9vb2/93MHf/XABc/1gAWN0AAAAUAAAAFVsAW/ZcAFz/n22f/+3t7f/r6+v/ayRr/2IdYv9YF1j/ZS5l/7ShtP/e3t7/lWKV/1wAXP9bAFv2AAAAFQAAABJcAFz7XABc/6BuoP/w8PD/7u7u/3QrdP9tJW3/Yx5j/2w0bP+4pbj/4ODg/5Zklv9cAFz/XABc+wAAABIAAAANWQBZ21wAXP9+N37/8vLy//Dw8P95L3n/djF2/6mHqf/i4OL/5eXl/+Li4v95MXn/XABc/1kAWdoAAAANAAAABlMAU5ZcAFz/XABc/8muyf/y8vL/nGqc/93U3f/s7Oz/6enp/+fn5/+9or3/XABc/1wAXP9TAFOVAAAABgAAAAI9AD0nWwBb9VwAXP9lDmX/yK3I//Ly8v/w8PD/7u7u/+zs7P/BpsH/ZA5k/1wAXP9bAFv1PQA9JwAAAAIAAAAAAAAABFAAUGFcAFz+XABc/1wAXP99NX3/n2yf/55rnv98M3z/XABc/1wAXP9cAFz+TwBPYAAAAAQAAAAAAAAAAAAAAAEAAAAFUQBRX1sAW/NcAFz/XABc/1wAXP9cAFz/XABc/1wAXP9bAFvzUQBRXwAAAAUAAAABAAAAAAAAAAAAAAAAAAAAAQAAAAM/AD8dVgBWjVoAWtNcAFz1XABc+1oAWtVWAFaNPwA/HQAAAAMAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAMAAAAFAAAABgAAAAYAAAAFAAAAAwAAAAEAAAAAAAAAAAAAAAAAAAAAwAMAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIABAADAAwAA4AcAAA=='
$CheckBox_mpv_IconBytes = [Convert]::FromBase64String($CheckBox_mpv_Icon64)
$CheckBox_mpv_IconStream = [System.IO.MemoryStream]::new($CheckBox_mpv_IconBytes, 0, $CheckBox_mpv_IconBytes.Length)
$CheckBox_mpv.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_mpv_IconStream).GetHIcon()))
$CheckBox_mpv.ImageAlign = 'MiddleLeft'
$CheckBox_mpv.Text = '    mpv (Desktop)'
$CheckBox_mpv.TextAlign = 'MiddleLeft'
$CheckBox_mpv.CheckAlign = 'MiddleLeft'
$CheckBox_mpv.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_mpv)

if ((Test-Path -Path "$($env:USERPROFILE)\Desktop\mpv")) {
    $CheckBox_mpv.Enabled = $false
    $CheckBox_mpv.Text += ' (Installed)'
}

$CheckBox_NordVPN = New-Object System.Windows.Forms.CheckBox
$CheckBox_NordVPN.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_NordVPN.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_NordVPN_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4FHUwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP+BR1MAAAAA/4BGOv+ARv3/f0Q8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP+BR1P/gEb8/4BDJv+ARqD/gEb//4BG0/+ZMwUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP+JTg3/gEbj/4BG//+AR4n/gEbi/4BG//+ARv//gUZ1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD/gEeN/4BG//+ARv//f0XK/4BG/v+ARv//gEb//39G9P9/RB4AAAAA/4NGIQAAAAAAAAAAAAAAAP+DRiH/gkcv/4BG+/+ARv//gEb//4BG6f+ARv7/gEb//4BG//+ARv//gEav/39EHv+BRl8AAAAAAAAAAP+ARTT/gEZM/4BGxf+ARv//gEb//4BG//+ARur/gEbh/4BG//+ARv//gEb//4BG//+ARtT/gEanAAAAAP//AAH/gEbG/4BG0/+ARv//gEb//4BG//+ARv//gEbJ/4BFnv+ARv//gEb//4BG//+ARv//gEb//4BG/v+CRT//gUdd/4BG//+ARv//gEb//4BG//+ARv//gEb//4BGhv+ARDj/gEb//4BG//+ARv//gEb//4BG//+ARv//gEbT/4BG5f+ARv//gEb//4BG//+ARv//gEb//4BG+/+DSSMAAAAA/4BFov+ARv//gEb//4BG//+ARv//gEb//4BG//+ARv//gEb//4BG//+ARv//gEb//4BG//+ARooAAAAAAAAAAP+AQAz/gEbH/4BG//+ARv//gEb//4BG//+ARv//gEb//4BG//+ARv//gEb//4BG//+ARrX/mTMFAAAAAAAAAAAAAAAA/4tGC/+ARqD/gEb+/4BG//+ARv//gEb//4BG//+ARv//gEb//4BG/P+ARo//gFUGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4JINf+AR5v/gEbb/4BG+v+ARvn/gEbX/4BGkv+ASSoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_NordVPN_IconBytes = [Convert]::FromBase64String($CheckBox_NordVPN_Icon64)
$CheckBox_NordVPN_IconStream = [System.IO.MemoryStream]::new($CheckBox_NordVPN_IconBytes, 0, $CheckBox_NordVPN_IconBytes.Length)
$CheckBox_NordVPN.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_NordVPN_IconStream).GetHIcon()))
$CheckBox_NordVPN.ImageAlign = 'MiddleLeft'
$CheckBox_NordVPN.Text = '    NordVPN'
$CheckBox_NordVPN.TextAlign = 'MiddleLeft'
$CheckBox_NordVPN.CheckAlign = 'MiddleLeft'
$CheckBox_NordVPN.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_NordVPN)

if ($InstalledSoftware -match 'NordVPN') {
    $CheckBox_NordVPN.Enabled = $false
    $CheckBox_NordVPN.Text += ' (Installed)'
}

$CheckBox_NotepadPlusPlus = New-Object System.Windows.Forms.CheckBox
$CheckBox_NotepadPlusPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_NotepadPlusPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_NotepadPlusPlus_Icon64 = 'AAABAAEAEBAAAAAAAABoBQAAFgAAACgAAAAQAAAAIAAAAAEACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEgCABVXFwA0bTUAAABzAAAAdAAqQUkAWlpaAFxcXAByWU4AYGBgAGVlZQBqamoAbm5uAHFxcQB1dXUAeXl5AH19fQAotUUAWIdZADLQdQAHCo8AHhmEAABuvgALdr0AAG3AAAF3xgABe8kAZZiIAFCPqgBbj7AAZLalADvdoQBz2a4AQuG5AAGDzQAriccABKjrAASv8AAEt/cABLb4AFSlywBTpcwAU67LAAbA/gANwv0AFsj4ADLN+ABb5MUAZejdAFzU+QCAgIAAk5OUAJaWlwCglI8AgKSBAK6urgC3t7cAurq6AMyplACnwKgAxr/RAJbe0gCRw+IAy9rMAOXg1ADs6eEA8e7nAPLv7QDq8OoA9fPyAPf19AD5+/kA/Pv6APv9+wD7/vwA/v7+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///8ACAgICAgICAgICAgICAAAAAhISEhISEhISEhISAoAAAAISAIBAQEBAQEBAkgLAAAAC0gDEhISEh8GKQNICwAAAAtIExQUFBQhKRscSAwAAAALSDcgICAgIC4lGEgMAAAADEg8IiIiIiIwLBs/DgAAAAxIQD4+Pj4+Pi8mFw4AAAAOSEQxMTExMTExLBseAAAADkhEQUFBQUFBQTInFwAAAA5ISEhISEhISEhILCMkAAAOSENBQUFBQTMzMysoGQAAEUhISEhISEgzSEgzLR02ABFINUg1RzVEM0gzAAA7CQAROgA6ADoAOjMzAAAAPRYFMzM4MzgzODMzAAAAAAAVBQAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAAAwAAAAMAAAABAAAAGQAAKjgAAAB8AAA='
$CheckBox_NotepadPlusPlus_IconBytes = [Convert]::FromBase64String($CheckBox_NotepadPlusPlus_Icon64)
$CheckBox_NotepadPlusPlus_IconStream = [System.IO.MemoryStream]::new($CheckBox_NotepadPlusPlus_IconBytes, 0, $CheckBox_NotepadPlusPlus_IconBytes.Length)
$CheckBox_NotepadPlusPlus.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_NotepadPlusPlus_IconStream).GetHIcon()))
$CheckBox_NotepadPlusPlus.ImageAlign = 'MiddleLeft'
$CheckBox_NotepadPlusPlus.Text = '    Notepad++'
$CheckBox_NotepadPlusPlus.TextAlign = 'MiddleLeft'
$CheckBox_NotepadPlusPlus.CheckAlign = 'MiddleLeft'
$CheckBox_NotepadPlusPlus.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_NotepadPlusPlus)

$Notepad = 'Notepad++ Updater'
$Notepad_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Notepad }
if (($Notepad_Exists)) {
    $CheckBox_NotepadPlusPlus.Enabled = $false
    $CheckBox_NotepadPlusPlus.Text += ' (Installed)'
}

$CheckBox_NVCleanstall = New-Object System.Windows.Forms.CheckBox
$CheckBox_NVCleanstall.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_NVCleanstall.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_NVCleanstall_Icon64 = 'AAABAAEAEBAAAAAAAABoBQAAFgAAACgAAAAQAAAAIAAAAAEACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACOekUAlnYyAIlrLQCngzcAqItIAKmPTwCpkVQAqZBRAKaOUACoiUIApYM7AG5oWABzbVwAc21dAHRuXgB0bl8AdG5gAFZwVwAOqWsAVWVOAKKBOgCoiUQAqYxKAKSEPgBsbGcAc3NuAHNzbwB0dHAAdHRyAHV1dABWdmoABMB9AADUiQAFr3MAmYA8AKmOTQCojEkAa2xnAD99ZABscmwAAMqDADprVAChgTwAqY1MAKSFPwAohGIAANGHABWmcgBqc28APm1WAGVOSwCihT8AG5FnAA+tdQBqT0wAY0dEAKGBPQCojEoAamxpACWSawAA04gAZ0hEAGFDPwBtbW0AcnFwACiMZwA/bVYAZUM/AGA/OwCoiUMApYM8AG9nWgBzaVsAcGRWAC2HWQBEcE4AbVZHAGtRQgBqTj4AaUs7AGZKOgCoikUAqY9QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgEBAQEBAQEBAQEBAQEBAgEDAwMDAwMDAwMDAwMDAwEBAwMDAwMDAwMDAwMDAwMBAQMDBAUGBgcHBgZSBAMDAQFFRkdISUpLTE1OT1AUUQEBJBc/QEE8KEI2PUNEKisBATkXOjs8ICAoMTY9PiojAQErMzQgIDUfICgxNjc4BQEBKywtLi8wHh8gKDEyKgUBASQXJSYnHB0eHyAoKSorAQEWFxgZGhscHR4fICEiIwEBCQoLDAwNDg8QERITFBUBAQMDBAUGBgcHBgYIBAMDAQEDAwMDAwMDAwMDAwMDAwEBAwMDAwMDAwMDAwMDAwMBAAEBAQEBAQEBAQEBAQEBAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
$CheckBox_NVCleanstall_IconBytes = [Convert]::FromBase64String($CheckBox_NVCleanstall_Icon64)
$CheckBox_NVCleanstall_IconStream = [System.IO.MemoryStream]::new($CheckBox_NVCleanstall_IconBytes, 0, $CheckBox_NVCleanstall_IconBytes.Length)
$CheckBox_NVCleanstall.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_NVCleanstall_IconStream).GetHIcon()))
$CheckBox_NVCleanstall.ImageAlign = 'MiddleLeft'
$CheckBox_NVCleanstall.Text = '    NVCleanstall'
$CheckBox_NVCleanstall.TextAlign = 'MiddleLeft'
$CheckBox_NVCleanstall.CheckAlign = 'MiddleLeft'
$CheckBox_NVCleanstall.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_NVCleanstall)

# If ((Get-WmiObject Win32_VideoController).Name -like '*NVIDIA*') {
#     $CheckBox_NVCleanstall.Text += ' (Compatible GPU)'
# }

If ((Get-WmiObject Win32_VideoController).Name -notlike '*NVIDIA*') {
    $CheckBox_NVCleanstall.Text += ' (Incompatible GPU)'
    $CheckBox_NVCleanstall.Enabled = $false
}

if ($InstalledSoftware -match 'NVCleanstall') {
    $CheckBox_NVCleanstall.Enabled = $false
    $CheckBox_NVCleanstall.Text += ' (Installed)'
}

$CheckBox_nvidiaProfileInspector = New-Object System.Windows.Forms.CheckBox
$CheckBox_nvidiaProfileInspector.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_nvidiaProfileInspector.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_nvidiaProfileInspector_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAEgAAACAAAAAeAAAADwAAAAYAAAAIAAAACAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAKAAAAJgAAAE8AAABlAAAATgAAACsAAAAoAAAAMAAAAB8AAAAHAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAPAAAANwZcR6EJkG/mCIts4ARJOHcBDAlNAzcqgwRCM4QAAAAnAAAABgAAAAAAAAAAAAAAAAAAAAIAAAATAiYdTQmWdNkLvZL/C7SL+QVUQX4BGBJXCZJx3QmTcvEDMCVfAAAAEwAAAAEAAAAAAAAAAAAAAAQAAAAZBD0vYwqvh+4MyZv/DL+T+AVZRXoDLyRVCq6H5wu0i/0EPzGRAAAAKAAAAAQAAAAAAAAAAAAAAAIAAAAYBVA+dAu8kvQN1aX/DMud/QRLOpIDKiBCCreN3AzMnv8GalLPAAAAhQAAAEcAAAAZAAAABQAAAAAAAAAECH9ibQzEmPoN4K3/DeKv/wZnUNMAAACICZBvsQvDl/8Mz6D/Cq2G4gIpIKYAAACFAAAAUgAAABoAAAACCIdoMgqshfkMzp//Duay/w7nsv8LuY/wAiYduQAEA5IHfmKtDMWY9QzJm/8LuY/7BmBKswAAAHAAAAA4AAAADAAAAAAJmXYlC7iOugzSov8N3qz/Dd2r/wzQoP0IgmTaARIOqgEYE5EIjW62C7iO8QqrhP0EPzBxAAAANwAAABEAAAAAAAAAAAAAAAAKqYJRC8GV3gzQof8N1qX/DNSk/wvGmfgHe1/UARgSqwAIBo8GZE2iB39iuQAIBjMAAAAPAAAAAAAAAAAAAAAAAAAAAAAAAAYKq4RmC72S0wzLnf8M0KH/DNGh/wzKnPsIjGzZAikgrwAAAI4AAABgAAAAJQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKp4FBC7eNsgzGmf8My53/DMqc/wvBlf8Hf2LRAAAAfQAAAEkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKn3scCqyGfAu3jcsLu5D/Cq+H/wd1WqEAAAA+AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZl3HAmUclkJi2yXBmFKPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/h8AAPgDAADwAwAA4AMAAMAHAACAAwAAgAEAAAAAAACAAAAA4AAAAPgAAAD+AAAA/4AAAP/wAAD//wAA//8AAA=='
$CheckBox_nvidiaProfileInspector_IconBytes = [Convert]::FromBase64String($CheckBox_nvidiaProfileInspector_Icon64)
$CheckBox_nvidiaProfileInspector_IconStream = [System.IO.MemoryStream]::new($CheckBox_nvidiaProfileInspector_IconBytes, 0, $CheckBox_nvidiaProfileInspector_IconBytes.Length)
$CheckBox_nvidiaProfileInspector.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_nvidiaProfileInspector_IconStream).GetHIcon()))
$CheckBox_nvidiaProfileInspector.ImageAlign = 'MiddleLeft'
$CheckBox_nvidiaProfileInspector.Text = '    nvidiaProfileInspector'
$CheckBox_nvidiaProfileInspector.TextAlign = 'MiddleLeft'
$CheckBox_nvidiaProfileInspector.CheckAlign = 'MiddleLeft'
$CheckBox_nvidiaProfileInspector.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_nvidiaProfileInspector)

$CheckBox_MicrosoftOffice = New-Object System.Windows.Forms.CheckBox
$CheckBox_MicrosoftOffice.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_MicrosoftOffice.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_MicrosoftOffice_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
$CheckBox_MicrosoftOffice_IconBytes = [Convert]::FromBase64String($CheckBox_MicrosoftOffice_Icon64)
$CheckBox_MicrosoftOffice_IconStream = [System.IO.MemoryStream]::new($CheckBox_MicrosoftOffice_IconBytes, 0, $CheckBox_MicrosoftOffice_IconBytes.Length)
$CheckBox_MicrosoftOffice.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_MicrosoftOffice_IconStream).GetHIcon()))
$CheckBox_MicrosoftOffice.ImageAlign = 'MiddleLeft'
$CheckBox_MicrosoftOffice.Text = '    Microsoft Office'
$CheckBox_MicrosoftOffice.TextAlign = 'MiddleLeft'
$CheckBox_MicrosoftOffice.CheckAlign = 'MiddleLeft'
$CheckBox_MicrosoftOffice.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_MicrosoftOffice)

# if ($InstalledSoftware -match 'Microsoft Office' -or $InstalledSoftware -match 'Microsoft 365') {
#     $CheckBox_MicrosoftOffice.Enabled = $false
#     $CheckBox_MicrosoftOffice.Text += ' (Installed)'
# }

$CheckBox_Plex = New-Object System.Windows.Forms.CheckBox
$CheckBox_Plex.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Plex.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Plex_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//AQ6C9BETjtMzEobMSg6R1EkMmeYyEKjwEQD//wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADHvXERpps2ccSnTDHjlI6x8vOPYhMTr2HT1P6hhdg8EOksxkAMD4EAAAAAAAAAAAAAAAAAAAAAAAAAAAGYbfHhlfkaceKjT3IhQK/iMTCf4iFgz+JRoT/iUaFP4mGhb+ITY+9hGBrKMGy/8bAAAAAAAAAAAAAAAAIo/YERhdj6cfICL8IRkT/h8vPP4bXZH+G1qM/iEzQ/4kHBf+JSIg/iYbGP4kKCn7EIixoQDP/w8AAAAAAAD/ARl2smYdKjX2HxkU/iAeHP4fISP+GW+0/haO6v4XdLf+JCEh/iUgHf4kIyL+JxwY/iE4QfUHodhgAP//ASOPyhEcVXPCIBgS/h8eHP4gIB/+IBoU/h8wQP4Sitn+DaDx/hhefv4nGRT+JCIh/iYjIv4nGhb+FW6OvQDT/w4Ze84xHTRI6h8ZFP4fHx/+ICAg/iAeHf4jGBP+GFyD/gmt+f4Hre7+HzlC/iYbF/4lJCT+JxsX/h5JWecCw/8sGHrBRx8qNfYfGxf+Hx8f/iAgIP4gICD+IhwY/iIcGv4NlM3+AMb//gqbyf4mHx7+JSQk/iYeG/4hPEP0A7btQhh0wEcfLTb1HxsX/h8fH/4gICD+ICAg/iIbGP4iHx7+DZfT/gDG//4MlcH+JSAd/iUkJP4mHhv+ITxF8wOy7EEces8vHDdK6R8ZE/4fHx7+ICAg/iAeHP4jGBP+GGCL/gmt+v4Hqer+ITQ6/iYbGP4lJCT+JxoW/h5MXOYCwPwrEI7XDx5Xdr4gFxP+Hx0c/iAgH/4gGRT+HzRG/hKL3P4Nn+7+GVh1/icZFP4kIiH+JiMi/icbF/4UeZq5ANz/DQAA/wEYd65gHiw49R8ZFP4gHhz+HyQm/hlzu/4Wjev+F3Gw/iQfHv4lIB7+JCIi/igcGP4gPEXzCKzjWgAAAAAAAAAAEZnfDhlfmJ4fIib7IRgS/h8tOf4dVYP+HVJ9/iIwO/4kHRj+JSEg/iYbGP4jLDD6C4u0mQDe/wwAAAAAAAAAAAAAAAATjNwZGWGXnR8tOfQhFQ3+IxMI/iIVC/4lGhP+JRkT/iYbFv4gOkPzDoaymQnL/xcAAAAAAAAAAAAAAAAAAAAAAAAAABKm/w0ZfsZcHF2MuR08UOUeMD3zIDVB8hxCVOUVapS4C5/aWQDC/wwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARSk/w0QkeIqE4zVPw6Q2T8Ioe4pFr//DAAAAAAAAAAAAAAAAAAAAAAAAAAA8A8AAOAHAADAAwAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAgAEAAMADAADgBwAA8B8AAA=='
$CheckBox_Plex_IconBytes = [Convert]::FromBase64String($CheckBox_Plex_Icon64)
$CheckBox_Plex_IconStream = [System.IO.MemoryStream]::new($CheckBox_Plex_IconBytes, 0, $CheckBox_Plex_IconBytes.Length)
$CheckBox_Plex.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Plex_IconStream).GetHIcon()))
$CheckBox_Plex.ImageAlign = 'MiddleLeft'
$CheckBox_Plex.Text = '    Plex'
$CheckBox_Plex.TextAlign = 'MiddleLeft'
$CheckBox_Plex.CheckAlign = 'MiddleLeft'
$CheckBox_Plex.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Plex)

$PlexMediaServer = 'PlexMediaServer Updater'
$PlexMediaServer_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $PlexMediaServer }
if (($PlexMediaServer_Exists)) {
    $CheckBox_Plex.Enabled = $false
    $CheckBox_Plex.Text += ' (Installed)'
}

$CheckBox_PuTTY = New-Object System.Windows.Forms.CheckBox
$CheckBox_PuTTY.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_PuTTY.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# # Official ICO from EXE
$CheckBox_PuTTY_Icon64 = 'AAABAAEAEBAQAAAAAAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICAgAAAAP8AAP8AAAD//wD/AAAA/wD/AP//AAD///8AAAAAAAAAAAAHiIiIgAAAAA///4iIAAAAAIiIiIgAAAAAeId3gAAAAAD0tMeAAAAAAPxLSIAAAAAA/ES7AIiIAAD4u7uwiIiAAAAAu7uwiIAAAAALuId4AAAAAAhLTHgAAAAAD8S0eAAAAAAPzER4AAAAAA///3gAAAAAAAAAAACAfwAAAD8AAAAfAACAHwAAgD8AAIA/AACAAwAAgAEAAIAAAADAAAAA/AEAAPwBAAD8AQAA/AEAAPwBAAD+AwAA'
$CheckBox_PuTTY_IconBytes = [Convert]::FromBase64String($CheckBox_PuTTY_Icon64)
$CheckBox_PuTTY_IconStream = [System.IO.MemoryStream]::new($CheckBox_PuTTY_IconBytes, 0, $CheckBox_PuTTY_IconBytes.Length)
$CheckBox_PuTTY.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_PuTTY_IconStream).GetHIcon()))
$CheckBox_PuTTY.ImageAlign = 'MiddleLeft'
$CheckBox_PuTTY.Text = '    PuTTY'
$CheckBox_PuTTY.TextAlign = 'MiddleLeft'
$CheckBox_PuTTY.CheckAlign = 'MiddleLeft'
$CheckBox_PuTTY.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_PuTTY)

if ($InstalledSoftware -match 'PuTTY') {
    $CheckBox_PuTTY.Enabled = $false
    $CheckBox_PuTTY.Text += ' (Installed)'
}

$CheckBox_Python = New-Object System.Windows.Forms.CheckBox
$CheckBox_Python.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Python.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Python_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABO2/9QRNf/gDvU/4A71P8QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABm4/9gXOD//1Lc//9I2f//PtX/wDvU/xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAc+j/wGrl//9g4f/wVt3/wEza/8BC1v8wAAAAAAAAAAAAAAAAZWVl/2VlZf9lZWX/ZWVl/2VlZf+ke0h0q3o9/3ff79Bz6P//bub//2Tj//9a3///UNv//0bY/9A81P8QAAAAAGVlZf9CQkL/QkJC/0JCQv9CQkLAt4VG/7B/Qf+TqI/ic+j//3Po//9x5///aOT//17g//9U3f//Stn/gAAAAABlZWX/QkJC/0JCQv9CQkL/QkJCwL2KSv+2hEX/sH5A/56PZeaUlnTQjZuA1HPn/fNs5f//YuL//1je/4AAAAAAZWVl/0JCQv9CQkL/QkJC/0JCQuDBj07xvIlJ/7WDRP+vfUD/qHc7/6FxN/+ThFrzc+f98m/n//9m4/9wAAAAAGVlZf9CQkL/M5kz/zOZM/8zmTP/U1JD87SGTMS7iEjwtIJE/658P/+ndzv/oHE2/3nT3axy3PGeAAAAAAAAAABlZWX/QkJC/0JCQv9CQkL/QkJC/0JCQv9CQkL/voxMxLqHSPCzgkP/rXw+/6Z2Ov9lUz2sZWVl/wAAAAAAAAAAZWVl/0JCQv8zmTP/M5kz/zOZM/8zmTP/M5kz/3RqRnq/jEzwuYZH/7KBQv+YcD/EQkJC/2VlZf8AAAAAAAAAAGVlZf9CQkL/QkJC/0JCQv9CQkL/QkJC/0JCQv9CQkL/V09EyGhZRdBmV0PQQkJC/0JCQv9lZWX/AAAAAAAAAABlZWX/QkJC/zOZM/8zmTP/M5kz/0JCQv9CQkL/QkJC/0JCQv9CQkL/QkJC/0JCQv9CQkL/ZWVl/wAAAAAAAAAAZWVl/0JCQv9CQkL/QkJC/0JCQv9CQkL/QkJC/0JCQv9CQkL/QkJC/0JCQv9CQkL/QkJC/2VlZf8AAAAAAAAAAMx6AP/MegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/AAAAAAAAAADMegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/zHoA/8x6AP/MegD/zHoA/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/4cAAP8DAAD/AwAAgAAAAIAAAACAAAAAgAAAAIABAACAAQAAgAEAAIABAACAAQAAgAEAAIABAACAAQAA//8AAA=='
$CheckBox_Python_IconBytes = [Convert]::FromBase64String($CheckBox_Python_Icon64)
$CheckBox_Python_IconStream = [System.IO.MemoryStream]::new($CheckBox_Python_IconBytes, 0, $CheckBox_Python_IconBytes.Length)
$CheckBox_Python.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Python_IconStream).GetHIcon()))
$CheckBox_Python.ImageAlign = 'MiddleLeft'
$CheckBox_Python.Text = '    Python'
$CheckBox_Python.TextAlign = 'MiddleLeft'
$CheckBox_Python.CheckAlign = 'MiddleLeft'
$CheckBox_Python.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Python)

$Python = 'Python Updater'
$Python_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $Python }
if (($Python_Exists)) {
    $CheckBox_Python.Enabled = $false
    $CheckBox_Python.Text += ' (Installed)'
}

$CheckBox_qBittorrent = New-Object System.Windows.Forms.CheckBox
$CheckBox_qBittorrent.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_qBittorrent.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_qBittorrent_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/vHZN+zKqIfowqO14rKLy+Kyi8vowqO17Mqoh/7x2TcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD+8OIS8NGxet6qgdnMhU//xHc+/8BwNv+/bzX/wXM7/8h/S//apHzZ7Mytev7w4hIAAAAAAAAAAAAAAAD+8OIS7cmnuteYZf/Je0D/x3k+/8V2PP/DdDr/wXE3/8BwNv+/bjX/v241/86MXP/pxKO6/vDiEgAAAAAAAAAA8tOzetuea//Ogkb/zYBE/8t9Qv/dpHP/3KJy/8V2PP/Dczn/wXE3/8BvNv+/bjX/zoxc/+7MrXoAAAAA/vHZN+e3idnTiUz/0YdK/9CESP/Ogkb/4qx9/96ldP/IekD/xng9/8R1O//Cczn/wXE3/8BvNv/apHzZ/vHZN/XTs4fenGP/145Q/92cZP/uxZr/672R/+q8kP/gp3b/1pdm/9ulff/nxav/7dTC/9OYbP/Ccjj/yYFN/+zKqIfy0K613pdZ/92XW//94sD/2pJX/9iQVf/00Kn/4qt5/96qgf/57+j/zH5D/82ETf/x3c//zYhV/8Z5QP/rxaO18cafy+CZWv/osHr/8MOW/9qSVP/Yj1H/6LSD/+Ste//grYP/58Kk/8+DR//NgET/5b6g/9qkfP/HeT7/5LeQy/LKoczknl7/6a53//HFmP/ellj/3JRW/+y9jv/nsH7/47CG/+zMsf/Sh0v/0IVJ/+bAov/gsIr/y31C/+S3kMv21rG16KVn/+ekZv/62rT/459h/9+YWf/52LL/6bOA/+a0if/149P/2ZNa/9SJTf/58Oj/1pNf/9CGTP/uyae1+du5h+2xdf/ppGT/7bN7//fRp//20Kb/7LeE/+esdf/otoz/8da//+7Os//y3Mj/4q+G/9OJTP/XlF3/8c+vh/7x2Tf0xpvZ7Klo/+qmZv/ppGT/56Fh/+WfX//jnF3/6rqO/+/LrP/dlVf/25JU/9mQUv/XjVD/57aJ2f7x2TcAAAAA+t2+evO8hf/tq2n/66hn/+qmZf/oo2P/5qFh/+y8kf/vx6T/4Jla/96XWP/clFb/46hz//LVs3oAAAAAAAAAAP7w4hL52La69L6G/++ta//tqmn/66hn/+mlZf/oo2P/5qBg/+SeXv/im1z/5614//LQrrr+8OISAAAAAAAAAAAAAAAA/vDiEvrfvHr1zJ3Z8rh7//Cvb//tqmn/66dn/+qoaf/rrHL/7r+V2fbZunr+8OISAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/vHZN/vbuYf52rS199Cny/fQp8v517S1+du5h/7x2TcAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAwAA8A8AAA=='
$CheckBox_qBittorrent_IconBytes = [Convert]::FromBase64String($CheckBox_qBittorrent_Icon64)
$CheckBox_qBittorrent_IconStream = [System.IO.MemoryStream]::new($CheckBox_qBittorrent_IconBytes, 0, $CheckBox_qBittorrent_IconBytes.Length)
$CheckBox_qBittorrent.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_qBittorrent_IconStream).GetHIcon()))
$CheckBox_qBittorrent.ImageAlign = 'MiddleLeft'
$CheckBox_qBittorrent.Text = '    qBittorrent'
$CheckBox_qBittorrent.TextAlign = 'MiddleLeft'
$CheckBox_qBittorrent.CheckAlign = 'MiddleLeft'
$CheckBox_qBittorrent.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_qBittorrent)

$qBittorrent = 'qBittorrent Updater'
$qBittorrent_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $qBittorrent }
if (($qBittorrent_Exists)) {
    $CheckBox_qBittorrent.Enabled = $false
    $CheckBox_qBittorrent.Text += ' (Installed)'
}

$CheckBox_RazerSynapse = New-Object System.Windows.Forms.CheckBox
$CheckBox_RazerSynapse.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_RazerSynapse.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_RazerSynapse_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB0YQAQdGEAIZjSkGKcpAQSrPQZIrz0HGKs9B2irOQdopzUDHKcxAkyjEPUMVfiQKB0YQBAdGEAMHRhACAAAAAAdGEAImwj0YKs9BlSvQQu4qz0H/Ks1A/ynMQP8pzED/KcxA/ynNQP8qzUHuKc1BlyOzNxsHRhAEB0YQAwdGEAInxD0bK9BBsSrRQv8qzkH/Kcs//yjJP/8oxz7/KMc+/yRbLP8noTj/Kcs//yrNQP8pzkCyJbo5HQdGEAMcly0HKs9BlCrRQv8qzUD/Kco//yjHPv8nxDz/JsE7/ybBO/8jXCv/JHsw/yjHPv8pyz//Ks5B/yrOQZQZjSkIKcpAQSvQQvAqzkH/Kco//yfGPf8mwTv/JHww/yR5L/8kei//I00p/yRpLf8nwzz/KMg+/ynMQP8qz0HwKMg+QirPQZIqz0H/Kcs//yjHPv8mwTv/JYky/yRlLP8jSSf/I28t/yRjK/8lijL/JsA7/yfFPf8pyj//Ks9B/yrPQZIrz0HGKs5B/yjJP/8nxD3/Jr86/ySoNf8jXyr/Ikon/yJrLP8jlzP/JLg3/yW9Ov8nwzz/KMk+/yrNQP8rz0HGKtBC2SnMQP8oyD7/J6U3/yR0Lv8kmTP/Imgr/yFEJv8hYSr/Ik0o/yNGJ/8kZSz/JsE7/yjHPv8pzED/KtBC2SrOQdopzED/KKI4/yNZK/8jVCr/I2ks/yKFL/8hVyj/IWAq/yJVKP8jQSb/I1Yq/ybBO/8oxz7/KcxA/yrPQdoqzkDGKcxA/yRRKv8kdDD/JZo0/yNVKf8jRif/Ik0o/yJYKf8ijDD/I1Ip/yR4L/8mwTv/KMg+/ynMQP8qzkDGKc1BkyrNQP8oyT//J8U9/ybBO/8keC//JGIs/yNQKP8jqjT/JHAt/yNfK/8lnTT/J8Q8/yjJPv8pzUD/Kc1BkyjEPUMqzkHwKcxA/yjJPv8nxT3/Jrs7/yR4L/8lmzT/Jbw5/yRtLf8jQif/I2Is/yfDPf8pyj//Ks1B8CjEPUMVfiQKKs5BlCrOQf8pzED/KMk//yjGPf8nxDz/JsI8/ybCPP8mwjz/J7o7/yR2MP8kZS3/KcxA/ynKP5YTdCEMB0YQBCW6OR0qz0GyKs9B/yrNQP8pyz//KMk//yjIPv8oyD7/KMg+/yjIPv8pyj//KcxA/ynMQLMjsTcfB0YQBgdGEAMHRhADJLg5GirPQZUq0ELuKs9B/yrOQf8qzUD/Kc1A/ynNQP8pzUD/Ks1B7inLP5cirjUcB0YQBgdGEAQHRhABB0YQAgdGEAMZjSkGKc1BQCrPQZErz0HFK9BC2SvQQtkqz0HFKc1BkijEPUMScB8KB0YQBQdGEAQHRhADgAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_RazerSynapse_IconBytes = [Convert]::FromBase64String($CheckBox_RazerSynapse_Icon64)
$CheckBox_RazerSynapse_IconStream = [System.IO.MemoryStream]::new($CheckBox_RazerSynapse_IconBytes, 0, $CheckBox_RazerSynapse_IconBytes.Length)
$CheckBox_RazerSynapse.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_RazerSynapse_IconStream).GetHIcon()))
$CheckBox_RazerSynapse.ImageAlign = 'MiddleLeft'
$CheckBox_RazerSynapse.Text = '    Razer Synapse'
$CheckBox_RazerSynapse.TextAlign = 'MiddleLeft'
$CheckBox_RazerSynapse.CheckAlign = 'MiddleLeft'
$CheckBox_RazerSynapse.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_RazerSynapse)

if ($InstalledSoftware -match 'Razer Synapse') {
    $CheckBox_RazerSynapse.Enabled = $false
    $CheckBox_RazerSynapse.Text += ' (Installed)'
}

$CheckBox_Steam = New-Object System.Windows.Forms.CheckBox
$CheckBox_Steam.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Steam.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Steam_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAqXYANqdyAZqpcwLfqXQC+ql0AvqpcwLfp3IBmql2ADYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACjbQAOnWoEpZ5qBP+eagT/nmoE/55qBP+eagT/nmoE/55qBP+eagT/nWoEpaNtAA4AAAAAAAAAAAAAAACRWwAOlGAGya6HQ//h07r/5djC/8Wod/+UYAb/lGAG/5RgBv+UYAb/lGAG/5RgBv+UYAbJkVsADgAAAAAAAAAAiVYHpZRlHv/w6uD/1MGk/8Wrhf+8n3P/ropV/4lWCP+JVgj/iVYI/4lWCP+JVgj/iVYI/4lWB6UAAAAAgU4NN6SBUf/i18f////////////9/Pv/spRr/8WukP9/TQr/f00K/39NCv9/TQr/f00K/39NCv9/TQr/f0sJNuXcz+P8+/n////////////s5d7/39TH/6+Sc//49fP/wauS/3hIEv91RA3/dUQN/3VEDf91RA3/dUQN/3VCDZr////////////////+/f3/7efi/7mijf/r5d/////////////f1Mv/f1Uv/2w8EP9sPBD/bDwQ/2w8EP9rOxDf/////+zm4v+rkoD/bkMl/4hlS//Sxbv///////////////////////z7+v/k3Nb/nYBs/2I0E/9iNBP/YDQT+o5yY/xbLhn/WSwW/1ksFv9ZLBb/Zz0p//Lu7f///////////8S1rf+HZlb/s5+V//r4+P+ZfXD/WSwW/1cqFvpQIxnfUCQZ/1AkGf9QJBn/UCQZ/1AkGf+KbWb//////8Gyrv+Ocmv/w7Sw/8i7t/+SdnD/6OLg/1AkGf9QIxnfRx8XmkgfGf9IHxn/SB8Z/0gfGf9IHxn/SB8Z/9vT0v+OdXH/wbOx///////r5ub/ZkQ///////9IHxn/Rx8XmkIcFzZCHhj/Qh4Y/0IeGP9CHhj/Qh4Y/0IeGP+7raz/s6ek/7aqqP/b1NP/yr++/3ZcV//q5ub/Qh4Y/0IcFzYAAAAAPB0VpTwdFv88HRb/PB0W/zwdFv88HRb/Ujcw//Xz8/+djor/WT85/3BZVP/08/L/kX97/zwdFaUAAAAAAAAAADYkEg42GhTJNhwU/zYcFP82HBT/NhwU/zYcFP9hTEb/1M/N///////u6+v/kYN//zYdFck2JBIOAAAAAAAAAAAAAAAANhISDi4aEqUwGxP/MBsT/zAbE/8wGxP/MBsT/zAbE/8wGxP/MBsT/y4aEqU2EhIOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALxwSNi4aEposGxLfLBkS+iwZEvosGxLfLhoSmi8cEjYAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAEAAIABAADAAwAA8A8AAA=='
$CheckBox_Steam_IconBytes = [Convert]::FromBase64String($CheckBox_Steam_Icon64)
$CheckBox_Steam_IconStream = [System.IO.MemoryStream]::new($CheckBox_Steam_IconBytes, 0, $CheckBox_Steam_IconBytes.Length)
$CheckBox_Steam.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Steam_IconStream).GetHIcon()))
$CheckBox_Steam.ImageAlign = 'MiddleLeft'
$CheckBox_Steam.Text = '    Steam'
$CheckBox_Steam.TextAlign = 'MiddleLeft'
$CheckBox_Steam.CheckAlign = 'MiddleLeft'
$CheckBox_Steam.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Steam)

if ($InstalledSoftware -match 'Steam') {
    $CheckBox_Steam.Enabled = $false
    $CheckBox_Steam.Text += ' (Installed)'
}

$CheckBox_SubtitleEdit = New-Object System.Windows.Forms.CheckBox
$CheckBox_SubtitleEdit.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_SubtitleEdit.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_SubtitleEdit_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiIs4DIiLOfSIiztgiIs7kIiLO5CIizuQiIs7kIiLO5CIizuQiIs7kIiLO5CIizuQiIs7kIiLO2CIizn4iIs4DIiLOfiIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLOfyIiztoiIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIiztsiIs7mIyPO/5KS5f+zs+3/s7Pt/7Oz7f+jo+n/S0vX/11d2v+zs+3/s7Pt/7Oz7f+zs+3/j4/l/yMjzv8iIs7nIiLO5iIizv84ONP/29v1//39/f/9/f3//f39//b2+/9QUNj/19f0//39/f/9/f3/2dn1/zY20v8iIs7/IiLO5yIizuYiIs7/IiLO/ykpz/8zM9H/MzPR/2tr3f/9/f3/q6vr/yws0P8zM9H/MzPR/ykpz/8iIs7/IiLO/yIizuciIs7mIiLO/yIizv8iIs7/IiLO/yIizv9ERNX//f39/7S07f8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7nIiLO5iIizv8rK9D/m5vo/9fX9P/c3PX/8/P7//39/f9nZ93/r6/s/9zc9f/c3PX/Z2fc/yIizv8iIs7/IiLO5yIizuYiIs7/sbHs//39/f/v7/r/5ub3/9XV9P91dd//X1/a/+bm9//m5vf/5ub3/2pq3f8iIs7/IiLO/yIizuciIs7mKirQ//r6/P/R0fP/JibP/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7nIiLO5igoz//39/v/29v1/zY20v8oKM//KCjP/ygoz/8kJM//JibP/ygoz/8oKM//JSXP/yIizv8iIs7/IiLO5yIizuYiIs7/nZ3o//39/f/9/f3//f39//39/f/BwfD/U1PY/+3t+f/9/f3//f39/9PT9P8yMtH/IiLO/yIizuciIs7mIiLO/yQkz/99feH/ubnu/76+7/+oqOr/NTXS/66u6/++vu//vr7v/76+7/++vu//lJTm/yMjzv8iIs7nIiLO2iIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO3CIizoEiIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizv8iIs7/IiLO/yIizoIiIs4EIiLOgiIizt0iIs7pIiLO6SIizukiIs7pIiLO6SIizukiIs7pIiLO6SIizukiIs7pIiLO3SIizoMiIs4EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_SubtitleEdit_IconBytes = [Convert]::FromBase64String($CheckBox_SubtitleEdit_Icon64)
$CheckBox_SubtitleEdit_IconStream = [System.IO.MemoryStream]::new($CheckBox_SubtitleEdit_IconBytes, 0, $CheckBox_SubtitleEdit_IconBytes.Length)
$CheckBox_SubtitleEdit.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_SubtitleEdit_IconStream).GetHIcon()))
$CheckBox_SubtitleEdit.ImageAlign = 'MiddleLeft'
$CheckBox_SubtitleEdit.Text = '    Subtitle Edit'
$CheckBox_SubtitleEdit.TextAlign = 'MiddleLeft'
$CheckBox_SubtitleEdit.CheckAlign = 'MiddleLeft'
$CheckBox_SubtitleEdit.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_SubtitleEdit)

if ($InstalledSoftware -match 'Subtitle Edit') {
    $CheckBox_SubtitleEdit.Enabled = $false
    $CheckBox_SubtitleEdit.Text += ' (Installed)'
}

$CheckBox_Telegram = New-Object System.Windows.Forms.CheckBox
$CheckBox_Telegram.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Telegram.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Telegram_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUDQAAr3cIAJ5rBwasdQcgr3cIN693CDesdgcgnmsHBq93CAAUDQAAAAAAAAAAAAAAAAAAAAAAAAAAAACveAoAqXQKBbd9CkS5fwqjun8J2bp/Cey6fwnsun8J2bl/CqO3fQpEqXQKBa94CgAAAAAAAAAAAAAAAAC5gA0AtX0NDLyCDYO9ggzwvYIM/72CDP+9ggz/vYIM/72CDP+9ggz/vYIM8LyCDYO1fQ0MuYANAAAAAAC1fhAAr3oQBMCFEIPBhQ/7wYUP/8GFD//BhQ//wYUP/8CFDv/AhA3/wIUO/8GFD//BhQ/7wIUQg696EAS1fhAAxooTAMGHEkXEiRLvxIgS/8SIEv/EiRL/xIgS/8OHD//Ikib/3r6A/9OnUP/DhxD/xIgS/8SJEu/BhxJFxooTALF9FQTGixWix4wV/8eMFf/HixT/xooT/8eMFv/UqFD/8eLF///////nz57/x4sU/8eMFf/HjBX/xosVorF9FQTCiRcfyY4Y2MqPGP/Kjxr/zpgr/9GeOf/PmS7/8eLE////////////8eDA/8ySH//Kjhf/yo8Y/8mOGNjCiRcfyI4aNc2RG+vNkRn/16dH//Ljxv/79uz/69Sm/+C8dP/37dn///////fu2//SnDD/zZEZ/82SG//NkRvryI4aNcuRHTXQlR7r0JUd/9KZJv/csFf/7dWl//r06P/27Nf/69Gg//rz5f/8+PD/2ahG/9CUG//QlR7/0JUe68uRHTXNkx8e05gh2NOYIf/TmCD/05Ye/9SYIf/aqEP/6cqN//Xmyf/79uv//v36/+C1YP/Tlh3/05gh/9OYIdjNkx8exY4fBNaaI6LXmyT/15sk/9ebJP/WmyP/1poh/9aaIf/aozb/5b1u//Darf/gs1j/1poh/9ebJP/WmiOixY4fBNufJgDYnSZE2p4m7tqeJv/anib/2p4m/9qeJv/anib/2Z0l/9mcI//anif/2p4o/9qeJv/anibu2J0mRNufJwDWnScA0psmBNyhKYHdoSn63aEp/92hKf/doSn/3aEp/92hKf/doSn/3aEp/92hKf/doSn63KEpgdKbJgTWnSgAAAAAANyjKwDaoisL36QsgeCkLO/gpCz/4KQs/+CkLP/gpCz/4KQs/+CkLP/gpCzv36QsgdqiKwvcoysAAAAAAAAAAAAAAAAA3aUuANukLQXgpi5D4qcvouKnL9jjpy/r46cv6+KnL9jipy+i4KYuQ9ukLQXdpS4AAAAAAAAAAAAAAAAAAAAAAAAAAABNTS0A4KcwANqkMAXgpjAe4acwNOGnMDTgpjAe2qQwBeCnMABNSi4AAAAAAAAAAAAAAAAA+B8AAOAHAADAAwAAgAEAAIABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAQAAgAEAAMADAADgBwAA+B8AAA=='
$CheckBox_Telegram_IconBytes = [Convert]::FromBase64String($CheckBox_Telegram_Icon64)
$CheckBox_Telegram_IconStream = [System.IO.MemoryStream]::new($CheckBox_Telegram_IconBytes, 0, $CheckBox_Telegram_IconBytes.Length)
$CheckBox_Telegram.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Telegram_IconStream).GetHIcon()))
$CheckBox_Telegram.ImageAlign = 'MiddleLeft'
$CheckBox_Telegram.Text = '    Telegram'
$CheckBox_Telegram.TextAlign = 'MiddleLeft'
$CheckBox_Telegram.CheckAlign = 'MiddleLeft'
$CheckBox_Telegram.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Telegram)

if ($InstalledSoftware -match 'Telegram') {
    $CheckBox_Telegram.Enabled = $false
    $CheckBox_Telegram.Text += ' (Installed)'
}

$CheckBox_TranslucentTB = New-Object System.Windows.Forms.CheckBox
$CheckBox_TranslucentTB.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_TranslucentTB.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_TranslucentTB_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1KMNkNSiCv/UoQb/1KEEkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASGfbcLOTieuptGX/dcCF/2fDiutDx5LMQceRzEDHkcQ/x5CFPseQIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEtq3peukpT/l7p1/0jHlP9Gx5T/RceT/0THkv9Cx5L/QceR/0DHkfU/x5A9AAAAAAAAAAAAAAAAAAAAAAAAAABObuCXrpSW/5e7dv9Kx5X/SceV/0fHlD1Fx5M9RMeTcEPHkuZCx5L/QceRzQAAAAAAAAAAAAAAAAAAAAAAAAAAUnHjl6+VmP+Yu3f/TceW/0vHlv8AAAAAAAAAAAAAAABFx5OXRMeT/0PHkv8AAAAAAAAAAAAAAAAAAAAAAAAAAFV05Zevl5v/mbx5/0/Hl/9Ox5f/HVQ+AAAAAABKx5UUSMeUzEfHlP9Fx5PWAAAAAAAAAAAAAAAAAAAAAAAAAABZd+iXsJmd/5m8e/9Rx5j/UMeY/0/Hl/tNx5f8TMeW/0rHlf9Jx5X1R8eUPgAAAAAAAAAAAAAAAAAAAAAAAAAAXHvrl7GboP+avXz/VMeZ/1LHmf9Rx5jNT8eXzE7Hl/lNx5b4TMeWZAAAAAAAAAAAAAAAAAAAAABkg/F7Y4Hvl2B+7dWxnaP/m71+/1bHmv9Vx5r/AAAAAAAAAABPx5gjT8eX/07Hl/9Ox5c+AAAAAAAAAAAAAAAAZ4Xz7WWD8f9jgvD/sp+m/5u+gP9Zx5v/V8eb/wAAAAAAAAAAVMeZElLHmP9Qx5j/T8eXiwAAAAAAAAAAAAAAAGmH9ClnhfMzZYTyM8utca2cvoL/W8ec/1rHnP9Zx5uhV8ebpFbHmulUx5n/U8eZ/1LHmF8AAAAA1LhkEdS3YZjUtl6Y1LZamNS1V5jUtFLgnb+E/17Hnv9cx53/W8ec/1nHnP9Yx5v/V8eb/1XHmrJTxpkGAAAAANS5aCzUuGb/1Lhj/9S3X//Utlv/1LVY/8C5bP+kvn//pL1+/6O9fP+su3X/sbpx/8izVP/Urj0rAAAAAAAAAADUum4j1Lps/9S5af/UuGX/1Ldi/9S2Xv/Utlr/1LVX/9S0U//Us1D/1LJM/9SxSf/UsEX/1LBCIgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AAD4AQAA+AAAAPgAAAD4OAAA+DAAAPgAAAD4AQAA4DAAAOAwAADgAAAAgAAAAIABAACAAQAA//8AAA=='
$CheckBox_TranslucentTB_IconBytes = [Convert]::FromBase64String($CheckBox_TranslucentTB_Icon64)
$CheckBox_TranslucentTB_IconStream = [System.IO.MemoryStream]::new($CheckBox_TranslucentTB_IconBytes, 0, $CheckBox_TranslucentTB_IconBytes.Length)
$CheckBox_TranslucentTB.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_TranslucentTB_IconStream).GetHIcon()))
$CheckBox_TranslucentTB.ImageAlign = 'MiddleLeft'
$CheckBox_TranslucentTB.Text = '    TranslucentTB'
$CheckBox_TranslucentTB.TextAlign = 'MiddleLeft'
$CheckBox_TranslucentTB.CheckAlign = 'MiddleLeft'
$CheckBox_TranslucentTB.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_TranslucentTB)

if ($InstalledSoftware -match 'TranslucentTB') {
    $CheckBox_TranslucentTB.Enabled = $false
    $CheckBox_TranslucentTB.Text += ' (Installed)'
}

$CheckBox_Valorant = New-Object System.Windows.Forms.CheckBox
$CheckBox_Valorant.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Valorant.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Resized from Official ICO from Website
$CheckBox_Valorant_Icon64 = 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFVG/wBURv8AVEb/KFRG/1lURv9aVEb/W1RG/09URv8LVEb/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFNF/wBURv8AVEb/IVRG/8VURv//VEb//lRG//tURv+FVEb/BVRG/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABURv8AVEb/EVRG/6lURv//VEb//1RG//9URv+nVEb/EFRG/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABURv8AVEb/BlRG/4lURv/8VEb//1RG//9URv/EVEb/IVVG/wNVRv8FVUb/BVVG/wRVRv8BVUb/AAAAAABURv8AUkX/AVRG/2hURv/1VEb//1RG//9URv/bVEb/NVRG/w9URv+PVEb/tVRG/7NURv+zVEb/XVRF/wFURv8AVEb/AFRG/0ZURv/oVEb//1RG//9URv/tVEb/UlRG/wBURv8AVEb/VlRG/+9URv//VEb//1RG/+hURv9HVEb/AFBE/wFURv+fVEb//1RG//9URv/4VEb/clRG/wJURv8AVEb/AFRG/wJURv9yVEb/+FRG//9URv//VEb/n1ZE/wFRRf8CVEb/pFRG//9URv/+VEb/k1RG/wlURv8AAAAAAAAAAABURv8AVEb/CVRG/5RURv/+VEb//1RG/6RVRf8CUUX/AlRG/6RURv//VEb/s1RG/xVURv8AAAAAAAAAAAAAAAAAAAAAAFRG/wBURv8VVEb/s1RG//9URv+kVUX/AlFF/wJURv+mVEb/0lRG/yhURv8AVEX/AAAAAAAAAAAAAAAAAAAAAABVR/8AVEb/AFRG/yhURv/SVEb/plVF/wJSRf8EVEb/iFRG/0VURv8AVEX/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRG/wBURv8AVEb/RVRG/4hVRf8EU0b/AlRG/xpURv8DVEb/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVEb/AFRG/wNURv8aVEb/AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAP//AAD4HwAA8B8AAOA/AADAAwAAgAEAAIGBAAABgAAAA8AAAAfgAAAP8AAAH/gAAB/4AAD//wAA//8AAA=='
$CheckBox_Valorant_IconBytes = [Convert]::FromBase64String($CheckBox_Valorant_Icon64)
$CheckBox_Valorant_IconStream = [System.IO.MemoryStream]::new($CheckBox_Valorant_IconBytes, 0, $CheckBox_Valorant_IconBytes.Length)
$CheckBox_Valorant.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Valorant_IconStream).GetHIcon()))
$CheckBox_Valorant.ImageAlign = 'MiddleLeft'
$CheckBox_Valorant.Text = '    Valorant'
$CheckBox_Valorant.TextAlign = 'MiddleLeft'
$CheckBox_Valorant.CheckAlign = 'MiddleLeft'
$CheckBox_Valorant.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Valorant)

if ($InstalledSoftware -match 'VALORANT') {
    $CheckBox_Valorant.Enabled = $false
    $CheckBox_Valorant.Text += ' (Installed)'
}

$CheckBox_VisualStudioCode = New-Object System.Windows.Forms.CheckBox
$CheckBox_VisualStudioCode.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_VisualStudioCode.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_VisualStudioCode_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzX0DYeSSFPPsmRz74pAUnQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzn4Eks5+AP/OfgD/8J8g//CfIP/tmx374pEViAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzn8Eo86AAP/OgAD/zoAA//GhIP/xoSD/8aEg//GhIP8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADPgg4Rz4IGpM+CAP/PggD/z4IA/8+CAP/xoiH/8aIh//GiIf/xoiH/sG4HpbBtAP+vbQTTsHETIwAAAADPgg4R0IME09CDAP/QgwD/0IMA/9CDAP/QhAHx8aQh//GkIf/xpCH/8aQh/7FuAP+xbgD/sW4A/7FuAfG2dA5g0YUE1NGFAP/RhQD/0YUA/9GFAP/RhQbE3qhTF/GlIv/xpSL/8aUi//GlIv+ycxFnsnAA/7JwAP+5dAD/zoQA/9KHAP/ShwD/0ocA/9KHAP/Rhw2HAAAAAP///wfypyL/8qci//KnIv/ypyL/AAAAALN1GDW6dgH00YgA/9KJAP/SiQD/0okA/9KJAvPSiRZGAAAAAAAAAAD///8I8qgj//KoI//yqCP/8qgj/wAAAADTixs204sC9dOLAP/TiwD/04sA/8uGAP+3dQLztHcYRwAAAAAAAAAA////CfKqI//yqiP/8qoj//KqI//TjBZp1I0A/9SNAP/UjQD/1I0A/8aCAP+2dQD/tnUA/7Z1AP+1dxKKAAAAAP///wryrCT/8qwk//KsJP/yrCT/1Y8A/9WPAP/VjwD/1Y8D8tCJF2S4eAjXuHYA/7h2AP+4dgD/uHYA/7d4CsjSrXId860k//OtJP/zrST/860k/9WQEavWkQD/1ZAI19SPJCUAAAAAtn0lE7l5CNe5eAD/uXgA/7l4AP+5eAD/uXgD8/OvJf/zryX/868l//OvJf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC2fSUTunwSrLt6AP+7egD/u3oA/7t6AP/zsCX/87Al//OwJf/zsCX/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC7fROtvHsA/7x7AP+8ewD/87Im//OyJv/zsib/87Im/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL2CGqG9fQD/vX0A//SzJv/0syb/7awj/NmWIpAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAvIIib+KoHPbtrSP825gipQAAAAAAAAAA/8MAAP+AAAD/AAAA/AAAAAgAAAAAAAAAACAAAIBgAACAYAAAACAAAAAAAAAIAAAA/AAAAP8AAAD/gAAA/8MAAA=='
$CheckBox_VisualStudioCode_IconBytes = [Convert]::FromBase64String($CheckBox_VisualStudioCode_Icon64)
$CheckBox_VisualStudioCode_IconStream = [System.IO.MemoryStream]::new($CheckBox_VisualStudioCode_IconBytes, 0, $CheckBox_VisualStudioCode_IconBytes.Length)
$CheckBox_VisualStudioCode.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_VisualStudioCode_IconStream).GetHIcon()))
$CheckBox_VisualStudioCode.ImageAlign = 'MiddleLeft'
$CheckBox_VisualStudioCode.Text = '    Visual Studio Code'
$CheckBox_VisualStudioCode.TextAlign = 'MiddleLeft'
$CheckBox_VisualStudioCode.CheckAlign = 'MiddleLeft'
$CheckBox_VisualStudioCode.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_VisualStudioCode)

$VSCode = 'Visual Studio Code Updater'
$VSCode_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $VSCode }
if (($VSCode_Exists)) {
    $CheckBox_VisualStudioCode.Enabled = $false
    $CheckBox_VisualStudioCode.Text += ' (Installed)'
}

$CheckBox_Windows10IoTEnterprise2021 = New-Object System.Windows.Forms.CheckBox
$CheckBox_Windows10IoTEnterprise2021.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Windows10IoTEnterprise2021.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Windows10IoTEnterprise2021_Icon64 = 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANR4CgDUeAoF1HgKEtR4CiLUeAo71HgKWNR4CnrUeApRAAAAANR4CgDUeAoG1HgKEtR4CiDUeAo51HgKI9R4CjzUeAqP1HgKq9R4CsXUeArd1HgK69R4CvfUeAr/1HgKkNR4CknUeAqT1HgKsdR4CsvUeArh1HgK8dR4CnnUeAp+1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4CpDUeAqR1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAp91HgKfdR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAqQ1HgKkNR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgKfdR4Cn3UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgKkNR4CpDUeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cn3UeAp91HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4CpDUeAqR1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAp+1HgKftR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAqR1HgKR9R4Cn7UeAp91HgKfdR4Cn3UeAp+1HgKPtR4Cj7UeAp+1HgKfdR4Cn3UeAp91HgKfdR4Cn3UeAp+1HgKR9R4CkfUeAp+1HgKfdR4Cn3UeAp91HgKftR4Cj7UeAo+1HgKftR4Cn3UeAp91HgKfdR4Cn3UeAp91HgKftR4CkfUeAqR1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAp+1HgKftR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAqR1HgKkNR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgKfdR4Cn3UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgKkNR4CpDUeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cn3UeAp91HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4CpDUeAqR1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAp91HgKfdR4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAqQ1HgKSdR4CpPUeAqx1HgKy9R4CuHUeArx1HgKedR4Cn7UeAr/1HgK/9R4Cv/UeAr/1HgK/9R4Cv/UeAr/1HgKkAAAAADUeAoA1HgKBtR4ChLUeAog1HgKOdR4CiPUeAo81HgKj9R4CqvUeArF1HgK3dR4CuvUeAr31HgK/9R4CpAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANR4CgDUeAoF1HgKEtR4CiLUeAo71HgKWNR4CnrUeApR/4AAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAAAAA/4AAAA=='
$CheckBox_Windows10IoTEnterprise2021_IconBytes = [Convert]::FromBase64String($CheckBox_Windows10IoTEnterprise2021_Icon64)
$CheckBox_Windows10IoTEnterprise2021_IconStream = [System.IO.MemoryStream]::new($CheckBox_Windows10IoTEnterprise2021_IconBytes, 0, $CheckBox_Windows10IoTEnterprise2021_IconBytes.Length)
$CheckBox_Windows10IoTEnterprise2021.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Windows10IoTEnterprise2021_IconStream).GetHIcon()))
$CheckBox_Windows10IoTEnterprise2021.ImageAlign = 'MiddleLeft'
$CheckBox_Windows10IoTEnterprise2021.Text = '    Windows 10 IoT Enterprise LTSC 2021'
$CheckBox_Windows10IoTEnterprise2021.TextAlign = 'MiddleLeft'
$CheckBox_Windows10IoTEnterprise2021.CheckAlign = 'MiddleLeft'
$CheckBox_Windows10IoTEnterprise2021.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Windows10IoTEnterprise2021)

$CheckBox_Zoom = New-Object System.Windows.Forms.CheckBox
$CheckBox_Zoom.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Zoom.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_Zoom_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADKSgggwkcJj8RHCL/GSQnvykgI/81KCf/RTAnu0ksJz9hOCY/KSgggAAAAAAAAAAAAAAAAAAAAAAAAAAC/RgiAxUcI/8VHCP/KSAj/zUoJ/9FKCP/TTAn/1k0J/9hOCf/cTwn/4FAJ/+FSCXAAAAAAAAAAAAAAAADCRwlwxUcI/8pICP/NSgn/zUoJ/9NMCf/WTQn/2E4J/9tPCf/gUAn/4FAJ/+RSCf/oUwr/61QKfwAAAADKSgggxUcI/8pICP/NSgn/0UoI/9NMCf/YTgn/208J/+BQCf/gUAn/5FIJ/+hTCv/qVAr/7VUK//JXCv/3WAwgykoJkM1KCf/RSgj/00wJ/9ZNCf/YTgn/3E8J/+BQCf/kUgn/6FMK/+pUCv/tVQr/8lcK//JXCv/2WQr/+FkLkNJLCc/TTAn/4oRW/+2nhP/tp4T/7aeE/+yTZv/rdDj/6FMK/+1VCv/3hEf/8lcK//ZZCv/5jVf//FsL//5cDL/VTQnu2E4J//bTwf/+6+L/8aiE//KphP/xilb//NXC//RsKf/yVwr//vXw//laC//9cSr//uvi//5dDP/+YxLu208J/9xPCf/iXBn/+9/S//KphP/qVAr/7VUK//zVwv/0bCn/9lkK///////+XQz//XEq//7r4v/9ZBX//God/+BQCf/kUgn/5FIJ/+tfGv/739L/96qF//JXCv/81cL/+nk5//xbC////////mAQ//13Mv/+6+L//God//lwJv/lUgrv6FMK//GKVv/2qoX/+7eT///////7l2b/+7eT//7Msv//wqT///////7FqP/+z7j/+7eT//hyKP/2di3v61QJv+1VCv/4oXb//KyF//yshf/8rIX//XEq//5dDP/9qHv//ah7//eER//8rIX//ah7//h1LP/3eDD/9Xw2z/FWC4/yVwr/9lkK//laC//8Wwv//l0M//5gEP/9ZBX//Gca//puIv/5cCb/+HUs//d4MP/1fDT/9H44//OBPpD3WAwg+VoL//xbC//+XQz//mAQ//1kFf/8Zxr//God//lwJv/4cij/93gw//V8NP/0fjj/9IE8//KGQf/vi0wgAAAAAP1cCn/+YBD//WQV//xnGv/8ah3/+m4i//hyKP/4dSz/93gw//R+OP/0gTz/8oZB//GJRf/xikpvAAAAAAAAAAAAAAAA/WUXb/xqHf/6biL/+XAm//h1LP/3eDD/9Xw0//SBPP/zhD7/8YlF//CMSv7vj0x/AAAAAAAAAAAAAAAAAAAAAAAAAAD3cCgg+nQnj/Z3L8/1fDXu9H44//OEPv/xhkPv8ItHv++PTY/vi0wgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$CheckBox_Zoom_IconBytes = [Convert]::FromBase64String($CheckBox_Zoom_Icon64)
$CheckBox_Zoom_IconStream = [System.IO.MemoryStream]::new($CheckBox_Zoom_IconBytes, 0, $CheckBox_Zoom_IconBytes.Length)
$CheckBox_Zoom.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Zoom_IconStream).GetHIcon()))
$CheckBox_Zoom.ImageAlign = 'MiddleLeft'
$CheckBox_Zoom.Text = '    Zoom'
$CheckBox_Zoom.TextAlign = 'MiddleLeft'
$CheckBox_Zoom.CheckAlign = 'MiddleLeft'
$CheckBox_Zoom.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_Zoom)

if ($InstalledSoftware -match 'Zoom') {
    $CheckBox_Zoom.Enabled = $false
    $CheckBox_Zoom.Text += ' (Uninstalled)'
}

$CheckBox_UninstallEdge = New-Object System.Windows.Forms.CheckBox
$CheckBox_UninstallEdge.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_UninstallEdge.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
# Official ICO from EXE
$CheckBox_UninstallEdge_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1HgAnNN5BPTTeQP/zHYF/7tqCP+tYwv/o10S+ZJOD50AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADUeAA81HgA9tR5Af/SeAP/qV0K/5RQDP+QTQ3/kE4N/5JOD/+STg//kE0Q9o9MEDwAAAAAAAAAAAAAAADUeAA81HgA/tR5Af/VewL/p10K/5RQDP+STwz/lVEO/5hSDv+WUA//lE8P/5FOEP+PTBD+jUsRPAAAAAAAAAAA1HgA9tR5Af/VewL/xHAF/5VQDP+UUAz/llEM/5pTDv+YUg77llAP3JRPD8CRThDvj0wQ+41LEfYAAAAA1HgAnNV5Af/VewL/1nwD/7dpB/+WUQz/lFAM/5xUDf6aUw6cAAAAAAAAAAAAAAAAAAAAAAAAAACNSxFXAAAAANV5Ae/VewL/1n0D/9d/Bf+tYwr/llEM/5dSDP6dVQ1XAAAAAIW+NjyGvzevacE/51fDRe9NyEyvQM5UPAAAAADVewL/1n0E/9d/Bf/XgQf/u24J/5RQDP+ZUw3CAAAAAAAAAACavzPniL83/4DCO/9mw0L/UM1Q/0XRVv461FtX1X0E/9d/Bf/XgQf/2IQI/9aDCv+TUAv/mFINcwAAAAAAAAAAm78znJLBN/+Nxjz/Z8pI/2PRT/9S11n/QNdd79uMD//WgAf/2IQJ/9mGCv/aiQz/wHUO/4tLC8cAAAAAAAAAAMWxN92XxDj/jck//4XORf9v1E//VdZX/0zdX//fnB3/0X8J/9mHC//biQ3/3IwP/92PEf/OhRP/0o4fodyXGMHIrCT/pcc3/5HLQP+H00r/b9RP/2LgXf9M5Gb/6q8s/cWDEP/Vhg3/24wP/92PEf/ekhP/35YW/92XGP/JlRv/0cIq/7/EMP+qyzv/jtVK/4DcU/9o4V3/WOZl//e8MJzzvTD/15we/8mHE//QiRL/0YsV/8eOGP/NpyH/0cIq/9HCKv/BxzL/tM08/5rUR/+M21D/aetn/1rubdwAAAAA9r0x9vO+Mv/svzD/58Aw/+DBLv/XwSv/0sIq/9HCKv/LxzH/vsw4/6rUQ/+a203/fuZe/23qZf9h7208AAAAAPi+MzzzvjL+778y/+jAMf/hwS//28It/9bELv/SxC3/z8Yw/8bKNv+r1kb/qdlJ/4jmXf926mScAAAAAAAAAAAAAAAA+L40PPW/NPbwwDT/5cEx/97DMf/WxC7/0sYw/8/GMP/DzTr/utJA/6TbTP6W4lacAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8sA1nOvCNO/lwjP/18Yy/9XHNP/OzDn/wtE/9rbVRMCp20wfAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAgAEAAAB9AAAAgQAAAYAAAAGAAAABgAAAAAAAAAAAAAAAAAAAgAAAAIABAADAAwAA8AcAAA=='
$CheckBox_UninstallEdge_IconBytes = [Convert]::FromBase64String($CheckBox_UninstallEdge_Icon64)
$CheckBox_UninstallEdge_IconStream = [System.IO.MemoryStream]::new($CheckBox_UninstallEdge_IconBytes, 0, $CheckBox_UninstallEdge_IconBytes.Length)
$CheckBox_UninstallEdge.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_UninstallEdge_IconStream).GetHIcon()))
$CheckBox_UninstallEdge.ImageAlign = 'MiddleLeft'
$CheckBox_UninstallEdge.Text = '    Uninstall Edge'
$CheckBox_UninstallEdge.TextAlign = 'MiddleLeft'
$CheckBox_UninstallEdge.CheckAlign = 'MiddleLeft'
$CheckBox_UninstallEdge.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_UninstallEdge)

$EdgeUninstaller = 'Edge Uninstaller'
$EdgeUninstaller_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $EdgeUninstaller }
if (($EdgeUninstaller_Exists)) {
    $CheckBox_UninstallEdge.Enabled = $false
    $CheckBox_UninstallEdge.Text += ' (Uninstalled)'
}

$Form_SoftwareSelection_OK = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_OK.Location = New-Object System.Drawing.Size((($Form_SoftwareSelection.Width) / 3 ), (($Form_SoftwareSelection.height) - 65))
$Form_SoftwareSelection_OK.Size = New-Object System.Drawing.Size(57, 20)
$Form_SoftwareSelection_OK.Text = 'OK'
$Form_SoftwareSelection_OK.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_OK)

$Form_SoftwareSelection_Cancel = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_Cancel.Location = New-Object System.Drawing.Size((($Form_SoftwareSelection.Width) / 2 ), (($Form_SoftwareSelection.height) - 65))
$Form_SoftwareSelection_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Form_SoftwareSelection_Cancel.Text = 'Cancel'
$Form_SoftwareSelection_Cancel.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_Cancel)

$Form_SoftwareSelection_OK.Add_Click{
    # Priority: Browser required, manual input
    if ($CheckBox_NVCleanstall.Checked) {
        Write-Host 'Software Selection: NVCleanstall: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_mpv.Checked) {
        Write-Host 'Software Selection: mpv: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_RazerSynapse.Checked) {
        Write-Host 'Software Selection: Razer Synapse: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://rzr.to/synapse-3-pc-download', "$env:TEMP\Synapse.exe")
        
        Write-Host 'Software Selection: Razer Synapse: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\Synapse.exe
    }

    # Priority: Manual input
    if ($CheckBox_HyperXNGENUITY.Checked) {
        Write-Host 'Software Selection: HyperX NGENUITY: Downloading' -ForegroundColor green -BackgroundColor black
        $Hyperx = New-Object System.Net.WebClient
        $Hyperx.Headers.Add('user-agent', 'Wget')
        $Hyperx.DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://hyperx.com/pages/ngenuity' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match '.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$ENV:temp\HyperX_NGENUITY.exe")
        
        Write-Host 'Software Selection: HyperX NGENUITY: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\HyperX_NGENUITY.exe
    }

    if ($CheckBox_DotNET.Checked) {
        Write-Host 'Software Selection: .NET: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')
    }

    if ($CheckBox_7Zip.Checked) {
        Write-Host 'Software Selection: 7-Zip: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
    }

    if ($CheckBox_AnyDesk.Checked) {
        Write-Host 'Software Selection: AnyDesk: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://download.anydesk.com/AnyDesk.exe', "$env:TEMP\AnyDesk.exe")
        
        Write-Host 'Software Selection: AnyDesk: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\AnyDesk.exe -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --create-shortcuts --create-desktop-icon --silent'
        
        Write-Host 'Software Selection: AnyDesk: Optional Offer - Recommended by AnyDesk: Decline' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Force 
        }
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Google\No Chrome Offer Until' -Name 'AnyDesk Software GmbH' -Value 30241008 -PropertyType DWord -Force
    }

    if ($CheckBox_BattleNet.Checked) {
        Write-Host 'Software Selection: Battle.net: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe', "$env:TEMP\Battle.net-Setup.exe")
        
        Write-Host 'Software Selection: Battle.net: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\Battle.net-Setup.exe -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
    }

    if ($CheckBox_CrystalDiskInfo.Checked) {
        Write-Host 'Software Selection: CrystalDiskInfo: Downloading' -ForegroundColor green -BackgroundColor black
        $CrystalDiskInfo = New-Object System.Net.WebClient
        $CrystalDiskInfo.Headers.Add('user-agent', 'Wget')
        $CrystalDiskInfo.DownloadFile('https://crystalmark.info/redirect.php?product=CrystalDiskInfoInstaller', "$ENV:temp\CrystalDiskInfo.exe")
        
        Write-Host 'Software Selection: CrystalDiskInfo: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $ENV:temp\CrystalDiskInfo.exe -ArgumentList '/VERYSILENT'
    }

    if ($CheckBox_CrystalDiskMark.Checked) {
        Write-Host 'Software Selection: CrystalDiskMark: Downloading' -ForegroundColor green -BackgroundColor black
        $CrystalDiskMark = New-Object System.Net.WebClient
        $CrystalDiskMark.Headers.Add('user-agent', 'Wget')
        $CrystalDiskMark.DownloadFile('https://crystalmark.info/redirect.php?product=CrystalDiskMarkInstaller', "$ENV:temp\CrystalDiskMark.exe")
        
        Write-Host 'Software Selection: CrystalDiskMark: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $ENV:temp\CrystalDiskMark.exe -ArgumentList '/VERYSILENT'
    }
    
    if ($CheckBox_Discord.Checked) {
        Write-Host 'Software Selection: Discord: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
    }

    if ($CheckBox_BetterDiscord.Checked) {
        Write-Host 'Software Selection: BetterDiscord: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/Download.ps1')
    }

    if ($CheckBox_Chrome.Checked) {
        Write-Host 'Software Selection: Google Chrome: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Download.ps1')
    }

    if ($CheckBox_ChromeExtensions.Checked) {
        Write-Host 'Software Selection: Google Chrome - Extensions: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')
    }

    if ($CheckBox_DisplayDriverUninstaller.Checked) {
        Write-Host 'Software Selection: Display Driver Uninstaller: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Download.ps1')
    }

    if ($CheckBox_EdgeWebView2.Checked) {
        Write-Host 'Software Selection: Edge WebView2: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/p/?LinkId=2124703', "$env:TEMP\MicrosoftEdgeWebview2Setup.exe")
        
        Write-Host 'Software Selection: Edge WebView2: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $env:TEMP\MicrosoftEdgeWebview2Setup.exe
    }

    if ($CheckBox_Jellyfin.Checked) {
        Write-Host 'Software Selection: Jellyfin: Get latest release' -ForegroundColor green -BackgroundColor black
        $JellyfinLatest = (Invoke-WebRequest -UseBasicParsing -Uri 'https://repo.jellyfin.org/?path=/server/windows/latest-stable/amd64' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'x64.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        $JellyfinURL = 'https://repo.jellyfin.org' + $JellyfinLatest
        
        Write-Host 'Software Selection: Jellyfin: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile($JellyfinURL, "$env:TEMP\Jelly.exe")
        
        Write-Host 'Software Selection: Jellyfin: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\Jelly.exe -ArgumentList '/S'
    }

    if ($CheckBox_LogitechGHUB.Checked) {
        Write-Host 'Software Selection: Logitech G HUB: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe', "$env:TEMP\lghub_installer.exe")
        
        Write-Host 'Software Selection: Logitech G HUB: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\lghub_installer.exe -ArgumentList '--silent'
    }

    if ($CheckBox_EpicGames.Checked) {
        Write-Host 'Software Selection: Epic Games Launcher: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi', "$env:TEMP\EpicInstaller.msi")
                
        Write-Host 'Software Selection: Epic Games Launcher: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $env:TEMP\EpicInstaller.msi -ArgumentList '/quiet /norestart'
    }

    if ($CheckBox_eMClientLicenseFix.Checked) {
        Write-Host 'Software Selection: eM Client - License Fix: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/eM_Client/License.ps1')
    }

    if ($CheckBox_Firefox.Checked) {
        Write-Host 'Software Selection: Mozilla Firefox: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Download.ps1')
    }

    if ($CheckBox_FirefoxArkenfox.Checked) {
        Write-Host 'Software Selection: Mozilla Firefox - Arkenfox: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')
    }

    if ($CheckBox_FirefoxExtensions.Checked) {
        Write-Host 'Software Selection: Mozilla Firefox - Extensions: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')
    }

    if ($CheckBox_Git.Checked) {
        Write-Host 'Software Selection: Git: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Git/Download.ps1')
    }

    if ($CheckBox_MediaInfo.Checked) {
        Write-Host 'Software Selection: MediaInfo: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')
    }

    if ($CheckBox_MicrosoftStore.Checked) {
        Write-Host 'Software Selection: Microsoft Store: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://github.com/kkkgo/LTSC-Add-MicrosoftStore/archive/refs/heads/master.zip', "$env:TEMP\LTSC-Add-MicrosoftStore.zip")
        
        Write-Host 'Software Selection: Microsoft Store: Extracting' -ForegroundColor green -BackgroundColor black
        Expand-Archive -Path "$env:TEMP\LTSC-Add-MicrosoftStore.zip" -DestinationPath "$env:TEMP\LTSC-Add-MicrosoftStore" -Force
        
        Write-Host 'Software Selection: Microsoft Store: Setting Unattended' -ForegroundColor green -BackgroundColor black
        (Get-Content "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd").Replace('pause >nul', '') | Set-Content "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
        
        Write-Host 'Software Selection: Microsoft Store: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
    }

    if ($CheckBox_NordVPN.Checked) {
        Write-Host 'Software Selection: NordVPN: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNInstall.exe', "$env:TEMP\NordVPNInstall.exe")
        
        Write-Host 'Software Selection: NordVPN: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\NordVPNInstall.exe -ArgumentList '/verysilent'
    }

    if ($CheckBox_NotepadPlusPlus.Checked) {
        Write-Host 'Software Selection: Notepad++: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad++/Download.ps1')
    }

    if ($CheckBox_nvidiaProfileInspector.Checked) {
        Write-Host 'Software Selection: nvidiaProfileInspector: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/nvidiaProfileInspector/Download.ps1')
    }

    if ($CheckBox_PuTTY.Checked) {
        Write-Host 'Software Selection: PuTTY: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'putty-64bit') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\PuTTY.msi")
        
        Write-Host 'Software Selection: PuTTY: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $env:TEMP\PuTTY.msi -ArgumentList '/quiet'
        
    }

    if ($CheckBox_Plex.Checked) {
        Write-Host 'Software Selection: Plex: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')
    }

    if ($CheckBox_Python.Checked) {
        Write-Host 'Software Selection: Python: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
    }

    if ($CheckBox_qBittorrent.Checked) {
        Write-Host 'Software Selection: qBittorrent: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
    }

    if ($CheckBox_Steam.Checked) {
        Write-Host 'Software Selection: Steam: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe', "$env:TEMP\SteamSetup.exe")
        
        Write-Host 'Software Selection: Steam: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\SteamSetup.exe -ArgumentList '/S'
    }

    if ($CheckBox_SubtitleEdit.Checked) {
        Write-Host 'Software Selection: Subtitle Edit: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Subtitle_Edit/Download.ps1')
    }

    if ($CheckBox_Telegram.Checked) {
        Write-Host 'Software Selection: Telegram: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://telegram.org/dl/desktop/win64', "$env:TEMP\Telegram.exe")
        
        Write-Host 'Software Selection: Telegram: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\Telegram.exe -ArgumentList '/VERYSILENT'
    }

    if ($CheckBox_TranslucentTB.Checked) {
        Write-Host 'Software Selection: TranslucentTB: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/TranslucentTB/Download.ps1')
    }
    
    if ($CheckBox_Valorant.Checked) {
        Write-Host 'Software Selection: Valorant: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.ap.exe', "$env:TEMP\VALORANT.exe")
                
        Write-Host 'Software Selection: Valorant: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $env:TEMP\VALORANT.exe -ArgumentList '--skip-to-install'
    }

    if ($CheckBox_VisualStudioCode.Checked) {
        Write-Host 'Software Selection: Visual Studio Code: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')
    }

    if ($CheckBox_Windows10IoTEnterprise2021.Checked) {
        Write-Host 'Software Selection: Windows 10 IoT Enterprise LTSC 2021: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/ISO.ps1')
    }

    if ($CheckBox_Zoom.Checked) {
        Write-Host 'Software Selection: Zoom: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://zoom.us/client/latest/ZoomInstaller.exe?archType=x64', "$env:TEMP\ZoomInstallerFull-x64.exe")
        
        Write-Host 'Software Selection: Zoom: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath $env:TEMP\ZoomInstallerFull-x64.exe
    }

    if ($CheckBox_UninstallEdge.Checked) {
        Write-Host 'Software Selection: Microsoft Edge: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Edge/Uninstall.ps1')
    }
    
    if ($CheckBox_MicrosoftOffice.Checked) {

        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        [System.Windows.Forms.Application]::EnableVisualStyles()
        
        $Form_OfficeSelection = New-Object System.Windows.Forms.Form
        $Form_OfficeSelection.width = 900
        $Form_OfficeSelection.height = 470
        $Form_OfficeSelection.Text = 'Office Selection'
        $Form_OfficeSelection.StartPosition = 'CenterScreen'
        $Form_OfficeSelection.Font = New-Object System.Drawing.Font('Tahoma', 11)
        
        $CheckBox_X_Axis1 = 5
        $CheckBox_Y_Axis2 = 0
        $CheckBox_Size_X1 = (($Form_OfficeSelection.width) - 50)
        $CheckBox_Size_Y2 = 26
        
        $Panel_OfficeSelection = New-Object System.Windows.Forms.Panel
        $Panel_OfficeSelection.Location = New-Object System.Drawing.Size(0, 0)
        $Panel_OfficeSelection.Size = New-Object System.Drawing.Size((($Form_OfficeSelection.width) - 20), (($Form_OfficeSelection.Height) - 65))
        $Panel_OfficeSelection.AutoScroll = $true
        $Panel_OfficeSelection.AutoSize = $false
        $Form_OfficeSelection.Controls.Add($Panel_OfficeSelection)
        
        $CheckBox_Microsoft365ProPlus = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Microsoft365ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Microsoft365ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Resized from Official ICO from Website
        $CheckBox_Microsoft365ProPlus_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_Microsoft365ProPlus_IconBytes = [Convert]::FromBase64String($CheckBox_Microsoft365ProPlus_Icon64)
        $CheckBox_Microsoft365ProPlus_IconStream = [System.IO.MemoryStream]::new($CheckBox_Microsoft365ProPlus_IconBytes, 0, $CheckBox_Microsoft365ProPlus_IconBytes.Length)
        $CheckBox_Microsoft365ProPlus.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Microsoft365ProPlus_IconStream).GetHIcon()))
        $CheckBox_Microsoft365ProPlus.ImageAlign = 'MiddleLeft'
        $CheckBox_Microsoft365ProPlus.Text = '    Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word)'
        $CheckBox_Microsoft365ProPlus.TextAlign = 'MiddleLeft'
        $CheckBox_Microsoft365ProPlus.CheckAlign = 'MiddleLeft'
        $CheckBox_Microsoft365ProPlus.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Microsoft365ProPlus)
        
        $CheckBox_Office2024ProPlus = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Resized from Official ICO from Website
        $CheckBox_Office2024ProPlus_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_Office2024ProPlus_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024ProPlus_Icon64)
        $CheckBox_Office2024ProPlus_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024ProPlus_IconBytes, 0, $CheckBox_Office2024ProPlus_IconBytes.Length)
        $CheckBox_Office2024ProPlus.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024ProPlus_IconStream).GetHIcon()))
        $CheckBox_Office2024ProPlus.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024ProPlus.Text = '    Office 2024 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Word)'
        $CheckBox_Office2024ProPlus.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024ProPlus.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024ProPlus.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024ProPlus)
        
        $CheckBox_Office2024Access = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024Access.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024Access.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2024Access_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhFIgQIRSIcCEUiL8hFIjvIRSI/yEUiP8hFIj/IRSI/yEUiP8hFIjvIRSIvyEUiHAhFIgQAAAAAAAAAAAAAAAAIRSI7yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI7wAAAAAAAAAAAAAAABAKRP8QCkT/EApE/xAKRP8QCkT/EApE/xAKRP8ZD2b/IRSI/yEUiP8hFIj/IRSI/yEUiP8xIK/vMSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8vH6j/EApE/yEUiP8hFIj/IRSI/yEUiP8hFIj/MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/xgQV/8xIK//MB+t/y0dpf8oGZn/IhWK/zEgr/8xIK//5eP1/7+55v8xIK//MSCv/7+55v/l4/X/MSCv/zEgr/8YEFf/MSCv/zEgr/8xIK//MSCv/zAfrf8xIK//MSCv/5iQ1///////zMfr/8zH6///////mJDX/zEgr/8xIK//GBBX/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/9LPLn//////8zH6//Mx+v//////0s8uf8xIK//MSCv/xgQV/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/8zH6/+/ueb/v7nm/9jV8P8xIK//MSCv/zEgr/8wJ2T/YE/J/11Mx/9UQ8P/RjW6/zQjsf8xIK//MSCv/zEgr/9+dM3///////////9+dM3/MSCv/zEgr/8xIK//MCdk/2BPyf9gT8n/YE/J/2BPyf9dTMf/MSCv/zEgr/8xIK//Pi60////////////Pi60/zEgr/8xIK//MSCv/zAnZP9gT8n/YE/J/2BPyf9gT8n/YE/J/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8zKmr/YE/J/2BPyf9gT8n/YE/J/2BPyf8xIK/vMSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/83JrL/lYDg/5WA4P+Sfd//iHTa/3dk0/9jUsr/AAAAAAAAAAAAAAAAkn3f/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/kn3f/wAAAAAAAAAAAAAAAJWA4O+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4O8AAAAAAAAAAAAAAACVgOAQlYDgcJWA4L+VgODvlYDg/5WA4P+VgOD/lYDg/5WA4P+VgODvlYDgv5WA4HCVgOAQ4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2024Access_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024Access_Icon64)
        $CheckBox_Office2024Access_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024Access_IconBytes, 0, $CheckBox_Office2024Access_IconBytes.Length)
        $CheckBox_Office2024Access.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024Access_IconStream).GetHIcon()))
        $CheckBox_Office2024Access.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024Access.Text = '    Office 2024 - Access'
        $CheckBox_Office2024Access.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024Access.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024Access.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024Access)
        
        $CheckBox_Office2024Excel = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024Excel.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024Excel.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2024Excel_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3XBjvN1wY/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/zdcGP83XBjvAAAAAAAAAAAAAAAAMFEV/zBRFf8wURX/MFEV/zBRFf8wURX/NVkX/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/wAAAAAAAAAAAAAAACVCDf8lQg3/JUIN/yVCDf8lQg3/JUIN/xsuDP8pRRL/N1wY/zdcGP83XBj/N1wY/zdcGP9BfBDvQXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP8/dxD/Gy4M/zdcGP83XBj/N1wY/zdcGP83XBj/QXwQ/0F8EP9llT3/ZZU9/0F8EP9BfBD/ZZU9/2WVPf9BfBD/QXwQ/yA+CP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/rMaW//////9ZjC7/cZ1M//////+gvoj/QXwQ/0F8EP8gPgj/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/02EH//n7+H/0N7D/9Dew//n7+H/TYQf/0F8EP9BfBD/ID4I/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/fKVb////////////fKVb/0F8EP9BfBD/QXwQ/yA+CP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/3GdTP///////////3GdTP9BfBD/QXwQ/0F8EP8zURD/ZqMh/2ajIf9moyH/ZqMh/2ajIf9BfBD/QXwQ/0F8EP/n7+H/5+/h/9Dew//n7+H/QXwQ/0F8EP9BfBD/M1EQ/2ajIf9moyH/ZqMh/2ajIf9moyH/QXwQ/0F8EP+UtXn//////4itav9llT3//////6C+iP9BfBD/QXwQ/zNREP9moyH/ZqMh/2ajIf9moyH/ZqMh/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP82VhH/ZqMh/2ajIf9moyH/ZqMh/2ajIf9BfBDvQXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9DfhH/gcQz/4HEM/+BxDP/gcQz/4HEM/+BxDP/AAAAAAAAAAAAAAAAZqMh/2ajIf9moyH/ZqMh/2ajIf9moyH/ZqMh/4HEM/+BxDP/gcQz/4HEM/+BxDP/gcQz/wAAAAAAAAAAAAAAAGajIf9moyH/ZqMh/2ajIf9moyH/ZqMh/2ajIf+BxDP/gcQz/4HEM/+BxDP/gcQz/4HEM/8AAAAAAAAAAAAAAABmoyHvZqMh/2ajIf9moyH/ZqMh/2ajIf9moyH/gcQz/4HEM/+BxDP/gcQz/4HEM/+BxDPv4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2024Excel_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024Excel_Icon64)
        $CheckBox_Office2024Excel_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024Excel_IconBytes, 0, $CheckBox_Office2024Excel_IconBytes.Length)
        $CheckBox_Office2024Excel.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024Excel_IconStream).GetHIcon()))
        $CheckBox_Office2024Excel.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024Excel.Text = '    Office 2024 - Excel'
        $CheckBox_Office2024Excel.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024Excel.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024Excel.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024Excel)
        
        $CheckBox_Office2024Outlook = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024Outlook.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024Outlook.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2024Outlook_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOqoKO/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+imJ//YkxzvAAAAAAAAAADqqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/92ZIP/KgxP/0YcT/wAAAAAAAAAAjV0P/41dD/+NXQ//jV0P/41dD/+NXQ//jV0P/3VUFP+wfh7/4p4j/86IFv/OhRP/240U/9+QFP/UeADv1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/OdgH/aUYM/8uDEv/YixP/35AU/9+QFP/fkBT/1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/2hDCv/fkBT/35AU/9+QFP/fkBT/35AU/9R4AP/UeAD/3JEw//ru3/////////////ru3//ckTD/1HgA/9R4AP9WNAz/xHwX/9+QFP/fkBT/35AU/9+QFP/UeAD/1HgA//ru3//89+//4aJQ/+GiUP/89+//9N2//9R4AP/UeAD/b04T/7l3Hf+vbBj/zoMW/9+QFP/fkBT/1HgA/9R4AP//////6ryA/9R4AP/UeAD/6ryA///////UeAD/1HgA/3VUFP/qqCj/1ZQj/7BvG/+2cRj/yXwS/9R4AP/UeAD//////+q8gP/UeAD/1HgA/+q8gP//////1HgA/9R4AP91VBT/6qgo/+qoKP/qqCj/zYwh/3AvC9/UeAD/1HgA//Tdv//89+//4aJQ/9+aQP/67t//+u7f/9R4AP/UeAD/f2wo///ZUP//2VD//9lQ///ZUP8AAAAA1HgA/9R4AP/ckTD/9+bP////////////+u7f/9yRMP/UeAD/1HgA/39sKP//2VD//9lQ///ZUP//2VD/AAAAANR4AP/UeAD/1HgA/9R4AP/XgBD/2Ykg/9R4AP/UeAD/1HgA/9R4AP+Hcyv//9lQ///ZUP//2VD//9lQ/wAAAADUeADv1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/XfgX//9lQ///ZUP//2VD//9lQ///ZUP8AAAAAAAAAAAAAAAAAAAAA6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj//9lQ///ZUP//2VD//9lQ///ZUP//2VD/AAAAAAAAAAAAAAAAAAAAAOqoKP/qqCj/6qgo/+qoKP/qqCj/6qgo///ZUP//2VD//9lQ///ZUP//2VD//9lQ/wAAAAAAAAAAAAAAAAAAAADFdg3vxXUM/8V1DP/FdQz/xXUM/8V1DP/KgRb/yoEW/8qBFv/KgRb/yoEW/8uDGO8AAAAAwAAAAMAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAQAAAAEAAOABAADgAQAA4AEAAA=='
        $CheckBox_Office2024Outlook_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024Outlook_Icon64)
        $CheckBox_Office2024Outlook_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024Outlook_IconBytes, 0, $CheckBox_Office2024Outlook_IconBytes.Length)
        $CheckBox_Office2024Outlook.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024Outlook_IconStream).GetHIcon()))
        $CheckBox_Office2024Outlook.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024Outlook.Text = '    Office 2024 - Outlook'
        $CheckBox_Office2024Outlook.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024Outlook.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024Outlook.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024Outlook)
        
        $CheckBox_Office2024PowerPoint = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024PowerPoint.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024PowerPoint.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2024PowerPoint_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMFLTYDBS078wUtP/MFLT/zBS0/8wUtP/MFLTvzBS02AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwUtMgMFLTzzBS0/8wUtP/MFLT/zBS0/8wUtP/MFLT/zBS0/8wUtP/MFLTzzBS0yAAAAAAAAAAAAAAAAAWJV4gFiVe7xYlXv8WJV7/FiVe/xYlXv8WJV7/FiVe/xYlXv8jPJn/MFLT/zBS0/8wUtPvMFLTIAAAAAAcPsTvHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPL7/FiVe/zBS0/8wUtP/MFLT/zBS088AAAAAHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xYlXv8wUtP/MFLT/zBS0/8wUtP/MFLTYBw+xP8cPsT/HD7E//////9VbtP/HD7E/xw+xP8cPsT/HD7E/xw+xP8WJV7/MFLT/zBS0/8wUtP/MFLT/zBS078cPsT/HD7E/xw+xP//////VW7T/xw+xP8cPsT/HD7E/xw+xP8cPsT/FiVe/zBS0/8wUtP/MFLT/zBS0/8wUtP/HD7E/xw+xP8cPsT/////////////////xs/w/ypKyP8cPsT/HD7E/xYlXv8wUtP/MFLT/zBS0/8wUtP/MFLT/xw+xP8cPsT/HD7E//////9/kt7/Y3rW//////+On+L/HD7E/xw+xP8wQHL/a4///2uP//9rj///a4///2uP//8cPsT/HD7E/xw+xP//////VW7T/zhWy//x8/v/jp/i/xw+xP8cPsT/MEBy/2uP//9rj///a4///2uP//9rj///HD7E/xw+xP8cPsT/////////////////8fP7/0diz/8cPsT/HD7E/zBAcv9rj///a4///2uP//9rj///a4//vxw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP80RXv/a4///2uP//9rj///a4///2uP/2AcPsTvHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8hQ8j/a4///2uP//9rj///a4///2uP/88AAAAAAAAAAEds7SBHbO3vR2zt/0ds7f9HbO3/R2zt/0ds7f9rj///a4///2uP//9rj///a4///2uP/+9rj/8gAAAAAAAAAAAAAAAAR2ztIEds7c9HbO3/R2zt/0ds7f9HbO3/a4///2uP//9rj///a4///2uP/89rj/8gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAR2ztYEds7b9HbO3/R2zt/2uP//9rj///a4//v2uP/2AAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAIABAADAAwAA8A8AAA=='
        $CheckBox_Office2024PowerPoint_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024PowerPoint_Icon64)
        $CheckBox_Office2024PowerPoint_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024PowerPoint_IconBytes, 0, $CheckBox_Office2024PowerPoint_IconBytes.Length)
        $CheckBox_Office2024PowerPoint.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024PowerPoint_IconStream).GetHIcon()))
        $CheckBox_Office2024PowerPoint.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024PowerPoint.Text = '    Office 2024 - PowerPoint'
        $CheckBox_Office2024PowerPoint.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024PowerPoint.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024PowerPoint.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024PowerPoint)
        
        $CheckBox_Office2024Word = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2024Word.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2024Word.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2024Word_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACRPxDvkT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxDvAAAAAAAAAAAAAAAAkT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/wAAAAAAAAAAAAAAAEgfCP9IHwj/SB8I/0gfCP9IHwj/SB8I/0gfCP9tLwz/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+9WhjvvVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+2Vhf/SB8I/5E/EP+RPxD/kT8Q/5E/EP+RPxD/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/14tDP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/4rea///////Og1L/zoNS///////it5r/vVoY/71aGP9eLQz/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/+/Wxf//////3q2M/9qiff//////79bF/71aGP+9Whj/Xi0M/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP//////8+DU/+rLt//qy7f/8+DU//////+9Whj/vVoY/14tDP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP/Og1L//////9aYb//36uL/+/Xx/9aYb///////zoNS/71aGP9pPhX/03wr/9N8K//TfCv/03wr/9N8K/+9Whj/2qJ9//v18f/BZCb////////////FbzX/9+ri/9qiff+9Whj/aT4V/9N8K//TfCv/03wr/9N8K//TfCv/vVoY/+rLt//v1sX/vVoY//Pg1P/36uL/vVoY/+/Wxf/qy7f/vVoY/2k+Ff/TfCv/03wr/9N8K//TfCv/03wr/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP9wQhb/03wr/9N8K//TfCv/03wr/9N8K/+9WhjvvVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP/AXxv/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/AAAAAAAAAAAAAAAA7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/wAAAAAAAAAAAAAAAO6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf8AAAAAAAAAAAAAAADupUHv7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUHv4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2024Word_IconBytes = [Convert]::FromBase64String($CheckBox_Office2024Word_Icon64)
        $CheckBox_Office2024Word_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2024Word_IconBytes, 0, $CheckBox_Office2024Word_IconBytes.Length)
        $CheckBox_Office2024Word.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2024Word_IconStream).GetHIcon()))
        $CheckBox_Office2024Word.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2024Word.Text = '    Office 2024 - Word'
        $CheckBox_Office2024Word.TextAlign = 'MiddleLeft'
        $CheckBox_Office2024Word.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2024Word.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2024Word)
        
        $CheckBox_Office2021ProPlus = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Resized from Official ICO from Website
        $CheckBox_Office2021ProPlus_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_Office2021ProPlus_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021ProPlus_Icon64)
        $CheckBox_Office2021ProPlus_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021ProPlus_IconBytes, 0, $CheckBox_Office2021ProPlus_IconBytes.Length)
        $CheckBox_Office2021ProPlus.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021ProPlus_IconStream).GetHIcon()))
        $CheckBox_Office2021ProPlus.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021ProPlus.Text = '    Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word)'
        $CheckBox_Office2021ProPlus.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021ProPlus.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021ProPlus.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021ProPlus)
        
        $CheckBox_Office2021Access = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021Access.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021Access.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021Access_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhFIgQIRSIcCEUiL8hFIjvIRSI/yEUiP8hFIj/IRSI/yEUiP8hFIjvIRSIvyEUiHAhFIgQAAAAAAAAAAAAAAAAIRSI7yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI/yEUiP8hFIj/IRSI7wAAAAAAAAAAAAAAABAKRP8QCkT/EApE/xAKRP8QCkT/EApE/xAKRP8ZD2b/IRSI/yEUiP8hFIj/IRSI/yEUiP8xIK/vMSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8vH6j/EApE/yEUiP8hFIj/IRSI/yEUiP8hFIj/MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/xgQV/8xIK//MB+t/y0dpf8oGZn/IhWK/zEgr/8xIK//5eP1/7+55v8xIK//MSCv/7+55v/l4/X/MSCv/zEgr/8YEFf/MSCv/zEgr/8xIK//MSCv/zAfrf8xIK//MSCv/5iQ1///////zMfr/8zH6///////mJDX/zEgr/8xIK//GBBX/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/9LPLn//////8zH6//Mx+v//////0s8uf8xIK//MSCv/xgQV/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/8zH6/+/ueb/v7nm/9jV8P8xIK//MSCv/zEgr/8wJ2T/YE/J/11Mx/9UQ8P/RjW6/zQjsf8xIK//MSCv/zEgr/9+dM3///////////9+dM3/MSCv/zEgr/8xIK//MCdk/2BPyf9gT8n/YE/J/2BPyf9dTMf/MSCv/zEgr/8xIK//Pi60////////////Pi60/zEgr/8xIK//MSCv/zAnZP9gT8n/YE/J/2BPyf9gT8n/YE/J/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/8zKmr/YE/J/2BPyf9gT8n/YE/J/2BPyf8xIK/vMSCv/zEgr/8xIK//MSCv/zEgr/8xIK//MSCv/zEgr/83JrL/lYDg/5WA4P+Sfd//iHTa/3dk0/9jUsr/AAAAAAAAAAAAAAAAkn3f/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/kn3f/wAAAAAAAAAAAAAAAJWA4O+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4P+VgOD/lYDg/5WA4O8AAAAAAAAAAAAAAACVgOAQlYDgcJWA4L+VgODvlYDg/5WA4P+VgOD/lYDg/5WA4P+VgODvlYDgv5WA4HCVgOAQ4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2021Access_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021Access_Icon64)
        $CheckBox_Office2021Access_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021Access_IconBytes, 0, $CheckBox_Office2021Access_IconBytes.Length)
        $CheckBox_Office2021Access.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021Access_IconStream).GetHIcon()))
        $CheckBox_Office2021Access.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021Access.Text = '    Office 2021 - Access'
        $CheckBox_Office2021Access.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021Access.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021Access.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021Access)
        
        $CheckBox_Office2021Excel = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021Excel.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021Excel.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021Excel_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA3XBjvN1wY/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/zdcGP83XBjvAAAAAAAAAAAAAAAAMFEV/zBRFf8wURX/MFEV/zBRFf8wURX/NVkX/zdcGP83XBj/N1wY/zdcGP83XBj/N1wY/wAAAAAAAAAAAAAAACVCDf8lQg3/JUIN/yVCDf8lQg3/JUIN/xsuDP8pRRL/N1wY/zdcGP83XBj/N1wY/zdcGP9BfBDvQXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP8/dxD/Gy4M/zdcGP83XBj/N1wY/zdcGP83XBj/QXwQ/0F8EP9llT3/ZZU9/0F8EP9BfBD/ZZU9/2WVPf9BfBD/QXwQ/yA+CP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/rMaW//////9ZjC7/cZ1M//////+gvoj/QXwQ/0F8EP8gPgj/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/02EH//n7+H/0N7D/9Dew//n7+H/TYQf/0F8EP9BfBD/ID4I/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/fKVb////////////fKVb/0F8EP9BfBD/QXwQ/yA+CP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/3GdTP///////////3GdTP9BfBD/QXwQ/0F8EP8zURD/ZqMh/2ajIf9moyH/ZqMh/2ajIf9BfBD/QXwQ/0F8EP/n7+H/5+/h/9Dew//n7+H/QXwQ/0F8EP9BfBD/M1EQ/2ajIf9moyH/ZqMh/2ajIf9moyH/QXwQ/0F8EP+UtXn//////4itav9llT3//////6C+iP9BfBD/QXwQ/zNREP9moyH/ZqMh/2ajIf9moyH/ZqMh/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP82VhH/ZqMh/2ajIf9moyH/ZqMh/2ajIf9BfBDvQXwQ/0F8EP9BfBD/QXwQ/0F8EP9BfBD/QXwQ/0F8EP9DfhH/gcQz/4HEM/+BxDP/gcQz/4HEM/+BxDP/AAAAAAAAAAAAAAAAZqMh/2ajIf9moyH/ZqMh/2ajIf9moyH/ZqMh/4HEM/+BxDP/gcQz/4HEM/+BxDP/gcQz/wAAAAAAAAAAAAAAAGajIf9moyH/ZqMh/2ajIf9moyH/ZqMh/2ajIf+BxDP/gcQz/4HEM/+BxDP/gcQz/4HEM/8AAAAAAAAAAAAAAABmoyHvZqMh/2ajIf9moyH/ZqMh/2ajIf9moyH/gcQz/4HEM/+BxDP/gcQz/4HEM/+BxDPv4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2021Excel_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021Excel_Icon64)
        $CheckBox_Office2021Excel_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021Excel_IconBytes, 0, $CheckBox_Office2021Excel_IconBytes.Length)
        $CheckBox_Office2021Excel.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021Excel_IconStream).GetHIcon()))
        $CheckBox_Office2021Excel.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021Excel.Text = '    Office 2021 - Excel'
        $CheckBox_Office2021Excel.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021Excel.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021Excel.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021Excel)
        
        $CheckBox_Office2021OneNote = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021OneNote.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021OneNote.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021OneNote_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADqZMrv6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv+qGXf/qhl3/6oZd/+qGXfvAAAAAAAAAAAAAAAA6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/qhl3/6oZd/+qGXf/qhl3/wAAAAAAAAAAAAAAADsZM/87GTP/Oxkz/zsZM/87GTP/Oxkz/zsZM/99NWz/6mTK/6oZd/+qGXf/qhl3/6oZd/+qGXfvqhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+jGXP/Oxkz/+pkyv+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/zsZM//qZMr/vzKT/78yk/+/MpP/vzKT/6oZd/+qGXf//////9WMu/+qGXf/ryeA/+/U5v//////qhl3/6oZd/87GTP/6mTK/78yk/+/MpP/vzKT/78yk/+qGXf/qhl3///////VjLv/qhl3/+S31f///////////6oZd/+qGXf/Oxkz/+pkyv+/MpP/vzKT/78yk/+/MpP/qhl3/6oZd///////1Yy7/89+s///////5LfV//////+qGXf/qhl3/zsZM//qZMr/vzKT/78yk/+/MpP/vzKT/6oZd/+qGXf//////+rG3f//////36nM/79Tmf//////qhl3/6oZd/87GTP/6mTK/9VLrv/VS67/1Uuu/9VLrv+qGXf/qhl3////////////79Tm/68ngP+/U5n//////6oZd/+qGXf/Oxkz/+pkyv/VS67/1Uuu/9VLrv/VS67/qhl3/6oZd///////+vH3/7pEkf+qGXf/v1OZ//////+qGXf/qhl3/zsZM//qZMr/1Uuu/9VLrv/VS67/1Uuu/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/9GHjz/6mTK/9VLrv/VS67/1Uuu/9VLrv+qGXfvqhl3/6oZd/+qGXf/qhl3/6oZd/+qGXf/qhl3/6oZd/+uHnz/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/AAAAAAAAAAAAAAAA6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/wAAAAAAAAAA6mTKEOpkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv8AAAAAAAAAAOpkyhDqZMrv6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMr/6mTK/+pkyv/qZMrv4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADAAAAAwAAAAA=='
        $CheckBox_Office2021OneNote_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021OneNote_Icon64)
        $CheckBox_Office2021OneNote_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021OneNote_IconBytes, 0, $CheckBox_Office2021OneNote_IconBytes.Length)
        $CheckBox_Office2021OneNote.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021OneNote_IconStream).GetHIcon()))
        $CheckBox_Office2021OneNote.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021OneNote.Text = '    Office 2021 - OneNote'
        $CheckBox_Office2021OneNote.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021OneNote.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021OneNote.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021OneNote)
        
        $CheckBox_Office2021Outlook = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021Outlook.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021Outlook.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021Outlook_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOqoKO/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+imJ//YkxzvAAAAAAAAAADqqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj/6qgo/92ZIP/KgxP/0YcT/wAAAAAAAAAAjV0P/41dD/+NXQ//jV0P/41dD/+NXQ//jV0P/3VUFP+wfh7/4p4j/86IFv/OhRP/240U/9+QFP/UeADv1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/OdgH/aUYM/8uDEv/YixP/35AU/9+QFP/fkBT/1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/2hDCv/fkBT/35AU/9+QFP/fkBT/35AU/9R4AP/UeAD/3JEw//ru3/////////////ru3//ckTD/1HgA/9R4AP9WNAz/xHwX/9+QFP/fkBT/35AU/9+QFP/UeAD/1HgA//ru3//89+//4aJQ/+GiUP/89+//9N2//9R4AP/UeAD/b04T/7l3Hf+vbBj/zoMW/9+QFP/fkBT/1HgA/9R4AP//////6ryA/9R4AP/UeAD/6ryA///////UeAD/1HgA/3VUFP/qqCj/1ZQj/7BvG/+2cRj/yXwS/9R4AP/UeAD//////+q8gP/UeAD/1HgA/+q8gP//////1HgA/9R4AP91VBT/6qgo/+qoKP/qqCj/zYwh/3AvC9/UeAD/1HgA//Tdv//89+//4aJQ/9+aQP/67t//+u7f/9R4AP/UeAD/f2wo///ZUP//2VD//9lQ///ZUP8AAAAA1HgA/9R4AP/ckTD/9+bP////////////+u7f/9yRMP/UeAD/1HgA/39sKP//2VD//9lQ///ZUP//2VD/AAAAANR4AP/UeAD/1HgA/9R4AP/XgBD/2Ykg/9R4AP/UeAD/1HgA/9R4AP+Hcyv//9lQ///ZUP//2VD//9lQ/wAAAADUeADv1HgA/9R4AP/UeAD/1HgA/9R4AP/UeAD/1HgA/9R4AP/XfgX//9lQ///ZUP//2VD//9lQ///ZUP8AAAAAAAAAAAAAAAAAAAAA6qgo/+qoKP/qqCj/6qgo/+qoKP/qqCj//9lQ///ZUP//2VD//9lQ///ZUP//2VD/AAAAAAAAAAAAAAAAAAAAAOqoKP/qqCj/6qgo/+qoKP/qqCj/6qgo///ZUP//2VD//9lQ///ZUP//2VD//9lQ/wAAAAAAAAAAAAAAAAAAAADFdg3vxXUM/8V1DP/FdQz/xXUM/8V1DP/KgRb/yoEW/8qBFv/KgRb/yoEW/8uDGO8AAAAAwAAAAMAAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAQAAAAEAAOABAADgAQAA4AEAAA=='
        $CheckBox_Office2021Outlook_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021Outlook_Icon64)
        $CheckBox_Office2021Outlook_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021Outlook_IconBytes, 0, $CheckBox_Office2021Outlook_IconBytes.Length)
        $CheckBox_Office2021Outlook.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021Outlook_IconStream).GetHIcon()))
        $CheckBox_Office2021Outlook.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021Outlook.Text = '    Office 2021 - Outlook'
        $CheckBox_Office2021Outlook.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021Outlook.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021Outlook.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021Outlook)
        
        $CheckBox_Office2021PowerPoint = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021PowerPoint.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021PowerPoint.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021PowerPoint_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMFLTYDBS078wUtP/MFLT/zBS0/8wUtP/MFLTvzBS02AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwUtMgMFLTzzBS0/8wUtP/MFLT/zBS0/8wUtP/MFLT/zBS0/8wUtP/MFLTzzBS0yAAAAAAAAAAAAAAAAAWJV4gFiVe7xYlXv8WJV7/FiVe/xYlXv8WJV7/FiVe/xYlXv8jPJn/MFLT/zBS0/8wUtPvMFLTIAAAAAAcPsTvHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPL7/FiVe/zBS0/8wUtP/MFLT/zBS088AAAAAHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xYlXv8wUtP/MFLT/zBS0/8wUtP/MFLTYBw+xP8cPsT/HD7E//////9VbtP/HD7E/xw+xP8cPsT/HD7E/xw+xP8WJV7/MFLT/zBS0/8wUtP/MFLT/zBS078cPsT/HD7E/xw+xP//////VW7T/xw+xP8cPsT/HD7E/xw+xP8cPsT/FiVe/zBS0/8wUtP/MFLT/zBS0/8wUtP/HD7E/xw+xP8cPsT/////////////////xs/w/ypKyP8cPsT/HD7E/xYlXv8wUtP/MFLT/zBS0/8wUtP/MFLT/xw+xP8cPsT/HD7E//////9/kt7/Y3rW//////+On+L/HD7E/xw+xP8wQHL/a4///2uP//9rj///a4///2uP//8cPsT/HD7E/xw+xP//////VW7T/zhWy//x8/v/jp/i/xw+xP8cPsT/MEBy/2uP//9rj///a4///2uP//9rj///HD7E/xw+xP8cPsT/////////////////8fP7/0diz/8cPsT/HD7E/zBAcv9rj///a4///2uP//9rj///a4//vxw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP80RXv/a4///2uP//9rj///a4///2uP/2AcPsTvHD7E/xw+xP8cPsT/HD7E/xw+xP8cPsT/HD7E/xw+xP8hQ8j/a4///2uP//9rj///a4///2uP/88AAAAAAAAAAEds7SBHbO3vR2zt/0ds7f9HbO3/R2zt/0ds7f9rj///a4///2uP//9rj///a4///2uP/+9rj/8gAAAAAAAAAAAAAAAAR2ztIEds7c9HbO3/R2zt/0ds7f9HbO3/a4///2uP//9rj///a4///2uP/89rj/8gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAR2ztYEds7b9HbO3/R2zt/2uP//9rj///a4//v2uP/2AAAAAAAAAAAAAAAAAAAAAA8A8AAMADAACAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAIABAADAAwAA8A8AAA=='
        $CheckBox_Office2021PowerPoint_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021PowerPoint_Icon64)
        $CheckBox_Office2021PowerPoint_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021PowerPoint_IconBytes, 0, $CheckBox_Office2021PowerPoint_IconBytes.Length)
        $CheckBox_Office2021PowerPoint.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021PowerPoint_IconStream).GetHIcon()))
        $CheckBox_Office2021PowerPoint.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021PowerPoint.Text = '    Office 2021 - PowerPoint'
        $CheckBox_Office2021PowerPoint.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021PowerPoint.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021PowerPoint.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021PowerPoint)
        
        $CheckBox_Office2021Publisher = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021Publisher.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021Publisher.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021Publisher_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACHgwPvh4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD7wAAAAAAAAAAAAAAAAAAAAAAAAAAh4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/9saQL/h4MD7wAAAAAAAAAAAAAAADw6Af88OgH/PDoB/zw6Af88OgH/PDoB/zw6Af9iXwL/h4MD/4eDA/+HgwP/bGkC/4eDA/+HgwPvh4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+CfgP/QT8B/4eDA/+HgwP/h4MD/2xpAv+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/1hVCv+hmxr/oZsa/6GbGv9saQL/h4MD/4eDA/+HgwP/h4MD//////+lokL/h4MD/4eDA/+HgwP/h4MD/4eDA/9YVQr/oZsa/6GbGv+hmxr/bGkC/4eDA/+HgwP/h4MD/4eDA///////paJC/4eDA/+HgwP/h4MD/4eDA/+HgwP/WFUK/6GbGv+hmxr/oZsa/2xpAv+HgwP/h4MD/4eDA/+HgwP/////////////////4eDA/4+LE/+HgwP/h4MD/1hVCv+hmxr/oZsa/6GbGv9saQL/h4MD/4eDA/+HgwP/h4MD//////+8uXH/rapS///////DwYH/h4MD/4eDA/9oZBP/0MY3/9DGN//Qxjf/bGkC/4eDA/+HgwP/h4MD/4eDA///////paJC/5aTI//49+//w8GB/4eDA/+HgwP/aGQT/9DGN//Qxjf/0MY3/2xpAv+HgwP/h4MD/4eDA/+HgwP/////////////////+Pfv/56aMv+HgwP/h4MD/2hkE//Qxjf/0MY3/9DGN/9saQL/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/9vahX/0MY3/9DGN//Qxjf/bGkC/4eDA/+HgwPvh4MD/4eDA/+HgwP/h4MD/4eDA/+HgwP/h4MD/4eDA/+Mhwb/0MY3/9DGN//Qxjf/0MY3/2xpAv+HgwP/AAAAAAAAAAAAAAAA0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/0MY3/9DGN/9saQL/h4MD/wAAAAAAAAAAAAAAANDGN//Qxjf/0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/bGkC/4eDA+8AAAAAAAAAAAAAAADQxjfv0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/0MY3/9DGN//Qxjf/0MY37wAAAAAAAAAA4AMAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AMAAA=='
        $CheckBox_Office2021Publisher_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021Publisher_Icon64)
        $CheckBox_Office2021Publisher_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021Publisher_IconBytes, 0, $CheckBox_Office2021Publisher_IconBytes.Length)
        $CheckBox_Office2021Publisher.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021Publisher_IconStream).GetHIcon()))
        $CheckBox_Office2021Publisher.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021Publisher.Text = '    Office 2021 - Publisher'
        $CheckBox_Office2021Publisher.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021Publisher.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021Publisher.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021Publisher)
        
        $CheckBox_Office2021Word = New-Object System.Windows.Forms.CheckBox
        $CheckBox_Office2021Word.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_Office2021Word.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Official ICO from EXE
        $CheckBox_Office2021Word_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACRPxDvkT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxDvAAAAAAAAAAAAAAAAkT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+RPxD/kT8Q/wAAAAAAAAAAAAAAAEgfCP9IHwj/SB8I/0gfCP9IHwj/SB8I/0gfCP9tLwz/kT8Q/5E/EP+RPxD/kT8Q/5E/EP+9WhjvvVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+2Vhf/SB8I/5E/EP+RPxD/kT8Q/5E/EP+RPxD/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/14tDP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/4rea///////Og1L/zoNS///////it5r/vVoY/71aGP9eLQz/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/+/Wxf//////3q2M/9qiff//////79bF/71aGP+9Whj/Xi0M/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP//////8+DU/+rLt//qy7f/8+DU//////+9Whj/vVoY/14tDP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP/Og1L//////9aYb//36uL/+/Xx/9aYb///////zoNS/71aGP9pPhX/03wr/9N8K//TfCv/03wr/9N8K/+9Whj/2qJ9//v18f/BZCb////////////FbzX/9+ri/9qiff+9Whj/aT4V/9N8K//TfCv/03wr/9N8K//TfCv/vVoY/+rLt//v1sX/vVoY//Pg1P/36uL/vVoY/+/Wxf/qy7f/vVoY/2k+Ff/TfCv/03wr/9N8K//TfCv/03wr/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP9wQhb/03wr/9N8K//TfCv/03wr/9N8K/+9WhjvvVoY/71aGP+9Whj/vVoY/71aGP+9Whj/vVoY/71aGP/AXxv/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/AAAAAAAAAAAAAAAA7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/wAAAAAAAAAAAAAAAO6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf8AAAAAAAAAAAAAAADupUHv7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUH/7qVB/+6lQf/upUHv4AAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAA4AAAAA=='
        $CheckBox_Office2021Word_IconBytes = [Convert]::FromBase64String($CheckBox_Office2021Word_Icon64)
        $CheckBox_Office2021Word_IconStream = [System.IO.MemoryStream]::new($CheckBox_Office2021Word_IconBytes, 0, $CheckBox_Office2021Word_IconBytes.Length)
        $CheckBox_Office2021Word.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_Office2021Word_IconStream).GetHIcon()))
        $CheckBox_Office2021Word.ImageAlign = 'MiddleLeft'
        $CheckBox_Office2021Word.Text = '    Office 2021 - Word'
        $CheckBox_Office2021Word.TextAlign = 'MiddleLeft'
        $CheckBox_Office2021Word.CheckAlign = 'MiddleLeft'
        $CheckBox_Office2021Word.Checked = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_Office2021Word)
        
        $CheckBox_ActivateOffice = New-Object System.Windows.Forms.CheckBox
        $CheckBox_ActivateOffice.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_ActivateOffice.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Which ICO to Use?
        $CheckBox_ActivateOffice_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_ActivateOffice_IconBytes = [Convert]::FromBase64String($CheckBox_ActivateOffice_Icon64)
        $CheckBox_ActivateOffice_IconStream = [System.IO.MemoryStream]::new($CheckBox_ActivateOffice_IconBytes, 0, $CheckBox_ActivateOffice_IconBytes.Length)
        $CheckBox_ActivateOffice.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_ActivateOffice_IconStream).GetHIcon()))
        $CheckBox_ActivateOffice.ImageAlign = 'MiddleLeft'
        $CheckBox_ActivateOffice.Text = '    Activate Office (Recommended)'
        $CheckBox_ActivateOffice.TextAlign = 'MiddleLeft'
        $CheckBox_ActivateOffice.CheckAlign = 'MiddleLeft'
        $CheckBox_ActivateOffice.Checked = $true
        $Panel_OfficeSelection.Controls.Add($CheckBox_ActivateOffice)
        
        $CheckBox_DisableTelemetry = New-Object System.Windows.Forms.CheckBox
        $CheckBox_DisableTelemetry.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_DisableTelemetry.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Which ICO to Use?
        $CheckBox_DisableTelemetry_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_DisableTelemetry_IconBytes = [Convert]::FromBase64String($CheckBox_DisableTelemetry_Icon64)
        $CheckBox_DisableTelemetry_IconStream = [System.IO.MemoryStream]::new($CheckBox_DisableTelemetry_IconBytes, 0, $CheckBox_DisableTelemetry_IconBytes.Length)
        $CheckBox_DisableTelemetry.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_DisableTelemetry_IconStream).GetHIcon()))
        $CheckBox_DisableTelemetry.ImageAlign = 'MiddleLeft'
        $CheckBox_DisableTelemetry.Text = '    Disable Telemetry (Recommended)'
        $CheckBox_DisableTelemetry.TextAlign = 'MiddleLeft'
        $CheckBox_DisableTelemetry.CheckAlign = 'MiddleLeft'
        $CheckBox_DisableTelemetry.Checked = $true
        $Panel_OfficeSelection.Controls.Add($CheckBox_DisableTelemetry)
        
        $CheckBox_DisableTelemetry.Add_Click( {
                if ($CheckBox_DisableTelemetry.Checked -eq $true) {
                    $CheckBox_EnableTelemetry.Enabled = $false
                }
                elseif ($CheckBox_DisableTelemetry.Checked -eq $false) {
                    $CheckBox_EnableTelemetry.Enabled = $true
                }   
            }
        )
        
        $CheckBox_EnableTelemetry = New-Object System.Windows.Forms.CheckBox
        $CheckBox_EnableTelemetry.Location = New-Object System.Drawing.Size($CheckBox_X_Axis1, $CheckBox_Y_Axis2)
        $CheckBox_Y_Axis2 += 22
        $CheckBox_EnableTelemetry.Size = New-Object System.Drawing.Size($CheckBox_Size_X1, $CheckBox_Size_Y2)
        # Which ICO to Use?
        $CheckBox_EnableTelemetry_Icon64 = 'AAABAAEAEBAAAAAAAABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpi74Y5Ie4cN2CsXDYfqwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPmYzwj0lMl47Y7B8uWIuf/dgbH/1Xup8s51oXbIcJsIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA95fPAvua0VD9m9Pc95fN/++QxP/miLr/3IGw/9N5pv/Lc53/w22V3LxnjlCvYIACAAAAAAAAAAAAAAAA0HUmEsVuIbiyYhj/rmEv/9Z/jP/yksf/54m8/9yAr//Qd6P/xm+Z/75pkP+4Y4n/sl+DuK1bfhIAAAAAAAAAANd5OZrTdi3/ynEi/7xpGP+rXhH/r2I5/9Z+mf/af67/zHSf/8Fqk/+4Y4n/sV6C/6xafP+pWHmaAAAAAAAAAADZekjW2XpF/9d5PP/RdS//x28h/7dlFeigVxBi1nyqYsVul+i4Y4n/r1x//6lYef+lVXb/olRx1gAAAAAAAAAA2ntU2tp7VP/ae1T/2npR/9d5R+rNcy0eAAAAAAAAAAC3Y4keqll77KRUdf+fUHD/l0to/69zXNoAAAAAAAAAANt7Ydrce2P/3Htl/9x8af/cfG6QAAAAAAAAAAAAAAAAAAAAAJpNa5CVSWb/i0Nd/6RsU//010/aAAAAAAAAAADcfG3a3Xxw/918df/efH3/3n2FfAAAAAAAAAAAAAAAAAAAAACKQl18klNU/9OqT//84E///eFP2gAAAAAAAAAA3Xx42t58ff/efYP/332N/8dteLCjVTcOAAAAAAAAAADrt0oO1qRMsPHKTf/3003/+NZO//nYTtoAAAAAAAAAAN59gdbefYf/332P/+B+mf+2Ymj/r1w66M55Q5DdlUeQ5qlJ6Oy4Sv/wwUv/8shM//TMTf/20E3WAAAAAAAAAADffYqa332Q/+B9mP/hfqL/tmJs/7FeOv/Qe0P/3JJG/+KhSP/orkn/7LhK/++/S//xxEz/8shMmgAAAAAAAAAA332REuB9mLjgfqD/4X6p/7ZibP+yYDv/0H1D/9uQRv/gnUf/5adJ/+mwSv/suEr/7r5LuPDDSxIAAAAAAAAAAAAAAADfgJ8C4X6lUOF+rNy9Z3T/smE7/9F+Q//bj0b/35lH/+OjSP/mq0nc6bJKUO+3UAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADhfqoI1HaTdrdlQvLRfkP/245G/96XR/Lhn0h25KVJCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBbkMY0n9EcNqORnDdlEcYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//8AAPw/AADwDwAAwAMAAIABAACBgQAAg8EAAIPBAACH4QAAg8EAAIABAACAAQAAwAMAAPAPAAD8PwAA//8AAA=='
        $CheckBox_EnableTelemetry_IconBytes = [Convert]::FromBase64String($CheckBox_EnableTelemetry_Icon64)
        $CheckBox_EnableTelemetry_IconStream = [System.IO.MemoryStream]::new($CheckBox_EnableTelemetry_IconBytes, 0, $CheckBox_EnableTelemetry_IconBytes.Length)
        $CheckBox_EnableTelemetry.Image = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($CheckBox_EnableTelemetry_IconStream).GetHIcon()))
        $CheckBox_EnableTelemetry.ImageAlign = 'MiddleLeft'
        $CheckBox_EnableTelemetry.Text = '    Enable Telemetry'
        $CheckBox_EnableTelemetry.TextAlign = 'MiddleLeft'
        $CheckBox_EnableTelemetry.CheckAlign = 'MiddleLeft'
        $CheckBox_EnableTelemetry.Checked = $false
        $CheckBox_EnableTelemetry.Enabled = $false
        $Panel_OfficeSelection.Controls.Add($CheckBox_EnableTelemetry)
        
        $CheckBox_EnableTelemetry.Add_Click( {
                if ($CheckBox_EnableTelemetry.Checked -eq $true) {
                    $CheckBox_DisableTelemetry.Enabled = $false
                }
                elseif ($CheckBox_EnableTelemetry.Checked -eq $false) {
                    $CheckBox_DisableTelemetry.Enabled = $true
                }   
            }
        )
        
        $Form_OfficeSelection_OK = New-Object System.Windows.Forms.Button
        $Form_OfficeSelection_OK.Location = New-Object System.Drawing.Size((($Form_OfficeSelection.Width) / 3 ), (($Form_OfficeSelection.height) - 65))
        $Form_OfficeSelection_OK.Size = New-Object System.Drawing.Size(57, 20)
        $Form_OfficeSelection_OK.Text = 'OK'
        $Form_OfficeSelection_OK.Add_Click({ $Form_OfficeSelection.Close() })
        $Form_OfficeSelection.Controls.Add($Form_OfficeSelection_OK)
        
        $Form_OfficeSelection_Cancel = New-Object System.Windows.Forms.Button
        $Form_OfficeSelection_Cancel.Location = New-Object System.Drawing.Size((($Form_OfficeSelection.Width) / 2 ), (($Form_OfficeSelection.height) - 65))
        $Form_OfficeSelection_Cancel.Size = New-Object System.Drawing.Size(57, 20)
        $Form_OfficeSelection_Cancel.Text = 'Cancel'
        $Form_OfficeSelection_Cancel.Add_Click({ $Form_OfficeSelection.Close() })
        $Form_OfficeSelection.Controls.Add($Form_OfficeSelection_Cancel)
        
        $Form_OfficeSelection_OK.Add_Click{
            if ($CheckBox_Microsoft365ProPlus.Checked) {
                Write-Host 'Office Selection: Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word): Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'O365ProPlus') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\O365ProPlus.exe")
                
                Write-Host 'Office Selection: Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word): Installing' -ForegroundColor green 
                Start-Process $env:TEMP\O365ProPlus.exe -Wait
            }
        
            if ($CheckBox_Office2024ProPlus.Checked) {
                Write-Host 'Office Selection: Office 2024 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word): Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'ProPlus2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\ProPlus2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word): Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\ProPlus2024.exe -Wait
            }
        
            if ($CheckBox_Office2024Access.Checked) {
                Write-Host 'Office Selection: Office 2024 - (Access): Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Access2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Access2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - (Access): Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Access2024.exe -Wait
            }
        
            if ($CheckBox_Office2024Excel.Checked) {
                Write-Host 'Office Selection: Office 2024 - Excel: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Excel2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Excel2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - Excel: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Excel2024.exe -Wait
            }
        
            if ($CheckBox_Office2024Outlook.Checked) {
                Write-Host 'Office Selection: Office 2024 - Outlook: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Outlook2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Outlook2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - Outlook: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Outlook2024.exe -Wait
            }
        
            if ($CheckBox_Office2024PowerPoint.Checked) {
                Write-Host 'Office Selection: Office 2024 - PowerPoint: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'PowerPoint2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\PowerPoint2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - PowerPoint: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\PowerPoint2024.exe -Wait
            }
        
            if ($CheckBox_Office2024Word.Checked) {
                Write-Host 'Office Selection: Office 2024 - Word: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Word2024') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Word2024.exe")
        
                Write-Host 'Office Selection: Office 2024 - Word: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Word2024.exe -Wait
            }
        
            if ($CheckBox_Office2021ProPlus.Checked) {
                Write-Host 'Office Selection: Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word): Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'ProPlus2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\ProPlus2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word): Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\ProPlus2021.exe -Wait
            }
        
            if ($CheckBox_Office2021Access.Checked) {
                Write-Host 'Office Selection: Office 2021 - (Access): Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Access2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Access2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - (Access): Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Access2021.exe -Wait
            }
        
            if ($CheckBox_Office2021Excel.Checked) {
                Write-Host 'Office Selection: Office 2021 - Excel: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Excel2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Excel2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - Excel: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Excel2021.exe -Wait
            }
        
            if ($CheckBox_Office2021OneNote.Checked) {
                Write-Host 'Office Selection: Office 2021 - OneNote: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'OneNote2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\OneNote2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - OneNote: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\OneNote2021.exe -Wait
            }
        
            if ($CheckBox_Office2021Outlook.Checked) {
                Write-Host 'Office Selection: Office 2021 - Outlook: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Outlook2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Outlook2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - Outlook: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Outlook2021.exe -Wait
            }
        
            if ($CheckBox_Office2021PowerPoint.Checked) {
                Write-Host 'Office Selection: Office 2021 - PowerPoint: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'PowerPoint2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\PowerPoint2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - PowerPoint: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\PowerPoint2021.exe -Wait
            }
        
            if ($CheckBox_Office2021Publisher.Checked) {
                Write-Host 'Office Selection: Office 2021 - Publisher: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Publisher2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Publisher2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - Publisher: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Publisher2021.exe -Wait
            }
        
            if ($CheckBox_Office2021Word.Checked) {
                Write-Host 'Office Selection: Office 2021 - Word: Downloading' -ForegroundColor green -BackgroundColor black
                (New-Object System.Net.WebClient).DownloadFile(((Invoke-WebRequest -UseBasicParsing -Uri 'https://gravesoft.dev/office_c2r_links' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Word2021') } | Select-Object -First 1 | Select-Object -ExpandProperty href)).Replace('amp;', ''), "$env:TEMP\Word2021.exe")
        
                Write-Host 'Office Selection: Office 2021 - Word: Installing' -ForegroundColor green -BackgroundColor black
                Start-Process $env:TEMP\Word2021.exe -Wait
            }
        
            if ($CheckBox_ActivateOffice.Checked) {
                Write-Host 'Office Selection: Activating' -ForegroundColor green -BackgroundColor black
                & ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://get.activated.win/')))) /Ohook
            }
        
            if ($CheckBox_DisableTelemetry.Checked) {
                Write-Host 'Office Selection: Disabling Telemetry' -ForegroundColor green -BackgroundColor black
                Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_DisableTelemetry.ps1')
            }
        
            if ($CheckBox_EnableTelemetry.Checked) {
                Write-Host 'Office Selection: Enabling Telemetry' -ForegroundColor green -BackgroundColor black
                Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_RevertTelemetry.ps1')
            }
        
        }
        
        $Form_OfficeSelection.Add_Shown({ $Form_OfficeSelection.Activate() })
        [void] $Form_OfficeSelection.ShowDialog()

    }

    if ($CheckBox_AdobeAcrobat.Checked) {
        Write-Host 'Adobe Acrobat: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
        
        Write-Host 'Adobe Acrobat: Getting magnet' -ForegroundColor green -BackgroundColor black
        $Adrobat1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Acrobat' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'x64') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        $Adrobat2 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        if ($null -eq $Adrobat2) {
            $Adrobat2 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        }
        $Adrobat3 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        
        Write-Host 'Adobe Acrobat: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
        if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
            Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
        }
        
        Write-Host 'Adobe Acrobat: Deleting temp folder' -ForegroundColor green -BackgroundColor black
        Remove-Item -Path "$env:TEMP\*Acrobat*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
        
        Write-Host 'Adobe Acrobat: Opening magnet' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Adrobat3)"""
        
        Write-Host 'Adobe Acrobat: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat*' -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        $AcrobatTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Acrobat: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Add-MpPreference -ExclusionPath "$AcrobatTempDir"
        
        Write-Host 'Adobe Acrobat: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
        While ($null -eq (Get-ChildItem -Path "$AcrobatTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        $AcrobatTempISO = Get-ChildItem -Path "$AcrobatTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Acrobat: Waiting download to complete' -ForegroundColor green -BackgroundColor black
        $null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Acrobat*' } | Select-Object -First 1
        
        Write-Host 'Adobe Acrobat: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
        
        Write-Host 'Adobe Acrobat: Extracting ISO' -ForegroundColor green -BackgroundColor black
        & "$env:ProgramFiles\7-Zip\7z.exe" x "$AcrobatTempISO" -o"$AcrobatTempDir" -y
            
        Write-Host 'Adobe Acrobat: Opening Installer' -ForegroundColor green -BackgroundColor black
        $AcrobatTEMPinstaller = Get-ChildItem -Path "$AcrobatTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
        Start-Process $AcrobatTEMPinstaller
            
        Write-Host 'Adobe Acrobat: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Acrobat * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Acrobat: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Acrobat * Installer' } -ErrorAction SilentlyContinue))) {
            Write-Host 'Adobe Acrobat: Installing' -ForegroundColor green -BackgroundColor black
            $wshell = New-Object -ComObject wscript.shell
            $wshell.SendKeys('{ENTER}')
            Start-Sleep -Milliseconds 1000
        }
            
        Write-Host 'Adobe Acrobat: Waiting for process to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Acrobat: Waiting for process to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
            
        Write-Host 'Adobe Acrobat: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Remove-MpPreference -ExclusionPath "$AcrobatTempDir"

        # https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/index.html
        # https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/FeatureLockDown.html#idkeyname_1_13262
        Write-Host 'Adobe Acrobat: Turn off the generative AI features' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -LiteralPath 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown') -ne $true) {
            New-Item 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Force
        }
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bEnableGentech' -PropertyType DWord -Value 0

        Write-Host 'Adobe Acrobat: Preferences: Catalog: Enable Logging: Off' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Force
        }
        New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Name 'bCreateLog' -Value 0 -PropertyType DWord -Force

        Write-Host 'Adobe Acrobat: Preferences: Page Display: Zoom: Fit Visible' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
        }
        New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'iDefaultZoomType' -Value '4' -PropertyType String -Force

        Write-Host 'Adobe Acrobat: General: Show me messages when I launch Adobe Acrobat: Disable' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Force
        }
        New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Name 'bShowMsgAtLaunch' -Value 0 -PropertyType DWord -Force

        Write-Host 'Adobe Acrobat: Edit: Prefrences: Security (Enhanced): Protected View: All Files' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force 
        }
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force
    }
    
    if ($CheckBox_AdobeLightroomClassic.Checked) {
        Write-Host 'Adobe Lightroom Classic: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
        
        Write-Host 'Adobe Lightroom Classic: Getting magnet' -ForegroundColor green -BackgroundColor black
        $Lightroom_Classic1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Lightroom' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Classic') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        $Lightroom_Classic2 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        if ($null -eq $Lightroom_Classic2) {
            $Lightroom_Classic2 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        }
        $Lightroom_Classic3 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        
        Write-Host 'Adobe Lightroom Classic: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
        if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
            Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
        }
        
        Write-Host 'Adobe Lightroom Classic: Deleting temp folder' -ForegroundColor green -BackgroundColor black
        Remove-Item -Path "$env:TEMP\*Classic*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
        
        Write-Host 'Adobe Lightroom Classic: Opening magnet' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Lightroom_Classic3)"""
        
        Write-Host 'Adobe Lightroom Classic: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Classic*' -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        $Lightroom_ClassicTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Classic*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Lightroom Classic: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Add-MpPreference -ExclusionPath "$Lightroom_ClassicTempDir"
        
        Write-Host 'Adobe Lightroom Classic: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
        While ($null -eq (Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        $Lightroom_ClassicTempISO = Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Lightroom Classic: Waiting download to complete' -ForegroundColor green -BackgroundColor black
        $null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Classic*' } | Select-Object -First 1
        
        Write-Host 'Adobe Lightroom Classic: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
        
        Write-Host 'Adobe Lightroom Classic: Extracting ISO' -ForegroundColor green -BackgroundColor black
        & "$env:ProgramFiles\7-Zip\7z.exe" x "$Lightroom_ClassicTempISO" -o"$Lightroom_ClassicTempDir" -y
            
        Write-Host 'Adobe Lightroom Classic: Opening Installer' -ForegroundColor green -BackgroundColor black
        $Lightroom_ClassicTempInstaller = Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
        Start-Process $Lightroom_ClassicTempInstaller
            
        Write-Host 'Adobe Lightroom Classic: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Lightroom Classic: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
            Write-Host 'Adobe Lightroom Classic: Installing' -ForegroundColor green -BackgroundColor black
            $wshell = New-Object -ComObject wscript.shell
            $wshell.SendKeys('{ENTER}')
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Lightroom Classic: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Lightroom Classic: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
            
        Write-Host 'Adobe Lightroom Classic: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Remove-MpPreference -ExclusionPath "$Lightroom_ClassicTempDir"
    }

    if ($CheckBox_AdobePhotoshop.Checked) {
        Write-Host 'Adobe Photoshop: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
        
        Write-Host 'Adobe Photoshop: Getting magnet' -ForegroundColor green -BackgroundColor black
        $Photoshop1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Photoshop' | Select-Object -ExpandProperty Links | Where-Object { (($_.outerHTML -notmatch 'Elements') -and ($_.outerHTML -notmatch 'Collection') -and ($_.outerHTML -match 'Multilingual')) } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        $Photoshop2 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        if ($null -eq $Photoshop2) {
            $Photoshop2 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        }
        $Photoshop3 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        
        Write-Host 'Adobe Photoshop: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
        if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
            Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
        }
        
        Write-Host 'Adobe Photoshop: Deleting temp folder' -ForegroundColor green -BackgroundColor black
        Remove-Item -Path "$env:TEMP\*Photoshop*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
        
        Write-Host 'Adobe Photoshop: Opening magnet' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Photoshop3)"""
        
        Write-Host 'Adobe Photoshop: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Photoshop*' -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        $PhotoshopTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Photoshop*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Photoshop: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Add-MpPreference -ExclusionPath "$PhotoshopTempDir"
        
        Write-Host 'Adobe Photoshop: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
        While ($null -eq (Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        $PhotoshopTempISO = Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'Adobe Photoshop: Waiting download to complete' -ForegroundColor green -BackgroundColor black
        $null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Photoshop*' } | Select-Object -First 1
        
        Write-Host 'Adobe Photoshop: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
        
        Write-Host 'Adobe Photoshop: Extracting ISO' -ForegroundColor green -BackgroundColor black
        & "$env:ProgramFiles\7-Zip\7z.exe" x "$PhotoshopTempISO" -o"$PhotoshopTempDir" -y
            
        Write-Host 'Adobe Photoshop: Opening Installer' -ForegroundColor green -BackgroundColor black
        $PhotoshopTempInstaller = Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
        Start-Process $PhotoshopTempInstaller
            
        Write-Host 'Adobe Photoshop: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Photoshop: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
            Write-Host 'Adobe Photoshop: Installing' -ForegroundColor green -BackgroundColor black
            $wshell = New-Object -ComObject wscript.shell
            $wshell.SendKeys('{ENTER}')
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Photoshop: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        
        Write-Host 'Adobe Photoshop: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
        while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
            
        Write-Host 'Adobe Photoshop: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Remove-MpPreference -ExclusionPath "$PhotoshopTempDir"
    }

    if ($CheckBox_JitBit_Macro_Recorder.Checked) {
        Write-Host 'JitBit Macro Recorder: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
        
        Write-Host 'JitBit Macro Recorder: Getting magnet' -ForegroundColor green -BackgroundColor black
        $JitBit1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://rutracker.org/forum/viewtopic.php?t=6357418' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
        
        Write-Host 'JitBit Macro Recorder: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
        if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
            Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
        }
        
        Write-Host 'JitBit Macro Recorder: Deleting temp folder' -ForegroundColor green -BackgroundColor black
        Remove-Item -Path "$env:TEMP\*JitBit*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
        
        Write-Host 'JitBit Macro Recorder: Opening magnet' -ForegroundColor green -BackgroundColor black
        Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($JitBit1)"""
        
        Write-Host 'JitBit Macro Recorder: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*JitBit*' -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        $JitBitTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*JitBit*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'JitBit Macro Recorder: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Add-MpPreference -ExclusionPath "$JitBitTempDir"
        
        Write-Host 'JitBit Macro Recorder: Waiting for installer file to be created' -ForegroundColor green -BackgroundColor black
        While ($null -eq (Get-ChildItem -Path "$JitBitTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        $JitBitTempInstaller = Get-ChildItem -Path "$JitBitTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
        
        Write-Host 'JitBit Macro Recorder: Waiting download to complete' -ForegroundColor green -BackgroundColor black
        $null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*JitBit*' } | Select-Object -First 1
        
        Write-Host 'JitBit Macro Recorder: Installing' -ForegroundColor green -BackgroundColor black
        Start-Process $JitBitTempInstaller -ArgumentList '/verysilent /Tasks=create_start_menu_entry' -Wait
        
        Write-Host 'JitBit Macro Recorder: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
        Remove-MpPreference -ExclusionPath "$JitBitTempDir"
        
        Write-Host 'Jitbit Macro Recorder: Settings: General: Disable the welcome screen: On' -ForegroundColor green -BackgroundColor black
        if ((Test-Path -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder') -ne $true) {
            New-Item 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Force 
        }
        
        Write-Host 'Jitbit Macro Recorder: Disabling Startup Screen' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'DisableStartupScreen' -Value 'True' -PropertyType String -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Playback settings: Continuous reply: Infinite playback' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'NumberOfPlaybacks' -Value 0 -PropertyType DWord -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Playback settings: Hide the topmost playing... bar: Off' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'HidePlayWnd' -Value 'False' -PropertyType String -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: General: Move the playback toolbar to the right: On' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PlayRecFormsOnTheRight' -Value 'True' -PropertyType String -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Play / Pause / Resume playback: F8' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PausePlayKey' -Value 119 -PropertyType DWord -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort playback: F9' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortPlayKey' -Value 120 -PropertyType DWord -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Step-by-step playback: F10' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'StepByStepPlayKey' -Value 121 -PropertyType DWord -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Start / Pause / Resume recording: F11' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'RecordKey' -Value 122 -PropertyType DWord -Force
        
        Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort recording: F12' -ForegroundColor green -BackgroundColor black
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortRecKey' -Value 123 -PropertyType DWord -Force
    }

}

$Form_SoftwareSelection.Add_Shown({ $Form_SoftwareSelection.Activate() })
[void] $Form_SoftwareSelection.ShowDialog()