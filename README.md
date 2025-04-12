### 🐳 Build Docker image on your local machine
```bash
docker build -t wol_web .
```

### 📦 Copy necessary files to the router
```bash
scp start_wrappers.sh wol_wrapper.sh ping_wrapper.sh root@<router-ip>:/root/wol_app/
scp config.json root@<router-ip>:/root/wol_app/
```

### 🔐 SSH into the router
```bash
ssh root@<router-ip>
```

### 📥 Install required packages on OpenWrt
```bash
opkg update
opkg install etherwake socat coreutils-mkfifo jq
```

### 🧱 Create socket directory and set permissions
```bash
mkdir -p /var/run/wol_sockets
chmod 777 /var/run/wol_sockets
mkdir -p /root/wol_app
chmod +x /root/wol_app/*.sh
```

### 🛠️ Create and enable the wrapper service
```bash
cat > /etc/init.d/wol_sockets << 'EOF'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command /bin/sh /root/wol_app/start_wrappers.sh
    procd_set_param respawn
    procd_close_instance
}
EOF

chmod +x /etc/init.d/wol_sockets
/etc/init.d/wol_sockets enable
/etc/init.d/wol_sockets start
```

### 📤 (Optional) Transfer Docker image to the router
On your local machine:
```bash
docker save wol_web | gzip > wol_web.tar.gz
scp wol_web.tar.gz root@<router-ip>:/root/
```

Then on the router:
```bash
gunzip -c /root/wol_web.tar.gz | docker load
```

### 🐳 Create and enable Docker container service
```bash
cat > /etc/init.d/wol_web << 'EOF'
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command docker run --rm \
        --name wol_web \
        -p 80:80 \
        -v /var/run/wol_sockets:/var/run/wol_sockets \
        -v /root/wol_app/config.json:/var/www/config/config.json \
        wol_web
    procd_set_param respawn
    procd_close_instance
}
EOF

chmod +x /etc/init.d/wol_web
/etc/init.d/wol_web enable
/etc/init.d/wol_web start
```

### ✅ Done!
Visit `http://<router-ip>` in your browser to control and monitor your NAS.
