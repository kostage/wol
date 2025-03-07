#!/usr/bin/env bats

load 'test_helper'

@test "status.sh reports online when ping succeeds" {
    # Update mock config to simulate successful ping
    echo '{"mock_ping_result":"success"}' > /var/www/mock_config.json
    
    run "$TEST_CGI_BIN/status.sh"
    
    assert_success
    assert_output $'Content-type: application/json\n\n{"status":"online"}'
}

@test "status.sh reports offline when ping fails" {
    # Update mock config to simulate failed ping
    echo '{"mock_ping_result":"error"}' > /var/www/mock_config.json
    
    run "$TEST_CGI_BIN/status.sh"
    
    assert_success
    assert_output $'Content-type: application/json\n\n{"status":"offline"}'
}
