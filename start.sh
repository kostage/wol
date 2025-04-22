#!/bin/sh

# Set permissions for logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Read port form config
CONFIG=$(cat /var/www/config/config.json)
export PORT=$(echo "$CONFIG" | jq -r '.port')

envsubst '${PORT}' < /etc/lighttpd/lighttpd.conf.tpl > /etc/lighttpd/lighttpd.conf

# Start Lighttpd
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
