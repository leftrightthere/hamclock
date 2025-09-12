#!/bin/bash

# Startup script for HamClock with React OS Info App
# This script starts both HamClock and the React app backend

set -e

echo "Starting HamClock with React OS Info App..."

# Start the React app backend (which also serves the frontend)
cd /opt/backend
echo "Starting React app backend on port 3001..."
node server.js &
BACKEND_PID=$!

# Run the original HamClock init script
cd /opt/hamclock/ESPHamClock
echo "Starting HamClock..."
/opt/hamclock/init.sh &
HAMCLOCK_PID=$!

# Function to handle shutdown
cleanup() {
    echo "Shutting down services..."
    kill $BACKEND_PID $HAMCLOCK_PID 2>/dev/null || true
    wait
}

# Set trap to handle container shutdown
trap cleanup TERM INT

echo "Services started:"
echo "- HamClock: http://localhost:8080 (API), http://localhost:8081 (Web UI), http://localhost:8082 (Read-only Web UI)"
echo "- React OS Info App: http://localhost:3001"

# Wait for all background processes
wait