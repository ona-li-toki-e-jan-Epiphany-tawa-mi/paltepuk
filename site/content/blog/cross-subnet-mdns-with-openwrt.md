+++
title               = 'Cross-Subnet mDNS with OpenWRT'
scrollingTitleCount = 2
date                = '2025-01-29'
+++

Written: January 29, 2025.

---

Probably around a year ago, I switched out the babified router from my ISP with
a Linksys WRT1900AC and installed OpenWRT [https://openwrt.org *(January 29,
2025)*](https://openwrt.org) on it.

I've been liking OpenWRT quite a bit. I love all the knobs and levers it gives
you. I also like that you can allow in IPv6 traffic unlike that piece of trash
my ISP gave me (yes, it only allowed IPv4 for inbound connections, despite also
having access to an IPv6 connection and allowing outbound IPv6.)

One of the things I've been working on setting up is a seperate VLAN that
doesn't have internet access for stuff like IoT devices. I don't really have any
of those, but I do have a printer, that, as you might imagine, connects to the
internet for no good reason.

Making a seperate Wi-Fi network and VLAN and setting up the firewall rules for
it was pretty easy, except for one thing: mDNS!

mDNS, standing for Multicast Domain Name System, is a way for devices to
advertise themselves to other devices on a network. For instance, say you have a
printer; you probably don't have to connect to it manually, rather the computer
just "figures it out," which is thanks to mDNS.

The problem with mDNS lies in that mDNS broadcasts are local to the subnet the
device is in, and since each VLAN gets it's own subnet, devices in the main VLAN
can't see the advertisements of the printer and other devices in the
internetless VLAN.

## Avahi: My Savior, My Lord

I struggled for a while with this, but a couple days ago, I found a thread on
the OpenWRT forms (which I can't find again, sorry) that showed how to do this.

Firstly, you need to install Avahi on the router. There's a number of
Avahi-related packages from the OpenWRT package repository, but I think
**avahi-nodbus-daemon** or **avahi-dbus-daemon** are probably the ones you want,
I went with **avahi-nodbus-daemon**.

Then, you'll want to SSH into the router, if you aren't already, and open up the
file **/etc/avahi/avahi-daemon.conf**. The contents will look something like
this:

```ini
[server]
#host-name=foo
#domain-name=local
use-ipv4=yes
use-ipv6=yes
check-response-ttl=no
use-iff-running=no

[publish]
publish-addresses=yes
publish-hinfo=yes
publish-workstation=no
publish-domain=yes
#publish-dns-servers=192.168.1.1
#publish-resolv-conf-dns-servers=yes

[reflector]
enable-reflector=no
reflect-ipv=no

[rlimits]
#rlimit-as=
rlimit-core=0
rlimit-data=4194304
rlimit-fsize=0
rlimit-nofile=30
rlimit-stack=4194304
rlimit-nproc=3
```

All that matters here is that you set **enable-reflector** to **yes**. The
reflector will rebroadcast any mDNS packets onto other subnets
automatically. Then, run **service avahi-daemon reload** to apply the changes.

If the VLAN your mDNS devices are on is allowed to contact the router, then you
don't need to do anything else. But, the internetless VLAN in my setup
isn't. Let's take a look at the basic rules in Network > Firewall > General
Settings in LuCI:

![firewall rules](/blog/cross-subnet-mdns-with-openwrt/firewall.webp)

lan is the main VLAN/zone, and deadzone is the one without internet.

Input being accept means that the device can talk to the router. Forward being
accept means devices within the same VLAN can talk to eachother.

As you can see, lan can talk to the internet (wan,) devices in deadzone, the
router (input is accept,) and other devices in lan (forward is accept.)

But deadzone can only talk to lan. Most importantly, it can't talk to the router
(input is reject,) which means mDNS broadcasts won't work.

The way to selectively allow mDNS is with a couple traffic rules, which I set up
with LuCI in Network > Firewall > Traffic Rules:

![traffic rules](/blog/cross-subnet-mdns-with-openwrt/traffic-rules.webp)

*I've included the rules for DNS (needed for local .lan addresses) and DHCP in
this image, but they're not relavent to mDNS.*

Despite mDNS broadcasting to the specific addresses **224.0.0.251** and
**ff02::fb**, they are ultimately talking to the router, hence **this device**
(the router) is the destination.

In /etc/config/firewall, these rules look like this:

```text
config rule
    option name 'Allow-IPv4-mDNS-Deadzone'
    option family 'ipv4'
    list proto 'udp'
    option src 'deadzone'
    option src_port '5353'
    list dest_ip '224.0.0.251'
    option dest_port '5353'
    option target 'ACCEPT'

config rule
    option name 'Allow-IPv6-mDNS-Deadzone'
    option family 'ipv6'
    list proto 'udp'
    option src 'deadzone'
    option src_port '5353'
    list dest_ip 'ff02::fb'
    option dest_port '5353'
    option target 'ACCEPT'
```

Happly multicasting!
