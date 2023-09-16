#!/bin/bash

# Define variables
remote_server="192.168.1.51"  # Replace with your server's IP address or hostname
remote_user="git"             # Replace with the remote user on the server
key_comment="Gal R"           # Replace with your desired comment for the SSH key

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "$key_comment"

# Check if the SSH key pair generation was successful
if [ $? -eq 0 ]; then
    echo "SSH key pair generated successfully."
else
    echo "Error: SSH key pair generation failed."
    exit 1
fi

# Copy the public key to the remote server
cat ~/.ssh/id_rsa.pub | ssh "$remote_user@$remote_server" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'

# Check if the public key was successfully copied
if [ $? -eq 0 ]; then
    echo "Public key copied to the remote server."
else
    echo "Error: Public key copy to the remote server failed."
    exit 1
fi

# Set appropriate permissions for the SSH directory and files
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

echo "SSH key-based authentication setup complete."

# Optionally, you can add more commands here to configure the Git repository or other settings as needed.
