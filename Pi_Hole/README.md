# Information

Everything about Pi-Hole.

## Pre Installation

1. Download and Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
2. Enable SSH.
3. Set Locale.
4. Disable Telemetry.

## Login

1. Download and Open [PuTTY](https://www.putty.org/).
2. Login to Raspberry Pi IP.

## Installation

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

## Initial Setup

### Unbound Setup

1. Edit `/etc/unbound/unbound.conf.d/pi-hole.conf`:

   ```bash
   sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
   ```

1. Add server settings:

   ```bash
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
   ```

1. Edit `/etc/dnsmasq.d/99-edns.conf`:

   ```bash
   sudo nano /etc/dnsmasq.d/99-edns.conf
   ```

1. Add `edns` settings:

   ```bash
   edns-packet-max=1232
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

> Note: [Source](https://docs.pi-hole.net/guides/dns/unbound/)

### Auto-Update Setup

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

### Argon ONE

1. If user have Argon ONE Case:

   ```bash
   curl https://download.argon40.com/argon1.sh | sudo bash
   ```

### Pi-Hole Setup

1. Browser > Pi-Hole IP > Login to Pi-Hole WebUI.
1. `Settings` > `DNS` > `Upstream DNS Servers` > `127.0.0.1#5335`
1. `Settings` > `DNS` > `Interface settings` > `Permit all origins`.
<!-- 1. `Settings` > `DNS` > `Advanced DNS settings` > Enable `Never forward non-FQDN A and AAAA queries`. (Default)
1. `Settings` > `DNS` > `Advanced DNS settings` > Enable `Never forward reverse lookups for private IP ranges`. (Default) -->
1. `Settings` > `DNS` > `Advanced DNS settings` > `Rate-limiting` > `Block clients making more than 0 queries within 0 seconds`.
1. `Settings` > `Web interface` > `Pi-hole deep-midnight theme (dark)`.

## Adlists

```text
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts https://v.firebog.net/hosts/static/w3kbl.txt https://adaway.org/hosts.txt https://v.firebog.net/hosts/AdguardDNS.txt https://v.firebog.net/hosts/Admiral.txt https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt https://v.firebog.net/hosts/Easylist.txt https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts https://v.firebog.net/hosts/Easyprivacy.txt https://v.firebog.net/hosts/Prigent-Ads.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt https://v.firebog.net/hosts/Prigent-Crypto.txt https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt https://phishing.army/download/phishing_army_blocklist_extended.txt https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts https://urlhaus.abuse.ch/downloads/hostfile/ https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser https://www.github.developerdan.com/hosts/lists/hate-and-junk-extended.txt https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt https://someonewhocares.org/hosts/zero/hosts https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts https://winhelp2002.mvps.org/hosts.txt https://v.firebog.net/hosts/neohostsbasic.txt https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt https://hostfiles.frogeye.fr/multiparty-trackers-hosts.txt https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt https://v.firebog.net/hosts/Prigent-Malware.txt https://blocklistproject.github.io/Lists/ads.txt https://zerodot1.gitlab.io/CoinBlockerLists/hosts https://raw.githubusercontent.com/anudeepND/blacklist/master/CoinMiner.txt https://gitlab.com/ZeroDot1/CoinBlockerLists/-/raw/master/hosts https://blocklistproject.github.io/Lists/tracking.txt https://blocklistproject.github.io/Lists/ransomware.txt https://blocklistproject.github.io/Lists/phishing.txt https://blocklistproject.github.io/Lists/crypto.txt https://blocklistproject.github.io/Lists/fraud.txt https://blocklistproject.github.io/Lists/redirect.txt https://someonewhocares.org/hosts/hosts https://v.firebog.net/hosts/RPiList-Malware.txt https://v.firebog.net/hosts/RPiList-Phishing.txt https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts https://malware-filter.gitlab.io/malware-filter/phishing-filter-hosts.txt https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt https://raw.githubusercontent.com/im-sm/Pi-hole-Torrent-Blocklist/main/all-torrent-websites.txt https://raw.githubusercontent.com/im-sm/Pi-hole-Torrent-Blocklist/main/all-torrent-trackres.txt https://github.com/matomo-org/referrer-spam-blacklist/raw/master/spammers.txt https://raw.githubusercontent.com/stamparm/blackbook/master/blackbook.txt https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/EasyPrivacyCNAME.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardTracking.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardCNAME.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileSpyware.txt https://raw.githubusercontent.com/infinitytec/blocklists/master/ads-and-trackers.txt https://raw.githubusercontent.com/infinitytec/blocklists/master/scams-and-phishing.txt https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/domains https://raw.githubusercontent.com/mitchellkrogza/The-Big-List-of-Hacked-Malware-Web-Sites/master/hacked-domains.list https://raw.githubusercontent.com/nextdns/cname-cloaking-blocklist/master/domains https://raw.githubusercontent.com/paulgb/BarbBlock/master/blacklists/domain-list.txt https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts https://raw.githubusercontent.com/lightswitch05/hosts/master/docs/lists/ads-and-tracking-extended.txt https://raw.githubusercontent.com/yous/YousList/master/hosts.txt https://raw.githubusercontent.com/bkrcrc/turk-adlist/master/hosts https://raw.githubusercontent.com/omicron-b/custom-filters/master/domains_imported.txt https://raw.githubusercontent.com/Dawsey21/Lists/master/main-blacklist.txt https://raw.githubusercontent.com/olbat/ut1-blacklists/master/blacklists/stalkerware/domains https://blocklistproject.github.io/Lists/alt-version/ransomware-nl.txt https://blocklistproject.github.io/Lists/alt-version/scam-nl.txt https://blocklistproject.github.io/Lists/alt-version/tracking-nl.txt https://urlhaus.abuse.ch/downloads/rpz/ https://raw.githubusercontent.com/Yhonay/antipopads/master/hosts https://raw.githubusercontent.com/PoorPocketsMcNewHold/SteamScamSites/master/steamscamsite.txt https://big.oisd.nl https://raw.githubusercontent.com/ByKsTv/Everything/main/Pi_Hole/Blacklist.txt
```

## Domains Regex Blacklist

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

## Domains Whitelist

### Kan11

```text
smartplugin.youbora.com
```

```text
VOD @ Kan11
```

### N12

```text
pubads.g.doubleclick.net
```

```text
TVShows Not Starting @ N12
```

### 13tv

```text
imasdk.googleapis.com
```

```text
AdBlocker Warning @ 13tv
```

### YouTube

```text
s.youtube.com
```

```text
Mark Watched @ YouTube
```

### Where's my droid

```text
wmdcommander.appspot.com
```

```text
Wheres my droid
```

### Honey

```text
s.joinhoney.com
```

```text
Honey
```

### Honey (Another)

```text
d.joinhoney.com
```

```text
Honey
```
