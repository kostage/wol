FROM debian:bookworm-slim

# Create non-root user
RUN adduser --disabled-password --uid 1000 appuser && \
    echo 'appuser ALL=(root) NOPASSWD: /usr/sbin/etherwake' >> /etc/sudoers && \
    echo 'appuser ALL=(root) NOPASSWD: /var/www/mock/etherwake' >> /etc/sudoers

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    -o Dpkg::Options::="--force-confold" \
    ca-certificates \
    lighttpd \
    iputils-ping \
    jq \
    etherwake \
    sudo \
    bats \
    curl \
    bash \
    git \
    gettext-base \
    libcap2-bin \
    net-tools && \
    apt-get clean && \
    update-ca-certificates --fresh && \
    setcap cap_net_raw+ep /bin/ping && \
    rm -rf /var/lib/apt/lists/* && \
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
COPY wol-wrapper.sh ping-wrapper.sh /var/www/mock/
RUN chmod +x /var/www/mock/*
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

RUN apt-get update && \
    apt-get install -y socat && \
    mkdir -p /var/run/wol-sockets && \
    chown appuser:appuser /var/run/wol-sockets

RUN which etherwake && etherwake --version || echo "etherwake not found"
RUN which ping && which jq && which socat

USER appuser

CMD ["/start.sh"]
