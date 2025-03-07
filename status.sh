#!/bin/sh

# Use test-specific config if available, otherwise fall back to default
CONFIG_FILE="${TEST_WWW_DIR:-/var/www}/config.json"
CONFIG=$(cat "$CONFIG_FILE")
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