#!/bin/sh

# Prepare config
export APP_PATH="$PATH"
envsubst < /etc/lighttpd/lighttpd.conf > /tmp/lighttpd_patched.conf

# Set permissions for logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Start Lighttpd
exec lighttpd -D -f /tmp/lighttpd_patched.conf
