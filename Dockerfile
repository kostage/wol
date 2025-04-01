FROM debian:bookworm-slim

# Create non-root user
RUN adduser --disabled-password --uid 1000 appuser && \
    echo 'appuser ALL=(root) NOPASSWD: /usr/sbin/etherwake' >> /etc/sudoers

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    -o Dpkg::Options::="--force-confold" \
    ca-certificates \
    lighttpd \
    jq \
    etherwake \
    sudo \
    socat && \
    apt-get clean && \
    update-ca-certificates --fresh && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/www/localhost/htdocs /var/www/cgi-bin /var/log/lighttpd && \
    chown -R appuser:appuser /var/www /var/log/lighttpd

# Create directory structure
RUN mkdir -p /var/www/cgi-bin

# Copy files
COPY index.html /var/www/localhost/htdocs/
COPY wol.sh status.sh /var/www/cgi-bin/
COPY start.sh /
COPY config.json /var/www/config/
COPY lighttpd.conf /etc/lighttpd/

# Set permissions
RUN chmod +x /var/www/cgi-bin/*.sh && \
    chmod +x /start.sh && \
    chown -R appuser:appuser /var/www

EXPOSE 80

USER appuser

CMD ["/start.sh"]
