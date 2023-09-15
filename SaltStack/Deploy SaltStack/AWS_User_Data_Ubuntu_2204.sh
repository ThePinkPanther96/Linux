#!/bin/bash
MYIP=$(hostname -I | awk -F'.' '{print $4}' | awk '{print $1}')
apt-get -y install python3
sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/22.04/amd64/latest jammy main" | sudo tee /etc/apt/sources.list.d/salt.list

#yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-3.el7.noarch.rpm 
apt update
apt-get -y install salt-minion
sed -i 's/\#master\: salt/master\: 172\.31\.22\.250/g' /etc/salt/minion  
sed -i 's/\#hash_type\: sha256/hash_type\: sha256/g' /etc/salt/minion
sed -i "s/\#id\:/id\: chnx${MYIP}/g" /etc/salt/minion 
systemctl start salt-minion.service 
systemctl enable salt-minion.service