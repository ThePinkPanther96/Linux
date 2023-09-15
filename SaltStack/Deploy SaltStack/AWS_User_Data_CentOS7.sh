#!/bin/bash
MYIP=$(hostname -I | awk -F'.' '{print $4}' | awk '{print $1}')
yum -y install python3
sudo rpm --import https://repo.saltproject.io/py3/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub
curl -fsSL https://repo.saltproject.io/py3/redhat/7/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo


yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-3.el7.noarch.rpm 
yum clean expire-cache
yum -y install salt-minion
sed -i 's/\#master\: salt/master\: 0\.0\.0\.0/g' /etc/salt/minion # Enter Salt Master IP  
sed -i 's/\#hash_type\: sha256/hash_type\: sha256/g' /etc/salt/minion
sed -i "s/\#id\:/id\: chnx${MYIP}/g" /etc/salt/minion 
systemctl start salt-minion.service 
systemctl enable salt-minion.service 