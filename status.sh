#!/bin/sh

# Determine whether to use real or mock commands
CONFIG=$(cat /var/www/config.json)
USE_MOCK=$(echo "$CONFIG" | jq -r '.use_mock')

if [ "$USE_MOCK" = "true" ]; then
    PING="/var/www/mock/ping"
else
    PING="/bin/ping"
fi

# Initialize state if not exists
if [ ! -f /var/www/state.json ]; then
    echo '{"desired_state":"off","last_wake_attempt":null,"retry_count":0}' > /var/www/state.json
fi

# Read config and state
CONFIG=$(cat /var/www/config.json)
STATE=$(cat /var/www/state.json)
IP=$(echo "$CONFIG" | jq -r '.ip_address')
DESIRED_STATE=$(echo "$STATE" | jq -r '.desired_state')
RETRY_COUNT=$(echo "$STATE" | jq -r '.retry_count')
LAST_ATTEMPT=$(echo "$STATE" | jq -r '.last_wake_attempt')

# Check current status
if $PING -c 1 -W 1 "$IP" >/dev/null 2>&1; then
    STATUS="online"
    # Reset state if machine is online
    if [ "$DESIRED_STATE" = "on" ]; then
        echo '{"desired_state":"off","last_wake_attempt":null,"retry_count":0}' > /var/www/state.json
    fi
else
    STATUS="offline"
    
    # Handle retries if desired state is on
    if [ "$DESIRED_STATE" = "on" ]; then
        CURRENT_TIME=$(date +%s)
        RETRY_INTERVAL=$(echo "$CONFIG" | grep -oP '"retry_interval":\s*\K[0-9]+')
        MAX_RETRIES=$(echo "$CONFIG" | grep -oP '"max_retries":\s*\K[0-9]+')
        
        if [ $((CURRENT_TIME - LAST_ATTEMPT)) -ge $RETRY_INTERVAL ]; then
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                # Send WoL packet again
                MAC=$(echo "$CONFIG" | grep -oP '"mac_address":\s*"\K[^"]+')
                if etherwake -i eth0 "$MAC" 2>/dev/null; then
                    NEW_RETRY_COUNT=$((RETRY_COUNT + 1))
                    echo '{"desired_state":"on","last_wake_attempt":'$CURRENT_TIME',"retry_count":'$NEW_RETRY_COUNT'}' > /var/www/state.json
                fi
            else
                # Max retries reached, reset state
                echo '{"desired_state":"off","last_wake_attempt":null,"retry_count":0}' > /var/www/state.json
            fi
        fi
    fi
fi

# Return status
echo "Content-type: application/json"
echo ""
echo '{"status":"'$STATUS'","desired_state":"'$DESIRED_STATE'","retry_count":'$RETRY_COUNT'}'
