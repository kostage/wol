#!/bin/sh

# Prepare config
APP_PATH="$PATH"
if [ "$USE_MOCK" == "true" ]; then
    APP_PATH="/var/www/mock:$APP_PATH"
fi

# Patch the config file using envsubst
export APP_PATH
envsubst < /etc/lighttpd/lighttpd.conf > /tmp/lighttpd_patched.conf

# Set permissions for logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Start wrapper scripts
/var/www/mock/wol-wrapper.sh &
/var/www/mock/ping-wrapper.sh &

# Start Lighttpd with the patched config
exec lighttpd -D -f /tmp/lighttpd_patched.conf
