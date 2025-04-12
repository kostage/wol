#!/bin/sh

# Read config
CONFIG=$(cat /var/www/config/config.json)
IP=$(echo "$CONFIG" | jq -r '.ip_address')

# Send IP to socket and capture the result
RESULT=$(echo "$IP" | socat -t 2 UNIX-CONNECT:/var/run/wol_sockets/ping.sock - 2>/dev/null)

if [ "$RESULT" = "0" ]; then
    STATUS="online"
else
    STATUS="offline"
fi

# Return JSON response
echo "Content-type: application/json"
echo ""
echo '{"status":"'"$STATUS"'"}'
