#!/usr/bin/env bash

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
    
    # Initialize config.json with use_mock set to true
    echo '{
        "mac_address": "00:11:22:33:44:55",
        "ip_address": "192.168.1.100",
        "use_mock": true
    }' > "$TEST_WWW_DIR/config.json"
    
    # Initialize mock_config.json with default values
    echo '{
        "mock_ping_result": "success",
        "mock_etherwake_result": "success"
    }' > "$TEST_WWW_DIR/mock_config.json"
    
    # Set PATH to include our mock directory
    export PATH="$TEST_MOCK_DIR:$PATH"
}

teardown() {
    # Clean up temporary directories
    rm -rf "$TEST_TEMP_DIR"
}