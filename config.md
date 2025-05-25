# Cisco configuration
## Basic config
```
ena
conf t
hostname R1
no ip domain-lookup
banner motd #Banner uzenet#
service password-encryption
int vlan 1
 no sh
 ip address 172.17.0.195 255.255.255.0
ip default-gateway 172.17.0.1
enable password jelszo
VAGY
enable secret StrongPW
username Admin privilege 15 secret Admin
username User01 privilege 1 secret User01
line con 0
 password StrongPW
 login local
 logging synchronous
 exec-timeout 1
line vty 0 15
 password StrongPW
 login local
 logging synchronous
 exec-timeout 1
 transport input ssh
ip domain-name example.com
crypto key generate rsa
 2048
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 2

sh ip int br

int range fa0/1-24
sh
description --NOT_CONNECTED--

security passwords min-length 8
login block-for 120 attempts 3 within 60

no cdp run  -CDP egész eszközön tiltása
no cdp enable  - CDP interfészen tiltás

mdix auto   - az interfész automatikusan felismeri a szükséges kábelcsatlakozási típust (egyenes vagy keresztkábel)
```

## Interface configuration
```
default interface gi0/1 (alap konfigra vissza rakja)

interface fastEthernet0/1
 ip address 192.168.1.1 255.255.255.0
 description Connection to Switch 1, port F0/5
 no sh
 exit

interface Serial0/0/0
 ip address 10.1.1.1 255.255.255.252
 description Connection to R2, Serial0/0/0 (DCE)
 no sh
 exit
sh ip int br
```
## VLAN config
```
Access – Állandó non-trunking módba helyezi az Ethernet portot, és egyezteti a kapcsolat
nem trunk kapcsolattá történő átalakítását. Az Ethernet port nem trunk porttá válik akkor is,
ha a szomszédos port nem ért egyet a változtatással.

Trunk – Az Ethernet-portot állandó trunk üzemmódba állítja, és egyeztet, hogy a kapcsolatot trunk kapcsolattá alakítsa.
A port akkor is trönk porttá válik, ha a szomszédos port nem ért egyet a változtatással.

Dynamic Auto – Az Ethernet-port készen áll arra, hogy a kapcsolatot trunk kapcsolattá alakítsa.
A port trunk porttá válik, ha a szomszédos port trunk vagy dinamic desirable módra van állítva.
Ez az alapértelmezett mód egyes kapcsolóportokhoz.

Dynamic Desirable – A portot aktívan megkísérli átalakítani trunk kapcsolattá.
A port trunk porttá válik, ha a szomszédos Ethernet port trunk, dinamic desirable vagy dinamic auto módra van állítva.

No-negotiate – Letiltja a DTP-t. A port nem küld DTP-kereteket, és nem befolyásolja a bejövő DTP-keretek.
Ha két kapcsoló között szeretne trönköt beállítani, amikor a DTP le van tiltva, manuálisan kell konfigurálnia a trönköt
a (switchport mode trunk) paranccsal mindkét oldalon.

vlan 10
 name Management
int f0/1
 switchport mode access
 switchport access vlan 10

VOICE VLAN:
vlan 20
 name student
 vlan 150
 name VOICE
 exit
int f0/2
 sw m a
 sw a vlan 20
 mls qos trust cos
 sw voice vlan 150
 exit

TRUNK:
interface f0/1
 switchport mode trunk
 switchport trunk allowed vlan 1,2,3
 switchport trunk native vlan 99
 switchport nonegotiate   - DTP letiltása

VLAN klónozás switch-ek között:
SW-1:
vtp domain SITE-HQ
vtp password jelszo
vtp version 2
vtp mode server
show vtp pasword
SW-2:
vtp domain SITE-HQ
vtp password jelszo
vtp version 2
vtp mode client
show vlan
show vlan br
show int f0/1 switchport
```
## Router-on-a-stick
```
int g0/1
 no sh
int g0/1.10
 encapsulation dot1q 10
 ip address 192.168.10.1 255.255.255.0
 exit
interface gig0/1.16
 encapsulation dot1Q 16 native
 ip address 192.168.16.1 255.255.255.0
```
## Portfast(L2 hurkok megszüntetése), BPDU guard (access interfacen BPDU csomagok szűrése)
```
int range f0/1-24
 spanning-tree portfast
 spanning-tree bpduguard enable
```
## DHCP (routeren)
```
ip dhcp excluded-address 192.168.10.1 192.168.10.10
ip dhcp excluded-address 192.168.10.254
ip dhcp pool Development
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 172.16.0.100
 domain-name example.com (nem kötelező)
 exit
show ip dhcp binding
no service dhcp  - kikapcsolás
service dhcp   - kikapcsolás után újra visszakapcsolás

ROUTER DHCP KLIENSKÉNT:
interface g0/1
 ip address dhcp
 no sh
 exit
show ip interface g0/1

DHCP RELAY AGENT:
A DHCP relay agent olyan TCP/IP állomás, amely a DHCP-szerver és a kliens közötti kérések és válaszok továbbítására szolgál, ha a kiszolgáló egy másik hálózaton van jelen.
A relay-agent fogadja a DHCP-üzeneteket, majd új DHCP-üzenetet generálnak, amelyet egy másik interfészen továbbítanak.

R1(config)# interface g0/0
R1(config-if)# ip helper-address 10.1.1.2

R1 alhálózat felőli intefésze a g0/0
10.1.1.2 pedig a DHCP router interfésze az előző routertől
```
## OSPF configuration
```
router ospf 1
 router-id 1.1.1.1
 network 192.168.1.0 0.0.0.255 area 0
 network 10.1.1.0 0.0.0.3 area 0
 passive-interface g0/1
 default-information originate (hirdesse az alapértelmezett útvonalat a többi router számára)
 exit
```
## HSRP (harmadik-rétegbeli redundancia, virtuális IP ha kiesik egy router)
```
AKTÍV ROUTER:
int g0/1 (alhálózati gépek felé néző interface)
 standby 1 ip 192.16.0.254
 standby 1 priority 150
 standby 1 preempt
 end
sh standby br

PASSZÍV ROUTER:
int g0/1
 standby 1 ip 192.16.0.254
 standby 1 priority 50
 exit
```
## EtherChannel
### PAgP
```
AKTÍV:
int range f0/23-24
 channel-group 1 mode desirable

PASSZÍV:
int range f0/23-24
 channel-group 1 mode auto
sh ip int br
```
### LACP
```
AKTÍV:
int range f0/23-24
 no sh
 channel-group 1 mode active
 exit
interface port-channel 1
 no sh
 switchport mode trunk
 switchport trunk allowed vlan 1,2,3

PASSZÍV:
int range f0/23-24
 no sh
 channel-group 1 mode passive
 exit
interface port-channel 1
 no sh
 switchport mode trunk
 switchport trunk allowed vlan 1,2,3
```
## Default route (on the router)
```
router ospf 1
default-information originate
exit
! you need static route on perimeter router
ip route 0.0.0.0 0.0.0.0 101.101.101.10
(IP cím VAGY kimenő interface)
ip route 0.0.0.0 0.0.0.0 s0/0/1
! on the ISP's router you also need static route
ip route 0.0.0.0 0.0.0.0 101.101.101.9
exit
sh ip route
!IPv6 default route:
ipv6 route ::/0 s0/1/1
```
## IPv6
```
ipv6 unicast-routing
int s0/0/1
 ipv6 add CAFE:0:1:2:3::1/64
 ipv6 add FE80::1 link-local
 no sh
```
## IPv6 SLAAC 
```
ipv6 dhcp pool Cafe
 domain-name cafe.com
 dns-server CAFE:0:0:2000::2000
 exit
int g0/1
 ipv6 nd other-config-flag
 ipv6 dhcp server Cafe
```
## NAT-PAT
```
ip access-list extended Internal
 deny ip 192.168.10.0 0.0.0.255 172.31.0.0 0.0.0.255
 deny ip 192.168.40.0 0.0.0.255 172.31.0.0 0.0.0.255
 deny ip 172.16.0.0 0.0.0.255 172.31.0.0 0.0.0.255
 permit ip 192.168.10.0 0.0.0.255 any
 permit ip 192.168.40.0 0.0.0.255 any
 permit ip 172.16.0.0 0.0.0.255 any
 deny ip any any
 exit
PAT:
ip nat inside source list Internal interface s0/1/0 overload

show ip access-list

int g0/1.10
 ip nat inside
int g0/1.16
 ip nat inside
int g0/1.40
 ip nat inside
int s0/1/0
 ip nat outside

PORT FORWARD: HTTP, HTTPS, FTP, DNS(belső aztán külső IP)
ip nat inside source static tcp 172.17.0.100 80 199.18.200.2 80
ip nat inside source static tcp 172.17.0.100 443 199.18.200.2 443
ip nat inside source static tcp 172.17.0.100 20 199.18.200.2 20
ip nat inside source static tcp 172.17.0.100 21 199.18.200.2 21
ip nat inside source static udp 172.17.0.100 53 199.18.200.2 53
```

## Site-to-site VPN configuration (1:50:30)
```
! enabling and configuring isakmp
license boot module c2900 technology-package securityk9
do copy run start
reload

crypto isakmp enable
ip access-list extended IPSec

HQ:
permit ip 192.168.10.0 0.0.0.255 172.31.0.0 0.0.0.255
permit ip 192.168.40.0 0.0.0.255 172.31.0.0 0.0.0.255
permit ip 172.16.0.0 0.0.0.255 172.31.0.0 0.0.0.255
R2:
permit ip 172.31.0.0 0.0.0.255 192.168.10.0 0.0.0.255
permit ip 172.31.0.0 0.0.0.255 192.168.40.0 0.0.0.255
permit ip 172.31.0.0 0.0.0.255 172.16.0.0 0.0.0.255

crypto isakmp policy 10
 authentication pre-share
 group 2
 hash sha
 encryption aes 192
 lifetime 43200
 end
show crypto isakmp policy

! setting up VPN
conf t
crypto isakmp key StrongPW address 10.2.2.1   (túloldali eszköz címe)
crypto ipsec transform-set TS1 esp-aes esp-sha-hmac
!!crypto ipsec security-association lifetime seconds 1800
!!access-list 101 permit ip 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255
crypto map CMAP1 10 ipsec-isakmp
match address IPSec
set peer 10.2.2.1   (túloldali router címe)
!!set pfs group5
set transform-set TS1
!!set security-association lifetime seconds 900
exit

! adding to interface (public)
interface S0/1/0
 crypto map CMAP1
 end
!
show crypto ipsec transform-set
show crypto ipsec sa
!
```
## ZPF zóna-alapú tűzfal 2:14:49
```
!Hozzon létre három zónát:

zone security INSIDE
zone security DMZ
zone security OUTSIDE

!Class-map-ek (forgalom-osztályok) létrehozása
!Ezek határozzák meg, milyen protokollokat engedélyezel adott forgalomirányhoz.

class-map type inspect match-any INSIDE_TO_DMZ_PROTOCOLS
 match protocol dns
 match protocol ftp
 match protocol http
 match protocol https
 match protocol icmp
 match protocol ssh
 exit

class-map type inspect match-any INSIDE_TO_OUTSIDE_PROTOCOLS
 match protocol ip
 exit

class-map type inspect match-any OUTSIDE_TO_DMZ_PROTOCOLS
 match protocol dns
 match protocol ftp
 match protocol http
 match protocol https
 exit

!Policy-map-ek (szabályzatok) létrehozása
!A class-map-ek alapján engedélyezett forgalmakat itt definiálod.
!a) INSIDE_TO_DMZ_POLICY
!b) INSIDE_TO_OUTSIDE_POLICY
!c) OUTSIDE_TO_DMZ_POLICY

policy-map type inspect INSIDE_TO_DMZ_POLICY
 class type inspect INSIDE_TO_DMZ_PROTOCOLS
 inspect
 exit

policy-map type inspect INSIDE_TO_OUTSIDE_POLICY
 class type inspect INSIDE_TO_OUTSIDE_PROTOCOLS
 inspect
 exit

policy-map type inspect OUTSIDE_TO_DMZ_POLICY
 class type inspect OUTSIDE_TO_DMZ_PROTOCOLS
 inspect
 exit

!Zóna-párok (zóna-párosítások) létrehozása
!Itt adod meg, melyik forgalmi irányra melyik szabályzat vonatkozik.

zone-pair security INSIDE_TO_DMZ source INSIDE destination DMZ
 service-policy type inspect INSIDE_TO_DMZ_POLICY
 exit
zone-pair security INSIDE_TO_OUTSIDE source INSIDE destination OUTSIDE
 service-policy type inspect INSIDE_TO_OUTSIDE_POLICY
 exit
zone-pair security OUTSIDE_TO_DMZ source OUTSIDE destination DMZ
 service-policy type inspect OUTSIDE_TO_DMZ_POLICY
 exit

!Interfészek zónákhoz rendelése

interface Se0/1/0
 zone-member security OUTSIDE

interface Gig0/1
 zone-member security DMZ

interface Gig0/2
 zone-member security INSIDE

show zone-pair security
```
## Security configuration
```
!!! syntax !!!

! enable algorithm-type {md5 | scrypt | sha256} secret [password]
! username [username] algorithm-type {md5 | scrypt | sha256} secret [password]

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
security passwords min-length 10
service password-encryption
line vty 0 4
exec-timeout 3 30
line console 0
exec-timeout 3 30
transport input ssh
enable secret cisco12345
!ios 15.3-tól:
!enable algorithm-type scrypt secret cisco12345
username admin01 secret admin01pass

!

line console 0
login local
exec-timeout 5 0
logging synchronous
exit
line aux 0
login local
exit


! ssh config

ip domain-name ccnasecurity.com
!crypto key generate rsa modulus 1024
crypto key generate rsa general-keys modulus 1024
ip ssh version 2
username Bob algorithm-type scrypt secret cisco12345
line vty 0 4
login local
transport input ssh
! exec-timeout 5 0
end

! show ip ssh
! ip ssh time-out 60
! ip ssh authentication-retries 2
! exit

```

## ACL config
```
! allow only https and http to a segment (eg. to server)
! on the router next to server
access-list 101 permit tcp any host 172.16.102.102 eq 80
access-list 101 permit tcp any host 172.16.102.102 eq 443
access-list 101 deny ip any any
!
!Állítson be egy ACL-t a Site HQ forgalomirányítón,
!mely csakis FTP, HTTP, HTTPS és DNS forgalmat engedélyez
!a 10-es és 40-es VLAN-okba bejutni!
!a. ACL javasolt neve: DNS_Web_FTP
!b. Javasolt interfészek: Gig0/1.10 és Gig0/1.40
!c. Sikeres konfiguráció után a Development PC 1 – 2 és
!Management Laptop 1 – 2 eszközök nem képesek például ping-et végezni.
ip access-list extended DNS_Web_FTP
permit tcp any any eq www
permit tcp any any eq 443
permit tcp any any eq ftp
permit udp any any eq domain
deny ip any any
int g0/1.10
ip access-group Csak_FTP_Web_DNS in
int g0/1.40
ip access-group Csak_FTP_Web_DNS in
sh ip access-list

```

## Securing config files
```
conf t
secure boot-image
secure boot-config
exit
show secure bootset

```

## Saving configuration
```
copy running-config startup-config
```
