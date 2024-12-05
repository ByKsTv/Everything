if ((Get-WmiObject -Class Win32_OperatingSystem).ProductType -eq 3) {
    & ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /KMS38
}
else {
    & ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /HWID
}  