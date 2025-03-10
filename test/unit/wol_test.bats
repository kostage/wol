#!/usr/bin/env bats

load 'test_helper'

@test "wol.sh sends WoL packet successfully" {
    # Update mock config to simulate successful WoL
    echo '{"mock_etherwake_result":"success"}' > /var/www/mock_config.json
    
    run "$TEST_CGI_BIN/wol.sh"
    
    assert_success
    assert_output $'Content-type: application/json\n\n{"status":"success","message":"Wake signal sent"}'
}

@test "wol.sh handles WoL failure" {
    # Update mock config to simulate failed WoL
    echo '{"mock_etherwake_result":"error"}' > /var/www/mock_config.json
    
    run "$TEST_CGI_BIN/wol.sh"
    
    assert_failure
    assert_output $'Content-type: application/json\nStatus: 500 Internal Server Error\n\n{"status":"error","message":"Failed to send wake signal"}'
}
