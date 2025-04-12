#!/bin/bash

# CONFIGURATION
ROUTER_IP="192.168.8.1"  # <-- replace with your router's IP
ROUTER_PORT="7777"
ROUTER_SSH_HOST="glinet"
REMOTE_APP_DIR="/root/wol_app"
LOCAL_CONFIG="config.json"
DOCKER_IMAGE_NAME="ghcr.io/kostage/wol"
DOCKER_IMAGE_TAG="v0.0.5"

echo "📤 Copying files to router..."
scp -O wrappers/start_wrappers.sh wrappers/wol_handler.sh wrappers/ping_handler.sh "$LOCAL_CONFIG" "$ROUTER_SSH_HOST:$REMOTE_APP_DIR/"

echo "🔧 Connecting to router and setting up..."
ssh "$ROUTER_SSH_HOST" /bin/sh << 'EOF'
# Variables
APP_DIR="/root/wol_app"
SOCKET_DIR="$APP_DIR/wol_sockets"

# Install required packages
opkg update
opkg install etherwake socat jq

# Create socket directory
mkdir -p "$SOCKET_DIR"
chmod 777 "$SOCKET_DIR"
mkdir -p "$APP_DIR"
chmod +x "$APP_DIR"/*.sh

# Create and enable wrapper service
cat > /etc/init.d/wol_sockets << 'EOL'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command /bin/sh /root/wol_app/start_wrappers.sh
    procd_set_param respawn
    procd_close_instance
}
EOL

chmod +x /etc/init.d/wol_sockets
/etc/init.d/wol_sockets enable
/etc/init.d/wol_sockets start

# Pull Docker image
docker pull ghcr.io/kostage/wol:v0.0.5

# Create and enable Docker service
cat > /etc/init.d/wol_web << 'EOL'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command docker run --rm \
        --name wol_web \
        -p 7777:80 \
        -v /root/wol_app/wol_sockets:/var/run/wol_sockets \
        -v /root/wol_app/config.json:/var/www/config/config.json \
        ghcr.io/kostage/wol:v0.0.5
    procd_set_param respawn
    procd_close_instance
}
EOL

chmod +x /etc/init.d/wol_web
/etc/init.d/wol_web enable
/etc/init.d/wol_web start
EOF

echo "✅ Setup complete! Access the UI at http://$ROUTER_IP:$ROUTER_PORT"
