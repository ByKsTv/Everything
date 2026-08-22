# Remove 'Get Started' app
# Remove 'Windows Backup' app

# Administrative Shares: Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareWks' -Value '0' -PropertyType DWord -Force
