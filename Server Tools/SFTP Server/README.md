
# SFTP-Server
## Introduction
The purpose of this tutorial is to provide comprehensive instructions on creating an Ubuntu-based SFTP server. In this tutorial, you will learn how to set up user groups and individual users and SFTP Jail.

## Requirements
- Ubuntu 18.04 or higher
- At least 10BG Storage 
- 2 Disks, 1 For the OS, 1 for storage.
- Inbound port 22 (SSH).

## Reconfiguring default home directory
Reconfiguring the default home directory allows you to move the user's home directory to the storage disk, enhancing security. Once this change is made, new users' home directories will be automatically redirected to the second disk.
1. If ssh is not installed, install it:
    ```
    sudo apt install ssh
    
    ```
2. Make sure ssh is enables:
    ```
    ufw allow ssh
    ufw enable -y
    ```
3. Chance the default home directory to the second disk of each new user:
    ```
    vi /etc/default/useradd
  
    HOME=/<DiskName>
    ```
## Configuring SFTP Jail
An SFTP chroot jail allows you to create a secure directory that confines a user to a specific area.
Edit the following file:
1. Create a dedicated group
    ```
    addgroup <Group Nmae>
    ```
2. Navigate to ```sshd_config```:
    ```
    vi /etc/ssh/sshd_config
    ```
3. Paste the following settings:
    ```
    Match Group <Group Nmae>
        ChrootDirectory %h
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp
    ```
4. save the file & restart the ssh service:
    ```
    systemctl restart ssh
    ```

## Configuring Group & users:
1. Create a new user: 
    ```
    useradd -m <username>
    passwd <username>
    ```
2. Edit the user, group, and set the correct permissions:
    ```
    usermod -G <group name> <username>
    chown root:root /<homedir>/<username>
    chmod 755 /<home>/<username>
    ```

3. Create a dedicated directory for the user to use for the SFTP function.
  This configuration will allow you to create a closed environment for each SFTP user, so the user won't be able to exit the confines of its designated area:
    ```
    cd /<homedir>/<username>
    mkdir <directory>
    chown <username>:<group> *
    ```