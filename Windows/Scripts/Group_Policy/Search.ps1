Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
	Text            = 'Search Policy'
	Font            = [Drawing.Font]::new('Tahoma', 11)
	Width           = 200
	Height          = 90
	StartPosition   = 'CenterScreen'
	FormBorderStyle = 'FixedDialog'
	Topmost         = $true
	MaximizeBox     = $false
	MinimizeBox     = $false
	ControlBox      = $false
}

$ButtonSpacer = 15
$ButtonWidth = 57
$TotalButtonWidth = $ButtonSpacer + $ButtonWidth + $ButtonWidth
$FormCenterX = [math]::Round(($Form.ClientSize.Width - $TotalButtonWidth) / 2)
$ButtonHeight = 20
$ButtonYLocation = $Form.Height - 60

$OK = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'OK'
	Width     = $ButtonWidth
	Height    = $ButtonHeight
	Location  = [Drawing.Point]::new($FormCenterX, $ButtonYLocation)
	Add_Click = ({ $Form.Close() })
}

$CancelX = $FormCenterX + $ButtonWidth + $ButtonSpacer
$Cancel = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'Cancel'
	Width     = $ButtonWidth
	Height    = $ButtonHeight
	Location  = [Drawing.Point]::new($CancelX, $ButtonYLocation)
	Add_Click = ({ $Form.Close() })
}

$LocX = 5
$LocY = 0
$SizeX = $Form.Width - 25
$SizeY = 26

$TextBox = New-Object System.Windows.Forms.TextBox -Property @{
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$Form.Controls.Add($OK)
$Form.Controls.Add($Cancel)

$Form.Controls.Add($TextBox)

[void] $Form.ShowDialog()

$UserDefined = $TextBox.Text
if ($UserDefined) {
	$UserDefined = "$UserDefined"
	$Dir = Get-ChildItem -Path "$env:windir\PolicyDefinitions" -Recurse -File
	foreach ($File in $Dir) {
		try {
			if ((Get-Content $File.FullName -ErrorAction Stop) -match $UserDefined) {
				Write-Host "Found '$UserDefined' in: $($File.FullName)" -ForegroundColor Green
			}
		} catch {
			Write-Host "Error reading: $($File.FullName)" -ForegroundColor Red
		}
	}
}
