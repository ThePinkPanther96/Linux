# Configuring Fail2Ban
## Introduction
Fail2Ban watches for suspicious activity, like too many login attempts from one place, and blocks those suspicious users from accessing your system, helping to keep it safe from potential threats.
Configuring Fail2Ban involves scanning log files such as ```/var/log/auth.log``` and banning IP addresses that have made too many failed login attempts. It effectively blocks clients that repeatedly fail to authenticate correctly with your system.

## Requirements 
- Ubuntu 18.04 or higher
- At least 10BG Storage 
- Inbound port 22 (SSH).

## Configuration
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
    If everything is correct, this should be the output:

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
    ``
# Testing
Now, that you've successfully configured Fail2Ban and Fail2Ban Jail, you can start test it's fonctunabilty. 

1. Try logging in with a wrong password. Repeate this step until you reach the 'maxrety' trashold that you've configured previusly. 

2. From the server use these commands to test Fail2Ban status.
    - Use this command to see a list of blocked IP addresses:
    
    ```
    fail2ban-client status 
    ```

    - Use this command to release banned IP addresses:

    ```
    fail2ban-client unban <IP Address>
    ```
    
    - Enter ```fail2ban.log``` to see the full list of IP addresses:
    ```
    vi /var/log/fail2ban.log
    # Or
    less /var/log/fail2ban.log|grep ban
    ```

I trust this guide equips you with the essential information to commence your project.
Should you have any inquiries or suggestions, please don't hesitate to reach out to me.
Many thanks! 😊