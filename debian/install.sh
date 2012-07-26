#!/bin/bash -ue
#-*-sh-*-
#
# $Id: install-debian.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:18:13 2012 mstenber
# Last modified: Thu Jul 26 10:50:40 2012 mstenber
# Edit time:     1 min
#

apt-get install isc-dhcp-client ndisc6 iproute
cp -a lsadr /usr/share
cp dhclient.conf /etc/dhcp
cp -a dhclient-exit-hooks.d /etc/dhcp
cp debian/startup.sh /etc/rc.local

