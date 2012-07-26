#!/bin/bash -ue
#-*-sh-*-
#
# $Id: update-git.sh $
#
# Author: Markus Stenberg <fingon@iki.fi>
#
# Created:       Wed Jul 25 17:22:02 2012 mstenber
# Last modified: Thu Jul 26 10:31:38 2012 mstenber
# Edit time:     7 min
#

UML=$HOME/uml

# Utility script to gather the latest versions of the associated scripts
rsync -a --delete $UML/template/lsadr/usr/share/lsadr .
rsync -a --delete $UML/lab/ow4/openwrt/etc/dhcp/dhclient-exit-hooks.d .
cp -a $UML/lab/ow4/openwrt/etc/dhcp/dhclient.conf .
cp -a $UML/openwrt/extra/etc/dhclient-exit-hooks .


#echo '#! /bin/sh' > openwrt/startup.sh
#cat $UML/template/openwrt-cpe.startup >> openwrt/startup.sh
