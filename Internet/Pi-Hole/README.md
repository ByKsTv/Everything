# Table Of Contents

- [Setup](#setup)

## Setup

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
https://adaway.org/hosts.txt
https://big.oisd.nl
https://blocklistproject.github.io/Lists/ads.txt
https://blocklistproject.github.io/Lists/crypto.txt
https://blocklistproject.github.io/Lists/fraud.txt
https://blocklistproject.github.io/Lists/phishing.txt
https://blocklistproject.github.io/Lists/ransomware.txt
https://blocklistproject.github.io/Lists/tracking.txt
https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt
https://lists.cyberhost.uk/malware.txt
https://malware-filter.gitlab.io/malware-filter/phishing-filter-hosts.txt
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext
https://phishing.army/download/phishing_army_blocklist_extended.txt
https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts
https://raw.githubusercontent.com/ByKsTv/Everything/main/Internet/Pi-Hole/Blacklist.txt
https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts
https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts
https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt
https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt
https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt
https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts
https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt
https://raw.githubusercontent.com/infinitytec/blocklists/master/ads-and-trackers.txt
https://raw.githubusercontent.com/infinitytec/blocklists/master/scams-and-phishing.txt
https://raw.githubusercontent.com/lightswitch05/hosts/master/docs/lists/ads-and-tracking-extended.txt
https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt
https://raw.githubusercontent.com/nextdns/cname-cloaking-blocklist/master/domains
https://raw.githubusercontent.com/olbat/ut1-blacklists/master/blacklists/stalkerware/domains
https://raw.githubusercontent.com/omicron-b/custom-filters/master/domains_imported.txt
https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardCNAME.txt
https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt
https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt
https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardTracking.txt
https://raw.githubusercontent.com/sakib-m/Pi-hole-Torrent-Blocklist/main/all-torrent-trackers.txt
https://raw.githubusercontent.com/sakib-m/Pi-hole-Torrent-Blocklist/main/all-torrent-websites.txt
https://raw.githubusercontent.com/stamparm/blackbook/master/blackbook.txt
https://raw.githubusercontent.com/yous/YousList/master/hosts.txt
https://someonewhocares.org/hosts/zero/hosts
https://urlhaus.abuse.ch/downloads/hostfile/
https://urlhaus.abuse.ch/downloads/rpz/
https://v.firebog.net/hosts/AdguardDNS.txt
https://v.firebog.net/hosts/Admiral.txt
https://v.firebog.net/hosts/Easylist.txt
https://v.firebog.net/hosts/Easyprivacy.txt
https://v.firebog.net/hosts/Prigent-Ads.txt
https://v.firebog.net/hosts/Prigent-Crypto.txt
https://v.firebog.net/hosts/Prigent-Malware.txt
https://v.firebog.net/hosts/RPiList-Malware.txt
https://v.firebog.net/hosts/RPiList-Phishing.txt
https://v.firebog.net/hosts/static/w3kbl.txt
```

> Source: <https://firebog.net/>

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
