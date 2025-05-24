# Cisco configuration
## Basic config
```
ena
conf t
hostname R1
```
## Interface configuration
```
interface fastEthernet0/1
ip address 192.168.1.1 255.255.255.0
!description Connection to Switch 1, port F0/5
no sh
exit

!

interface Serial0/0/0
ip address 10.1.1.1 255.255.255.252
!description Connection to R2, Serial0/0/0 (DCE)
no sh
exit
```

## OSPF configuration
```
router ospf 1
router-id 192.168.1.5
network 192.168.1.0 0.0.0.255 area 0
network 10.1.1.0 0.0.0.3 area 0
exit
```
## If need default route (on the router)
```
router ospf 101
default-information originate
exit
! you need static route on perimeter router
ip route 0.0.0.0 0.0.0.0 101.101.101.10
! on the ISP's router you also need static route
ip route 0.0.0.0 0.0.0.0 101.101.101.9
exit
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

## Site-to-site VPN configuration
```
! enabling and configuring isakmp
conf t
crypto isakmp enable
crypto isakmp policy 10
hash sha
authentication pre-share
group 5
lifetime 3600
encryption aes 256
end
show crypto isakmp policy

!

! setting up VPN
conf t
crypto isakmp key cisco123 address 10.2.2.1
crypto ipsec transform-set 50 esp-aes 256 esp-sha-hmac
crypto ipsec security-association lifetime seconds 1800
access-list 101 permit ip 192.168.1.0 0.0.0.255 192.168.3.0 0.0.0.255
crypto map CMAP 10 ipsec-isakmp
match address 101
set peer 10.2.2.1
set pfs group5
set transform-set 50
set security-association lifetime seconds 900
exit

!

! adding to interface
interface S0/0/0
crypto map CMAP
end
!
show crypto ipsec transform-set
show crypto ipsec sa
!
```
