#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <num_logs> <log_size>"
    exit 1
fi

num_logs="$1"
log_size="$2"

# updater server
sudo apt-get -y update 

# Install auditd service
apt-get install -y auditd

# Enable service
systemctl start auditd
systemctl enable auditd

# Configure logs
