
# SFTP-Server
### In this tutorial I will be sowing you how to construct an Ubuntu based SFTP server with groups and users, as well as configuring SFTP Jail, File auditing and Fail2Ban.


## Requirements
- Ubuntu 18.04 or higher.
- At least 1024MB of RAM.
- At least 10BG Storage 
- 2 Disks, 1 For the OS, 1 for storage.
- Open port 22 (SSH).

## Reconfigure the default home directory
This is used to move the user's home directory to the storage disk for better security. After changing the default home directory new users' home directory will be automatically redirected to the second disk.
```nh
vi /etc/default/useradd

HOME=/<DiskName>
```

## Configuring Fail2Ban
Fail2Ban scans log files like /var/log/auth.log and bans IP addresses conducting too many failed login attempts. It blocks clients that repeatedly fail to authenticate correctly with your system.
### Installaion
```nh
#install fail2ban package:

apt-get update -y
apt-get install fail2ban

#allow ssh if it is not allowed:

ufw allow ssh
ufw enable

#start and enable fail2ban service:

systemctl start fail2ban
systemctl enable fail2ban

#check if servise is running:
systemctl status fail2ban

#configiure fail2ban local conf files:

cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

## Configuring the jail.local file
```nh
vi /etc/fail2ban/jail.local

#configure the following settings:

# ignorecommand = /path/to/command <ip>

ignorecommand =

# "bantime" is the number of seconds that a host is banned.

bantime  = 1w

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
```nh
fail2ban-client status
fail2ban-client unban <IP Address>
```

## Configuring SFTP Jail
A SFTP chroot jail allows you to create a secure directory that confines a user to specific area.
```nh
#edit the following file;

vi /etc/ssh/sshd_config

#paste the following settings:

Match Group filetransfer
    ChrootDirectory %h
    X11Forwarding no
    AllowTcpForwarding no
    ForceCommand internal-sftp

#save file & rstart ssh service:

service ssh restart
```

## Configuring Group & users:
```nh
#make user: 

useradd -m <username>
passwd <username>

#edit user, group, and give the right permissions:

usermod -G <groupname> <username>
chown root:root /<homedir>/<username>
chmod 755 /<home>/<username>

#make a dedicated for the user to use for the SFTP function:

cd /<homedir>/<username>
mkdir <directory>
chown <username>:<group> *
```

## Configuring File Auditing
The auditd is responsible for writing audit records to the disk. During startup, the rules in /etc/audit.rules are read by this daemon. You can open /etc/audit.rules file and make changes such as setup audit file log location and other option. 
```nh
apt-get install auditd -y 

#Start and enable the service

systemctl start auditd
systemctl enable auditd
```

### Configuration
The configuration of audit is handled in a single file (whereas rules are handled in a completely separate file). Although the default should suffice for most needs, you can configure the system by issuing the command
```nh
vi /etc/audit/auditd.conf
```

### In that file you might want to configure the following entries.
The location of the log file is configured in the line
```nh
log_file = /var/log/audit/audit.log
```
The number of logs retained on the server is configured in the entry
```nh
num_logs = 5
```
Configure the maximum log file size (in MB) in the line.
```nh
max_log_file = 8
```
NOTE! If you make any changes to that configuration, you will have to restart the service.
```nh
systemctl restart auditd
```
### Creating rules
The first thing you want to do is to make sure you're starting with a clean state by using the following command
```nh
auditctl -l

### Creatinh auditing rules

vi /etc/audit/rules.d/audit.rules
```
### How a rule is configured
The rule pattern will look like the following
```nh
V-w /file/or/directory/path -p permissions -k key name
```
### The breakdown of the above lines looks like this
- -w is the path to watch
- -p is the permissions to monitor
- -k is the key name for the rule
### The permissions will be configured like this
- -r - read
- -w - write
- -x - execute
- -a - change in the file's attribute (either ownership or permissions)
### Viewing the auditd log file
You can view every entry in the auditd log by using the following command.
```nh
less /var/log/audit/audit.log 
#To see a log for a specific audit use the following command:
ausearch -k passwd
```
