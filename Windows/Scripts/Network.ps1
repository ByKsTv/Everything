# Settings: Network & Internet: All networks: Network discovery: Off
Set-NetFirewallRule -Profile Any -Group '@FirewallAPI.dll,-28502' -Enabled False
# Settings: Network & Internet: All networks: File and printer sharing: Off
Set-NetFirewallRule -Profile Any -Group '@FirewallAPI.dll,-32752' -Enabled False
Set-NetFirewallRule -Profile Any -Name 'FPS-SMB-In-TCP' -Enabled False

# Settings: Network & Internet: Private networks: Current profile
Set-NetConnectionProfile -NetworkCategory Private

# Settings: Network & Internet: Private networks: Network discovery: On
Set-NetFirewallRule -Profile Private -Group '@FirewallAPI.dll,-28502' -Enabled True
# Settings: Network & Internet: Private networks: File and printer sharing: On
Set-NetFirewallRule -Profile Private -Group '@FirewallAPI.dll,-32752' -Enabled True
Set-NetFirewallRule -Profile Private -Name 'FPS-SMB-In-TCP' -Enabled True
Set-Service -Name 'FDResPub' -StartupType Automatic
Start-Service -Name 'FDResPub'
Set-Service -Name 'SSDPSRV' -StartupType Automatic
Start-Service -Name 'SSDPSRV'
Set-Service -Name 'upnphost' -StartupType Automatic
Start-Service -Name 'upnphost'

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 4 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 5 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 6 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 7 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value -1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 30 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'SackOpts' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpMaxDupAcks' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'FastSendDatagramThreshold' -PropertyType DWord -Value 0x10000 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Ndis\Parameters' -Name 'RssBaseCpu' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'Tcp1323Opts' -PropertyType DWord -Value 3 -Force

Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object {
	New-ItemProperty -Path $_.PsPath -Name 'TcpAckFrequency' -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path $_.PsPath -Name 'TCPNoDelay' -PropertyType DWord -Value 1 -Force
}

Disable-NetAdapterChecksumOffload -Name *
Disable-NetAdapterLso -Name *
Set-NetOffloadGlobalSetting -Chimney Disabled
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Enabled
Set-NetOffloadGlobalSetting -ReceiveSideScaling Enabled
Set-NetTCPSetting -AutoTuningLevelLocal experimental
Set-NetTCPSetting -EcnCapability Enabled
Set-NetTCPSetting -InitialRtoMs 3000
Set-NetTCPSetting -MaxSynRetransmissions 2
Set-NetTCPSetting -NonSackRttResiliency Enabled
Set-NetTCPSetting -ScalingHeuristics Disabled
Set-NetTCPSetting -Timestamps Enabled
netsh int tcp set global autotuninglevel=experimental
netsh int tcp set global dca=disabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global maxsynretransmissions=2
netsh int tcp set global netdma=disabled
netsh int tcp set global nonsackrttresiliency=enabled
netsh int tcp set global pacingprofile=off
netsh int tcp set global rsc=enabled
netsh int tcp set global rss=enabled
netsh int tcp set global timestamps=Enabled
netsh int tcp set heuristics disabled
netsh int tcp set supplemental template=internet congestionprovider=ctcp
netsh interface teredo set state disabled

$MTU_URL = 'google.com'
$MTU_Initial = 1472
while ($true) {
	if ((ping -f -l $MTU_Initial $MTU_URL -n 1 | Out-String) -match 'Packet needs to be fragmented') {
		$MTU_Initial--
	}
	else {
		break
	}
}
$MTU_Final = $MTU_Initial + 28
$MTU_Interface = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }).InterfaceAlias
Write-Host "Setting MTU to $MTU_Final"
netsh interface ipv4 set subinterface "$MTU_Interface" mtu=$MTU_Final store=persistent

$SettingsToChange = @(
	@{ DisplayName = 'ARP Offload'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Adaptive Inter-Frame Spacing'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'DMA Coalescing'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'ECMA'; DisplayValues = @('Enabled') },
	@{ DisplayName = 'Enable PME'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Energy Efficient Ethernet'; DisplayValues = @('Disabled', 'Off') },
	@{ DisplayName = 'Flow Control'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Gigabit Lite'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Gigabit Master Slave Mode'; DisplayValues = @('Auto Detect') },
	@{ DisplayName = 'Green Ethernet'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'IPv4 Checksum Offload'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Interrupt Moderation Rate'; DisplayValues = @('Off') },
	@{ DisplayName = 'Interrupt Moderation'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Jumbo Frame'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Jumbo Packet'; DisplayValues = @('1514', 'Disabled') },
	@{ DisplayName = 'Large Send Offload (IPv4)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Large Send Offload v2 (IPv4)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Large Send Offload v2 (IPv6)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Legacy Switch Compatibility Mode'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Log Link State Event'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Max IRQ per Second'; DisplayValues = @('30000') },
	@{ DisplayName = 'Maximum Number of RSS Queues'; DisplayValues = @('1 RSS Queues', '2 RSS Queues', '4 RSS Queues', '1 Queue', '2 Queue', '4 Queue') },
	@{ DisplayName = 'Maximum number of RSS Processors'; DisplayValues = @('1', '2', '4', '8') },
	@{ DisplayName = 'Media Status'; DisplayValues = @('Always Connected') },
	@{ DisplayName = 'NS Offload'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Non-Admin Access'; DisplayValues = @('Not Allowed') },
	@{ DisplayName = 'PTP Hardware Timestamp'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Packet Priority & VLAN'; DisplayValues = @('Packet Priority & VLAN Disabled') },
	@{ DisplayName = 'Power Saving Mode'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Priority & VLAN'; DisplayValues = @('Priority & VLAN Disabled') },
	@{ DisplayName = 'Priority / VLAN tag'; DisplayValues = @('Priority & VLAN Disabled') },
	@{ DisplayName = 'Protocol ARP Offload'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Protocol NS Offload'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'RSS load balancing profile'; DisplayValues = @('ClosestProcessor') },
	@{ DisplayName = 'Receive Buffers'; DisplayValues = @('2048') },
	@{ DisplayName = 'Receive Side Scaling'; DisplayValues = @('Enabled') },
	@{ DisplayName = 'Reduce Speed On Power Down'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'SWOI'; DisplayValues = @('Enabled') },
	@{ DisplayName = 'Selective Suspend Idle Timeout'; DisplayValues = @('5') },
	@{ DisplayName = 'Selective Suspend'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Shutdown Wake Up'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Shutdown Wake-On-Lan'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Software Timestamp'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Speed & Duplex'; DisplayValues = @('1.0 Gbps Full Duplex', '2.5 Gbps Full Duplex') },
	@{ DisplayName = 'System Idle Power Saver'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'TCP Checksum Offload (IPv4)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'TCP Checksum Offload (IPv6)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Transmit Buffers'; DisplayValues = @('1024', '2048') },
	@{ DisplayName = 'UDP Checksum Offload (IPv4)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'UDP Checksum Offload (IPv6)'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Ultra Low Power Mode'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'WOL & Shutdown Link Speed'; DisplayValues = @('Not Speed Down') },
	@{ DisplayName = 'Wait for Link'; DisplayValues = @('Off') },
	@{ DisplayName = 'Wake from S0ix on Magic Packet'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Wake on LAN'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Wake on Link Settings'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Wake on Magic Packet'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Wake on Pattern Match'; DisplayValues = @('Disabled') }

	# TODO
	# Ethernet0: Locally Administered Address: Valid Values:
	# Ethernet0: Maximum RSS Processor Number: Valid Values: 
	# Ethernet0: Preferred NUMA node: Valid Values: 
	# Ethernet0: RSS Base Processor Number: Valid Values: 
	# Ethernet: Network Address: Valid Values:
	# Ethernet: VLAN ID: Valid Values:
	# Local Area Connection: MAC Address: Valid Values:
	# Local Area Connection: MTU: Valid Values:
	# VMware Network Adapter VMnet1: VLAN ID: Valid Values:
)

$UnusedSettings = @()

$NetworkAdapters = Get-NetAdapter
foreach ($Adapter in $NetworkAdapters) {
	$AdvancedProperties = try {
		Get-NetAdapterAdvancedProperty -Name $Adapter.Name -ErrorAction Stop
	}
 catch {
		Write-Host "Error retrieving properties for adapter: $($Adapter.Name)" -ForegroundColor Red
		continue
	}

	foreach ($Setting in $SettingsToChange) {
		$Property = $AdvancedProperties | Where-Object { $_.DisplayName -eq $Setting.DisplayName }
		if ($Property) {
			$ValidValues = $Property.ValidDisplayValues
			Write-Host "$($Adapter.Name): $($Setting.DisplayName): Options: $($ValidValues -join ', ')"
			$ValuesToApply = if ($ValidValues -and $ValidValues.Count -gt 0) {
				$Setting.DisplayValues | Where-Object { $ValidValues -contains $_ }
			}
			else {
				$Setting.DisplayValues
			}
			foreach ($Value in $ValuesToApply) {
				try {
					Write-Host "$($Adapter.Name): $($Setting.DisplayName): Applying Value: $Value" -ForegroundColor Green
					Set-NetAdapterAdvancedProperty -Name $Adapter.Name -DisplayName $Setting.DisplayName -DisplayValue $Value -ErrorAction Stop
				}
				catch {
					Write-Host "Error applying value '$Value' for '$($Setting.DisplayName)' on '$($Adapter.Name)'" -ForegroundColor Red
				}
			}
		}
	}

	$UsedDisplayNames = $SettingsToChange.DisplayName
	$UnusedSettings += $AdvancedProperties | Where-Object { $UsedDisplayNames -notcontains $_.DisplayName } | ForEach-Object {
		[PSCustomObject]@{
			AdapterName = $Adapter.Name
			DisplayName = $_.DisplayName
			ValidValues = $_.ValidDisplayValues -join ', '
		}
	}
}

if ($UnusedSettings.Count -gt 0) {
	Write-Host 'Unused Settings Found:' -ForegroundColor Red
	foreach ($Setting in $UnusedSettings) {
		Write-Host "$($Setting.AdapterName): $($Setting.DisplayName): Valid Values: $($Setting.ValidValues)"
	}
}
else {
	Write-Host 'No unused settings found.' -ForegroundColor Green
}

Add-Type -AssemblyName System.Windows.Forms
$WakeOnLanAnswer = [Windows.Forms.MessageBox]::Show((New-Object Windows.Forms.Form -Property @{ TopMost = $true }), 'Enable Wake-On-Lan?', 'Wake-On-Lan', 4, 32)
$PnPValue = if ($WakeOnLanAnswer -eq 'Yes') {
 256 
}
else {
 24 
}
$WakeOnLanStatus = if ($WakeOnLanAnswer -eq 'Yes') {
 'Enabled' 
}
else {
 'Disabled' 
}

$NetworkAdapters | ForEach-Object {
	Set-NetAdapterPowerManagement -Name $_.Name -WakeOnPattern $WakeOnLanStatus -Confirm:$false
	Set-NetAdapterPowerManagement -Name $_.Name -WakeOnMagicPacket $WakeOnLanStatus -Confirm:$false
	Set-NetAdapterPowerManagement -Name $_.Name -DeviceSleepOnDisconnect $WakeOnLanStatus -Confirm:$false
}

$KeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\'
$NetworkAdapters | ForEach-Object {
	$Adapter = $_
	foreach ($Entry in (Get-ChildItem $KeyPath -ErrorAction SilentlyContinue).Name) {
		if ((Get-ItemProperty REGISTRY::$Entry).DriverDesc -eq $Adapter.InterfaceDescription) {
			$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			if ($Value -ne $PnPValue) {
				Set-ItemProperty -Path REGISTRY::$Entry -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $Adapter.PnPDeviceID -Confirm:$false
				$Value = (Get-ItemProperty REGISTRY::$Entry).PnPCapabilities
			}
			Write-Host "Wake-On-LAN: $WakeOnLanStatus for adapter $($Adapter.Name)" -ForegroundColor Green
		}
	}
}

$WakeOnLanProperties = @(
	'Enable PME',
	'Shutdown Wake Up',
	'Wake on magic packet'
)

foreach ($Adapter in $NetworkAdapters) {
	$AdvancedProperties = Get-NetAdapterAdvancedProperty -Name $Adapter.Name -ErrorAction SilentlyContinue
	if ($AdvancedProperties) {
		foreach ($PropertyName in $WakeOnLanProperties) {
			if ($AdvancedProperties | Where-Object { $_.DisplayName -eq $PropertyName }) {
				Set-NetAdapterAdvancedProperty -Name $Adapter.Name -DisplayName $PropertyName -DisplayValue $WakeOnLanStatus
			}
		}
	}
}

while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) {
	Start-Sleep -Milliseconds 1000
}
