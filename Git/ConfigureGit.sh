#!/bin/bash

# Variables
REPO_NAME="repo"

# Update system packages
#sudo yum update

# Install Git
sudo yum install -y git

# Create SSH directory and set permissions for the 'git' user
sudo useradd -r -m -U -d /home/git -s /bin/bash git

# Run commands as the 'git' user
sudo -u git bash <<EOF

mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key pair without passphrase if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

# Create an Authorized Keys file if it doesn't exist
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Add your public key to the Authorized Keys file
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Create a directory for Git repositories
mkdir ~/git-repos

# Initialize a bare Git repository
cd ~/git-repos
git init --bare --shared $REPO_NAME.git

# Set permissions for the Git repository
chown -R git:git $REPO_NAME.git

EOF
