#!/usr/bin/env bash

#######################################################################
# Developed by : Dmitri Donskoy
# Purpose      : Ansible lightweight Docker master node
# Update date  : 10.05.2025
# Version      : 0.0.1
#######################################################################

set -o errexit
set -o nounset
set -o pipefail

# Check if docker-compose is installed
command -v docker-compose >/dev/null 2>&1 || {
  echo >&2 "docker-compose is not installed. Aborting."
  exit 1
}

# Logging function
log() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

log "Building Docker image..."
docker-compose build

log "Starting Docker containers..."
docker-compose up -d
