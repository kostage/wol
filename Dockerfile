FROM alpine:latest

# Create non-root user
RUN adduser -D -u 1000 appuser

# Install dependencies
RUN apk add --no-cache \
    lighttpd \
    jq \
    socat \
    gettext

# Create directory structure
RUN mkdir -p \
    /var/www/localhost/htdocs \
    /var/www/cgi-bin \
    /var/log/lighttpd \
    /var/www/config && \
    chown -R appuser:appuser /var/www /var/log/lighttpd

# Copy files
COPY index.html /var/www/localhost/htdocs/
COPY wol.sh status.sh /var/www/cgi-bin/
COPY start.sh /
COPY config.json /var/www/config/
COPY lighttpd.conf /etc/lighttpd/

# Set permissions
RUN chmod +x /var/www/cgi-bin/*.sh && \
    chmod +x /start.sh

EXPOSE 80

USER appuser

CMD ["/start.sh"]
