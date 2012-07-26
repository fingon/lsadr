#! /bin/sh

# Clean ip6tables state (it is broken, for some ineffable reason)
ip6tables -F
ip6tables -X
ip6tables -P FORWARD ACCEPT
  
# Fire up _two_ dhclients on eth1 (that we haven't intentionally
# included in openwrt config itself)
ifconfig eth1 up
  
dhclient eth1 -cf /etc/dhclient.conf -sf /usr/sbin/dhclient-script
dhclient -6 -P eth1 -sf /usr/sbin/dhclient-script
  

