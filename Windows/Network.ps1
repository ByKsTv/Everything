Write-Host 'IPv4 > MTU > 1500' -ForegroundColor green -BackgroundColor black
$AdapterName = $(Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).Name
netsh interface ipv4 set subinterface "$AdapterName" mtu=1500 store=persistent
Write-Host 'IPv6 > MTU > 1500' -ForegroundColor green -BackgroundColor black
netsh interface ipv6 set subinterface "$AdapterName" mtu=1500 store=persistent
Write-Host 'Congestion Provider > None' -ForegroundColor green -BackgroundColor black
netsh int tcp set supplemental internet congestionprovider=None
Write-Host 'DCA > Disabled' -ForegroundColor green -BackgroundColor black
netsh int tcp set global dca=Disabled
Write-Host 'Teredo > Disabled' -ForegroundColor green -BackgroundColor black
netsh interface teredo set state disabled
$NetworkSettingsName = Get-NetAdapterAdvancedProperty | Select-Object -Property 'DisplayName'
if ($NetworkSettingsName -match 'ARP Offload') {
	Write-Host 'ARP Offload > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'ARP Offload' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Adaptive Inter-Frame Spacing') {
	Write-Host 'Adaptive Inter-Frame Spacing > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Adaptive Inter-Frame Spacing' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'DMA Coalescing') {
	Write-Host 'DMA Coalescing > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'DMA Coalescing' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'ECMA') {
	Write-Host 'ECMA > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'ECMA' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Energy Efficient Ethernet') {
	Write-Host 'Energy Efficient Ethernet > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Energy Efficient Ethernet') {
	Write-Host 'Energy Efficient Ethernet > Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Energy Efficient Ethernet' -DisplayValue 'Off'
}
if ($NetworkSettingsName -match 'Flow Control') {
	Write-Host 'Flow Control > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Flow Control' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Gigabit Master Slave Mode') {
	Write-Host 'Gigabit Master Slave Mode > Auto Detect' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Gigabit Master Slave Mode' -DisplayValue 'Auto Detect'
}
if ($NetworkSettingsName -match 'IPv4 Checksum Offload') {
	Write-Host 'IPv4 Checksum Offload > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'IPv4 Checksum Offload' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Interrupt Moderation Rate') {
	Write-Host 'Interrupt Moderation Rate > Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Interrupt Moderation Rate' -DisplayValue 'Off'
}
if ($NetworkSettingsName -match 'Interrupt Moderation') {
	Write-Host 'Interrupt Moderation > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Interrupt Moderation' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Jumbo Frame') {
	Write-Host 'Jumbo Frame > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Frame' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Jumbo Packet') {
	Write-Host 'Jumbo Packet > 1514' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Packet' -DisplayValue '1514'
}
if ($NetworkSettingsName -match 'Jumbo Packet') {
	Write-Host 'Jumbo Packet > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Jumbo Packet' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Large Send Offload (IPv4)') {
	Write-Host 'Large Send Offload (IPv4) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload (IPv4)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Large Send Offload v2 (IPv4)') {
	Write-Host 'Large Send Offload v2 (IPv4) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload v2 (IPv4)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Large Send Offload v2 (IPv6)') {
	Write-Host 'Large Send Offload v2 (IPv6) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Large Send Offload v2 (IPv6)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Legacy Switch Compatibility Mode') {
	Write-Host 'Legacy Switch Compatibility Mode > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Legacy Switch Compatibility Mode' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Log Link State Event') {
	Write-Host 'Log Link State Event > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Log Link State Event' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Max IRQ per Second') {
	Write-Host 'Max IRQ per Second > 30000' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Max IRQ per Second' -DisplayValue '30000'
}
if ($NetworkSettingsName -match 'Maximum Number of RSS Queues') {
	Write-Host 'Maximum Number of RSS Queues > 1 Queue' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Maximum Number of RSS Queues' -DisplayValue '1 Queue'
}
if ($NetworkSettingsName -match 'NS Offload') {
	Write-Host 'NS Offload > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'NS Offload' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'PTP Hardware Timestamp') {
	Write-Host 'PTP Hardware Timestamp > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'PTP Hardware Timestamp' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Packet Priority & VLAN') {
	Write-Host 'Packet Priority & VLAN > Packet Priority & VLAN Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Packet Priority & VLAN' -DisplayValue 'Packet Priority & VLAN Disabled'
}
if ($NetworkSettingsName -match 'Protocol ARP Offload') {
	Write-Host 'Protocol ARP Offload > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Protocol ARP Offload' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Protocol NS Offload') {
	Write-Host 'Protocol NS Offload > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Protocol NS Offload' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Receive Buffers') {
	Write-Host 'Receive Buffers > 2048' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Receive Buffers' -DisplayValue '2048'
}
if ($NetworkSettingsName -match 'Receive Side Scaling') {
	Write-Host 'Receive Side Scaling > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Receive Side Scaling' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Reduce Speed On Power Down') {
	Write-Host 'Reduce Speed On Power Down > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Reduce Speed On Power Down' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'SWOI') {
	Write-Host 'SWOI > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'SWOI' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Selective Suspend Idle Timeout') {
	Write-Host 'Selective Suspend Idle Timeout > 5' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Selective Suspend Idle Timeout' -DisplayValue '5'
}
if ($NetworkSettingsName -match 'Selective Suspend') {
	Write-Host 'Selective Suspend > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Selective Suspend' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Software Timestamp') {
	Write-Host 'Software Timestamp > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Software Timestamp' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Speed & Duplex') {
	Write-Host 'Speed & Duplex > 1.0 Gbps Full Duplex' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Speed & Duplex' -DisplayValue '1.0 Gbps Full Duplex'
}
if ($NetworkSettingsName -match 'System Idle Power Saver') {
	Write-Host 'System Idle Power Saver > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'System Idle Power Saver' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'TCP Checksum Offload (IPv4)') {
	Write-Host 'TCP Checksum Offload (IPv4) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'TCP Checksum Offload (IPv6)') {
	Write-Host 'TCP Checksum Offload (IPv6) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'TCP Checksum Offload (IPv6)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Transmit Buffers') {
	Write-Host 'Transmit Buffers > 1024' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Transmit Buffers' -DisplayValue '1024'
}
if ($NetworkSettingsName -match 'Transmit Buffers') {
	Write-Host 'Transmit Buffers > 2048' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Transmit Buffers' -DisplayValue '2048'
}
if ($NetworkSettingsName -match 'UDP Checksum Offload (IPv4)') {
	Write-Host 'UDP Checksum Offload (IPv4) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'UDP Checksum Offload (IPv6)') {
	Write-Host 'UDP Checksum Offload (IPv6) > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'UDP Checksum Offload (IPv6)' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Ultra Low Power Mode') {
	Write-Host 'Ultra Low Power Mode > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Ultra Low Power Mode' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Wait for Link') {
	Write-Host 'Wait for Link > Off' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wait for Link' -DisplayValue 'Off'
}
if ($NetworkSettingsName -match 'Wake from S0ix on Magic Packet') {
	Write-Host 'Wake from S0ix on Magic Packet > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake from S0ix on Magic Packet' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Wake on Link Settings') {
	Write-Host 'Wake on Link Settings > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake on Link Settings' -DisplayValue 'Disabled'
}
if ($NetworkSettingsName -match 'Wake on Pattern Match') {
	Write-Host 'Wake on Pattern Match > Disabled' -ForegroundColor green -BackgroundColor black
	Set-NetAdapterAdvancedProperty -DisplayName 'Wake on Pattern Match' -DisplayValue 'Disabled'
}
Write-Host 'Auto Tuning Level Local > Normal' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -AutoTuningLevelLocal Normal
Write-Host 'Scaling Heuristics > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -ScalingHeuristics Disabled
Write-Host 'Receive Segment Coalescing > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled
Write-Host 'PacketCoalescingFilter > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled
Write-Host 'Receive Side Scaling > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -ReceiveSideScaling Disabled
Write-Host 'Large Send Offload > Disabled' -ForegroundColor green -BackgroundColor black
Disable-NetAdapterLso -Name *
Write-Host 'Checksum Offload > Disabled' -ForegroundColor green -BackgroundColor black
Disable-NetAdapterChecksumOffload -Name *
Write-Host 'EcnCapability > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -EcnCapability Disabled
Write-Host 'Chimney > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetOffloadGlobalSetting -Chimney Disabled
Write-Host 'Timestamps > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -Timestamps Disabled
Write-Host 'MaxSynRetransmissions > 2' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -MaxSynRetransmissions 2
Write-Host 'NonSackRttResiliency > Disabled' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -NonSackRttResiliency Disabled
Write-Host 'InitialRtoMs > 2000' -ForegroundColor green -BackgroundColor black
Set-NetTCPSetting -InitialRtoMs 2000
Write-Host 'Internet Explorer Optimization > MaxConnectionsPer1_0Server > 10' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER') -ne $true) {
 New-Item 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER' -Name 'iexplore.exe' -Value 10 -PropertyType DWord -Force
Write-Host 'Internet Explorer Optimization > MaxConnectionsPerServer > 10' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER') -ne $true) {
 New-Item 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER' -Name 'iexplore.exe' -Value 10 -PropertyType DWord -Force
Write-Host 'Host Resolution Priority > LocalPriority > 4' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 4 -PropertyType DWord -Force
Write-Host 'Host Resolution Priority > HostsPriority > 5' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 5 -PropertyType DWord -Force
Write-Host 'Host Resolution Priority > DnsPriority > 6' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 6 -PropertyType DWord -Force
Write-Host 'Host Resolution Priority > NetbtPriority > 7' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 7 -PropertyType DWord -Force
Write-Host 'QoS > NonBestEffortLimit > 0' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Psched') -ne $true) {
 New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Psched' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Psched' -Name 'NonBestEffortLimit' -Value 0 -PropertyType DWord -Force
Write-Host 'QoS > Do not use NLA > Optimal' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value '1' -PropertyType String -Force
Write-Host 'NetworkThrottlingIndex > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile') -ne $true) {
 New-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value -1 -PropertyType DWord -Force
Write-Host 'SystemResponsiveness > Gaming' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -Force
Write-Host 'Network Memory Allocation > Size > Gaming' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force
Write-Host 'IRPStackSize > 32' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType DWord -Force
Write-Host 'Network Memory Allocation > LargeSystemCache > Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType DWord -Force
Write-Host 'Dynamic Port Allocation > MaxUserPort > 65534' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType DWord -Force
Write-Host 'Dynamic Port Allocation > TcpTimedWaitDelay > 30' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 30 -PropertyType DWord -Force
Write-Host 'Time to Live > 64' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters') -ne $true) {
 New-Item 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Force 
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType DWord -Force
Write-Host 'TcpAckFrequency > Disabled' -ForegroundColor green -BackgroundColor black
$NetworkGUID = (Get-NetAdapter).InterfaceGUID
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force
Write-Host 'TcpDelAckTicks > Disabled' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TcpDelAckTicks' -Value 0 -PropertyType DWord -Force
Write-Host 'TCPNoDelay > Enabled' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$NetworkGUID -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force
Add-Type -AssemblyName System.Windows.Forms
$WakeOnLanAnswer = [System.Windows.Forms.MessageBox]::Show('Enable Wake-On-Lan?

Wake-on-LAN is an Ethernet computer networking standard that allows this PC to be turned on by a network message.
' , 'Wake-On-Lan' , 4, 32)
if ($WakeOnLanAnswer -eq 'Yes') {
	Write-Host 'Wake-On-Lan > On' -ForegroundColor green -BackgroundColor black
	$PnPValue = 256
	$Adapter = Get-NetAdapter | Where-Object { ($_.Status -eq 'Up') }
	$KeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\'
	foreach ($Entry in (Get-ChildItem $KeyPath -ErrorAction SilentlyContinue).Name) {
		if ((Get-ItemProperty REGISTRY::$Entry).DriverDesc -eq $Adapter.InterfaceDescription) {
			$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			if ($Value -ne $PnPValue) {
				Set-ItemProperty -Path REGISTRY::$Entry -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			}
			if ($Value -eq $PnPValue) {
				Write-Host 'Allow the computer to turn off this device to save power > On' -ForegroundColor green -BackgroundColor black
				Write-Host 'Allow this device to wake the computer > On' -ForegroundColor green -BackgroundColor black
				Write-Host 'Only allow a magic packet to wake the computer > On' -ForegroundColor green -BackgroundColor black
			}
			else {
				Write-Host 'Failed'
			}
		}
	}
	if ($NetworkSettingsName -match 'Wake on magic packet') {
		Write-Host 'Wake on magic packet > On' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Wake on magic packet' -DisplayValue 'Enabled'
	}
	if ($NetworkSettingsName -match 'Enable PME') {
		Write-Host 'Enable PME > On' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Enable PME' -DisplayValue 'Enabled'
	}
	if ($NetworkSettingsName -match 'Shutdown Wake Up') {
		Write-Host 'Shutdown Wake Up > Enabled' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Shutdown Wake Up' -DisplayValue 'Enabled'
	}
}
if ($WakeOnLanAnswer -eq 'No') {
	Write-Host 'Wake-On-Lan > Off' -ForegroundColor green -BackgroundColor black
	$PnPValue = 24
	$Adapter = Get-NetAdapter | Where-Object { ($_.Status -eq 'Up') }
	$KeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\'
	foreach ($Entry in (Get-ChildItem $KeyPath -ErrorAction SilentlyContinue).Name) {
		if ((Get-ItemProperty REGISTRY::$Entry).DriverDesc -eq $Adapter.InterfaceDescription) {
			$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			if ($Value -ne $PnPValue) {
				Set-ItemProperty -Path REGISTRY::$Entry -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			}
			if ($Value -eq $PnPValue) {
				Write-Host 'Allow the computer to turn off this device to save power > Off' -ForegroundColor green -BackgroundColor black
				Write-Host 'Allow this device to wake the computer > Off' -ForegroundColor green -BackgroundColor black
				Write-Host 'Only allow a magic packet to wake the computer > Off' -ForegroundColor green -BackgroundColor black
			}
			else {
				Write-Host 'Failed'
			}
		}
	}
	if ($NetworkSettingsName -match 'Wake on magic packet') {
		Write-Host 'Wake on magic packet > Off' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Wake on magic packet' -DisplayValue 'Disabled'
	}
	if ($NetworkSettingsName -match 'Enable PME') {
		Write-Host 'Enable PME > Off' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Enable PME' -DisplayValue 'Disabled'
	}
	if ($NetworkSettingsName -match 'Shutdown Wake Up') {
		Write-Host 'Shutdown Wake Up > Disabled' -ForegroundColor green -BackgroundColor black
		Set-NetAdapterAdvancedProperty -DisplayName 'Shutdown Wake Up' -DisplayValue 'Disabled'
	}
}
Write-Host 'Wait until networking is available' -ForegroundColor green -BackgroundColor black
# https://gist.github.com/larsks/4011808
while (1) {
	if ( ((Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter DHCPEnabled=TRUE | Where-Object { $_.DefaultIPGateway -ne $null }) | Measure-Object).count -gt 0 ) {
		break
	}
}