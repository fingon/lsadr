# Enable IPv4 forwarding by default
echo 1 > /proc/sys/net/ipv4/ip_forward
# insert the /etc/hosts.netkit, if it is helpful
if ! grep -q NETKIT /etc/hosts
then
  cat /etc/hosts.netkit >> /etc/hosts
fi
# start from /home/mstenber/uml/template/openwrt.startup
  # Install missing packages we really DO want
  opkg install /hostlab/openwrt-packages/*.ipk
  
  # Fire up _two_ dhclients on eth1 (that we haven't intentionally included in openwrt config itself)
  ifconfig eth1 up
  killall dhclient
  
  # Fix eth0 => br-lan in the DHCP scripts
  for FILE in /etc/dhcp/dhclient-exit-hooks.d/*
  do
  sed s/eth0/br-lan/ < $FILE > $FILE.new
  chmod a+x $FILE.new
  mv $FILE.new $FILE
  done
  
  
  # Run assorted client scripts
  dhclient eth1 -cf /etc/dhclient.conf -sf /usr/sbin/dhclient-script
  dhclient -6 -P eth1 -sf /usr/sbin/dhclient-script
  
  # Clean ip6tables state (it is broken, for some ineffable reason)
  ip6tables -F
  ip6tables -X
  ip6tables -P FORWARD ACCEPT
  
# end from /home/mstenber/uml/template/openwrt.startup

