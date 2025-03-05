#!/bin/sh

# Run unit tests
echo "Running unit tests..."
bats /test/unit

# Run integration tests
echo "Running integration tests..."
bats /test/integration
