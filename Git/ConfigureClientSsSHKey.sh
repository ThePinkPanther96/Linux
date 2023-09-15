#!/bin/bash

# Set variables for SSH key generation
KEY_TYPE="rsa"
KEY_BITS="4096"
KEY_COMMENT="N/A"  # Change this to your desired comment

# Set variables for SSH key file paths
SSH_KEY_PATH="~/.ssh/id_rsa"
SSH_PUBLIC_KEY_PATH="${SSH_KEY_PATH}.pub"

# Set variables for remote server
REMOTE_USERNAME="unix"
REMOTE_HOST="192.168.1.51"

# Step 1: Generate SSH key pair without user prompts
ssh-keygen -t "$KEY_TYPE" -b "$KEY_BITS" -C "$KEY_COMMENT" -f "$SSH_KEY_PATH" -N ""

# Step 2: Start SSH agent and add the SSH key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY_PATH"

# Step 3: Copy SSH public key to remote server (if not already authorized)
if ! ssh-copy-id "$REMOTE_USERNAME@$REMOTE_HOST"; then
  echo "SSH public key already authorized on $REMOTE_HOST or an error occurred."
else
  echo "SSH public key copied to $REMOTE_HOST for user $REMOTE_USERNAME."
fi
