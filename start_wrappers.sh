#!/bin/bash

set -e

APP_DIR="/root/wol_app"
SOCKET_DIR="$APP_DIR/wol_sockets"
SOCKET_WOL="$SOCKET_DIR/wol.sock"
SOCKET_PING="$SOCKET_DIR/ping.sock"

PID_WOL="wol_wrapper.pid"
PID_PING="ping_wrapper.pid"

# Clean old sockets
rm -f "$SOCKET_WOL" "$SOCKET_PING"

mkdir -p "$SOCKET_DIR"

# Start WOL listener
socat -u UNIX-LISTEN:"$SOCKET_WOL",fork EXEC:$APP_DIR/wol-handler.sh &
echo $! > "$PID_WOL"
echo "WOL wrapper started on $SOCKET_WOL"

# Start PING listener
socat -u UNIX-LISTEN:"$SOCKET_PING",fork EXEC:$APP_DIR/ping-handler.sh &
echo $! > "$PID_PING"
echo "Ping wrapper started on $SOCKET_PING"

# Cleanup function
cleanup() {
    echo "Cleaning up..."

    for pid_file in "$PID_WOL" "$PID_PING"; do
        if [ -f "$pid_file" ]; then
            pid=$(cat "$pid_file")
            echo "Killing $pid..."
            kill "$pid" 2>/dev/null || true
            rm -f "$pid_file"
        fi
    done

    rm -f "$SOCKET_WOL" "$SOCKET_PING"
}

trap cleanup EXIT INT

# Wait to keep the script alive while handlers run
wait
