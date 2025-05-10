#!/usr/bin/env bash

#######################################################################

#Developed by : Dmitri Donskoy
#Purpose : Ansible lightweight docker master node 
#Update date : 10.05.2025
#Version : 0.0.1
# set -x
set -o errexit
set -o nounset
set -o pipefail

############################ GLOBAL VARS ##############################

### Build image from Dockerfile
docker-compose build

### Start the container
docker-compose up -d
