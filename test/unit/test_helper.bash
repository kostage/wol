#!/usr/bin/env bash

# Load bats-support and bats-assert
load '/usr/lib/bats-support/load'
load '/usr/lib/bats-assert/load'

setup() {
    export CONFIG=`cat /var/www/config/config.json | envsubst`
    export PATH="/var/www/mock:$PATH"
    export TEST_CGI_BIN="/var/www/cgi-bin"
}

teardown() {
    # Clean up temporary directories
    rm -rf "$TEST_TEMP_DIR"
}
