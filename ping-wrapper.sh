#!/bin/bash
SOCKET="/var/run/wol-sockets/ping.sock" 
rm -f $SOCKET
mkfifo $SOCKET
chmod 777 $SOCKET

while true; do
    if read ip < $SOCKET; then
        ping -c 1 -W 1 "$ip" >/dev/null 2>&1
        echo $? > $SOCKET
    fi
done
