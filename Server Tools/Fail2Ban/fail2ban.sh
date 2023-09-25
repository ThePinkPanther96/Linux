#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <ip_ignore> <ban_time> <find_time> <maxretry>"
    exit 1
fi

ip_ignore="$1"
ban_time="$2"
find_time="$3"
maxretry="$4"

# Install SSH if not installed
sudo apt install -y openssh-server

# Enable SSH protocol in the firewall
sudo ufw allow ssh
sudo ufw --force enable

# Install and enable fail2ban
sudo apt-get install -y fail2ban 

systemctl start fail2ban	
systemctl enable fail2ban

# Copy fail2ban and jail .conf files to .local
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configure fila2ban jail in jail.local
sudo tee -a /etc/fail2ban/jail.local > /dev/null <<EOL
# ignorecommand = /path/to/command <ip>
ignorecommand = $ip_ignore
    
# "bantime" is the number of seconds that a host is banned (e.g. 1w, 2m, 3y).
bedtime  = $ban_time
    
# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime  = $find_time
    
# "maxretry" is the number of failures before a host get banned.
maxretry = $maxretry
    
# SSH servers
#
    
[sshd]
enabled = true
EOL

echo "Fail2Ban server configuration completed."