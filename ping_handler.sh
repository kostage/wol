#!/bin/sh

read IP

if ping -c 1 -W 1 "$IP" > /dev/null 2>&1; then
    echo 0
else
    echo 1
fi
