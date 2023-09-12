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
### Server side
1. Install the git package:
   ```
   sudo yum install git -y
   ```
2. Vreate new user for managing the Git environment:
   ```
   sudo useradd -r -m -U -d /home/git -s /bin/bash git
   ```
   *NOTE!* The user home directory is set to ```/home/git```. The repositories will be stored under this directory.

### Client side
t
## Testing
t
