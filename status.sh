#!/bin/sh

# Read config
CONFIG=`cat /var/www/config/config.json | envsubst`
IP=$(echo "$CONFIG" | jq -r '.ip_address')

# Check current status
if ping -c 1 -W 1 "$IP" >/dev/null 2>&1; then
    STATUS="online"
else
    STATUS="offline"
fi

# Return status
echo "Content-type: application/json"
echo ""
echo '{"status":"'$STATUS'"}'
