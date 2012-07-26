Author:        Markus Stenberg <markus.stenberg@iki.fi>, cisco Systems, Inc.
Created:       Mon Jul 23 11:05:05 2012 mstenber
Last modified: Thu Jul 26 10:22:50 2012 mstenber
Edit time:     39 min

Linux Source Address Dependent Routing
======================================

(c) 2012 cisco Systems, Inc. 

This is a set of sample scripts to deal with Internet-draft-specified
[6rd sunsetting][D1] and [multihoming][D2] on a Linux CPE. Both
of the documents specify something, which requires source-based
routing. Obviously they can be also used just to get 6rd ball rolling, or
to deal with multiple ISPs connected to a single CPE.

This should be considered just a work-in-progress sample; in practice,
distributions should integrate something similar to their own set of
startup/network setup infrastructure.

Required software
-----------------

- Linux 2.6.19 or later with IPV6_MULTIPLE_TABLES and CONFIG_IPV6_SIT_6RD
(if 6rd support is desired) enabled

- ISC DHCP

    - v4 client if 6rd configuration is used

    - v6 client if PD configuration is used

- ash / dash / bash / busybox
  ( to run the shell scripts )

- rdisc6 (from ndisc6, available at <http://www.remlab.net/ndisc6/> )
  ( to get default next-hop )

- iproute2

    

Source-based routing in Linux
-----------------------------

Linux IPv6 has two different options for dealing with this:

config IPV6_MULTIPLE_TABLES

which enables multiple routing tables, selection done by
preference-ordered search through a list of rules which identify the
table, and the criteria based on which it can be used (among other
things, source address can be used for filtering).

config IPV6_SUBTREES

provides for use of source addresses within individual routing tables;
however, the destination is used first for indexing, and the source
address is used just as tie breaker. Due to [e.g. MH-3][D2], this is
not really an option.


Underlying assumptions
----------------------

- only ways to get default route information are per-interface Router
  Advertisements, or the 6rd DHCP option (no DHCPv6 proprietary options for
  example).

- the CPE in question is the home router for which is directly connected to
  one or multiple ISPs, using one or more physical links (in a nested home
  router case, this set of scripts also could be adapted to [hierarchical
  DHCPv6 prefix delegation][D3])


Implementation approach
-----------------------

This implementation requires IPV6_MULTIPLE_TABLES option to be configured
in the kernel. [It is supported at least since Linux 2.6.19][D4]. There is a
rule per source prefix, and then source specific routing table which
contains the relevant home -> ISP routes. The reverse direction is handled
by the normal default routing

To implement [MH-3][D2], the preference of the rules is 1128-prefix_length
(so that the longer the prefix, the smaller the preference, and therefore
the sooner it is evaluated). The 1000 chosen as base is arbitrary; local
lookup table is at preference 0, and default table is at ~2^15.

For native <> 6rd [<> some other not yet implemented tunneling choice], the
choice is done via metric. Therefore, the route metrics within the
source-specific tables must follow the preferences specified within
[sunsetting document][D1].


Rule/route structure
--------------------

### Rule table

- src=prefix rule [preference as calculated above] -> per-prefix table

- main -> main table

### Routes in within per-prefix table ( preference 1000+ )

- dst=prefix => throw (skip evaluation within per-prefix table)

- other routes => wherever

- default route (native) => wherever (default metric 1500)

- 6rd default route (native) => wherever (metric 2000)

### Routes in main table ( preference 2^15+ )

 - locally reachable routes

 - dst=prefix => blackhole (to prevent routing loop)

   (high metric 1234567 => only used as default if nothing better exists)

 - default routes, if any => wherever

Linux kernel reserves 0, 253, 254, 255 for built-in use. We use table
numbers 1000+ (in a dynamic fashion).

A more correct approach would be to handle all source prefix-specific
things within per-prefix table, but unfortunately it would require changes
to any programs that manipulate the routes (e.g. internal routing protocols
for the home network), and therefore this throw + main table routing
approach is used.

Installation
------------

Assumptions

- eth0 = LAN

- eth1 = WAN
 

### On Debian 6.0 (and possibly Ubuntu as well)

The needed steps are as follows:

- install dependencies

- copy whole lsadr/ to /usr/share

- copy dhclient.conf to /etc/dhcp

- copy the dhclient-exit-hooks.d/ contents to /etc/dhcp/

- put contents of debian/startup.sh to /etc/rc.local

Or, you can just 

    > sudo ./debian/install.sh
    
(Note: It will overwrite /etc/rc.local.)    

### On OpenWRT

IPv6 support in general is also needed; play with make menuconfig to select
what's needed. It is also necessary to address lack of IPv6 support in ISC
DHCP bug <https://dev.openwrt.org/ticket/11811>. This can be done by
applying the supplied openwrt-dhcp-ipv6.diff to feeds/packages. Beyond
that, dhcp-client, rdisc6, radvd should be available.

After creating an image (and possibly even starting it),

- copy whole lsadr/ to /usr/share

- copy dhclient-exit-hooks.d/ contents to /etc/dhcp/

- copy dhclient.conf and dhclient-exit-script to /etc

- put contents of openwrt/startup.sh to /etc/rc.local

- dhclient/dhclient6/radvd scripts should be removed from /etc/init.d (or
  their start from /etc/rc.d)

- edit the use* scripts within /etc/dhcp/dhclient-exit-hooks.d/ for
  appropriate LAN_INTERFACE (probably br-lan)

Or, you can just 

    # ./openwrt/install.sh
    
(Assuming you have this tarball opened on a willing OpenWRT box, with the
appropriate kernel and patched ISC DHCP.)    

Credits
-------

Ole Troan <ot@cisco.com> - feedback on appropriate rule/route setup


 [D1]: http://tools.ietf.org/html/townsley-v6ops-6rd-sunsetting-00

 [D2]: http://tools.ietf.org/html/draft-townsley-troan-ipv6-ce-transitioning-02

 [D3]: http://tools.ietf.org/html/draft-baker-homenet-prefix-assignment-01

 [D4]: http://cateee.net/lkddb/web-lkddb/IPV6_MULTIPLE_TABLES.html
