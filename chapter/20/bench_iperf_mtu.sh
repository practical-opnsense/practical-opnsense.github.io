#!/bin/csh

set INTERFACE=vtnet1

foreach MTU ( 1420 1280 1024 512 256 128 )
  echo "*** Messung mit MTU ${MTU} Byte"
  ifconfig ${INTERFACE} mtu ${MTU}
  sleep 2
  iperf3 --client 192.0.2.3 --time 60 --interval 60 --omit 10 \
    --window 128K --format m | grep bit
end

ifconfig ${INTERFACE} mtu 1500
/usr/local/etc/rc.newwanip     # neue MTU aktivieren
