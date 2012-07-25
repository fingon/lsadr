#!/bin/bash -ue
#-*-sh-*-
#
# $Id: update-git.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:22:02 2012 mstenber
# Last modified: Wed Jul 25 17:32:54 2012 mstenber
# Edit time:     6 min
#

# Utility script to gather the latest versions of the associated scripts
rsync -a --delete ~/uml/template/lsadr/usr/share/lsadr .
rsync -a --delete ~/uml/lab/ow4/openwrt/etc/dhcp/dhclient-exit-hooks.d .
cp -a ~/uml/lab/ow4/openwrt/etc/dhcp/dhclient.conf .
cp -a ~/uml/openwrt/extra/etc/dhclient-exit-hooks .
