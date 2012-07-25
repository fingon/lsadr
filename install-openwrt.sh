#!/bin/sh
#-*-sh-*-
#
# $Id: install-openwrt.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:18:51 2012 mstenber
# Last modified: Wed Jul 25 17:31:01 2012 mstenber
# Edit time:     1 min
#

opkg install dhcp-client rdisc6 radvd
cp -al lsadr /usr/share
mkdir -p /etc/dhcp
cp -al dhclient-exit-hooks.d /etc/dhcp
cp dhclient.conf dhclient-exit-hooks /etc
rm /etc/init.d/{dhclient,dhclient6,radvd}



