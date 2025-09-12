#!/bin/bash
# Secure script to read OS release information
# This script only reads the /etc/os-release file without accepting any parameters
# to prevent command injection vulnerabilities

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Check if the file exists and is readable
if [[ -r "/etc/os-release" ]]; then
    cat /etc/os-release
else
    echo "Error: /etc/os-release file not found or not readable"
    exit 1
fi