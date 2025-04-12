#!/bin/ash

read IF MAC

/usr/bin/etherwake -i "$IF" "$MAC" > /dev/null 2>&1 && echo "OK" || echo "ERROR"
