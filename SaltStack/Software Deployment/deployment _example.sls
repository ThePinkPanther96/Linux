'firewall-cmd --add-port=<Some Port>/tcp --permanent':
 cmd.run


'yum install -y <Some Package or repo path>.rpm':
 cmd.run


mypkg:
  pkg.installed:
    - sources:
      - <Software Name>: salt://debs/<Some Installation Package>.deb

<Software Name>_conf:
  file.managed:
    - user:
    - group: <Group>
    - mode: '0755'
    - names:
      - /etc/<Software>/<DeploymentPath>.conf:
        - source: salt://<path>/<Software Name>.conf


'systemctl start <Service Name>':
 cmd.run

'systemctl enable <Service Name>':
 cmd.run

'<Some Additional Command>':
 cmd.run
