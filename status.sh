#!/bin/sh

# Read config
CONFIG=`cat /var/www/config/config.json | envsubst`
IP=$(echo "$CONFIG" | jq -r '.ip_address')

# Check via socket
if echo "$IP" | socat UNIX-CONNECT:/var/run/wol-sockets/ping.sock -; then
    STATUS="online"
else
    STATUS="offline"
fi

# Return status
echo "Content-type: application/json"
echo ""
echo '{"status":"'$STATUS'"}'
