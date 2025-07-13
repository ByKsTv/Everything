Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore

$DDL = 'https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

Expand-Archive -Path $SavePath -DestinationPath $env:TEMP -Force

Move-Item -Path "$env:TEMP\LGPO_30\LGPO.exe" -Destination $env:TEMP -Force

Remove-Item -Path "$env:TEMP\LGPO_30", "$env:TEMP\LGPO.zip" -Recurse -Force

function Set-Policy {
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		[ValidateSet('Computer', 'User')]
		$Scope,

		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 3
		)]
		[string]
		$Name,

		[Parameter(
			Mandatory = $true,
			Position = 4
		)]
		[ValidateSet('DWORD', 'SZ', 'EXSZ', 'CLEAR')]
		[string]
		$Type,

		[Parameter(
			Mandatory = $false,
			Position = 5
		)]
		$Value
	)

	switch ($Type) {
		'CLEAR' {
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type)`n
"@
		}
		default {
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type):$($Value)`n
"@
		}
	}

	if ($Scope -eq 'Computer') {
		$Path = "$env:TEMP\Computer.txt"
	}
	else {
		$Path = "$env:TEMP\User.txt"
	}

	Add-Content -Path $Path -Value $Policy -Encoding Default -Force
}