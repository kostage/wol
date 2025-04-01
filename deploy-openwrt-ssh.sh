ssh root@your-router 'opkg update && opkg install etherwake socat coreutils-mkfifo jq && mkdir -p /var/run/wol-sockets && chmod 777 /var/run/wol-sockets && cat > /usr/local/bin/wol-wrapper.sh << '"'EOF'"' && chmod +x /usr/local/bin/wol-wrapper.sh
#!/bin/sh
SOCKET=\"/var/run/wol-sockets/wol.sock\"
rm -f \$SOCKET
mkfifo \$SOCKET
chmod 777 \$SOCKET
while true; do
    if read line; do
        /usr/sbin/etherwake -i \$(echo \"\$line\" | jq -r '.if') \$(echo \"\$line\" | jq -r '.mac')
    done < \$SOCKET
done
EOF
cat > /usr/local/bin/ping-wrapper.sh << '"'EOF'"' && chmod +x /usr/local/bin/ping-wrapper.sh
#!/bin/sh
SOCKET=\"/var/run/wol-sockets/ping.sock\" 
rm -f \$SOCKET
mkfifo \$SOCKET
chmod 777 \$SOCKET
while true; do
    if read ip; do
        ping -c 1 -W 1 \"\$ip\" >/dev/null 2>&1
        echo \$? > \$SOCKET
    done < \$SOCKET
done
EOF
cat > /etc/init.d/wol-web << '"'EOF'"' && chmod +x /etc/init.d/wol-web
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command /bin/sh -c \"/usr/local/bin/wol-wrapper.sh & /usr/local/bin/ping-wrapper.sh\"
    procd_set_param respawn
    procd_close_instance
}
EOF
/etc/init.d/wol-web enable && /etc/init.d/wol-web start'
