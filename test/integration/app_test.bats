#!/usr/bin/env bats

# Load bats-support and bats-assert
load '/usr/lib/bats-support/load'
load '/usr/lib/bats-assert/load'

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
    assert_success
    assert_output --partial "<title>NAS Control</title>"
}

@test "wol endpoint responds" {
    run curl -s http://localhost:80/cgi-bin/wol.sh
    assert_success
    assert_output --partial '"status"'
}

@test "status endpoint responds" {
    run curl -s http://localhost:80/cgi-bin/status.sh
    assert_success
    assert_output --partial '"status"'
}