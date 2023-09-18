#!/bin/bash

if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    echo "Usage: $0 <username> <group_name> <homedir> <directory> [password]"
    exit 1
fi

username="$1"
group_name="$2"
homedir="$3"
directory="$4"
password="$5"

# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User $username already exists."
    if [ -n "$password" ]; then
        echo "Password provided but not changed for existing user $username."
    else
        echo "No password provided. Password not changed."
    fi
else
    # Step 1: Create a user and set the password if provided
    sudo useradd -m "$username"
    if [ -n "$password" ]; then
        echo "$username:$password" | sudo chpasswd
        echo "Password set for new user $username."
    fi
fi

# Step 2: Add the user to the group
sudo usermod -G "$group_name" "$username"

# Step 3: Change ownership of the user's home directory
sudo chown root:root "$homedir/$username"

# Step 4: Change permissions for the user's home directory
sudo chmod 755 "$homedir/$username"

# Step 5: Create a directory in the user's home directory
sudo mkdir -p "$homedir/$username/$directory"

# Step 6: Change ownership of the new directory
sudo chown "$username:$group_name" "$homedir/$username/$directory"

echo "SFTP user configuration for $username completed."
