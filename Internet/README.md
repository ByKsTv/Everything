# Table Of Contents

- [LAN](#lan)
  - [Equipment](#lan---equipment)
  - [Router Setup](#lan---router---setup)
  - [More - LAN](#lan---more)
- [WAN](#wan)
  - [Equipment](#wan---equipment)
  - [More - WAN](#wan---more)
- [Mobile](#mobile)

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

### LAN - Router - Setup

- `Network Application` -> `Settings` -> `System` -> `General` -> `Country/Region` -> `United States`
  > This will improve WiFI signal.
- `Network Application` -> `Settings` -> `WiFi` -> `Multicast to Unicast` -> `On`
  > This will improve. [More info](https://www.youtube.com/watch?v=ldOVGSiSViw).

### LAN - More

- More information about Ubiquiti:
  - [AP Antenna Radiation Patterns](https://help.ui.com/hc/en-us/articles/115005212927-AP-Antenna-Radiation-Patterns)
  - [UniFi WiFi SSID and AP Settings Overview](https://help.ui.com/hc/en-us/articles/32065480092951-UniFi-WiFi-SSID-and-AP-Settings-Overview)
  - [WiFi 7 MLO w/ Pixel 10 Pro & Ubiquiti UniFi Access Point (E7/U7-Pro-XGS/EMLMR/EMLSR/STR)](https://www.youtube.com/watch?v=RPSnWxe9_DE)
  - [777 or 404](https://www.youtube.com/@hz777)
  - [Mactelecom Networks](https://www.youtube.com/@MactelecomNetworks)

- For some IoT devices such as WiFi printers and WiFi universal remote will have issues if the "Band Steering" option is enabled.

- Do not plug RJ45 male connector at a sharp angle and stress it, it will damage the copper pins on the RJ45 female port.

- Never let ISP technicians touch your private LAN equipment.

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

- Clean fiber results better dBm and lower ping.
- Clean fiber even if it's new.

## Mobile

- When first joining a mobile SIM company, check goverment map for areas of coverage.
- When first joining a mobile SIM company, request discounts.
- Each year you'll have to renew the plan, when doing so use the Public Inquiry page, don't comminicate with the Customer Service via Whatsapp or phone call.
  > Remove all the extra charges such as `5G`, `Cyber Security` and bundled `TV` plans, all you actually need is phone calls + data plan.

Cancel unnecessary services, also voicemail
