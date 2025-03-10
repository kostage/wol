ARG SOURCE_IMAGE
FROM ${SOURCE_IMAGE}

# Create non-root user
RUN adduser -D -u 1000 appuser && \
    echo 'appuser ALL=(root) NOPASSWD: /usr/sbin/etherwake' >> /etc/sudoers

# Install dependencies
RUN apk add --no-cache \
    lighttpd \
    iputils \
    jq \
    envsubst \
    sudo \
    shadow \
    bats \
    curl \
    bash \
    git && \
    mkdir -p /var/www/localhost/htdocs /var/www/cgi-bin /var/www/mock /var/log/lighttpd && \
    chown -R appuser:appuser /var/www /var/log/lighttpd

# Install bats-assert and bats-support
RUN git clone https://github.com/bats-core/bats-support.git /usr/lib/bats-support && \
    git clone https://github.com/bats-core/bats-assert.git /usr/lib/bats-assert

# Copy test files
COPY test /test
COPY test/unit/test_helper.bash /test/
RUN chmod +x /test/unit/*.bats /test/integration/*.bats /test/test_helper.bash /test/run_tests.sh

# Create directory structure
RUN mkdir -p /var/www/cgi-bin /var/www/mock

# Copy files
COPY index.html /var/www/localhost/htdocs/
COPY wol.sh /var/www/cgi-bin/
COPY status.sh /var/www/cgi-bin/
COPY start.sh /
COPY mock/* /var/www/mock/
COPY config.json /var/www/config/
COPY mock_config.json /var/www/

# Set permissions
RUN chmod +x /var/www/cgi-bin/*.sh && \
    chmod +x /start.sh && \
    chmod +x /var/www/mock/* && \
    chown -R appuser:appuser /var/www

# Copy custom lighttpd.conf
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

# Create necessary directories
RUN mkdir -p /var/log/lighttpd && \
    chown appuser:appuser /var/log/lighttpd

EXPOSE 80

USER appuser

CMD ["/start.sh"]
