+++
title               = 'OpenWRT VLANs and the IPv6 Disaster'
scrollingTitleCount = 2
date                = '2025-02-03'
+++

Written: February 3, 2025.

---

This is sort-of a follow up to my previous article
[/blog/cross-subnet-mdns-with-openwrt/](/blog/cross-subnet-mdns-with-openwrt/),
where I talked about how I got mDNS working across multiple subnets in
OpenWRT. You should read it before reading this one if you haven't.

## FIREWALL EVERYTHING

One thing that I've been slacking since making this website is putting it's
server (which is on my home network btw) in it's own VLAN. Basically, for like
~10 months, the server could contact other devices on my network. This isn't the
end of the world, but such a setup would be best put in a DMZ (demilitarized
zone.)

There's two meanings commonly attributed to DMZ:

1. A device on the network that recieves all packets sent to the router that the router does not handle otherwise; basically, fuck this device in paticular. This is the common meaning in consumer devices.

2. A firewall zone on the network where the devices inside are exposed to the internet, and are mostly, if not completely, isolated from the rest of the network. This is used to protect the rest of the network from the scary outside world. This is the common meaning in enterprise equipment.

In this case, I am refering to #2. I'd like it such that, should the server be
compromised, nothing else on my network can be reached without an act of god
(a.k.a. nation state level threat actor, which isn't part of my threat model.)

I created a seperate bridge, interface, and firewall zone for the DMZ, and
assigned one of the ethernet ports of my router to it, set up the firewall
rules, and connected the server to it.

I also created a "secure" VLAN for a couple of my devices and made it so only
secure could contact the router for administration stuff.

Cool right?

## Right?

Wrong.

The next day, I went to check up on how the server's I2P router was running, and what did the i2pd web console show me?

```text
Network status v6: Unknown (testing)
```

IPv4 was working fine, but IPv6 had this on it, which was working fine before. I
went to check the logs and found that peers with IPv6 addresses weren't able to
contact my router, and looking at the transit tunnels i2pd did make, they was
not a single built IPv6 tunnel.

Hm?!?!?!

I did a lot of debugging and internet searching, when I eventually looked at my
router (actual router, not I2P,) and saw that none of my devices were being
assinged an IPv6 address through DHCPv6.

With this, I knew I probably fucked something up when I was setting up the
VLANs.

One thing I noticed is that I forgot to configure the interfaces for each VLAN
to have a DHCPv6 server, just DHCP, so I fixed that.

Then, through the internet, I learned that the ports used for DHCP and DHCPv6
are different (547 instead of 67,) and something with DHCPv6 needing devices to
be able to send ICMP (i.e. pings) to the router, leading me to need to make
extra firewall rules so my devices could attempt to get a DHCPv6 lease:

![new firewall rules](/blog/openwrt-vlans-and-the-ipv6-disaster/dhcpv6-firewall-rules.webp)

*Rinse and repeat for every VLAN that can't talk to the router by default.*

Then, I ran into the problem that my ISP delegated me a /64 prefix for IPv6
connections. This is a problem because each IPv6 subnet, and thus every VLAN,
needs a full /64 or else some stuff breaks (i.e.: SLAAC,) and each subnet can't
share the same address space.

I was stressing about what to do about this, reading through forums and what-not
for an answer. I randomly went into the wan6 interface (IPv6 external internet)
on the router and noticed you could set what prefix to request from the ISP. It
was set to automatic, giving the /64, but I tried setting it to /60 to see if
the ISP would give me it.

... and they did!

So, I set each interface for the VLANs to use a /64, which I think you can split
out 16 /64s from a /60. And, after applying the changes, each of them got an
IPv6 address! Yeah!

And then I reconnected my devices, and they started getting IPv6 leases! Hell
yeah!

And then i2pd started accepting IPv6 peers again! Fuck yeah!

## YEAAAAAHHHH!

I've learned quite a bit more about IPv6 thanks to my fuck up. Long live fuck
around and find out learning!

And another plus, i2pd now shows 40-45% tunnel success rate, rather than
20-30%?!? I did increase some of the limits stuff for i2pd, so that what might
have caused the better rate.
