#!/bin/sh

# Determine whether to use real or mock commands
CONFIG=$(cat /var/www/config.json)
USE_MOCK=$(echo "$CONFIG" | jq -r '.use_mock')

if [ "$USE_MOCK" = "true" ]; then
    ETHERWAKE="/var/www/mock/etherwake"
else
    ETHERWAKE="sudo /usr/sbin/etherwake"
fi

# Read MAC address
MAC=$(echo "$CONFIG" | jq -r '.mac_address')

# Send WoL packet
if $ETHERWAKE -i eth0 "$MAC" 2>/dev/null; then
    echo "Content-type: application/json"
    echo ""
    echo '{"status":"success","message":"Wake signal sent"}'
else
    echo "Content-type: application/json"
    echo "Status: 500 Internal Server Error"
    echo ""
    echo '{"status":"error","message":"Failed to send wake signal"}'
fi