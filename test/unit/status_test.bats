#!/usr/bin/env bats

load 'test_helper'

@test "status.sh reports online when ping succeeds" {
    # Setup mock config
    echo '{"mock_ping_result":"success"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/status.sh"
    
    [ "$status" -eq 0 ]
    [ "$output" == $'Content-type: application/json\n\n{"status":"online","desired_state":"off","retry_count":0}' ]
}

@test "status.sh reports offline when ping fails" {
    # Setup mock config
    echo '{"mock_ping_result":"error"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/status.sh"
    
    [ "$status" -eq 0 ]
    [ "$output" == $'Content-type: application/json\n\n{"status":"offline","desired_state":"off","retry_count":0}' ]
}
