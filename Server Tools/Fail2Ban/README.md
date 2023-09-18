# Configuring Fail2Ban
## Introduction
Fail2Ban watches for suspicious activity, like too many login attempts from one place, and blocks those suspicious users from accessing your system, helping to keep it safe from potential threats.
Configuring Fail2Ban involves scanning log files such as ```/var/log/auth.log``` and banning IP addresses that have made too many failed login attempts. It effectively blocks clients that repeatedly fail to authenticate correctly with your system.
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
    ``
