FROM alpine:latest


# Create non-root user
RUN adduser -D -u 1000 appuser && \
    echo 'appuser ALL=(root) NOPASSWD: /usr/sbin/etherwake' >> /etc/sudoers

# Install dependencies
# Install lighttpd and create necessary directories
RUN apk add --no-cache \
    lighttpd \
    iputils \
    jq \
    sudo \
    shadow && \
    mkdir -p /var/www/localhost/htdocs /var/www/cgi-bin /var/www/mock /var/log/lighttpd && \
    chown -R appuser:appuser /var/www /var/log/lighttpd

# Create directory structure
RUN mkdir -p /var/www/cgi-bin /var/www/mock

# Copy files
COPY index.html /var/www/localhost/htdocs/
COPY wol.sh /var/www/cgi-bin/
COPY status.sh /var/www/cgi-bin/
COPY start.sh /
COPY mock/* /var/www/mock/
COPY config.json /var/www/
COPY mock_config.json /var/www/

# Set permissions
RUN chmod +x /var/www/cgi-bin/*.sh && \
    chmod +x /start.sh && \
    chmod +x /var/www/mock/* && \
    chown -R appuser:appuser /var/www

# Configure lighttpd
RUN { \
    echo 'server.modules = ("mod_access", "mod_cgi")'; \
    echo 'server.document-root = "/var/www/localhost/htdocs"'; \
    echo 'server.port = 80'; \
    echo 'index-file.names = ("index.html")'; \
    echo 'cgi.assign = (".sh" => "/bin/sh")'; \
    echo 'server.username = "appuser"'; \
    echo 'server.groupname = "appuser"'; \
    echo 'server.errorlog = "/var/log/lighttpd/error.log"'; \
    echo 'accesslog.filename = "/var/log/lighttpd/access.log"'; \
} > /etc/lighttpd/lighttpd.conf

# Create necessary directories
RUN mkdir -p /var/log/lighttpd && \
    chown appuser:appuser /var/log/lighttpd
EXPOSE 80

USER appuser

CMD ["/start.sh"]
