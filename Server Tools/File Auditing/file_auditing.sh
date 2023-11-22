#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <num_logs> <log_size> <log_file_path>"
    exit 1
fi

num_logs="$1"
log_size="$2"
log_file_path="$3"

# updater server
sudo apt-get -y update 

# Install auditd service
apt-get install -y auditd

# Enable service
systemctl start auditd
systemctl enable auditd

# Update the configuration file with the new values
sed -i "s/^num_logs = .*/num_logs = $num_logs/" /etc/audit/auditd.conf
sed -i "s/^max_log_file = .*/max_log_file = $log_size/" /etc/audit/auditd.conf
sed -i "s|^log_file = .*|log_file = $log_file_path|" /etc/audit/auditd.conf

# Reset the audit service
systemctl restart auditd

