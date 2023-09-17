# Configure Git Server
## Introduction 
The purpose of this tutorial is to set up a comprehensive Git server environment, comprising a Git user, a repository, and SSH keys, on CentOS 7. Please note that I've chosen CentOS 7 for the sake of convenience. Nevertheless, the commands and accompanying scripts can be easily adapted for different Linux distributions.

## Requirements
- CentOS 7 environment
- Working networking connection with access to the internet.
- Basic understanding of Linux Bash.
- Remote client for testing. (In my case I used a Windows client with [Git Bash](https://git-scm.com/download/win))

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
   
4. Switch to 'git' user:
   ```
   sudo su - git
   ```
5. Create an SSH directory and the correct permissions:
   ```
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```
6. Generate an SSH key:
   ```
   ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
   ```
7. Create an authorized keys file with the correct permission, **if it does not exist**:
   ```
   touch ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```
8. Add your public key to the Authorized Keys file:
   ```
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```
*NOTE!* The server configuration is now complete. Now we will create a Git repository.
8. Create a new directory to store the repositories *(optional)*:
   ```
   mkdir -p ~/git-repos/new-rep.git
   ```
9. Inintioalize the new empty repository:
   ```
   git init --bare --shared /git-repos/new-rep.git
   ```
   ```
   Output
   Initialized empty Git repository in /home/git/TheNewDirectory.git/
   ```

## Configuring local Git Repository on the client side

1. Navigate back to the client. 
   *NOTE!* If you are using a Windows client use (Git bash)[https://git-scm.com/download/win] for Windows. 
2. Genetate ssh key and follow the prompts:
   ```
   ssh-keygen
   ```
3. After a successful key generation, copy the key to the target user's authorized keys on the server (in this case, user 'git'):
   ```
   ssh-copy-id git@192.168.1.51
   ```
## Testing
1. Test connection, try logging in to the server:
   ```
   ssh -i ~/.ssh/id_rsa git@192.168.1.51
   ```
2. "After a successful login, create a project directory, and then try cloning a repository:
   ```
   mkdir -p /path/to/local/project
   ```
3. Navigate to the project directory: 
   ```
   cd /path/to/local/project
   ```
4. Clone the repository from the server to the client: 
   ```
   git remote add origin git@192.168.1.51:new-repo.git
   ```
   ```
   Output:
   
   debug1: pledge: fork
   warning: You appear to have cloned an empty repository.
   debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
   debug1: channel 0: free: client-session, nchannels 1
   Transferred: sent 3660, received 3056 bytes, in 0.2 seconds
   Bytes per second: sent 17154.6, received 14323.6
   debug1: Exit status 0
   ```
5. Create a test file:
   ```
   echo "Hello, Git!" > test.txt
   ```
6. Stage all the changes in your current project directory for the next commit:
   ```
   git add .
   ```
7. Commit: 
   ```
   git commit -m "Add a sample file"
   ```
8. ```
   git push origin master
   ```
   ```
   Output:
   
   debug1: pledge: fork
   Enumerating objects: 3, done.
   Counting objects: 100% (3/3), done.
   Writing objects: 100% (3/3), 217 bytes | 217.00 KiB/s, done.
   Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
   debug1: client_input_channel_req: channel 0 rtype exit-status reply 0
   debug1: channel 0: free: client-session, nchannels 1
   Transferred: sent 4004, received 3288 bytes, in 0.2 seconds
   Bytes per second: sent 17073.8, received 14020.6
   debug1: Exit status 0
   To 192.168.1.51:/home/git/git-repos/new-repo.git
   * [new branch]      master -> master
   ```

## Testing the server side 
1. On the server navigate to the requiered repository: 
   ```
   cd ~/git-repos/repo.git
   ```
2. Try to display information about the tree object in the selected Git repository:
   ```
   git ls-tree master
   ```
   ```
   Output:

   [root@localhost new-repo.git]# git ls-tree master
   100644 blob 670a245535fe6316eb2316c1103b1a88bb519334    test.txt
   ```
   As you can see from the output, the 'text.txt' file we created previously was pushed to the server successfully.

## Automation
For convenience purposes, I created three Bash scripts to assist with Git configuration on both the server and the client.

[ConfigureGit.sh](https://github.com/ThePinkPanther96/Linux/blob/main/Git/ConfigureGit.sh) - 
This script automates the setup of a Git server environment. It installs Git, creates a 'git' user, generates an SSH key pair for the 'git' user, sets up an Authorized Keys file, creates a directory for Git repositories, initializes the repository, and sets appropriate permissions for the Git repository and its contents.

[ConfigureRepository.sh](https://github.com/ThePinkPanther96/Linux/blob/main/Git/ConfigureRepository.sh) - This script sets up a new Git repository on the server by specifying the Git user, the path for the repository, and its name. It checks if the repository directory already exists, creates it if it doesn't, and initializes the Git repository within that directory. 

[ConfigureClientSsSHKey.sh](https://github.com/ThePinkPanther96/Linux/blob/main/Git/ConfigureClientSsSHKey.sh) - This script sets up SSH key-based authentication for a remote client by generating an SSH key pair, copying the public key to the server, and configuring the necessary permissions.

