#!/usr/bin/env bats

setup() {
    # Start the application
    /start.sh &
    export APP_PID=$!
    sleep 1
}

teardown() {
    # Stop the application
    kill $APP_PID
}

@test "web interface returns index.html" {
    run curl -s http://localhost:80/
    [ "$status" -eq 0 ]
    [[ "$output" == *"<title>NAS Control</title>"* ]]
}

@test "wol endpoint responds" {
    run curl -s -X POST http://localhost:80/cgi-bin/wol.sh
    [ "$status" -eq 0 ]
    [[ "$output" == *"status"* ]]
}

@test "status endpoint responds" {
    run curl -s http://localhost:80/cgi-bin/status.sh
    [ "$status" -eq 0 ]
    [[ "$output" == *"status"* ]]
}