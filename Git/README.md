# Configure Git Server
## Introduction 
The purpose of this tutorial is to set up a comprehensive Git server environment, comprising a Git user, a repository, and SSH keys, on CentOS 7. Please note that I've chosen CentOS 7 for the sake of convenience. Nevertheless, the commands and accompanying scripts can be easily adapted for different Linux distributions.
199
## Requirements
- CentOS 7 environment
- Working networking connection with access to the internet.
- Basic understanding of Linux Bash.
- Remote client for testing (In my case I used Windows with Git Bash)

## How to configure the Git server manually
## Server side
1. Install the git package:
   ```
   sudo yum install git -y
   ```
2. Create a new user for managing the Git environment:
   ```
   sudo useradd -r -m -U -d /home/git -s /bin/bash git
   ```
   *NOTE!* The user home directory is set to ```/home/git```. The repositories will be stored under this directory.
3. Switch to 'git' user:
   ```
   sudo su - git
   ```
4. Create an SSH directory and the correct permissions:
   ```
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```
5. Generate an SSH key:
   ```
   ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
   ```
6. Create an authorized keys file with the correct permission, **if it does not exist**:
   ```
   touch ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```
7. Add your public key to the Authorized Keys file:
   ```
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```
*NOTE!* The server configuration is now complete. Now we will create a Git repository.
8. Create a new directory to store the repositories *(optional)*:
   ```
   mkdir -p ~/git-repos/<directoryName>.git
   ```
9. Inintioalize the new empty repository:
   ```
   git init --bare --shared /git-repos/<TheNewDirectory>.git
   ```
   ```
   Output
   Initialized empty Git repository in /home/git/TheNewDirectory.git/
   ```

## Configuring local Git Repository on the client side
### Linux Client

## Windows Client

## Testing

