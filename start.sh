#!/bin/sh

# Set permissions for logs
chown appuser:appuser /var/log/lighttpd /var/log/lighttpd/*.log 2>/dev/null || true

# Start Lighttpd
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
