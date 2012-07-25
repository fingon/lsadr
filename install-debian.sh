#!/bin/bash -ue
#-*-sh-*-
#
# $Id: install-debian.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:18:13 2012 mstenber
# Last modified: Wed Jul 25 17:18:21 2012 mstenber
# Edit time:     0 min
#

apt-get install isc-dhcp-client ndisc6 iproute
cp -al lsadr /usr/share
cp dhclient.conf /etc/dhcp
cp -al dhclient-exit-hooks.d /etc/dhcp
cp debian-startup.sh /etc/rc.local

