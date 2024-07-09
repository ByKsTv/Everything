Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_OfficeSelection = New-Object System.Windows.Forms.Form
$Form_OfficeSelection.width = 900
$Form_OfficeSelection.height = 400
$Form_OfficeSelection.Text = 'Office Selection'
$Form_OfficeSelection.StartPosition = 'CenterScreen'
$Form_OfficeSelection.Font = New-Object System.Drawing.Font('Tahoma', 11)

$CheckBox_X_Axis = 5
$CheckBox_Y_Axis = 0
$CheckBox_Size_X = (($Form_OfficeSelection.width) - 50)
$CheckBox_Size_Y = 26
# Icons size 16x16, format .ico from .exe file use 7zip
# [Convert]::ToBase64String((Get-Content "path" -Encoding Byte)) | Clip

$Panel_OfficeSelection = New-Object System.Windows.Forms.Panel
$Panel_OfficeSelection.Location = New-Object System.Drawing.Size(0, 0)
$Panel_OfficeSelection.Size = New-Object System.Drawing.Size((($Form_OfficeSelection.width) - 20), (($Form_OfficeSelection.Height) - 65))
$Panel_OfficeSelection.AutoScroll = $true
$Panel_OfficeSelection.AutoSize = $false
$Form_OfficeSelection.Controls.Add($Panel_OfficeSelection)

$CheckBox_Microsoft365ProPlus = New-Object System.Windows.Forms.CheckBox
$CheckBox_Microsoft365ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Microsoft365ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024Access.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024Access.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024Excel.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024Excel.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024Outlook.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024Outlook.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024PowerPoint.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024PowerPoint.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2024Word.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2024Word.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021ProPlus.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021ProPlus.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021Access.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021Access.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021Excel.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021Excel.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021OneNote.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021OneNote.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021Outlook.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021Outlook.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021PowerPoint.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021PowerPoint.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021Publisher.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021Publisher.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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
$CheckBox_Office2021Word.Location = New-Object System.Drawing.Size($CheckBox_X_Axis, $CheckBox_Y_Axis)
$CheckBox_Y_Axis += 22
$CheckBox_Office2021Word.Size = New-Object System.Drawing.Size($CheckBox_Size_X, $CheckBox_Size_Y)
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

	Write-Host 'Office Selection: Activating' -ForegroundColor green -BackgroundColor black
	& ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://get.activated.win/')))) /Ohook

	Write-Host 'Office Selection: Disabling Telemetry' -ForegroundColor green -BackgroundColor black
	Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_DisableTelemetry.ps1')
}

$Form_OfficeSelection.Add_Shown({ $Form_OfficeSelection.Activate() })
[void] $Form_OfficeSelection.ShowDialog()