#!/bin/sh

INTERFACE=vmx0

foreach MTU ( 1420 1280 1024 512 256 128 72 )
  echo "*** Benchmark with MTU ${MTU} Bytes"
  ifconfig ${INTERFACE} mtu ${MTU}
  sleep 2
  iperf3 --client 192.0.2.3 --window 128K --time 60 --interval 60 | grep bits
end

ifconfig ${INTERFACE} mtu 1500
/usr/local/etc/rc.newwanip     # use changed MTU value
