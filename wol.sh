#!/bin/sh

# Read config
CONFIG=`cat /var/www/config/config.json | envsubst`
MAC=$(echo "$CONFIG" | jq -r '.mac_address')
IF=$(echo "$CONFIG" | jq -r '.network_interface')

# Send via socket
if echo "{\"mac\":\"$MAC\",\"if\":\"$IF\"}" | socat UNIX-CONNECT:/var/run/wol-sockets/wol.sock -; then
    echo "Content-type: application/json"
    echo ""
    echo '{"status":"success","message":"Wake signal sent"}'
    exit 0
else
    echo "Content-type: application/json"
    echo "Status: 500 Internal Server Error"
    echo ""
    echo '{"status":"error","message":"Failed to send wake signal"}'
    exit 1
fi
