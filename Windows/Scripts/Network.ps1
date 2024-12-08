# Private Network
$FirewallRules = @(
	# File and printer sharing
	'@FirewallAPI.dll,-32752',

	# Network discovery
	'@FirewallAPI.dll,-28502'
)
Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled True
Set-NetFirewallRule -Profile Public, Private -Name FPS-SMB-In-TCP -Enabled True
Set-NetConnectionProfile -NetworkCategory Private


# 1. Retrieve All Network Adapters
$NetworkAdapters = Get-NetAdapter

# 2. Modify Registry for Network Optimization
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'LocalPriority' -Value 4 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'HostsPriority' -Value 5 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'DnsPriority' -Value 6 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\ServiceProvider' -Name 'NetbtPriority' -Value 7 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value -1 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'Size' -Value 3 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\LanmanServer\Parameters' -Name 'IRPStackSize' -Value 32 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Session Manager\Memory Management' -Name 'LargeSystemCache' -Value 0 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'MaxUserPort' -Value 65534 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'TcpTimedWaitDelay' -Value 30 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\Parameters' -Name 'DefaultTTL' -Value 64 -PropertyType 'DWord' -Force
if (-not (Test-Path -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS')) {
	New-Item -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Force
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value '1' -PropertyType 'String' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER' -Name 'iexplore.exe' -Value 10 -PropertyType 'DWord' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER' -Name 'iexplore.exe' -Value 10 -PropertyType 'DWord' -Force

# 3. Apply TCP Settings for Congestion Control, DCA, etc.
Set-NetTCPSetting -ScalingHeuristics Disabled
Set-NetTCPSetting -MaxSynRetransmissions 2
Set-NetTCPSetting -NonSackRttResiliency Disabled
Set-NetTCPSetting -InitialRtoMs 2000
Set-NetTCPSetting -AutoTuningLevelLocal Normal
Set-NetTCPSetting -EcnCapability Disabled
Set-NetTCPSetting -Timestamps Disabled

# 4. Disable RSS Globally
netsh int tcp set global rss=disabled

# 5. Disable Specific Offloads Globally
Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Disabled
Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disabled
Set-NetOffloadGlobalSetting -ReceiveSideScaling Disabled
Set-NetOffloadGlobalSetting -Chimney Disabled

# 6. Update Adapter-Specific Settings
$SettingsToChange = @(
	@{ DisplayName = 'Energy Efficient Ethernet'; DisplayValues = @('Disabled', 'Off') }
	@{ DisplayName = 'Flow Control'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Gigabit Master Slave Mode'; DisplayValues = @('Auto Detect') }
	@{ DisplayName = 'IPv4 Checksum Offload'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Interrupt Moderation Rate'; DisplayValues = @('Off') }
	@{ DisplayName = 'Interrupt Moderation'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Jumbo Frame'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Jumbo Packet'; DisplayValues = @('1514', 'Disabled') }
	@{ DisplayName = 'Large Send Offload (IPv4)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Large Send Offload v2 (IPv4)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Large Send Offload v2 (IPv6)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Legacy Switch Compatibility Mode'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Log Link State Event'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Max IRQ per Second'; DisplayValues = @('30000') }
	@{ DisplayName = 'Maximum Number of RSS Queues'; DisplayValues = @('1 RSS Queues', '1 Queue') }
	@{ DisplayName = 'NS Offload'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'PTP Hardware Timestamp'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Packet Priority & VLAN'; DisplayValues = @('Packet Priority & VLAN Disabled') }
	@{ DisplayName = 'Protocol ARP Offload'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Protocol NS Offload'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Receive Buffers'; DisplayValues = @('2048') }
	@{ DisplayName = 'Receive Side Scaling'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Reduce Speed On Power Down'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Selective Suspend'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Selective Suspend Idle Timeout'; DisplayValues = @('5') }
	@{ DisplayName = 'Software Timestamp'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Speed & Duplex'; DisplayValues = @('1.0 Gbps Full Duplex') }
	@{ DisplayName = 'System Idle Power Saver'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'TCP Checksum Offload (IPv4)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'TCP Checksum Offload (IPv6)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Transmit Buffers'; DisplayValues = @('1024', '2048') }
	@{ DisplayName = 'UDP Checksum Offload (IPv4)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'UDP Checksum Offload (IPv6)'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Ultra Low Power Mode'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Wait for Link'; DisplayValues = @('Off') }
	@{ DisplayName = 'Wake from S0ix on Magic Packet'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Wake on Link Settings'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Wake on Pattern Match'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Adaptive Inter-Frame Spacing'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'DMA Coalescing'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'WOL & Shutdown Link Speed'; DisplayValues = @('Not Speed Down') }
	@{ DisplayName = 'Shutdown Wake-On-Lan'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Priority & VLAN'; DisplayValues = @('Priority & VLAN Disabled') }
	@{ DisplayName = 'Gigabit Lite'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Power Saving Mode'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'Green Ethernet'; DisplayValues = @('Disabled') }
	@{ DisplayName = 'ECMA'; DisplayValues = @('Enabled') }
)

foreach ($Adapter in $NetworkAdapters) {
	$AdvancedProperties = Get-NetAdapterAdvancedProperty -Name $Adapter.Name -ErrorAction Stop
	foreach ($Setting in $SettingsToChange) {
		$Property = $AdvancedProperties | Where-Object { $_.DisplayName -eq $Setting.DisplayName }
		if ($Property) {
			foreach ($Value in $Setting.DisplayValues) {
				Write-Host "$($Adapter.Name): $($Setting.DisplayName): $Value" -ForegroundColor Green
				Set-NetAdapterAdvancedProperty -Name $Adapter.Name -DisplayName $Setting.DisplayName -DisplayValue $Value
			}
		}
	}
}

# 7. Disable Binding Settings for Specific Adapters
$DisableAdapterSettings = @('Large Send Offload', 'Checksum Offload')
foreach ($Setting in $DisableAdapterSettings) {
	Write-Host "Disabling $Setting for all adapters" -ForegroundColor Green
	Get-NetAdapter | ForEach-Object {
		$Binding = Get-NetAdapterBinding -Name $_.Name -AllBindings | Where-Object { $_.DisplayName -eq $Setting }
		if ($Binding) {
			Disable-NetAdapterBinding -Name $_.Name -DisplayName $Setting -Confirm:$false
		}
	}
}

# 8. Enable or Disable Wake-on-LAN Based on User Input
Add-Type -AssemblyName System.Windows.Forms
$WakeOnLanAnswer = [Windows.Forms.MessageBox]::Show('Enable Wake-On-Lan?', 'Wake-On-Lan', 4, 32)
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

# Update Wake-on-LAN settings with the PnPValue
$NetworkAdapters | ForEach-Object {
	Set-NetAdapterPowerManagement -Name $_.Name -WakeOnPattern $WakeOnLanStatus -Confirm:$false
	Set-NetAdapterPowerManagement -Name $_.Name -WakeOnMagicPacket $WakeOnLanStatus -Confirm:$false
	Set-NetAdapterPowerManagement -Name $_.Name -DeviceSleepOnDisconnect $WakeOnLanStatus -Confirm:$false
}

# Update Registry for Enabling/Disabling Wake-on-LAN Based on User Input
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

# 9. Disable Teredo
netsh interface teredo set state disabled

# 10. Wait for Network Connection
while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) {
	Start-Sleep -Milliseconds 1000
}
