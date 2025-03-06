#!/usr/bin/env bats

load 'test_helper'

@test "status.sh reports online when ping succeeds" {
    # Update mock config to simulate successful ping
    echo '{"mock_ping_result":"success"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/status.sh"
    
    [ "$status" -eq 0 ]
    [ "$output" == $'Content-type: application/json\n\n{"status":"online"}' ]
}

@test "status.sh reports offline when ping fails" {
    # Update mock config to simulate failed ping
    echo '{"mock_ping_result":"error"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/status.sh"
    
    [ "$status" -eq 0 ]
    [ "$output" == $'Content-type: application/json\n\n{"status":"offline"}' ]
}