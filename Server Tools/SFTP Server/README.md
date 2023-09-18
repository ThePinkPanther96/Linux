
# SFTP-Server
The purpose of this tutorial is to provide comprehensive instructions on creating an Ubuntu-based SFTP server. In this tutorial, you will learn how to set up user groups and individual users, configure SFTP Jail, enable file auditing, and implement Fail2Ban for enhanced security.


## Requirements
- Ubuntu 18.04 or higher
- At least 10BG Storage 
- 2 Disks, 1 For the OS, 1 for storage.
- Inbound port 22 (SSH).

## Reconfiguring default home directory
Reconfiguring the default home directory allows you to move the user's home directory to the storage disk, enhancing security. Once this change is made, new users' home directories will be automatically redirected to the second disk.
1. Chance the default home directory to the second disk of each new user:
  ```nh
  vi /etc/default/useradd

  HOME=/<DiskName>
  ```

## Configuring Fail2Ban
Configuring Fail2Ban involves scanning log files such as /var/log/auth.log and banning IP addresses that have made too many failed login attempts. It effectively blocks clients that repeatedly fail to authenticate correctly with your system.
### Installations
2. Install Fail2Ban package:
  ```
  apt-get update -y
  apt-get install fail2ban -y
  ```
3. Allow ssh server:
  ```
  ufw allow ssh
  ufw enable -y
  ```
4. Start and enable Fail2Ban service:
  ```
  systemctl start fail2ban
  systemctl enable fail2ban
  ```
5. After a successful installation check the service status:
  ```
  systemctl status fail2ban
  ```
  If everything is correct, this should be the output
  ```
  Output:

  ● fail2ban.service - Fail2Ban Service
       Loaded: loaded (/lib/systemd/system/fail2ban.service; disabled; vendor preset: enabled)
       Active: active (running) since Mon 2023-09-18 12:10:52 UTC; 7s ago
         Docs: man:fail2ban(1)
     Main PID: 1946 (fail2ban-server)
        Tasks: 5 (limit: 4558)
       Memory: 12.8M
          CPU: 122ms
       CGroup: /system.slice/fail2ban.service
               └─1946 /usr/bin/python3 /usr/bin/fail2ban-server -xf start 
  ```
6. Copy both ```fail2ban.conf``` and ```jail.conf``` to the same directory as .local, so the original files will be saved as backups:
  ```
  cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  ```

## Configuring the jail.local file
1. Enter the ```jail.local``` file":
  ```
  vi /etc/fail2ban/jail.local
  ```
2. In the file configure the following settings:
  ```
  # ignorecommand = /path/to/command <ip>
  ignorecommand =
  
  # "bantime" is the number of seconds that a host is banned (e.g. 1w, 2m, 3y).
  bedtime  = 1w
  
  # A host is banned if it has generated "maxretry" during the last "findtime"
  # seconds.
  findtime  = 1d
  
  # "maxretry" is the number of failures before a host get banned.
  maxretry = 5
  
  # SSH servers
  #
  
  [sshd]
  enabled = true
  ```

## Fail2ban administrative tools
```fail2ban-client status```: Checks what Fail2Ban is doing.
```fail2ban-client unban <IP Address>```: Unblocks a previously banned IP address.

## Configuring SFTP Jail
An SFTP chroot jail allows you to create a secure directory that confines a user to a specific area.
Edit the following file:
1. Navigate to ```sshd_config```:
  ```
  vi /etc/ssh/sshd_config
  ```
2. Paste the following settings:
  ```
  Match Group filetransfer
      ChrootDirectory %h
      X11Forwarding no
      AllowTcpForwarding no
      ForceCommand internal-sftp
  ```
3. save the file & restart the ssh service:
  ```
  service ssh restart
  ```

## Configuring Group & users:
1. Create a new user: 
  ```
  useradd -m <username>
  passwd <username>
  ```
2. Edit the user, group, and set the correct permissions:
```
usermod -G <groupname> <username>
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

