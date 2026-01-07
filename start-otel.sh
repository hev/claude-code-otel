#!/bin/bash
# Claude Code OTEL Stack - Startup Script
# Add to your shell profile: source /path/to/start-otel.sh

COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

start_otel_stack() {
    # Check if any of the core containers are running
    if docker ps --format '{{.Names}}' | grep -q "^otel-collector$"; then
        echo "Claude Code OTEL stack already running"
        return 0
    fi

    echo "Starting Claude Code OTEL stack..."
    docker compose -f "$COMPOSE_DIR/docker-compose.yml" up -d

    if [ $? -eq 0 ]; then
        echo "OTEL stack started - Grafana at http://localhost:3847"
    else
        echo "Failed to start OTEL stack"
        return 1
    fi
}

# Run on source/execution
start_otel_stack
