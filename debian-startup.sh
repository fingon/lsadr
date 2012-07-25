# autoconfigure eth1
ifconfig eth1 up

# fire up dhclient to configure interface
dhclient eth1

# Enable IPv4 forwarding by default
echo 1 > /proc/sys/net/ipv4/ip_forward
# enable ipv6 forwarding
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

# .. address RA acceptance 'feature' in Linux <3.x
# (pick one, or both)

  # .. but not on upstream interface, to make sure we get RA
  #  configuration there (sigh)
  #
  # but all.forwarding overrides int.forwarding for real forwarding
  # anyway, so this is safe..
  #
  echo 0 > /proc/sys/net/ipv6/conf/eth1/forwarding
  
  # Make sure we still accept RA despite in forwarding state from ISP
  #echo 2 > /proc/sys/net/ipv6/conf/eth1/accept_ra
  # only available in recent Linux versions?
  
# Fire up dhclient -6 to get PD assignment
dhclient -6 -cf /etc/dhcp/dhclient6.conf -P eth1


