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

# Initialize state if not exists
if [ ! -f /var/www/state.json ]; then
    # Determine actual state
    if $PING -c 1 -W 1 "$IP" >/dev/null 2>&1; then
        DESIRED_STATE="off"  # If machine is online, set desired state to "off"
    else
        DESIRED_STATE="on"   # If machine is offline, set desired state to "on"
    fi
    echo '{"desired_state":"'$DESIRED_STATE'","last_wake_attempt":null,"retry_count":0}' > /var/www/state.json
fi

# Set permissions for lighttpd logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Start lighttpd
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf