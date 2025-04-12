#!/bin/ash

CONFIG=$(cat /var/www/config/config.json)
MAC=$(echo "$CONFIG" | jq -r '.mac_address')
IF=$(echo "$CONFIG" | jq -r '.network_interface')

# Send JSON and capture output
RESPONSE=$(echo "$IF $MAC" | socat -t 2 UNIX-CONNECT:/var/run/wol_sockets/wol.sock -)

if [ "$RESPONSE" = "OK" ]; then
    echo "Content-type: application/json"
    echo ""
    echo '{"status":"success","message":"Wake signal sent"}'
else
    echo "Content-type: application/json"
    echo "Status: 500 Internal Server Error"
    echo ""
    echo '{"status":"error","message":"Failed to send wake signal"}'
fi
