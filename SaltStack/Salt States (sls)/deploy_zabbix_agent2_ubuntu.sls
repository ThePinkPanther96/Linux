'ufw allow 10050:10051/tcp':
 cmd.run



'apt-get install -y salt://debs/zabbix-agent2_6.0.7-1+ubuntu22.04_amd64.deb':
 cmd.run

mypkgs:
  pkg.installed:
    - sources:
      - zabbix-agent2: salt://debs/zabbix-agent2_5.4.9-1+ubuntu20.04_amd64.deb


zabbix_agent_conf:
  file.managed:
    - user:
    - group: root
    - mode: '0644'
    - names:
      - /etc/zabbix/zabbix_agent2.conf:
        - source: salt://files/zabbix_agent2.conf

zabbix_secret_psk:
  file.managed:
    - user: zabbix
    - group: zabbix
    - mode: '0640'
    - names:
      - /etc/zabbix/secret.psk:
        - source: salt://files/secret.psk



'systemctl start zabbix-agent2':
 cmd.run

'systemctl enable zabbix-agent2':
 cmd.run


'ufw reload':
 cmd.run
