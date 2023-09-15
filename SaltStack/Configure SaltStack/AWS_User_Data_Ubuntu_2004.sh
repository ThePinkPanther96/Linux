#!/bin/bash
MYIP=$(hostname -I | awk -F'.' '{print $4}' | awk '{print $1}')
apt-get -y install python3
sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-3.el7.noarch.rpm 
apt update
apt-get -y install salt-minion
sed -i 's/\#master\: salt/master\: 0\.0\.0\.0/g' /etc/salt/minion # Enter Salt Master IP  
sed -i 's/\#hash_type\: sha256/hash_type\: sha256/g' /etc/salt/minion
sed -i "s/\#id\:/id\: chnx${MYIP}/g" /etc/salt/minion 
systemctl start salt-minion.service 
systemctl enable salt-minion.service