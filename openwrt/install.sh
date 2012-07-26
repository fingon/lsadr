#!/bin/sh
#-*-sh-*-
#
# $Id: install-openwrt.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:18:51 2012 mstenber
# Last modified: Thu Jul 26 10:27:37 2012 mstenber
# Edit time:     3 min
#

opkg install dhcp-client rdisc6 radvd
cp -a lsadr /usr/share
mkdir -p /etc/dhcp
cp -a dhclient-exit-hooks.d /etc/dhcp
cp dhclient.conf dhclient-exit-hooks /etc
rm /etc/init.d/{dhclient,dhclient6,radvd}
cp openwrt/startup.sh /etc/rc.local

# Fix eth0 => br-lan in the DHCP scripts
for FILE in /etc/dhcp/dhclient-exit-hooks.d/*
do
  sed s/eth0/br-lan/ < $FILE > $FILE.new
  chmod a+x $FILE.new
  mv $FILE.new $FILE
done



