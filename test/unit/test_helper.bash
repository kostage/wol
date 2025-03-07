#!/usr/bin/env bash

# Load bats-support and bats-assert
load '/usr/lib/bats-support/load'
load '/usr/lib/bats-assert/load'

setup() {
    # Create temporary directories
    export TEST_TEMP_DIR=$(mktemp -d)
    export TEST_CGI_BIN="$TEST_TEMP_DIR/cgi-bin"
    export TEST_MOCK_DIR="$TEST_TEMP_DIR/mock"
    export TEST_WWW_DIR="$TEST_TEMP_DIR/www"
    
    mkdir -p "$TEST_CGI_BIN" "$TEST_MOCK_DIR" "$TEST_WWW_DIR"
    
    # Copy scripts to test location
    cp /var/www/cgi-bin/*.sh "$TEST_CGI_BIN/"
    cp /var/www/mock/* "$TEST_MOCK_DIR/"
    cp /var/www/config.json "$TEST_WWW_DIR/"
    cp /var/www/mock_config.json "$TEST_WWW_DIR/"
    
    # Force use_mock to true for tests
    echo "$(jq '.use_mock = true' "$TEST_WWW_DIR/config.json")" > "$TEST_WWW_DIR/config.json"
    
    # Set PATH to include our mock directory
    export PATH="$TEST_MOCK_DIR:$PATH"
}

teardown() {
    # Clean up temporary directories
    rm -rf "$TEST_TEMP_DIR"
}