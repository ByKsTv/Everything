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

Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object {
	# TcpAckFrequency=1 makes the ACKs get sent immediately instead of waiting to piggy-back, shaving off a round-trip in small-packet flows.
	New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force

	# TCPNoDelay=1 disables Nagle’s algorithm entirely, reducing latency in interactive/gaming traffic.
	New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force
}

# LocalPriority, HostsPriority, DnsPriority, NetbtPriority: modern Windows ignores these in favor of built-in address-sorting rules; explicitly setting them is redundant on up-to-date systems.
# Here are the official Microsoft Knowledge Base references showing that those ServiceProvider priority values are not applied by Windows:
#
#     KB Q171567 “Windows NT 4.0 ServiceProvider Priority Values Not Applied”
#     This article explicitly states that changing LocalPriority, HostsPriority, DnsPriority or NetbtPriority has no effect on Windows NT 4.0 (and by extension the mechanism was never re-enabled in later releases)
#     https://jeffpar.github.io/kbarchive/kb/171/Q171567/
#
#     KB Q139270 “How to Change Name Resolution Order on Windows 95 and Windows NT”
#     Under “More Information,” it cross-references Q171567 and makes clear these registry-based priority settings applied only to the very earliest Microsoft TCP/IP stacks (Win 95/NT 4.0)
#     https://support.microsoft.com/en-us/topic/microsoft-tcp-ip-host-name-resolution-order-dae00cc9-7e9c-c0cc-8360-477b99cb978a
#
# Taken together, Microsoft’s own documentation shows that these ServiceProvider priority keys were never supported beyond Windows NT 4.0, and modern Windows editions use the built-in RFC 3484/6724 address-sorting rules instead.
#
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 2 -PropertyType DWord -Force
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 3 -PropertyType DWord -Force
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 4 -PropertyType DWord -Force
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 8 -PropertyType DWord -Force

# disable all multimedia throttling on gigabit links.
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value 0xFFFFFFFF -PropertyType DWord -Force

# used by the Windows Multimedia Class Scheduler Service (MMCSS) to reserve a slice of CPU for background (low-priority) tasks.
# It’s a DWORD whose value is the percentage of CPU time guaranteed to low-priority threads.
# For example, if you set SystemResponsiveness = 20, then 20% of CPU cycles are held back for background work; the other 80% is available to foreground multimedia tasks (e.g. games, audio) 
# https://learn.microsoft.com/en-us/windows/win32/procthread/multimedia-class-scheduler-service
# Values not evenly divisible by 10 are rounded up to the next multiple of 10.
# A value of 0 is treated as 10 (i.e. 10% reserved).
# So by setting SystemResponsiveness = 0, you’re effectively telling MMCSS: “Don’t reserve more than 10% for background tasks,” which maximizes CPU allocation for your games and other time-sensitive applications.
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -Force

# SMB server settings—meant for optimizing Windows when it’s acting as a file server
# Size controls how many pending file-share requests the Server service will queue
# 1 (minimal memory), 2 (balanced), 3 (max for file-sharing)
# 3 tells the Server service to allocate the most IRP resources for concurrent file requests, improving throughput when you’re sharing or serving files over the network
# https://www.speedguide.net/articles/lan-tweaks-for-windows-7-8-10-5819
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force

# IRPStackSize increases the number of stacked I/O requests the Server service can handle.
# Default when absent: 15.
# Range: 11 to 50, but values above 33–38 have been reported to cause instability.
# 32 is the most widely recommended “sweet spot” that maximizes the stack without risking hangs 
# https://www.speedguide.net/faq/how-to-increase-irp-stack-size-to-improve-network-524
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType DWord -Force

# disables caching as a file-server to keep RAM free for applications.
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType DWord -Force

New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 30 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'SackOpts' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpMaxDupAcks' -PropertyType DWord -Value 2 -Force

# controls the maximum UDP datagram size (in bytes) that will be sent via the AFD “fast‐send” path. Any UDP send below this threshold is handed off directly to the AFD fast‐I/O routine, bypassing some of the usual buffering and offload logic.
# When no registry value is present, AFD uses its built-in default threshold of 1024 bytes (0x400).
# This is the point at which Windows switches from the ordinary send path into its optimized “small‐datagram” fast path.
# Source: Oracle’s Coherence documentation (quoting Microsoft’s behavior) states, “The default setting for what is considered a small datagram is 1024 bytes; increasing this value … can significantly improve network performance”
# https://docs.oracle.com/cd/E14039_01/coh.320/coh32ug/performance_tuning.htm
# Additionally, the open-source afd/registry.txt on GitHub notes that if you examine the AFD driver defaults, FastSendDatagramThreshold is 1024 by default
# https://github.com/DeDf/afd/blob/master/registry.txt
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'FastSendDatagramThreshold' -PropertyType DWord -Value 65536 -Force

# Some drivers (e.g., Intel’s 82598/82599 series) will actually drop traffic or go unstable if RssBaseCpu isn’t left at its default of 0 or a valid physical-core number. Intel explicitly warns that changing it “may not pass traffic” and recommends resetting it to 0x0 to resolve such issues
# https://www.intel.com/content/www/us/en/support/articles/000006703/ethernet-products.html
# Modern NIC drivers and NDIS dynamically spread RSS queues over multiple cores to maximize parallel packet processing. Pinning them to one CPU limits the number of hardware queues that can be used and creates a bottleneck on high-speed links
# https://learn.microsoft.com/en-us/windows-hardware/drivers/network/reserving-processors-for-applications
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Ndis\Parameters' -Name 'RssBaseCpu' -PropertyType DWord -Value 0 -Force

# Tcp1323Opts=1 turns only Window Scaling on. Timestamps introduce extra per-packet overhead (they add 12 bytes of header data) which can hurt throughput on high-speed, low-latency fiber links, so we disable them while keeping window scaling for large BDPs.
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'Tcp1323Opts' -Value 1 -PropertyType DWord -Force

# elevate actual game-process scheduling in the multimedia scheduler
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'GPU Priority' -Value 8 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Priority' -Value 6 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Scheduling Category' -Value 'High' -PropertyType String -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'SFIO Priority' -Value 'High' -PropertyType String -Force

# it speeds up Message Queuing traffic if you ever use it, but errors are silenced so it won’t break anything if MSMQ isn’t installed.
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters' -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue

Disable-NetAdapterChecksumOffload -Name *
Disable-NetAdapterLso -Name *
Set-NetOffloadGlobalSetting -Chimney Disabled
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled
Set-NetOffloadGlobalSetting -ReceiveSideScaling Enabled
Set-NetTCPSetting -AutoTuningLevelLocal normal
Set-NetTCPSetting -EcnCapability Enabled
Set-NetTCPSetting -InitialRtoMs 3000
Set-NetTCPSetting -MaxSynRetransmissions 2
Set-NetTCPSetting -NonSackRttResiliency Enabled
Set-NetTCPSetting -ScalingHeuristics Disabled
Set-NetTCPSetting -Timestamps Disabled
netsh interface tcp set global autotuninglevel=normal
netsh interface tcp set supplemental template=internet congestionprovider=ctcp
netsh interface tcp set global ecncapability=enabled
netsh interface tcp set global rsc=disabled
netsh interface tcp set global rss=enabled
netsh interface tcp set global dca=disabled
netsh interface tcp set global fastopen=enabled
netsh interface tcp set global maxsynretransmissions=2
netsh interface tcp set global netdma=disabled
netsh interface tcp set global nonsackrttresiliency=enabled
netsh interface tcp set global pacingprofile=off
netsh interface tcp set global timestamps=disabled
netsh interface tcp set heuristics disabled
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
netsh interface ipv6 set subinterface "$MTU_Interface" mtu=$MTU_Final store=persistent

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

	# https://www.intel.com/content/www/us/en/support/articles/000006703/ethernet-products.html
	@{ DisplayName = 'RSS load balancing profile'; DisplayValues = @('NUMAScalingStatic') },

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