$MTU_URL = '1.1.1.1'
$MTU_Initial = 1472
$InterfaceAliases = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway }).InterfaceAlias

$InterfaceAliases | ForEach-Object {
	& netsh.exe interface ipv4 set subinterface "$_" mtu=1500 store=persistent
	& netsh.exe interface ipv6 set subinterface "$_" mtu=1500 store=persistent
}

while ($true) {
	if ((& ping.exe -f -l $MTU_Initial $MTU_URL -n 1 | Out-String) -match 'Packet needs to be fragmented') {
		$MTU_Initial--
	}
	else {
		break
	}
}

$MTU_Final = $MTU_Initial + 28

$InterfaceAliases | ForEach-Object {
	[Console]::WriteLine("Setting MTU to $MTU_Final on $_")
	& netsh.exe interface ipv4 set subinterface "$_" mtu=$MTU_Final store=persistent
	& netsh.exe interface ipv6 set subinterface "$_" mtu=$MTU_Final store=persistent
}

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

# $cpuCount = [Environment]::ProcessorCount
# Set-NetAdapterRss -Name * -Enabled $true -MaxProcessors $cpuCount -BaseProcessorNumber 0 -Profile Closest

$C = [Environment]::ProcessorCount
$B = 0

if ($C -ge 8) {
	$B = 2
}

$M = [Math]::Min($C - 1, 15)

foreach ($A in Get-NetAdapter -Physical) {
	$R = Get-NetAdapterRss -Name $A.Name -ErrorAction SilentlyContinue

	if (-not $R) {
		continue
	}

	$N = [Math]::Min(4, $M - $B + 1)

	if ($R.NumberOfReceiveQueues -gt 0) {
		$N = [Math]::Min($N, $R.NumberOfReceiveQueues)
	}

	Set-NetAdapterRss -Name $A.Name -Enabled $true -Profile Closest -BaseProcessorNumber $B -MaxProcessorNumber $M -MaxProcessors $N -ErrorAction SilentlyContinue
}

$R = 'HKLM:\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}'
foreach ($K in Get-ChildItem -Path "$R\0*" -ErrorAction SilentlyContinue) {
	New-ItemProperty -Path $K.PSPath -Name ManyCoreScaling -Value '1' -PropertyType String -Force
	New-ItemProperty -Path $K.PSPath -Name DisablePortScaling -Value '0' -PropertyType String -Force
}

# Windows NDIS registry value used for network driver/debug tracing.
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\NDIS\Parameters' -Name 'TrackNblOwner' -Value 0 -PropertyType DWord -Force

$R = 'HKLM:\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}'
$V = @(
	, @('AutoPowerSaveModeEnabled', '0', 'DWord')
	, @('*NicAutoPowerSaver', '0', 'String')
	, @('DisableDelayedPowerUp', '1', 'DWord')
	, @('ReduceSpeedOnPowerDown', '0', 'DWord')
	, @('EnableConnectedPowerGating', '0', 'DWord')
	, @('*EnableDynamicPowerGating', '0', 'String')
	, @('EnableCoalesce', '0', 'DWord')
	, @('*UDPChecksumOffloadIPv4', '3', 'String')
	, @('*UDPChecksumOffloadIPv6', '3', 'String')
	, @('EnableUdpTxScaling', '1', 'DWord')
	, @('*TCPChecksumOffloadIPv6', '3', 'String')
	, @('*TCPChecksumOffloadIPv4', '3', 'String')
	, @('*PacketDirect', '0', 'String')
	, @('*LsoV1IPv4', '1', 'String')
)

foreach ($K in Get-ChildItem -Path "$R\0*" -ErrorAction SilentlyContinue) {
	foreach ($X in $V) {
		New-ItemProperty -Path $K.PSPath -Name $X[0] -Value $X[1] -PropertyType $X[2] -Force
	}
}

Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' | ForEach-Object {
	<#
	Setting:
	TcpAckFrequency

	Description:
	This setting controls how often TCP sends acknowledgments (ACKs) for received packets. It is used to fine-tune network performance, particularly for latency-sensitive applications like online gaming.

	Values:
	0 – Default. TCP may delay sending ACKs to improve efficiency by combining them.
	1 – TCP sends an ACK for every received packet, reducing latency but increasing network traffic.

	Note:
	Setting `TcpAckFrequency` to 1 can reduce latency in some real-time applications, but may increase CPU usage and network overhead. This setting should be tested per application needs.
#>
	New-ItemProperty -Path $_.PSPath -Name 'TcpAckFrequency' -Value 1 -PropertyType DWord -Force

	<#
	Setting:
	TCPNoDelay
	
	Description:
	Disables Nagle's algorithm for TCP connections. Nagle's algorithm combines small outgoing messages and sends them all at once to reduce network congestion. Setting TCPNoDelay to 1 disables this behavior, sending packets immediately without waiting.

	Values:
	0 - Enable Nagle's algorithm (default behavior).
	1 - Disable Nagle's algorithm (send TCP packets immediately without waiting).

	Note:
	Disabling Nagle's algorithm (setting to 1) can improve performance in low-latency applications like online gaming or real-time audio/video communication, but may increase network traffic slightly.
#>
	New-ItemProperty -Path $_.PSPath -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force
}

<#
	Setting:
	NetworkThrottlingIndex
	
	Description:
	Controls the rate at which network packets are processed for multimedia applications. This setting is part of Windows' multimedia class scheduler, which can throttle network performance to prioritize audio and video smoothness.

	Values:
	0–70 (decimal) - Throttles network traffic processing; higher values = less frequent processing.
	0xFFFFFFFF - Disables network throttling entirely, allowing maximum throughput.

	Note:
	Setting to 0xFFFFFFFF can improve performance for real-time applications (e.g., gaming, streaming), but may increase CPU usage and network congestion in some cases. Default value is typically 10 (decimal). Safe to tweak on modern systems for performance tuning.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value 0xFFFFFFFF -PropertyType DWord -Force

<#
	Setting:
	SystemResponsiveness
	
	Description:
	Determines the percentage of CPU resources reserved for system background tasks (like multimedia processing or background services) when multimedia tasks are running.

	Values:
	0–100 (decimal) - Percentage of CPU time reserved.
	0 - No CPU reserved for background tasks (maximum performance for foreground apps).
	20 (default) - Reserves 20% CPU for background tasks.

	Note:
	Setting to 0 can improve performance for foreground applications like games or DAWs. Safe to change on modern systems if you're prioritizing performance in latency-sensitive applications.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -Force

<#
	Setting:
	Size
	
	Description:
	Controls the amount of system resources allocated to the Server service for file and print sharing over the network.

	Values:
	1 - Minimize usage (conserves memory and limits connections).
	2 - Balance between memory usage and performance (default).
	3 - Maximize throughput for file sharing (uses more memory and resources).

	Note:
	Value 3 is recommended for systems acting as file servers or requiring high network performance. Changing this can impact how the server handles multiple simultaneous connections.
#>
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force

<#
	Setting:
	IRPStackSize

	Description:
	Defines the number of stack locations allocated for I/O Request Packets (IRPs), which are used by Windows to pass I/O requests through drivers. Affects network share accessibility and compatibility with certain drivers.

	Values:
	11–50 (decimal) - Valid range.
	Default - If not set, the default is typically 15.
	32 - A common higher value to prevent "Not enough server storage" errors.

	Note:
	A higher value can improve compatibility with antivirus, backup, or disk-filter drivers that add layers to the I/O stack. Avoid setting above 50, as values outside the valid range may be ignored or cause instability.
#>
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType DWord -Force

<#
	Setting:
	LargeSystemCache

	Description:
	Controls whether the system prioritizes file system caching for large-scale data handling, typically used by servers.

	Values:
	0 - Optimize for programs (default); gives more memory to running applications.
	1 - Optimize for system cache; allocates more memory to file system caching, reducing memory available for user programs.

	Note:
	Setting this to 1 is useful on servers where file caching is more important than foreground app performance. For most desktop systems, it should remain 0.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType DWord -Force

<#
	Setting:
	MaxUserPort

	Description:
	Defines the highest port number that can be used for dynamic (ephemeral) outbound TCP/UDP connections.

	Values:
	5000–65534 (decimal) - Valid range.
	Default - 5000 to 65534 depending on Windows version.
	65534 - Allows the system to use nearly the entire range of ephemeral ports, increasing the number of simultaneous outbound connections.

	Note:
	Useful for high-connection applications like servers, proxies, or P2P apps. Must be paired with appropriate `TcpTimedWaitDelay` and firewall settings to avoid port exhaustion.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType DWord -Force

<#
	Setting:
	TcpTimedWaitDelay

	Description:
	Controls the time a closed TCP connection remains in the TIME_WAIT state before being released and reused.

	Values:
	30–300 (decimal) - Duration in seconds.
	Default - 240 seconds.
	30 - Shortens TIME_WAIT to 30 seconds, allowing faster reuse of TCP ports.

	Note:
	Reducing this value can help prevent port exhaustion on systems handling many short-lived TCP connections, like web servers or game clients. Too low a value may increase the chance of delayed packets being misinterpreted as part of a new connection.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 300 -PropertyType DWord -Force

<#
	Setting:
	DefaultTTL

	Description:
	Specifies the default Time To Live (TTL) value set in the header of outbound IP packets. TTL determines how many network hops a packet can pass through before being discarded.

	Values:
	1–255 (decimal) - Number of hops allowed.
	Common values:
	  64 - Default for Linux/macOS systems.
	  128 - Default for Windows.
	  255 - Maximum allowed hops.

	Note:
	Setting TTL to 64 can make Windows behave more like Linux in network diagnostics. A lower TTL can limit packet propagation and help mitigate routing loops, but may cause reachability issues if too low.
#>
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType DWord -Force

<#
	Setting:
	SackOpts

	Description:
	Enables or disables TCP Selective Acknowledgment (SACK), which improves performance by allowing the receiver to inform the sender about specific lost packets rather than re-sending all data.

	Values:
	0 - Disable SACK.
	1 - Enable SACK (default).

	Note:
	Enabling SACK improves efficiency on high-latency or lossy networks by reducing unnecessary retransmissions. It is recommended to keep this enabled unless troubleshooting specific TCP issues.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'SackOpts' -PropertyType DWord -Value 1 -Force

<#
	Setting:
	TcpMaxDupAcks

	Description:
	Specifies the number of duplicate ACKs (acknowledgments) received before TCP performs fast retransmission of a lost segment.

	Values:
	1–3 (decimal) - Number of duplicate ACKs before retransmit.
	Default - 2 or 3, depending on Windows version.
	2 - Triggers faster retransmission, potentially improving performance on lossy networks.

	Note:
	Lowering this value can speed up recovery from packet loss but may cause unnecessary retransmissions on networks with out-of-order delivery. Typical recommended value is 2 or 3.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpMaxDupAcks' -PropertyType DWord -Value 1 -Force

<#
	Setting:
	FastSendDatagramThreshold

	Description:
	Specifies the maximum size (in bytes) of datagrams that the AFD (Ancillary Function Driver) can send using a fast path without buffering.

	Values:
	0–65535 (decimal) - Size in bytes.
	Default - 2048 bytes.
	65536 - Disables the threshold, forcing all datagrams to go through the fast path regardless of size.

	Note:
	Raising this value may improve performance for applications sending large UDP datagrams by avoiding additional buffering. However, using very large values may lead to resource issues if not managed carefully.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'FastSendDatagramThreshold' -PropertyType DWord -Value 65536 -Force

<#
    Setting:
    DefaultSendWindow

    Description:
    Default socket send buffer (bytes) AFD uses when an app doesn't set SO_SNDBUF.

    Values:
    DWORD bytes. Typical: 262144 (256 KiB). Use your Bandwidth-Delay Product if known.

    Note:
    Useful on high-BDP paths (long RTT / high Mbps). Windows autotuning still applies at TCP level; this only seeds Winsock’s defaults. Reboot required. Sources: smallvoid, ServerFault. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DefaultSendWindow' -PropertyType DWord -Value 2621440 -Force

<#
    Setting:
    DefaultReceiveWindow

    Description:
    Default socket receive buffer (bytes) when an app doesn’t set SO_RCVBUF.

    Values:
    DWORD bytes. Typical: 262144 (256 KiB). Match your BDP if possible.

    Note:
    Helps prevent application-level backpressure on high-rate streams. Reboot required. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DefaultReceiveWindow' -PropertyType DWord -Value 2621440 -Force

<#
    Setting:
    DynamicSendBufferDisable

    Description:
    Turns OFF (1) or ON (0) the dynamic send-backlog mechanism in AFD.

    Values:
    0 = ENABLE dynamic sizing (recommended); 1 = disable (legacy workaround).

    Note:
    Keep at 0 for better scaling/throughput on modern Windows. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DynamicSendBufferDisable' -PropertyType DWord -Value 0 -Force

<#
    Setting:
    BufferAlignment

    Description:
    Undocumented/private AFD tuning related to internal buffer alignment.

    Values:
    DWORD (undocumented). Do not set for performance.

    Note:
    Leave unset (or remove). There’s no evidence this improves modern Windows performance and it can regress stability. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'BufferAlignment' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    DoNotHoldNICBuffers

    Description:
    Undocumented/private toggle hinting whether AFD retains NIC buffers.

    Values:
    DWORD (undocumented). Avoid setting.

    Note:
    Leave unset (or remove). Seen in third-party scripts/malware; no credible perf data to support enabling it. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DoNotHoldNICBuffers' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    DisableDirectAcceptEx

    Description:
    Disables kernel-level AcceptEx fast-path used by servers.

    Values:
    0 = don’t disable (recommended); 1 = disable the fast path.

    Note:
    Disabling can slow high-connection-rate servers. Keep 0/absent for performance. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DisableDirectAcceptEx' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    DisableChainedReceive

    Description:
    Disables receiving data with chained MDLs/buffers.

    Values:
    0 = don’t disable (recommended); 1 = disable (can hurt throughput).

    Note:
    Keep at 0/absent; disabling usually reduces receive efficiency. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DisableChainedReceive' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    DisableRawSecurity

    Description:
    Disables AFD’s raw-socket security checks (legacy OSes).

    Values:
    0 = keep security (recommended); 1 = disable (less secure).

    Note:
    Setting 1 broadens raw socket access and is not a performance tweak. Keep 0. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DisableRawSecurity' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    IgnorePushBitOnReceives

    Description:
    Treat all incoming TCP segments as if PSH is set (deliver immediately).

    Values:
    0 = normal behavior (recommended generally); 1 = ignore PSH (lower latency workaround).

    Note:
    Only consider 1 if you’re working around specific stacks that don’t set PSH and you see latency hiccups; otherwise 0 for efficiency. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'IgnorePushBitOnReceives' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    IgnoreOrderlyRelease

    Description:
    Alters FIN/“orderly release” handling semantics.

    Values:
    0 = normal FIN handling (recommended); 1 = ignore (not advised).

    Note:
    Keep default; ignoring may confuse connection teardown and doesn’t help throughput. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'IgnoreOrderlyRelease' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    DisableAddressSharing

    Description:
    Disallow socket address/port reuse (SO_REUSEADDR) system-wide.

    Values:
    0 = allow reuse (recommended for many servers); 1 = disallow (hardening).

    Note:
    For raw performance/scale, keep 0. Some hardened baselines set 1 for security; assess your workload. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DisableAddressSharing' -PropertyType DWord -Value 1 -Force

<#
    Setting:
    FastCopyReceiveThreshold

    Description:
    UDP: payload size below which AFD copies directly instead of using more complex paths.

    Values:
    DWORD bytes. Default ~1024; recommended 1500.

    Note:
    1500 (0x5DC) lines up with typical Ethernet MTU and shows good results in published tests. 
#>
# New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'FastCopyReceiveThreshold' -PropertyType DWord -Value 1 -Force

<#
	Setting:
	RssBaseCpu

	Description:
	Specifies the starting CPU index for Receive Side Scaling (RSS), which distributes network processing across multiple CPUs to improve performance.

	Values:
	0 or higher (decimal) - CPU index to start assigning RSS processing.
	Default - 0 (first logical processor).

	Note:
	Used to control CPU affinity for network traffic. Setting this helps avoid placing RSS load on busy or reserved CPUs (e.g., for audio or real-time tasks). Make sure the specified CPU index is valid for the system.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Ndis\Parameters' -Name 'RssBaseCpu' -PropertyType DWord -Value 0 -Force

<#
	Setting:
	Tcp1323Opts

	Description:
	Enables or disables RFC 1323 TCP extensions, which support window scaling and timestamps for improved performance over high-latency or high-bandwidth networks.

	Values:
	0 - Disable both window scaling and timestamps.
	1 - Enable window scaling only.
	2 - Enable timestamps only.
	3 - Enable both window scaling and timestamps.

	Note:
	Setting this to 1 improves throughput on high-latency networks by allowing larger TCP window sizes. Timestamps (value 2 or 3) are useful for more accurate round-trip time measurement but can expose uptime to remote systems.
#>
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'Tcp1323Opts' -Value 3 -PropertyType DWord -Force

<#
	Setting:
	TCPNoDelay

	Description:
	Disables Nagle’s algorithm for Microsoft Message Queuing (MSMQ), allowing small TCP packets to be sent immediately without delay.

	Values:
	0 - Enable Nagle’s algorithm (default); small packets are combined before sending.
	1 - Disable Nagle’s algorithm; sends packets immediately to reduce latency.

	Note:
	Setting this to 1 can improve MSMQ performance in low-latency scenarios (e.g., real-time messaging), but may slightly increase network traffic. Use with care in high-volume systems.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters' -Name 'TCPNoDelay' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue

<#
	Setting:
	Checksum Offload

	Description:
	Disables hardware checksum offloading on all network adapters. Normally, the network adapter calculates checksums for TCP/IP packets to reduce CPU load.

	Values:
	Enabled (default) - Adapter handles checksum computation.
	Disabled - CPU handles checksum processing instead.

	Note:
	Disabling checksum offload can help troubleshoot network issues such as packet corruption, latency, or compatibility problems with older network hardware or drivers. It may slightly increase CPU usage.
	Controlling the following settings: IPv4 Checksum Offload, TCP Checksum Offload (IPv4), TCP Checksum Offload (IPv6), UDP Checksum Offload (IPv4), UDP Checksum Offload (IPv6)
#>
Enable-NetAdapterChecksumOffload -Name * -ErrorAction SilentlyContinue

<#
	Setting:
	Large Send Offload (LSO)

	Description:
	Disables Large Send Offload on all network adapters. LSO allows the network adapter to handle segmentation of large TCP packets, reducing CPU workload.

	Values:
	Enabled (default) - Adapter segments large TCP packets.
	Disabled - CPU handles segmentation of TCP packets.

	Note:
	Disabling LSO can reduce latency or fix compatibility issues with certain games, apps, or older hardware. However, it may increase CPU usage during high network throughput.
	Controlling the following settings: Large Send Offload (IPv4), Large Send Offload v2 (IPv4), Large Send Offload v2 (IPv6)
#>
Enable-NetAdapterLso -Name *

<#
	Setting:
	Chimney Offload

	Description:
	Controls TCP Chimney Offload, which offloads TCP processing from the CPU to the network adapter to reduce CPU usage.

	Values:
	Automatic - Windows decides when to use offload based on adapter support.
	Enabled - Forces TCP offload to the network adapter.
	Disabled - Disables offload; all TCP processing is handled by the CPU.

	Note:
	Disabling Chimney Offload can improve compatibility and stability on systems with older or unstable network drivers. It may slightly increase CPU usage but avoids potential connection issues.
#>
Set-NetOffloadGlobalSetting -Chimney Disabled

<#
	Setting:
	TaskOffload

	Description:
	Controls whether network task offloading (like checksum or segmentation) is enabled on the system. Offloading moves certain network tasks from the CPU to the network adapter to improve performance.

	Values:
	Enabled: Allows the network adapter to handle specific tasks instead of the CPU.
	Disabled: Forces the CPU to handle all network tasks, which can help in troubleshooting or with incompatible hardware.

	Note:
	Disabling task offloading can reduce performance but may solve certain network issues like slow file transfers or connection drops.
#>
Set-NetOffloadGlobalSetting -TaskOffload Enabled

<#
	Setting:
	NetworkDirect

	Description:
	Controls whether Network Direct (a high-performance, low-latency networking technology used mainly in data centers) is enabled on the system.

	Values:
	Enabled: Allows applications to use Network Direct for fast and efficient communication, typically with RDMA-capable (Remote Direct Memory Access) network adapters.
	Disabled: Disables Network Direct functionality, preventing use of RDMA for network communications.

	Note:
	This setting is mostly relevant in server or data center environments. Disabling it has little to no effect on typical home or office setups.
#>
Set-NetOffloadGlobalSetting -NetworkDirect Enabled

<#
	Setting:
	NetworkDirectAcrossIPSubnets

	Description:
	Determines whether Network Direct connections (RDMA) are allowed across different IP subnets.

	Values:
	Enabled: Allows RDMA communication between devices on different IP subnets.
	Disabled: Restricts RDMA communication to devices within the same IP subnet only.

	Note:
	Disabling can improve security and reduce complexity in environments where cross-subnet RDMA is not required.
#>
Set-NetOffloadGlobalSetting -NetworkDirectAcrossIPSubnets Blocked

<#
	Setting:
	PacketCoalescingFilter

	Description:
	Controls whether packet coalescing is used to reduce the number of received interrupts by combining multiple incoming packets into a single interrupt.

	Values:
	Enabled - Network adapter uses coalescing to group packets.
	Disabled - Each incoming packet generates a separate interrupt.

	Note:
	Disabling this may improve latency and responsiveness for real-time applications (like gaming or VoIP), but can slightly increase CPU usage due to more frequent interrupts.
#>
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled

<#
	Setting:
	Receive Segment Coalescing (RSC)

	Description:
	Controls whether the network adapter merges multiple incoming TCP segments into a single larger segment to reduce CPU load.

	Values:
	Enabled - Adapter coalesces incoming TCP segments.
	Disabled - Each TCP segment is processed individually by the CPU.

	Note:
	Disabling RSC can reduce input latency and improve consistency for real-time applications like gaming, but may slightly increase CPU usage during high network traffic.
#>
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled
netsh interface tcp set global rsc=disabled

<#
	Setting:
	Receive Side Scaling (RSS)

	Description:
	Enables or disables Receive Side Scaling, a feature that distributes incoming network traffic processing across multiple CPU cores to improve performance on multi-core systems.

	Values:
	Enabled - Network traffic is processed in parallel across multiple CPUs.
	Disabled - All incoming traffic is processed by a single CPU core.

	Note:
	Enabling RSS improves throughput and lowers CPU bottlenecks for high-speed network connections. It is recommended for most modern systems unless troubleshooting CPU affinity or driver-related issues.
#>
Set-NetOffloadGlobalSetting -ReceiveSideScaling Enabled
netsh interface tcp set global rss=enabled

<#
	Setting:
	AutoTuningLevelLocal

	Description:
	Controls the TCP receive window auto-tuning feature, which adjusts the size of the receive window to optimize throughput based on network conditions.

	Values:
	disabled - Disables auto-tuning (fixed receive window size).
	highlyrestricted - Limits adjustments very conservatively.
	restricted - Allows limited adjustments.
	normal - Enables full tuning (default).
	experimental - Aggressively adjusts window size (may cause instability).

	Note:
	Setting this to "normal" allows Windows to dynamically optimize TCP performance for most network environments. Only change this if troubleshooting or testing specific network behaviors.
#>
Set-NetTCPSetting -AutoTuningLevelLocal Normal
netsh interface tcp set global autotuninglevel=Normal

<#
	Setting:
	EcnCapability

	Description:
	Controls Explicit Congestion Notification (ECN) for TCP connections, allowing routers to signal network congestion without dropping packets.

	Values:
	Disabled - ECN is not used.
	Enabled - ECN is used if supported by the other end.
	Default - Uses system default setting (typically Enabled on modern Windows).

	Note:
	Enabling ECN can improve performance and reduce packet loss on congested networks. Some older routers or firewalls may not support ECN properly, which could lead to connectivity issues.
#>
Set-NetTCPSetting -EcnCapability Enabled
netsh interface tcp set global ecncapability=Enabled

<#
	Setting:
	InitialRtoMs

	Description:
	Sets the initial TCP retransmission timeout (RTO) in milliseconds, which is the wait time before retransmitting an unacknowledged packet.

	Values:
	300–60000 (decimal) - Timeout in milliseconds.
	Default - 3000 ms (3 seconds).

	Note:
	Lowering this value can improve responsiveness on lossy networks but may lead to unnecessary retransmissions. Increasing it can reduce retransmits on slow or high-latency networks. Use with care based on your environment.
#>
Set-NetTCPSetting -InitialRtoMs 3000

<#
	Setting:
	MaxSynRetransmissions

	Description:
	Specifies the maximum number of times TCP will retransmit a SYN packet when attempting to establish a connection.

	Values:
	2–8 (decimal) - Number of SYN retransmissions before giving up.
	Default - 2 or 3, depending on Windows version.
	2 - TCP gives up after sending the initial SYN and 2 retransmissions (total of 3 SYNs).

	Note:
	Lower values reduce connection retry time for unreachable hosts, which can improve responsiveness in some apps. Higher values improve reliability on slow or unstable networks.
#>
Set-NetTCPSetting -MaxSynRetransmissions 2
netsh interface tcp set global maxsynretransmissions=2

<#
	Setting:
	NonSackRttResiliency

	Description:
	Enables a protection mechanism that increases tolerance to round-trip time (RTT) variation when communicating with non-SACK (Selective Acknowledgment) capable hosts.

	Values:
	Disabled - Standard RTT behavior with non-SACK peers.
	Enabled - Adds delay and resilience to RTT estimation to prevent premature retransmissions with non-SACK peers.

	Note:
	Recommended to keep Enabled for improved stability and reliability when communicating with older or less capable TCP stacks that do not support SACK. Helps avoid unnecessary retransmissions.
#>
Set-NetTCPSetting -NonSackRttResiliency Enabled
netsh interface tcp set global nonsackrttresiliency=Enabled

<#
	Setting:
	ScalingHeuristics

	Description:
	Controls whether Windows can automatically disable TCP window scaling based on observed network behavior.

	Values:
	Enabled - Windows may turn off window scaling if it detects compatibility issues.
	Disabled - TCP window scaling remains enabled regardless of network conditions.

	Note:
	Disabling scaling heuristics ensures full use of window scaling, which improves performance on high-latency or high-bandwidth networks. Recommended for modern networks where compatibility issues are rare.
#>
Set-NetTCPSetting -ScalingHeuristics Disabled
netsh interface tcp set heuristics disabled

<#
	Setting:
	Timestamps

	Description:
	Controls the use of TCP timestamps (RFC 1323), which improve round-trip time (RTT) measurement and help with PAWS (Protect Against Wrapped Sequence numbers).

	Values:
	Enabled - TCP includes timestamps in packets.
	Disabled - Timestamps are not used.

	Note:
	Disabling timestamps can slightly reduce overhead and exposure of system uptime, but may impair RTT estimation and performance on high-latency networks. Recommended to leave enabled unless avoiding timestamp-related compatibility or privacy issues.
#>
Set-NetTCPSetting -Timestamps Enabled
netsh interface tcp set global timestamps=Enabled

<#
	Setting:
	CongestionProvider

	Description:
	Specifies the TCP congestion control algorithm used for managing network congestion and optimizing throughput.

	Values:
	none - Default Windows algorithm (usually NewReno).
	ctcp - Compound TCP; improves throughput on high-bandwidth, high-latency networks.
	dctcp - Data Center TCP; optimized for low-latency, high-speed data center environments.
	cubic - Modern algorithm offering better performance across various conditions (available on newer Windows builds).

	Note:
	Setting to "ctcp" enables Compound TCP, which combines delay-based and loss-based methods to improve performance on fast, long-distance connections. Recommended for internet use where bandwidth is high and latency is variable.
#>
netsh interface tcp set supplemental template=internet congestionprovider=cubic

<#
	Setting:
	Direct Cache Access (DCA)

	Description:
	Controls Direct Cache Access, a feature that allows network adapters to place incoming data directly into the CPU cache to reduce latency and improve performance.

	Values:
	enabled - DCA is used if supported by hardware and drivers.
	disabled - DCA is not used; data is handled through standard memory paths.

	Note:
	Disabling DCA can improve system stability or compatibility on hardware that doesn’t fully support it. On supported systems, enabling it may reduce latency in high-performance networking.
#>
netsh interface tcp set global dca=enabled

<#
	Setting:
	TCP Fast Open

	Description:
	Enables TCP Fast Open, which allows data to be sent during the initial TCP handshake, reducing latency for repeated connections.

	Values:
	enabled - TCP Fast Open is used if supported by both client and server.
	disabled - TCP Fast Open is not used.

	Note:
	Enabling TCP Fast Open can reduce connection setup time and improve performance for web and app traffic. It requires support on both ends and may be blocked by some firewalls or middleboxes.
#>
netsh interface tcp set global fastopen=enabled

<#
	Setting:
	PacingProfile

	Description:
	Controls TCP packet pacing behavior, which spreads out packet transmission over time to reduce bursts and improve network stability.

	Values:
	off - Disables pacing; packets are sent as fast as allowed by the congestion algorithm.
	highthroughput - Enables pacing optimized for maximum throughput.
	internetclient - Enables pacing optimized for typical internet usage.
	internetserver - Enables pacing optimized for servers handling many clients.

	Note:
	Setting to "off" disables pacing, which may reduce latency in real-time applications (e.g., gaming) but could increase burstiness and congestion on busy networks.
#>
netsh interface tcp set global pacingprofile=off

<#
	Setting:
	Teredo State

	Description:
	Controls the state of the Teredo tunneling protocol, which provides IPv6 connectivity over IPv4 networks using NAT traversal.

	Values:
	default - Enables Teredo with standard behavior.
	enterpriseclient - Enables Teredo in a managed network environment.
	client - Enables Teredo in unmanaged mode for general use.
	disabled - Disables Teredo completely.

	Note:
	Disabling Teredo can improve security and reduce unnecessary background traffic if IPv6 connectivity is not needed. Safe to disable on networks using native IPv6 or not requiring Teredo.
#>
netsh interface teredo set state disabled

$SettingsToChange = @(
	<#
	Setting:
	ARP Offload
	
	Description:
	Allows the network adapter to handle Address Resolution Protocol (ARP) requests without waking the computer.
	
	Values:
	Enabled, Disabled

	Note:
	Can save power when enabled.
#>
	@{ DisplayName = 'ARP Offload'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Adaptive Inter-Frame Spacing
	
	Description:
	Dynamically adjusts the spacing between transmitted frames to reduce collisions and improve performance.
	
	Values:
	Enabled, Disabled

	Note:
	Useful in environments with high network traffic.
#>
	@{ DisplayName = 'Adaptive Inter-Frame Spacing'; DisplayValues = @('Disabled') },

	<#
	Setting:
	DMA Coalescing
	
	Description:
	Reduces power consumption by grouping DMA (Direct Memory Access) operations.
	
	Values:
	Enabled, Disabled

	Note:
	May lower performance for power savings.
#>
	@{ DisplayName = 'DMA Coalescing'; DisplayValues = @('Disabled') },

	<#
	Setting:
	ECMA
	
	Description:
	Enables Energy Efficient Ethernet (EEE) as specified by the ECMA standard for lower power usage.
	
	Values:
	Enabled, Disabled

	Note:
	Related to energy savings.
#>
	@{ DisplayName = 'ECMA'; DisplayValues = @('Disabled') },
	@{ DisplayName = 'Energy-Efficient Ethernet'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Enable PME
	
	Description:
	Allows the network adapter to generate a Power Management Event (PME) to wake the computer.
	
	Values:
	Enabled, Disabled

	Note:
	Needed for wake-on-LAN.
#>
	@{ DisplayName = 'Enable PME'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Energy Efficient Ethernet
	
	Description:
	Reduces power consumption when network traffic is low using IEEE 802.3az standard.
	
	Values:
	Enabled, Disabled

	Note:
	Can slightly affect network performance.
#>
	@{ DisplayName = 'Energy Efficient Ethernet'; DisplayValues = @('Disabled', 'Off') },

	<#
	Setting:
	Flow Control
	
	Description:
	Manages data flow between computers to prevent packet loss during congestion.
	
	Values:
	Enabled, Disabled, Rx & Tx Enabled, Rx Enabled, Tx Enabled

	Note:
	Can help with network stability.
#>
	@{ DisplayName = 'Flow Control'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Gigabit Lite
	
	Description:
	Allows the adapter to operate in a lower-power gigabit mode.
	
	Values:
	Enabled, Disabled

	Note:
	May reduce speed for energy savings.
#>
	@{ DisplayName = 'Gigabit Lite'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Gigabit Master Slave Mode
	
	Description:
	Manually sets the adapter as master or slave for gigabit connections.
	
	Values:
	Auto, Master, Slave

	Note:
	Usually best to leave on Auto.
#>
	@{ DisplayName = 'Gigabit Master Slave Mode'; DisplayValues = @('Auto Detect') },

	<#
	Setting:
	Green Ethernet
	
	Description:
	Adjusts power usage based on cable length and network activity.
	
	Values:
	Enabled, Disabled

	Note:
	Energy saving feature.
#>
	@{ DisplayName = 'Green Ethernet'; DisplayValues = @('Disabled') },

	<#
	Setting:
	IPv4 Checksum Offload

	Description:
	Allows the network adapter to compute IPv4 checksums, offloading the task from the CPU.

	Values:
	Enabled, Disabled

	Note:
	Can improve system performance.
#>
	# @{ DisplayName = 'IPv4 Checksum Offload'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Interrupt Moderation Rate

	Description:
	Controls how often the network adapter generates interrupts to the CPU.

	Values:
	Adaptive, High, Medium, Low, Off

	Note:
	Lower rates reduce CPU usage but may add latency.
#>
	@{ DisplayName = 'Interrupt Moderation Rate'; DisplayValues = @('Off', 'Disabled') },

	<#
	Setting:
	Interrupt Moderation

	Description:
	Enables or disables grouping of interrupts to reduce CPU load.

	Values:
	Enabled, Disabled

	Note:
	Useful for reducing CPU overhead on busy networks.
#>
	@{ DisplayName = 'Interrupt Moderation'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Jumbo Frame

	Description:
	Allows larger-than-standard Ethernet frames for more efficient data transfer.

	Values:
	Disabled, 4088, 9014, 9216 Bytes (actual options vary by adapter)

	Note:
	All devices in the network must support it.
#>
	@{ DisplayName = 'Jumbo Frame'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Jumbo Packet

	Description:
	Alternate name for Jumbo Frame; allows setting maximum frame size.

	Values:
	Standard MTU, 4088, 9014, 9216 Bytes

	Note:
	Improves throughput on compatible networks.
#>

	@{ DisplayName = 'JumboPacket'; DisplayValues = @('1514', 'Disabled') },
	@{ DisplayName = 'Jumbo Packet'; DisplayValues = @('1514', 'Disabled') },

	<#
	Setting:
	Large Send Offload (IPv4)

	Description:
	Allows the adapter to offload segmentation of large IPv4 packets.

	Values:
	Enabled, Disabled

	Note:
	Reduces CPU load.
#>
	# @{ DisplayName = 'Large Send Offload (IPv4)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Large Send Offload v2 (IPv4)

	Description:
	Improved version of Large Send Offload for IPv4.

	Values:
	Enabled, Disabled

	Note:
	Better efficiency for modern networks.
#>
	# @{ DisplayName = 'Large Send Offload v2 (IPv4)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Large Send Offload v2 (IPv6)

	Description:
	Same as above but for IPv6 packets.

	Values:
	Enabled, Disabled

	Note:
	Reduces CPU load on IPv6 networks.
#>
	# @{ DisplayName = 'Large Send Offload v2 (IPv6)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Legacy Switch Compatibility Mode

	Description:
	Enables compatibility with older network switch hardware.

	Values:
	Enabled, Disabled

	Note:
	Only enable if you have issues with legacy switches.
#>
	@{ DisplayName = 'Legacy Switch Compatibility Mode'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Log Link State Event

	Description:
	Logs changes in the network connection status.

	Values:
	Enabled, Disabled

	Note:
	Helps in troubleshooting connection problems.
#>
	@{ DisplayName = 'Log Link State Event'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Max IRQ per Second

	Description:
	Sets the maximum number of interrupts per second for the adapter.

	Values:
	Numeric (varies by adapter)

	Note:
	Lower values can reduce CPU usage.
#>
	@{ DisplayName = 'Max IRQ per Second'; DisplayValues = @('30000') },

	<#
	Setting:
	Maximum Number of RSS Queues

	Description:
	Specifies how many Receive Side Scaling queues are used.

	Values:
	1, 2, 4, 8, etc. (varies by adapter)

	Note:
	Higher values help on multi-core systems.
#>
	@{ DisplayName = 'Maximum Number of RSS Queues'; DisplayValues = @('1 RSS Queues', '2 RSS Queues', '4 RSS Queues', '1 Queue', '2 Queue', '4 Queue', '2 Queues', '4 Queues') },

	<#
	Setting:
	Maximum number of RSS Processors

	Description:
	Limits how many processors RSS can use for network traffic.

	Values:
	1, 2, 4, 8, etc. (varies by adapter)

	Note:
	Matches or is less than total logical processors.
#>
	@{ DisplayName = 'Maximum number of RSS Processors'; DisplayValues = @('1', '2', '4', '8') },

	<#
	Setting:
	Media Status

	Description:
	Shows the current status of the network connection.

	Values:
	Always Connected, Normal

	Note:
	Usually for diagnostic use.
#>
	@{ DisplayName = 'Media Status'; DisplayValues = @('Always Connected') },

	<#
	Setting:
	NS Offload

	Description:
	Allows the adapter to respond to Neighbor Solicitation (NS) requests without waking the system.

	Values:
	Enabled, Disabled

	Note:
	Helps with power savings for IPv6.
#>
	@{ DisplayName = 'NS Offload'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Non-Admin Access

	Description:
	Allows non-administrator users to access adapter settings.

	Values:
	Enabled, Disabled

	Note:
	Can be a security risk if enabled.
#>
	@{ DisplayName = 'Non-Admin Access'; DisplayValues = @('Not Allowed') },

	<#
	Setting:
	PTP Hardware Timestamp

	Description:
	Enables hardware-based Precision Time Protocol timestamps for network traffic.

	Values:
	Enabled, Disabled

	Note:
	Used for highly accurate network timing.
#>
	@{ DisplayName = 'PTP Hardware Timestamp'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Packet Priority & VLAN

	Description:
	Enables support for 802.1p (priority tagging) and 802.1Q (VLAN tagging).

	Values:
	Enabled, Disabled

	Note:
	For networks using Quality of Service (QoS) and VLANs.
#>
	@{ DisplayName = 'Packet Priority & VLAN'; DisplayValues = @('Packet Priority & VLAN Disable', 'Packet Priority & VLAN Disabled') },

	<#
	Setting:
	Power Saving Mode

	Description:
	Puts the adapter into a low power state when idle.

	Values:
	Enabled, Disabled

	Note:
	May reduce power consumption.
#>
	@{ DisplayName = 'Power Saving Mode'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Priority & VLAN

	Description:
	Same as Packet Priority & VLAN; enables VLAN and traffic prioritization.

	Values:
	Enabled, Disabled

	Note:
	Improves network management.
#>
	@{ DisplayName = 'Priority & VLAN'; DisplayValues = @('Priority & VLAN Disabled') },

	<#
	Setting:
	Priority / VLAN tag

	Description:
	Enables tagging of packets with priority or VLAN information.

	Values:
	Enabled, Disabled

	Note:
	Required for some managed networks.
#>
	@{ DisplayName = 'Priority / VLAN tag'; DisplayValues = @('Priority & VLAN Disabled') },

	<#
	Setting:
	Protocol ARP Offload

	Description:
	Same as ARP Offload; adapter handles ARP requests when system sleeps.

	Values:
	Enabled, Disabled

	Note:
	Helps with network presence while asleep.
#>
	@{ DisplayName = 'Protocol ARP Offload'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Protocol NS Offload

	Description:
	Same as NS Offload; handles IPv6 NS requests when sleeping.

	Values:
	Enabled, Disabled

	Note:
	Improves IPv6 power efficiency.
#>
	@{ DisplayName = 'Protocol NS Offload'; DisplayValues = @('Enabled') },

	<#
	Setting:
	RSS load balancing profile

	Description:
	Sets how RSS distributes network processing across CPUs.

	Values:
	ClosestProcessor, ClosestRSSProcessor, NUMAScaling, ConservativeScaling

	Note:
	Helps tune performance for specific workloads.
	https://www.intel.com/content/www/us/en/support/articles/000006703/ethernet-products.html
#>
	@{ DisplayName = 'RSS load balancing profile'; DisplayValues = @('Closest Processor') },

	<#
	Setting:
	Receive Buffers

	Description:
	Number of buffers for incoming packets.

	Values:
	Numeric (varies by adapter)

	Note:
	Higher values may improve performance.
#>
	@{ DisplayName = 'Receive Buffers'; DisplayValues = @('2048', '4096') },

	<#
	Setting:
	Receive Side Scaling

	Description:
	Distributes incoming network traffic across multiple processors.

	Values:
	Enabled, Disabled

	Note:
	Improves performance on multi-core CPUs.
#>
	@{ DisplayName = 'Receive Side Scaling'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Reduce Speed On Power Down

	Description:
	Lowers link speed to save power when the system is idle.

	Values:
	Enabled, Disabled

	Note:
	May affect speed when waking up.
#>
	@{ DisplayName = 'Reduce Speed On Power Down'; DisplayValues = @('Disabled') },

	<#
	Setting:
	SWOI

	Description:
	Software Wake on Internet; wakes the device on internet activity.

	Values:
	Enabled, Disabled

	Note:
	May not be supported on all adapters.
#>
	@{ DisplayName = 'SWOI'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Selective Suspend Idle Timeout

	Description:
	Time in milliseconds before selective suspend activates.

	Values:
	Numeric (e.g., 100 ms)

	Note:
	Shorter times mean quicker power saving.
#>
	@{ DisplayName = 'Selective Suspend Idle Timeout'; DisplayValues = @('60') },

	<#
	Setting:
	Selective Suspend

	Description:
	Puts the adapter into a low-power state when not in use.

	Values:
	Enabled, Disabled

	Note:
	Helps with power saving on USB/Ethernet devices.
#>
	@{ DisplayName = 'Selective Suspend'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Shutdown Wake Up

	Description:
	Allows the adapter to wake the system from shutdown on network activity.

	Values:
	Enabled, Disabled

	Note:
	Required for some Wake-on-LAN features.
#>
	@{ DisplayName = 'Shutdown Wake Up'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Shutdown Wake-On-Lan

	Description:
	Allows system to wake from full shutdown (S5) using Wake-on-LAN.

	Values:
	Enabled, Disabled

	Note:
	Not all hardware supports waking from full power off.
#>
	@{ DisplayName = 'Shutdown Wake-On-Lan'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Software Timestamp

	Description:
	Enables timestamping of packets using software.

	Values:
	Enabled, Disabled

	Note:
	Less accurate than hardware timestamping.
#>
	@{ DisplayName = 'Software Timestamp'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Speed & Duplex

	Description:
	Sets the link speed and duplex mode of the network adapter.

	Values:
	Auto Negotiation, 10Mbps Half/Full, 100Mbps Half/Full, 1Gbps Full, etc.

	Note:
	Auto Negotiation is best for most users.
#>
	@{ DisplayName = 'Speed & Duplex'; DisplayValues = @('Auto Negotiation') },

	<#
	Setting:
	System Idle Power Saver

	Description:
	Reduces power usage when the system is idle.

	Values:
	Enabled, Disabled

	Note:
	Can help laptops save battery.
#>
	@{ DisplayName = 'System Idle Power Saver'; DisplayValues = @('Disabled') },

	<#
	Setting:
	TCP Checksum Offload (IPv4)

	Description:
	Offloads calculation of IPv4 TCP checksums to the adapter.

	Values:
	Enabled, Disabled

	Note:
	Frees up CPU resources.
#>
	# @{ DisplayName = 'TCP Checksum Offload (IPv4)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	TCP Checksum Offload (IPv6)

	Description:
	Offloads calculation of IPv6 TCP checksums.

	Values:
	Enabled, Disabled

	Note:
	Helps with IPv6 network performance.
#>
	# @{ DisplayName = 'TCP Checksum Offload (IPv6)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Transmit Buffers

	Description:
	Number of buffers for outgoing packets.

	Values:
	Numeric (varies by adapter)

	Note:
	More buffers may help with heavy network use.
#>
	@{ DisplayName = 'Transmit Buffers'; DisplayValues = @('1024', '2048', '8184') },

	<#
	Setting:
	UDP Checksum Offload (IPv4)

	Description:
	Offloads calculation of IPv4 UDP checksums.

	Values:
	Enabled, Disabled

	Note:
	Reduces CPU load.
#>
	# @{ DisplayName = 'UDP Checksum Offload (IPv4)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	UDP Checksum Offload (IPv6)

	Description:
	Offloads calculation of IPv6 UDP checksums.

	Values:
	Enabled, Disabled

	Note:
	Optimizes IPv6 UDP traffic.
#>
	# @{ DisplayName = 'UDP Checksum Offload (IPv6)'; DisplayValues = @('Enabled') },

	<#
	Setting:
	Ultra Low Power Mode

	Description:
	Puts the adapter into the lowest possible power state when not in use.

	Values:
	Enabled, Disabled

	Note:
	May delay connection on resume.
#>
	@{ DisplayName = 'Ultra Low Power Mode'; DisplayValues = @('Disabled') },

	<#
	Setting:
	WOL & Shutdown Link Speed

	Description:
	Sets link speed for Wake-on-LAN during shutdown.

	Values:
	Auto, 10Mbps, 100Mbps, 1Gbps

	Note:
	Lower speeds may use less power.
#>
	@{ DisplayName = 'WOL & Shutdown Link Speed'; DisplayValues = @('Not Speed Down') },

	<#
	Setting:
	Wait for Link

	Description:
	Delays system boot until network link is established.

	Values:
	On, Off

	Note:
	Useful for systems needing network at startup.
#>
	@{ DisplayName = 'Wait for Link'; DisplayValues = @('On') },

	<#
	Setting:
	Wake from S0ix on Magic Packet

	Description:
	Wakes device from modern standby (S0ix) on Magic Packet.

	Values:
	Enabled, Disabled

	Note:
	Needed for instant-on systems.
#>
	@{ DisplayName = 'Wake from S0ix on Magic Packet'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Wake on LAN

	Description:
	Allows the computer to be woken remotely using a special network message.

	Values:
	Enabled, Disabled

	Note:
	Requires configuration on both PC and network.
#>
	@{ DisplayName = 'Wake on LAN'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Wake on Link Settings

	Description:
	Controls waking the system when network link is detected.

	Values:
	Enabled, Disabled

	Note:
	May not be needed unless using specific network hardware.
#>
	@{ DisplayName = 'Wake on Link Settings'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Wake on Magic Packet

	Description:
	Allows waking the device when a Magic Packet is received.

	Values:
	Enabled, Disabled

	Note:
	Common Wake-on-LAN trigger.
#>
	@{ DisplayName = 'Wake on Magic Packet'; DisplayValues = @('Disabled') },

	<#
	Setting:
	Wake on Pattern Match

	Description:
	Allows waking the device when specific network patterns are detected.

	Values:
	Enabled, Disabled

	Note:
	For advanced Wake-on-LAN scenarios.
#>
	@{ DisplayName = 'Wake on Pattern Match'; DisplayValues = @('Disabled') }

	<#
	Setting:
	SSIdleTimeout

	Description:
	Specifies the maximum idle time, in seconds, before a network session is considered inactive 
	and is automatically disconnected. This helps manage resources and enforce security by 
	closing unused connections.

	Values:
	Any positive integer (typically in seconds). Common defaults range from 300 (5 minutes) to 1800 (30 minutes).

	Note:
	Set a lower value for security-sensitive environments to reduce exposure from idle connections. 
	Use a higher value if persistent connections are required for user convenience.
#>
	@{ DisplayName = 'SSIdleTimeout'; DisplayValues = @('60') }

	<#
	Setting:
	AutoDetach

	Description:
	Determines whether a device will automatically detach from the host system when a 
	USB reset or re-enumeration occurs. This is often used to allow firmware updates or 
	to reinitialize the device without manual unplugging.

	Values:
	Disabled  - Device remains attached during reset or re-enumeration.
	Enabled   - Device automatically detaches and reattaches during reset or re-enumeration.
	Use EEPROM Setting - Device follows the configuration stored in its EEPROM.

	Note:
	Enabled can simplify firmware updates or recovery, but may cause brief connection loss. 
	Use EEPROM Setting if the device’s built-in configuration should take precedence.
#>
	@{ DisplayName = 'AutoDetach'; DisplayValues = @('Use EEPROM Setting') }

	<#
	Setting:
	Mask WakeUp Event Timer

	Description:
	Specifies the delay before the system responds to a wake-up event after entering a low-power state. 
	This can help filter out unwanted or accidental wake-up triggers by ignoring events that occur 
	too soon after sleep.

	Values:
	0 second  - No delay; wake-up events are handled immediately.
	4 seconds  - Ignores wake-up events for the first 4 seconds after sleep.
	8 seconds  - Ignores wake-up events for the first 8 seconds after sleep.
	12 seconds - Ignores wake-up events for the first 12 seconds after sleep.
	16 seconds - Ignores wake-up events for the first 16 seconds after sleep.
	20 seconds - Ignores wake-up events for the first 20 seconds after sleep.
	24 seconds - Ignores wake-up events for the first 24 seconds after sleep.
	28 seconds - Ignores wake-up events for the first 28 seconds after sleep.

	Note:
	Use longer delays in environments prone to electrical noise or unintended wake signals. 
	Set to 0 seconds if you require the fastest possible wake-up response.
#>
	@{ DisplayName = 'Mask WakeUp Event Timer'; DisplayValues = @('0 second') }

	<#
	Setting:
	Wake on Link Change

	Description:
	Allows the system to wake from a low-power state when a change in the network link status 
	is detected, such as a cable being plugged in, unplugged, or a network speed/duplex change.

	Values:
	Disabled - Link status changes will not wake the system.
	Enabled - Any change in network link status will wake the system.

	Note:
	Enable for scenarios where immediate response to network link changes is required, 
	such as network diagnostics or remote access readiness. Disable to prevent unintended 
	wake-ups caused by transient link fluctuations.
#>
	@{ DisplayName = 'Wake on link change'; DisplayValues = @('Disabled') }

	<#
	Setting:
	WOL Link Power Saving

	Description:
	Controls whether the network adapter reduces link speed or power usage while the system 
	is in a low-power state, while still allowing Wake-on-LAN (WOL) functionality. This helps 
	save energy without fully disabling network wake capabilities.

	Values:
	Disabled - Maintains full link power in low-power states for maximum responsiveness.
	Enabled - Reduces link power consumption in low-power states while preserving WOL functionality.

	Note:
	Enable to conserve energy when the system is in sleep or standby, especially for battery-powered devices. 
	Disable if you require the fastest possible WOL response or if reduced link speed causes wake failures.
#>
	@{ DisplayName = 'WOL Link Power Saving'; DisplayValues = @('Disabled') }

	<#
    Setting:
    U1/U2 Power Saving

    Description:
    Controls whether the USB 3.0 link enters U1 or U2 low-power states when idle.
    These states allow the link to reduce power usage by partially suspending the
    connection while still maintaining readiness to resume full operation. U1 is a
    shallower, quicker-to-resume state, while U2 is deeper and more power-efficient
    but slightly slower to resume.

    Values:
    Disabled - Keeps the USB link in the U0 (active) state for maximum performance and lowest latency, at the cost of higher power usage.
    Enabled - Allows the USB link to enter U1/U2 states when idle to save power.

    Note:
    Enable to reduce power consumption on battery-powered systems or when using
    multiple USB devices that support U1/U2. Disable if you require the lowest
    possible latency or if certain USB devices experience connection delays or
    compatibility issues when resuming from low-power states.
#>
	@{ DisplayName = 'U1/U2 Power Saving'; DisplayValues = @('Disabled') }

	<#
    Setting:
    Suspend Low Power

    Description:
    Controls whether the device reduces power consumption while in a suspended
    state. When enabled, the device can enter a lower-power mode during suspend,
    conserving energy but potentially increasing resume latency.

    Values:
    Disabled - Keeps the device in a higher-power state during suspend for faster resume times and maximum responsiveness.
    Enabled - Allows the device to lower its power usage while suspended, saving energy.

    Note:
    Enable to extend battery life or reduce power usage in systems where longer
    resume times are acceptable. Disable if immediate wake performance is required
    or if certain devices do not function properly when resuming from low-power
    suspend.
#>
	@{ DisplayName = 'Suspend Low Power'; DisplayValues = @('Disabled') }

	<#
    Setting:
    Suspend AutoDetach

    Description:
    Controls whether the USB device automatically detaches from the host when the
    system enters a suspend state. This can help save power by fully disconnecting
    idle devices until the system resumes, after which the device will reattach.

    Values:
    Disabled - Keeps the device logically attached during suspend for quicker resume and uninterrupted functionality.
    Enabled - Automatically detaches the device during suspend to conserve power.

    Note:
    Enable to reduce power consumption on systems where detached devices can be
    reinitialized without issues upon resume. Disable if the device must remain
    continuously available or if reattachment causes delays or compatibility
    problems.
#>
	@{ DisplayName = 'Suspend AutoDetach'; DisplayValues = @('Disabled') }

	<#
    Setting:
    MAC Passthrough

    Description:
    Allows the network adapter to adopt the MAC address of another device,
    typically used in docking stations or with certain network configurations.
    This can ensure consistent network identification when switching between
    different hardware interfaces.

    Values:
    Disabled - Uses the network adapter’s built-in MAC address.
    Enabled - Inherits the MAC address from a connected device, such as a dock or external network interface.

    Note:
    Enable if you need consistent MAC addressing across multiple connection
    methods or when required by specific network policies. Disable to always use
    the adapter’s native MAC address for clear hardware identification.
#>
	@{ DisplayName = 'MAC Passthrough'; DisplayValues = @('Disabled') }

	<#
    Setting:
    ForceSuspend

    Description:
    Forces the device to enter the suspend state regardless of activity or pending
    operations. This can be used to ensure strict power savings, but may interrupt
    active data transfers or device functions.

    Values:
    Disabled - Allows the device to remain active if operations are ongoing, entering suspend only when idle or as determined by the system.
    Enabled - Forces the device into suspend mode immediately, even if operations are in progress.

    Note:
    Enable for maximum power savings when uninterrupted operation is not critical.
    Disable to prevent data loss or service interruptions when the device is active
    during a suspend event.
#>
	@{ DisplayName = 'ForceSuspend'; DisplayValues = @('Disabled') }

	<#
    Setting:
    Flow Control Mode Select

    Description:
    Determines how the network adapter handles Ethernet flow control, which is
    used to manage data transmission rates between devices to prevent packet loss
    during periods of high network traffic.

    Values:
    Aggressive Mode - Prioritizes sending pause frames quickly to slow incoming traffic, reducing the risk of buffer overflow but potentially lowering throughput.
    Passive Mode - Sends pause frames less frequently, allowing higher throughput but with a greater risk of packet loss under heavy load.

    Note:
    Use Aggressive Mode for environments with frequent congestion or where
    preventing packet loss is more important than maximum speed. Use Passive Mode
    for high-performance networks with minimal congestion and well-managed traffic.
#>
	@{ DisplayName = 'Flow Control Mode Select'; DisplayValues = @('Passive Mode') }

	<#
    Setting:
    Modern Standby Wake on Magic Packet

    Description:
    Controls whether the computer can wake from Modern Standby (low-power idle)
    mode when a specific Wake-on-LAN (WOL) Magic Packet is received. This feature
    allows remote wake capability while the system is in an ultra-low power state.

    Values:
    Disabled - Ignores Magic Packets during Modern Standby; the system will remain in low-power idle until another wake event occurs.
    Enabled - Wakes the system from Modern Standby upon receiving a valid Magic Packet.

    Note:
    Enable if you need to remotely wake the system while it is in Modern Standby,
    such as for updates or remote access. Disable to conserve maximum power or to
    prevent unintended wake events from network activity.
#>
	@{ DisplayName = 'Modern standby wake on Magic packet'; DisplayValues = @('Enabled') }

	<#
	Setting:
	NDIS QoS

	Description:
	Enables NIC-level Quality of Service so the adapter can mark and prioritize traffic (e.g., 802.1p/DSCP) and participate in Data Center Bridging features (ETS/PFC) when configured, helping latency-sensitive flows.

	Values:
	QoS Disabled, QoS Enabled

	Note:
	Best for managed networks using QoS/DCB (e.g., Hyper-V, SMB Direct/RDMA, iSCSI, VoIP). In typical home/office setups or with switches lacking QoS support, leave Disabled.
#>
	@{ DisplayName = 'NDIS QoS'; DisplayValues = @('QoS Disabled') }

	<#
	Setting:
	Recv Segment Coalescing (IPv4)

	Description:
	NIC offload that aggregates multiple incoming TCP segments from the same flow into a larger packet before handing it to the OS, reducing interrupts/CPU overhead and improving throughput for IPv4 traffic.

	Values:
	Disabled, Enabled

	Note:
	Usually beneficial to leave Enabled. May slightly add per-packet latency and can interfere with packet capture/IDS tools or certain VPN/teaming/virtual switch stacks—disable if troubleshooting odd latency, drops, or monitoring accuracy.
#>
	@{ DisplayName = 'Recv Segment Coalescing (IPv4)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Recv Segment Coalescing (IPv6)'; DisplayValues = @('Disabled') }

	<#
	Setting:
	Downshift retries

	Description:
	Sets how many failed 1Gb (1000BASE-T) auto-negotiation attempts the NIC’s PHY will make before disabling 1Gb and retrying link at 100/10 Mb to establish connectivity on marginal cabling or older gear. More retries = longer link-up time but greater chance to keep 1Gb; fewer retries = faster fallback to 100/10.

	Values:
	7, 6, 5, 4, 3, 2, 1, Disabled

	Note:
	Use higher values on known-good cabling to favor 1Gb links. Use lower values if links take long to come up or frequently drop to 100 Mb on suspect runs. “Disabled” prevents downshifting (keeps trying 1Gb), which can leave the link down on bad cabling; generally not recommended except for troubleshooting. Once the link is up, this setting doesn’t affect runtime speed/behavior.
#>
	@{ DisplayName = 'Downshift retries'; DisplayValues = @('7') }

	<#
	Setting:
	Wake from power off state

	Description:
	Allows the NIC to power on the system from a soft-off state (S5) when standby power is present—typically via a Magic Packet (WoL) or other wake events supported by the adapter. Not effective from mechanical off (G3) or when AC power is removed. Requires platform/BIOS and OS support to function.

	Values:
	Disabled, Enabled

	Note:
	Enable if you need Wake-on-LAN for remote access or maintenance after shutdown. May keep link LEDs on, draw a small standby power, or cause unintended wakes on noisy networks—use “Magic Packet only” if available. Ensure corresponding BIOS/UEFI PME/WoL options and the OS “Allow this device to wake the computer” setting are also enabled. Windows Fast Startup (hybrid shutdown, S4) can interact with this—behavior may differ by system.
#>
	@{ DisplayName = 'Wake from power off state'; DisplayValues = @('Disabled') }

	<#
	Setting:
	Wake on Link

	Description:
	Allows the NIC to wake the system when a physical Ethernet link is detected or restored (e.g., cable plugged in, switch port becomes active), without requiring a Magic Packet. Some adapters keep a low-power link alive while off so they can detect this event.

	Values:
	Disabled, Forced

	Note:
	Use “Forced” only if you specifically want the PC to power up on link change/restore. It can cause unintended wakes during link flaps, keeps link LEDs on, and draws small standby power. Requires BIOS/UEFI WoL/PME support and OS permission to let the NIC wake the computer. If you prefer wake via Magic Packet only, leave this Disabled.
#>
	@{ DisplayName = 'Wake on Link'; DisplayValues = @('Disabled') }

	<#
	Setting:
	Wake on Ping

	Description:
	Wakes the system when the NIC receives an ICMP Echo Request (ping) to its IP address while in a low-power state—no Magic Packet required. Relies on the adapter’s low-power filters/offloads (e.g., ARP/NDP, pattern match) and platform wake support.

	Values:
	Enabled, Disabled

	Note:
	Leave Disabled unless you specifically need to wake devices by ping. Any network scanner or stray ping can power the system on; ICMP filtering or blocked pings will prevent it from working. Requires BIOS/UEFI WoL/PME support and OS permission for the NIC to wake the computer; behavior may vary by adapter and may work only on the local subnet.
#>
	@{ DisplayName = 'Wake on Ping'; DisplayValues = @('Disabled') }

	@{ DisplayName = 'IPv4 Checksum Offload'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'Large Send Offload (IPv4)'; DisplayValues = @('Enabled') }
	@{ DisplayName = 'Large Send Offload V1 (IPv4)'; DisplayValues = @('Enabled') }
	@{ DisplayName = 'Large Send Offload V2 (IPv4)'; DisplayValues = @('Enabled') }
	@{ DisplayName = 'Large Send Offload V2 (IPv6)'; DisplayValues = @('Enabled') }
	@{ DisplayName = 'TCP Checksum Offload (IPv4)'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'TCP Checksum Offload (IPv6)'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'UDP Checksum Offload (IPv4)'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'UDP Checksum Offload (IPv6)'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'TCP/UDP Checksum Offload (IPv4)'; DisplayValues = @('Rx & Tx Enabled') }
	@{ DisplayName = 'TCP/UDP Checksum Offload (IPv6)'; DisplayValues = @('Rx & Tx Enabled') }

	@{ DisplayName = 'Link Speed Battery Saver'; DisplayValues = @('Disabled') }

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
	# Ethernet 3: AutoDetachTimer: Valid Values: 
	# Ethernet 3: NetworkAddress: Valid Values: 
	# Wi-Fi: Sleep on WoWLAN Disconnect: Valid Values: Disabled, Enabled
	# Wi-Fi: Packet Coalescing: Valid Values: Disabled, Enabled
	# Wi-Fi: ARP offload for WoWLAN: Valid Values: Disabled, Enabled
	# Wi-Fi: NS offload for WoWLAN: Valid Values: Disabled, Enabled
	# Wi-Fi: GTK rekeying for WoWLAN: Valid Values: Disabled, Enabled
	# Wi-Fi: Channel Width for 2.4GHz: Valid Values: 20 MHz Only, Auto
	# Wi-Fi: Channel Width for 5GHz: Valid Values: 20 MHz Only, Auto
	# Wi-Fi: Mixed Mode Protection: Valid Values: RTS/CTS Enabled, CTS-to-self Enabled
	# Wi-Fi: Fat Channel Intolerant: Valid Values: Disabled, Enabled
	# Wi-Fi: Transmit Power: Valid Values: 1. Lowest, 2. Medium-low, 3. Medium, 4. Medium-High, 5. Highest
	# Wi-Fi: 802.11n/ac/ax Wireless Mode: Valid Values: 1. Disabled, 2. 802.11n, 3. 802.11ac, 4. 802.11ax
	# Wi-Fi: MIMO Power Save Mode: Valid Values: Auto SMPS, Static SMPS, Dynamic SMPS, No SMPS
	# Wi-Fi: Roaming Aggressiveness: Valid Values: 1. Lowest, 2. Medium-low, 3. Medium, 4. Medium-High, 5. Highest
	# Wi-Fi: Preferred Band: Valid Values: 1. No Preference, 2. Prefer 2.4GHz band, 3. Prefer 5GHz band
	# Wi-Fi: Throughput Booster: Valid Values: Disabled, Enabled
	# Wi-Fi: U-APSD support: Valid Values: Disabled, Enabled
	# Wi-Fi: 802.11a/b/g Wireless Mode: Valid Values: 1. 5GHz 802.11a, 2. 2.4GHz 802.11b, 3. 2.4GHz 802.11g, 4. 2.4GHz 802.11b/g, 5. Dual Band 802.11a/g, 6. Dual Band 802.11a/b/g
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
$WakeOnLan_Popup = [Windows.Forms.MessageBox]::Show(
	(New-Object Windows.Forms.Form -Property @{ TopMost = $true }),
	'Enable Wake-On-LAN?',
	'Wake-On-LAN',
	[Windows.Forms.MessageBoxButtons]::YesNo,
	[Windows.Forms.MessageBoxIcon]::Question
)
if ($WakeOnLan_Popup -eq [Windows.Forms.DialogResult]::Yes) {
	$PnPValue = 256
	$pmStatus = 'Enabled'
}
else {
	$PnPValue = 24
	$pmStatus = 'Disabled'
}

$NetworkAdapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue
$pmAdapters = $NetworkAdapters | Get-NetAdapterPowerManagement -ErrorAction SilentlyContinue
foreach ($pm in $pmAdapters) {
	Set-NetAdapterPowerManagement -InputObject $pm -WakeOnPattern $pmStatus -WakeOnMagicPacket $pmStatus -DeviceSleepOnDisconnect Disabled -SelectiveSuspend Disabled -Confirm:$false
}

$KeyRoot = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}'
foreach ($nic in $NetworkAdapters) {
	$ifGuid = $nic.InterfaceGuid.ToString()
	Get-ChildItem -Path $KeyRoot -ErrorAction SilentlyContinue | ForEach-Object {
		$subKeyPath = $_.PSPath
		$props = Get-ItemProperty -Path $subKeyPath -Name NetCfgInstanceID, PnPCapabilities -ErrorAction SilentlyContinue
		if ($props.NetCfgInstanceID -and $props.NetCfgInstanceID -eq $ifGuid) {
			if ($props.PnPCapabilities -ne $PnPValue) {
				New-ItemProperty -Path $subKeyPath -Name PnPCapabilities -Value $PnPValue -Force
				Disable-PnpDevice -InstanceId $nic.PnPDeviceID -Confirm:$false
				Enable-PnpDevice -InstanceId $nic.PnPDeviceID -Confirm:$false
			}
		}
	}
}

$WakeOnLanProperties = @(
	'Enable PME',
	'Shutdown Wake Up',
	'Wake from power off state'
)
foreach ($Adapter in $NetworkAdapters) {
	$AdvancedProperties = Get-NetAdapterAdvancedProperty -Name $Adapter.Name -ErrorAction SilentlyContinue
	if ($AdvancedProperties) {
		foreach ($PropertyName in $WakeOnLanProperties) {
			if ($AdvancedProperties | Where-Object { $_.DisplayName -eq $PropertyName }) {
				Set-NetAdapterAdvancedProperty -Name $Adapter.Name -DisplayName $PropertyName -DisplayValue $pmStatus
			}
		}
	}
}

while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) {
	Start-Sleep -Milliseconds 1000
}

<#
Deprecated:

	Setting:
	NetDMA (Network Direct Memory Access)

	Description:
	Controls whether NetDMA is used to offload memory copy operations for network traffic, reducing CPU overhead by allowing direct transfers between network and system memory.

	Values:
	enabled - NetDMA is used if supported by hardware.
	disabled - NetDMA is not used; CPU handles memory copy operations.

	Note:
	Disabling NetDMA can improve compatibility on systems where hardware or drivers do not fully support it. On supported hardware, enabling may improve network performance with lower CPU usage.
	https://learn.microsoft.com/en-us/previous-versions/windows/hardware/network/netdma-drivers

netsh interface tcp set global netdma=enabled

	Setting:
	LocalPriority

	Description:
	Specifies the priority for resolving local hostnames (e.g., machine's own name).

	Values:
	Lower number = Higher priority
	Example: 1 is higher priority than 4

	Note:
	Has no effect on modern Windows systems (Windows 2000 and later), as name resolution now follows built-in rules defined by RFC 3484 and RFC 6724.

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 2 -PropertyType DWord -Force

	Setting:
	HostsPriority

	Description:
	Specifies the priority for resolving names via the local `hosts` file (C:\Windows\System32\drivers\etc\hosts).

	Values:
	Lower number = Higher priority
	Example: 1 is higher priority than 4

	Note:
	Ignored by modern Windows systems. Changing this setting does not impact resolution order beyond Windows NT 4.0.

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 3 -PropertyType DWord -Force

	Setting:
	DnsPriority

	Description:
	Specifies the priority for resolving names via DNS servers.

	Values:
	Lower number = Higher priority
	Example: 1 is higher priority than 4

	Note:
	This registry value is obsolete on modern systems. Windows uses built-in name resolution logic regardless of this setting.

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 4 -PropertyType DWord -Force

	Setting:
	NetbtPriority

	Description:
	Specifies the priority for resolving names via NetBIOS over TCP/IP.

	Values:
	Lower number = Higher priority
	Example: 1 is higher priority than 8

	Note:
	Deprecated on modern systems. NetBIOS is largely phased out and no longer affected by this setting.

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 8 -PropertyType DWord -Force
#>