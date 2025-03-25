#!/bin/sh

NEIGHBORS4=$(/usr/bin/netstat -4rn | grep UGS | awk '{ print $2 }')
for NHR in $NEIGHBORS4 ; do
  arp -n $NHR >/dev/null  ||  ping -t1 -c1 -W1 $NHR >/dev/null
done

NEIGHBORS6=$(/usr/bin/netstat -6rn | grep UGS | awk '{ print $2 }')
for NHR in $NEIGHBORS6 ; do
  ndp $NHR >/dev/null  ||  ping -t1 -c1 -W1 $NHR >/dev/null
done
