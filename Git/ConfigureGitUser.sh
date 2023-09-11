#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Define the new username and password
new_username="USERNAME"
new_password="PASSWORD"

# Function to check if a user exists
user_exists() {
  if id "$1" &>/dev/null; then
    return 0  # User exists
  else
    return 1  # User does not exist
  fi
}

# Check if the user already exists
if user_exists "$new_username"; then
  echo "User '$new_username' already exists. Aborting."
  exit 1
fi

# Create the new user
useradd -m -s /bin/bash "$new_username"

# Set the password for the new user (optional)
echo "$new_username:$new_password" | chpasswd

# Generate SSH keys for the new user
sudo -u "$new_username" ssh-keygen -t rsa -b 4096 -N "" -f "/home/$new_username/.ssh/id_rsa"
echo "SSH keys generated for $new_username."

# Set permissions for the new user's home directory
chmod 755 "/home/$new_username"

echo "User '$new_username' created successfully."
