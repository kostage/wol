#!/bin/bash
SOCKET="/var/run/wol-sockets/wol.sock"
rm -f $SOCKET
mkfifo $SOCKET
chmod 777 $SOCKET

while true; do
    if read line < $SOCKET; then
        sudo /usr/sbin/etherwake -i $(echo "$line" | jq -r '.if') $(echo "$line" | jq -r '.mac')
    fi
done
