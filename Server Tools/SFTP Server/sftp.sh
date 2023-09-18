#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <GroupName> <DiskName>"
    exit 1
fi

group_name="$1"
disk_name="$2"

# Install SSH if not installed
sudo apt install -y openssh-server

# Enable SSH protocol in the firewall
sudo ufw allow ssh
sudo ufw --force enable

# Change the default directory to a secondary disk
sudo bash -c "echo 'HOME=$disk_name' >> /etc/default/useradd"

# Create a new group for SFTP users
sudo groupadd "$group_name"

# Configure SFTP jail in sshd_config
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOL
Match Group $group_name
    ChrootDirectory %h
    X11Forwarding no
    AllowTcpForwarding no
    ForceCommand internal-sftp
EOL

# Restart the SSH service
sudo systemctl restart ssh

echo "SFTP server configuration completed."
