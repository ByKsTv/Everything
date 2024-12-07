if ((Test-Path -Path "$env:TEMP\Computer.txt") -or (Test-Path -Path "$env:TEMP\User.txt")) {
	if (Test-Path -Path "$env:TEMP\Computer.txt") {
		& "$env:TEMP\LGPO.exe" /t "$env:TEMP\Computer.txt"
	}
	if (Test-Path -Path "$env:TEMP\User.txt") {
		& "$env:TEMP\LGPO.exe" /t "$env:TEMP\User.txt"
	}

	gpupdate.exe /force
}

Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore