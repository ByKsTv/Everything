# Table Of Contents

- [LAN](#lan)
  - [Equipment](#lan---equipment)
  - [Pi-Hole Setup](#lan---pi-hole---setup)
  - [Router Setup](#lan---router---setup)
  - [More - LAN](#lan---more)
- [WAN](#wan)
  - [Equipment](#wan---equipment)
  - [More - WAN](#wan---more)
- [Mobile](#mobile)
- [Television](#television)
  - [Android TV](#android-tv)
    - [Setup](#android-tv---setup)
    - [Apps](#android-tv---apps)
      - [Setup](#android-tv---apps---setup)
    - [Notes](#android-tv---notes)
  - [Samsung](#samsung)
    - [Setup](#samsung-tv---setup)
    - [Notes](#samsung-tv---notes)
  - [LG](#lg)
    - [Setup](#lg-tv---setup)
    - [Notes](#lg-tv---notes)
  - [More - TV](#more)
  - [Clean](#clean)
- [Cancel](#cancel)

## LAN

### LAN - Equipment

1. Network Rack.
1. Rack-mountable router.
1. Cat 7 Cable (23AWG)
1. [Cable Strain Relief Boots (50PCS, 8.0mm Transparent)](https://www.aliexpress.com/item/4001178933737.html)
1. [Cable Stripper](https://www.aliexpress.com/item/1005005858039905.html)
1. [Cat 7 Connector (CAT7 Normal Silver)](https://www.aliexpress.com/item/1005004323161234.html) (Do not use passthrough)
1. [Cat 7 Crimper](https://www.aliexpress.com/item/33031923435.html)
1. [Cat 7 Keystone Jack (CAT7 STP)](https://www.aliexpress.com/item/1005006297343620.html)
1. [Cable Tester](https://www.aliexpress.com/item/4001142001681.html)

### LAN - Pi-Hole - Setup

- [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) (or higher)
- MicroSD Card (A2).
- MicroSD Card Reader.
- A router with access to change the DNS settings.

1. Download and Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
1. Enable `SSH`.
1. Set `Locale`.
1. Disable `Telemetry`.
1. Download and Open [PuTTY](https://www.putty.org/).
1. Login to Raspberry Pi IP.

1. Install Pi-Hole:

   ```bash
   curl -sSL https://install.pi-hole.net | sudo bash
   ```

1. Set Pi-Hole WebUI Password:

   ```bash
   sudo pihole -a -p
   ```

1. Install Unbound:

   ```bash
   sudo apt install unbound -y
   ```

1. Edit `/etc/unbound/unbound.conf.d/pi-hole.conf`:

   ```bash
   sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
   ```

1. Add server settings:

   ```conf
   server:
       # If no logfile is specified, syslog is used
       # logfile: "/var/log/unbound/unbound.log"
       verbosity: 0

       interface: 127.0.0.1
       port: 5335
       do-ip4: yes
       do-udp: yes
       do-tcp: yes

       # May be set to yes if you have IPv6 connectivity
       do-ip6: yes

       # You want to leave this to no unless you have *native* IPv6. With 6to4 and
       # Terredo tunnels your web browser should favor IPv4 for the same reasons
       prefer-ip6: yes

       # Use this only when you downloaded the list of primary root servers!
       # If you use the default dns-root-data package, unbound will find it automatically
       #root-hints: "/var/lib/unbound/root.hints"

       # Trust glue only if it is within the server's authority
       harden-glue: yes

       # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
       harden-dnssec-stripped: yes

       # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
       # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
       use-caps-for-id: no

       # Reduce EDNS reassembly buffer size.
       # IP fragmentation is unreliable on the Internet today, and can cause
       # transmission failures when large DNS messages are sent via UDP. Even
       # when fragmentation does work, it may not be secure; it is theoretically
       # possible to spoof parts of a fragmented DNS message, without easy
       # detection at the receiving end. Recently, there was an excellent study
       # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
       # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
       # in collaboration with NLnet Labs explored DNS using real world data from the
       # the RIPE Atlas probes and the researchers suggested different values for
       # IPv4 and IPv6 and in different scenarios. They advise that servers should
       # be configured to limit DNS messages sent over UDP to a size that will not
       # trigger fragmentation on typical network links. DNS servers can switch
       # from UDP to TCP when a DNS response is too big to fit in this limited
       # buffer size. This value has also been suggested in DNS Flag Day 2020.
       edns-buffer-size: 1232

       # Perform prefetching of close to expired message cache entries
       # This only applies to domains that have been frequently queried
       prefetch: yes

       # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
       num-threads: 1

       # Ensure kernel buffer is large enough to not lose messages in traffic spikes
       so-rcvbuf: 1m

       # Ensure privacy of local IP ranges
       private-address: 192.168.0.0/16
       private-address: 169.254.0.0/16
       private-address: 172.16.0.0/12
       private-address: 10.0.0.0/8
       private-address: fd00::/8
       private-address: fe80::/10

       # Ensure no reverse queries to non-public IP ranges (RFC6303 4.2)
       private-address: 192.0.2.0/24
       private-address: 198.51.100.0/24
       private-address: 203.0.113.0/24
       private-address: 255.255.255.255/32
       private-address: 2001:db8::/32
   ```

1. Disable `unbound-resolvconf.service`:

   ```bash
   sudo systemctl disable --now unbound-resolvconf.service
   ```

1. Disable `resolvconf_resolvers.conf`:

   ```bash
   sudo sed -Ei 's/^unbound_conf=/#unbound_conf=/' /etc/resolvconf.conf
   ```

1. Delete `resolvconf_resolvers.conf`:

   ```bash
   sudo rm /etc/unbound/unbound.conf.d/resolvconf_resolvers.conf
   ```

1. Restart Unbound:

   ```bash
   sudo service unbound restart
   ```

[Source](https://docs.pi-hole.net/guides/dns/unbound/)

1. Set scheduled tasks:

   ```bash
   sudo crontab -e
   ```

1. Add auto update tasks:

   ```bash
   00 04 * * * sudo apt-get update -y
   10 04 * * * sudo apt-get upgrade -y
   20 04 * * * sudo apt-get dist-upgrade -y
   30 04 * * * sudo apt-get full-upgrade -y
   00 05 * * * sudo apt-get autoclean -y
   10 05 * * * sudo apt-get autoremove -y
   20 05 * * * sudo pihole -up
   30 05 * * * sudo pihole -g
   ```

1. If user have Argon ONE Case:

   ```bash
   curl https://download.argon40.com/argon1.sh | sudo bash
   ```

1. Browser > Pi-Hole IP > Login to Pi-Hole WebUI.
1. `Settings` > `DNS` > `Upstream DNS Servers` > `127.0.0.1#5335`
1. `Settings` > `DNS` > `Interface settings` > `Permit all origins`.
1. `Settings` > `DNS` > `Advanced DNS settings` > `Rate-limiting` > `Block clients making more than 0 queries within 0 seconds`.
1. `Settings` > `Web interface` > `Pi-hole deep-midnight theme (dark)`.

Adlists:

```text
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts https://v.firebog.net/hosts/static/w3kbl.txt https://adaway.org/hosts.txt https://v.firebog.net/hosts/AdguardDNS.txt https://v.firebog.net/hosts/Admiral.txt https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt https://v.firebog.net/hosts/Easylist.txt https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts https://v.firebog.net/hosts/Easyprivacy.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt https://v.firebog.net/hosts/Prigent-Crypto.txt https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt https://phishing.army/download/phishing_army_blocklist_extended.txt https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts https://urlhaus.abuse.ch/downloads/hostfile/ https://www.github.developerdan.com/hosts/lists/hate-and-junk-extended.txt https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt https://someonewhocares.org/hosts/zero/hosts https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts https://winhelp2002.mvps.org/hosts.txt https://v.firebog.net/hosts/neohostsbasic.txt https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt https://v.firebog.net/hosts/Prigent-Malware.txt https://blocklistproject.github.io/Lists/ads.txt https://raw.githubusercontent.com/anudeepND/blacklist/master/CoinMiner.txt https://blocklistproject.github.io/Lists/tracking.txt https://blocklistproject.github.io/Lists/ransomware.txt https://blocklistproject.github.io/Lists/phishing.txt https://blocklistproject.github.io/Lists/crypto.txt https://blocklistproject.github.io/Lists/fraud.txt https://someonewhocares.org/hosts/hosts https://v.firebog.net/hosts/RPiList-Malware.txt https://v.firebog.net/hosts/RPiList-Phishing.txt https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts https://malware-filter.gitlab.io/malware-filter/phishing-filter-hosts.txt https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt https://raw.githubusercontent.com/sakib-m/Pi-hole-Torrent-Blocklist/main/all-torrent-websites.txt https://raw.githubusercontent.com/sakib-m/Pi-hole-Torrent-Blocklist/main/all-torrent-trackers.txt https://github.com/matomo-org/referrer-spam-blacklist/raw/master/spammers.txt https://raw.githubusercontent.com/stamparm/blackbook/master/blackbook.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/EasyPrivacyCNAME.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardTracking.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardCNAME.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt https://raw.githubusercontent.com/infinitytec/blocklists/master/ads-and-trackers.txt https://raw.githubusercontent.com/infinitytec/blocklists/master/scams-and-phishing.txt https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/domains https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.list https://raw.githubusercontent.com/nextdns/cname-cloaking-blocklist/master/domains https://raw.githubusercontent.com/paulgb/BarbBlock/master/blacklists/domain-list.txt https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts https://raw.githubusercontent.com/lightswitch05/hosts/master/docs/lists/ads-and-tracking-extended.txt https://raw.githubusercontent.com/yous/YousList/master/hosts.txt https://raw.githubusercontent.com/bkrcrc/turk-adlist/master/hosts https://raw.githubusercontent.com/omicron-b/custom-filters/master/domains_imported.txt https://raw.githubusercontent.com/Dawsey21/Lists/master/main-blacklist.txt https://raw.githubusercontent.com/olbat/ut1-blacklists/master/blacklists/stalkerware/domains https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt https://urlhaus.abuse.ch/downloads/rpz/ https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts https://raw.githubusercontent.com/PoorPocketsMcNewHold/SteamScamSites/master/steamscamsite.txt https://big.oisd.nl https://raw.githubusercontent.com/ByKsTv/Everything/main/Internet/Pi-Hole/Blacklist.txt
```

Allowlist:

```text
https://raw.githubusercontent.com/ByKsTv/Everything/main/Internet/Pi-Hole/Allowlist.txt
```

Domains Regex Blacklist:

```regex
^ad([sxv]?[0-9]*|system)[_.-]([^.[:space:]]+\.){1,}|[_.-]ad([sxv]?[0-9]*|system)[_.-]
^(.+[_.-])?adse?rv(er?|ice)?s?[0-9]*[_.-]
^(.+[_.-])?telemetry[_.-]
^adim(age|g)s?[0-9]*[_.-]
^adtrack(er|ing)?[0-9]*[_.-]
^advert(s|is(ing|ements?))?[0-9]*[_.-]
^aff(iliat(es?|ion))?[_.-]
^analytics?[_.-]
^banners?[_.-]
^beacons?[0-9]*[_.-]
^count(ers?)?[0-9]*[_.-]
^mads\.
^pixels?[-.]
^stat(s|istics)?[0-9]*[_.-]
```

Known Issues:

- When using `Pi-Hole` and `Kan11` app - a pop-up will say "No Connection" when first watching live.
- When using `Pi-Hole` and `Samsung` TV - can't install new apps.

### LAN - Router - Setup

1. `Network Application` > `Settings` > `System` > `General` > `Country/Region` > `United States`
   > This will improve WiFI signal.

### LAN - More

- More information about Ubiquiti:

  - [AP Antenna Radiation Patterns](https://help.ui.com/hc/en-us/articles/115005212927-AP-Antenna-Radiation-Patterns)
  - [777 or 404](https://www.youtube.com/@hz777)
  - [Mactelecom Networks](https://www.youtube.com/@MactelecomNetworks)

- For some IoT devices such as WiFi printers and WiFi universal remote will have issues if the "Band Steering" option is enabled.

- Do not plug RJ45 male connector at a sharp angle and stress it, it will damage the copper pins on the RJ45 female port.

## WAN

### WAN - Equipment

- Some ISPs use PPPoE and some use DHCP:

  - PPPoE - Visit the ISP website to know which SFP moudle to buy, tell the ISP Customer Service the serial number in order to activate it.
  - DHCP - TODO.

### WAN - More

- Ways to contact the ISP:

  - Chat with ISP technicians on Whatsapp.
  - Chat with ISP Customer Service on Whatsapp.
  - Report a hazarad damaged cable using the ISP website.
  - Send a public inquiry using the ISP website.
  - Call ISP technicians.
  - Call ISP Customer Service.
  - File a complaint on the Ministery of Communications website.

- Create a reminder to renew the plan each year.

- When adding or removing fixed IP, brief disconnections will occour:

  - On PPPoE Connection - Adding a fixed IP - 12 Seconds.
  - On PPPoE Connection - Removing a fixed IP - 10 Seconds.

- When changing ISP bandwidth plan, brief packet loss will occour but the actual change will occur when you manually reconnect.

- When trying to help a user with ISP router - first contact the ISP technical support.

- Process of moving from aerial infrastructure to underground infrastructure:

  - Contact Ministery of communications, request an underground infrastructure (some require payment).
  - Pay an upfront payment for opening a case (estimate around 160USD).
  - The area manager will come and inspect the area, make your demands to him and be clear on what's your plan is.
  - If you get the approvals and signetures yourself you'll receive a discount.
  - Get the plan from the area manager and contact the city reception in order to receive approval.
  - Pay the full price for the underground plan devised by the area manager (estimate around 450USD)
  - Contractors with heavy machinery will cut the road and get a network pipe 50CM diameter and will fill up the road with sand.
  - Contractors will later arrive to create an FDT box.
  - Contact ISP customer service on whatsapp and request to connect to the newly installed FDT box.
  - Sumbit a public inquiry to request a fix to the road.

- Technician law:

  - Example: Technician schduled to arrive from 12:00 to 14:00.
  - Technician arrives before 16:00 - No compensation.
  - Technician arrives after 16:00 - X compensation.
  - Technician arrives after 17:00 - X2 compensation.
  - Search for `Technician law` on Google.

- Process of getting a compensation thanks to `Technician law`:

  - Send a public inquiry using the ISP website.
  - You'll receive a phone call from the boss of the technician which will try to lie to you, just say `I would like a compensation`.
  - Now you'll receive a phone call from the public inquiry repesenetive which will get you your compensation.

- Process of reporting a damaged ISP cable and no internet connection:

  - Take a picture of the damaged ISP cable.
  - Contact the ISP in every way and claim: `Cable is damaged, I don't have internet and I work from home`.

## Mobile

- When first joining a mobile SIM company, check goverment map for areas of coverage.
- When first joining a mobile SIM company, request discounts.
- Each year you'll have to renew the plan, when doing so use the Public Inquiry page, don't comminicate with the Customer Service via Whatsapp or phone call.
  > Remove all the extra charges such as `5G`, `Cyber Security` and bundled `TV` plans, all you actually need is phone calls + data plan.

Cancel unnecessary services, also voicemail

## Television

### Android TV

#### Android TV - Setup

1. TODO

#### Android TV - Apps

| Name                     | Links                                                                                                                 | Mod to download    |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- | ------------------ |
| UniFi Protect            | [Google Play](https://play.google.com/store/apps/details?id=com.ubnt.unifi.protect)                                   |                    |
| NEXT TV                  | [Google Play](https://play.google.com/store/apps/details?id=com.hotnext)                                              |                    |
| SmartTube                | [GitHub](https://github.com/yuliskov/SmartTube/releases/latest)                                                       |                    |
| Netflix                  | [Google Play](https://play.google.com/store/apps/details?id=com.netflix.mediaclient)                                  |                    |
| Spotify                  | [4pda](https://4pda.to/forum/index.php?showtopic=248440#Spoil-8030514-11)                                             | Android TV         |
| Plex: Stream Movies & TV | [Google Play](https://play.google.com/store/apps/details?id=com.plexapp.android)                                      |                    |
| Kan11                    | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.il.ch1)                                   |                    |
| N12                      | [Google Play](https://play.google.com/store/apps/details?id=com.channel2.mobile.ui)                                   |                    |
| Reshet 13                | [Google Play](https://play.google.com/store/apps/details?id=com.applicaster.iReshet)                                  |                    |
| TV Bro                   | [Google Play](https://play.google.com/store/apps/details?id=com.phlox.tvwebbrowser)                                   |                    |
| UAD-ng                   | [GitHub](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest) | uad-ng-windows.exe |

#### Android TV - Apps - Setup

1. Open `UniFi Protect` > Login using QR Code
1. Install `SmartTube`:

   ```bash
   adb install SmartTube_stable_27.37_arm64-v8a.apk
   ```

1. Open `SmartTube` > Restore settings using file (TODO)
1. Open `Netflix` > Login
1. Install `Spotify`:

   ```bash
   adb install Spotify+-+Music+and+Podcasts_1.91.8_mod.apk
   ```

1. Open `Spotify` > Login
1. Open `Plex` > [Link TV](https://www.plex.tv/link/)
1. Plex > Settings TODO
1. Open `UAD-ng`

#### Android TV - Notes

- When using `UAD-ng` - Don't uninstall the following:

  - `com.google.android.tv.remote.service` - Android TV Remote Service.
  - `com.netflix.ninja` - Netflix.
  - A Package on the `Recommended` list - Disconnects the WiFi.
  - A Package on the `Recommended` list - Can't control TV from Google Home.

- TCL has issues playing Next TV channels, zoom-in when selecting a channel, temporary fix is the toggle overscan picture settings, but when chagning to different channel this fix needs to be re-applaied.

### Samsung

#### Samsung TV - Setup

1. `Settings` > `Support` > `Software Update` > `Update Now`.

   > Update TV Firmware at night hours to avoid power loss.
   >
   > Update takes 1 minute and 25 seconds.
   >
   > [Firmware Update Changelog](https://eu.community.samsung.com/t5/tv/tv-firmware-changelogs-on-german-community/td-p/1846870)

1. `Settings` > `General` > `Reset` > `0000` > `Reset` (This will take 2 min)
1. (SmartThings Setup) Remote Control > Left arrow > Left arrow.
1. (Connection Guide Setup) `Next`.
1. (WiFi Setup) `Skip` > `Skip`.
1. (Source Setup) `No signal` > `Next`.
1. (Smart Mode Setup) `Skip`.
1. `Skip`
1. (Tap View Setup) `Next`.
1. (Remote Control Testing Setup) > `Skip`.
1. (TV Ready To Use Setup) `Finish`.
1. `Settings` > `General` > `System Manager` > `Language` > `English`.
1. `Settings` > `General` > `System Manager` > `Auto Protection Time` > `Off`.
1. `Source` > Switch to the current HDMI source.
1. `Source` > `Edit` > `Blu-ray player` > `Ok`.
1. `Settings` > `Picture` > `Picture Mode` > `FILMMAKER MODE`.
1. `Settings` > `Picture` > `Expert Settings` > `Picture Clarity Settings` > `Custom` > `Blur Reduction: 0` > `Judder Reduction: 0`.
1. `Settings` > `General` > `External Device Manager` > `Input Signal Plus` > Select current HDMI > `Close`.
1. `Settings`> `General` > `Eco Solution` > `Ambient Light Detection` > `Off`
1. `Settings` > `General` > `Smart Features` > `Autorun Smart Hub: Off` > `Autorun Last App: Off` > `Autorun Multi View Casting: Off`.
1. Enable HDR in Windows.
1. `Settings` > `Picture` > `Expert Settings` > `Picture Clarity Settings` > `Custom` > `Blur Reduction: 0` > `Judder Reduction: 0`.
1. Disable HDR in Windows.
1. Enable Game Mode.
1. `Settings` > `General` > `External Device Manager` > `Game Mode Settings` > `On`
1. `Surround Sound` > `Off`

#### Samsung TV - Notes

- Uses TizenOS instead of Android, so you can't sideload APKs.
- Panning shot issue where the first frame of the panning shot will be stuck.
- Can't turn off the bluethooth even if the TV is only used as a monitor.

### LG

#### LG TV - Setup

1. `Settings` > `Picture` > `Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `White Balance` > `Colour Temperature` > `Warm 50` (2024-) / `Warm 40` (2025+)`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `Color Gamut` > `Auto Detect`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Super Resolution` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Noise Reduction` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `MPEG Noise Reduction` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Smooth Gradation` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Real Cinema` > `On`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `TruMotion` > `Off`
1. `Settings` > `Picture` > `Select Mode` > `1113111` > `EOTF` > `ST2084`
1. `Settings` > `Picture` > `HDR Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Colour` > `White Balance` > `Colour Temperature` > `Warm 50` (2024-) / `Warm 40` (2025+)`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Smooth Gradation` > `Off`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Real Cinema` > `On`
1. `Settings` > `Picture` > `Select Mode` > `1113111` > `EOTF` > `AUTO`
1. Open `Netflix` > Play `Dolby Vision` Content > Pause Video
1. `Settings` > `Picture` > `Dolby Vision Select Mode` > `FILMMAKER MODE`
1. `Settings` > `Picture` > `Advanced Settings` > `Clarity` > `Adjust Sharpness` > `0`
1. `Settings` > `General` > `System` > `Additional Settings` > `Settings Help` > `Off`
1. `Settings` > `General` > `Enegry Saving` > `Energy Saving Step` > `Off`

Source: [𝗟𝗚 𝗢𝗟𝗘𝗗 𝗧𝗩 𝗦𝗲𝘁𝘁𝗶𝗻𝗴𝘀 𝗧𝗵𝗲 𝗣𝗿𝗼𝘀 𝗨𝘀𝗲: SDR, HDR & Dolby Vision](https://www.youtube.com/watch?v=YQ9E7RK0gDM)

#### LG TV - Notes

- Uses webOS instead of Android, so you can't sideload APKs.

### More

- Most TVs have a network (RJ45) port limited to 100Mbps. To get faster speeds, you can use a USB-to-Ethernet adapter:

  - Buy a USB 3.0 to RJ45 adapter (1000Mbps).
  - Do not buy a USB 2.0 to RJ45 adapter (100Mbps).
  - Disable USB Debugging if enabled to make the adapter work.

- Most TVs are not Android-based (LG / Samsung / older TVs). To get Android apps, you can use a Android streaming device:

  - Google TV Streamer 4K
  - Xiaomi TV Box S 3rd Gen 4K

- Cable TV is outdated. Providers now sell a bundle that includes:

  - Router (Internet + WiFi) – rented monthly.
    - Instead - Buy your own (Recommended: Ubiquiti).
  - Android TV box (with their app) – rented monthly.
    - Instead - Buy your own (Recommended: Google TV Streamer 4K).
  - Access to channels via their app – monthly fee.
    - Instead - Subscribe directly (same as Netflix).

- Consider mounting the TV at an angle (up/down) so that if there's a dead pixel it won't bother you since it will be hidden by nearby pixels.

### Clean

- Do not use paper towel.
- Plug off power cable.
- Buy 2 Microfiber towels.
- Wet one with a bit of distilled water and ring it.
- Gently wipe the screen.
- Dry with the dry microfiber towel.

## Cancel

- Use [Netek](https://www.netek.co.il/)

- Next TV - you will have to contact their WhatsApp support team (3), and request to cancel, they will call you back within 2 working days.
