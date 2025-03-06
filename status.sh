#!/bin/sh

# Determine whether to use real or mock commands
CONFIG=$(cat /var/www/config.json)
USE_MOCK=$(echo "$CONFIG" | jq -r '.use_mock')

if [ "$USE_MOCK" = "true" ]; then
    PING="/var/www/mock/ping"
else
    PING="/bin/ping"
fi

# Read config
IP=$(echo "$CONFIG" | jq -r '.ip_address')

# Check current status
if $PING -c 1 -W 1 "$IP" >/dev/null 2>&1; then
    STATUS="online"
else
    STATUS="offline"
fi

# Return status
echo "Content-type: application/json"
echo ""
echo '{"status":"'$STATUS'"}'
