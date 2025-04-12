#!/bin/sh

read LINE

MAC=$(echo "$LINE" | jq -r '.mac')
IF=$(echo "$LINE" | jq -r '.if')

if /usr/sbin/etherwake -i "$IF" "$MAC" > /dev/null 2>&1; then
    echo "OK"
else
    echo "ERROR"
fi
