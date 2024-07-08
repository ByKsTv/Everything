Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_SoftwareSelection = New-Object System.Windows.Forms.Form
$Form_SoftwareSelection.width = 310
$Form_SoftwareSelection.height = 500
$Form_SoftwareSelection.Text = 'Software Selection'
$Form_SoftwareSelection.StartPosition = 'CenterScreen'
$Form_SoftwareSelection.Font = New-Object System.Drawing.Font('Tahoma', 10)

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
$CheckBox_X_Axis = 5
$CheckBox_Y_Axis = 0
$CheckBox_Size_X = (($Form_SoftwareSelection.width) - 50)
$CheckBox_Size_Y = 26
# Icons size 16x16, format .ico from .exe file use 7zip
# [Convert]::ToBase64String((Get-Content "path" -Encoding Byte)) | Clip

# Create panel
$Panel_SoftwareSelection = New-Object System.Windows.Forms.Panel
$Panel_SoftwareSelection.Location = New-Object System.Drawing.Size(0, 0)
$Panel_SoftwareSelection.Size = New-Object System.Drawing.Size((($Form_SoftwareSelection.width) - 20), (($Form_SoftwareSelection.Height) - 65))
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
$CheckBox_AdobeAcrobat.Text = '    Adobe Acrobat'
$CheckBox_AdobeAcrobat.TextAlign = 'MiddleLeft'
$CheckBox_AdobeAcrobat.CheckAlign = 'MiddleLeft'
$CheckBox_AdobeAcrobat.Checked = $false
$Panel_SoftwareSelection.Controls.Add($CheckBox_AdobeAcrobat)

if ($InstalledSoftware -match 'Adobe Acrobat') {
    $CheckBox_AdobeAcrobat.Enabled = $false
    $CheckBox_AdobeAcrobat.Text += ' (Installed)'
}

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

if ($InstalledSoftware -match 'Adobe Photoshop') {
    $CheckBox_AdobePhotoshop.Enabled = $false
    $CheckBox_AdobePhotoshop.Text += ' (Installed)'
}

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

if ($InstalledSoftware -match 'Microsoft Office' -or $InstalledSoftware -match 'Microsoft 365') {
    $CheckBox_MicrosoftOffice.Enabled = $false
    $CheckBox_MicrosoftOffice.Text += ' (Installed)'
}

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

if ($InstalledSoftware -match 'Plex') {
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
$Form_SoftwareSelection_OK.Size = New-Object System.Drawing.Size(53, 20)
$Form_SoftwareSelection_OK.Text = 'OK'
$Form_SoftwareSelection_OK.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_OK)

$Form_SoftwareSelection_Cancel = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_Cancel.Location = New-Object System.Drawing.Size((($Form_SoftwareSelection.Width) / 2 ), (($Form_SoftwareSelection.height) - 65))
$Form_SoftwareSelection_Cancel.Size = New-Object System.Drawing.Size(53, 20)
$Form_SoftwareSelection_Cancel.Text = 'Cancel'
$Form_SoftwareSelection_Cancel.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_Cancel)

$Form_SoftwareSelection_OK.Add_Click{
    # Priority: Browser required, manual input
    if ($CheckBox_NVCleanstall.Checked) {
        Write-Host 'Software Selection: NVCleanstall: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')
    }

    # Priority: Browser required, manual input
    if ($CheckBox_Plex.Checked) {
        Write-Host 'Software Selection: Plex: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_mpv.Checked) {
        Write-Host 'Software Selection: mpv: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_RazerSynapse.Checked) {
        Write-Host 'Software Selection: Razer Synapse: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Razer_Synapse/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_HyperXNGENUITY.Checked) {
        Write-Host 'Software Selection: HyperX NGENUITY: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/HyperX_NGENUITY/Download.ps1')
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
        Write-Host 'Software Selection: AnyDesk: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/AnyDesk/Download.ps1')
    }

    if ($CheckBox_BattleNet.Checked) {
        Write-Host 'Software Selection: Battle.net: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Battle.net/Download.ps1')
    }

    if ($CheckBox_CrystalDiskInfo.Checked) {
        Write-Host 'Software Selection: CrystalDiskInfo: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskInfo/Download.ps1')
    }

    if ($CheckBox_CrystalDiskMark.Checked) {
        Write-Host 'Software Selection: CrystalDiskMark: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskMark/Download.ps1')
    }
    
    if ($CheckBox_Discord.Checked) {
        Write-Host 'Software Selection: Discord: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
    }

    if ($CheckBox_BetterDiscord.Checked) {
        Write-Host 'Software Selection: BetterDiscord: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/Download.ps1')
    }

    if ($CheckBox_DisplayDriverUninstaller.Checked) {
        Write-Host 'Software Selection: Display Driver Uninstaller: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Download.ps1')
    }

    if ($CheckBox_Jellyfin.Checked) {
        Write-Host 'Software Selection: Jellyfin: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Jellyfin/Download.ps1')
    }

    if ($CheckBox_LogitechGHUB.Checked) {
        Write-Host 'Software Selection: Logitech G HUB: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Logitech_G_HUB/Download.ps1')
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
        Write-Host 'Software Selection: Microsoft Store: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Microsoft_Store/Download.ps1')
    }

    if ($CheckBox_NordVPN.Checked) {
        Write-Host 'Software Selection: NordVPN: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NordVPN/Download.ps1')
    }

    if ($CheckBox_NotepadPlusPlus.Checked) {
        Write-Host 'Software Selection: Notepad++: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad++/Download.ps1')
    }

    if ($CheckBox_PuTTY.Checked) {
        Write-Host 'Software Selection: PuTTY: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/PuTTY/Download.ps1')
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
        Write-Host 'Software Selection: Steam: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Steam/Download.ps1')
    }

    if ($CheckBox_SubtitleEdit.Checked) {
        Write-Host 'Software Selection: Subtitle Edit: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Subtitle_Edit/Download.ps1')
    }

    if ($CheckBox_Telegram.Checked) {
        Write-Host 'Software Selection: Telegram: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Telegram/Download.ps1')
    }

    if ($CheckBox_TranslucentTB.Checked) {
        Write-Host 'Software Selection: TranslucentTB: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/TranslucentTB/Download.ps1')
    }
    
    if ($CheckBox_VisualStudioCode.Checked) {
        Write-Host 'Software Selection: Visual Studio Code: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')
    }

    if ($CheckBox_UninstallEdge.Checked) {
        Write-Host 'Software Selection: Microsoft Edge: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Edge/Uninstall.ps1')
    }
    
    # Priority: Manual input
    if ($CheckBox_MicrosoftOffice.Checked) {
        Write-Host 'Software Selection: Microsoft Office: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1')
    }

    if ($CheckBox_AdobeAcrobat.Checked) {
        Write-Host 'Software Selection: Adobe Acrobat: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Adobe_Acrobat/Download.ps1')
    }

    if ($CheckBox_AdobePhotoshop.Checked) {
        Write-Host 'Software Selection: Adobe Photoshop: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Adobe_Photoshop/Download.ps1')
    }

    if ($CheckBox_JitBit_Macro_Recorder.Checked) {
        Write-Host 'Software Selection: JitBit Macro Recorder: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/JitBit_Macro_Recorder/Download.ps1')
    }

}

$Form_SoftwareSelection.Add_Shown({ $Form_SoftwareSelection.Activate() })
[void] $Form_SoftwareSelection.ShowDialog()