#!/bin/sh

# Initialize state if not exists
if [ ! -f /var/www/state.json ]; then
    echo '{"desired_state":"off","last_wake_attempt":null,"retry_count":0}' > /var/www/state.json
fi

# Set permissions for lighttpd logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Start lighttpd
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf