#!/usr/bin/env bats

load 'test_helper'

@test "wol.sh sends WoL packet successfully" {
    # Update mock config to simulate successful WoL
    echo '{"mock_etherwake_result":"success"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/wol.sh"
    
    [ "$status" -eq 0 ]
    [ "$output" == $'Content-type: application/json\n\n{"status":"success","message":"Wake signal sent"}' ]
}

@test "wol.sh handles WoL failure" {
    # Update mock config to simulate failed WoL
    echo '{"mock_etherwake_result":"error"}' > "$TEST_WWW_DIR/mock_config.json"
    
    run "$TEST_CGI_BIN/wol.sh"
    
    [ "$status" -eq 1 ]
    [ "$output" == $'Content-type: application/json\nStatus: 500 Internal Server Error\n\n{"status":"error","message":"Failed to send wake signal"}' ]
}