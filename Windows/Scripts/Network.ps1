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
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 255 -PropertyType DWord -Force

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
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'TcpMaxDupAcks' -PropertyType DWord -Value 3 -Force

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
	GPU Priority

	Description:
	Defines the GPU scheduling priority for the specified multimedia task—in this case, for games.

	Values:
	0–31 (decimal) - Higher values indicate higher GPU scheduling priority.
	Default - Typically 6 for games.
	8 - Gives the game task higher priority access to GPU resources.

	Note:
	This setting affects how the Multimedia Class Scheduler Service (MMCSS) allocates GPU time. Increasing the value can improve responsiveness and performance in games, but excessive values may starve other GPU-using tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'GPU Priority' -Value 8 -PropertyType DWord -Force

<#
	Setting:
	Priority

	Description:
	Sets the CPU scheduling priority for the specified multimedia task—in this case, games—under the Multimedia Class Scheduler Service (MMCSS).

	Values:
	1–8 (decimal) - Higher numbers give higher CPU scheduling priority.
	Default - Typically 6 for games.
	8 - Maximum priority within MMCSS-managed range.

	Note:
	This influences how much CPU time is given to games compared to other multimedia tasks. Higher values improve responsiveness but may reduce performance of background tasks or services.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Priority' -Value 6 -PropertyType DWord -Force

<#
	Setting:
	Scheduling Category

	Description:
	Defines the type of scheduling behavior applied to the task under the Multimedia Class Scheduler Service (MMCSS), influencing how aggressively it receives CPU time.

	Values:
	Low - Lowest priority for background tasks.
	Medium - Balanced CPU access.
	High - Higher CPU priority; suitable for latency-sensitive tasks like games.
	Exclusive - Highest priority; reserves CPU time exclusively (used with caution).

	Note:
	Setting this to "High" ensures games get faster CPU response compared to normal or background tasks. "Exclusive" may impact overall system responsiveness and is generally reserved for critical media tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Scheduling Category' -Value 'High' -PropertyType String -Force

<#
	Setting:
	SFIO Priority

	Description:
	Defines the background I/O (Slow File I/O) priority level for the task, affecting how Windows schedules disk operations for that task.

	Values:
	Idle - Lowest disk I/O priority.
	Low - Lower than normal I/O.
	Normal - Default priority for standard tasks.
	High - Elevated disk I/O priority for performance-critical tasks.

	Note:
	Setting this to "High" gives games higher priority access to disk resources, reducing I/O latency during gameplay. Useful for minimizing stutters from background disk activity.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'SFIO Priority' -Value 'High' -PropertyType String -Force

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
#>
Disable-NetAdapterChecksumOffload -Name *

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
#>
Disable-NetAdapterLso -Name *

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
Set-NetTCPSetting -AutoTuningLevelLocal normal
netsh interface tcp set global autotuninglevel=normal

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
netsh interface tcp set global ecncapability=enabled

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
Set-NetTCPSetting -InitialRtoMs 300

<#
	Setting:
	MaxSynRetransmissions

	Description:
	Specifies the maximum number of times TCP will retransmit a SYN packet when attempting to establish a connection.

	Values:
	1–8 (decimal) - Number of SYN retransmissions before giving up.
	Default - 2 or 3, depending on Windows version.
	2 - TCP gives up after sending the initial SYN and 2 retransmissions (total of 3 SYNs).

	Note:
	Lower values reduce connection retry time for unreachable hosts, which can improve responsiveness in some apps. Higher values improve reliability on slow or unstable networks.
#>
Set-NetTCPSetting -MaxSynRetransmissions 8
netsh interface tcp set global maxsynretransmissions=8

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
netsh interface tcp set global nonsackrttresiliency=enabled

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