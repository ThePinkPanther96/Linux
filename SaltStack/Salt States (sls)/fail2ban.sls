fail2ban_service:
  service.running:
  - name: fail2ban
  - enable: True

'/etc/fail2ban/fail2ban.local':
  file.managed:
    - source: salt://files/fail2ban.local
    - makedirs: True

'/etc/fail2ban/jail.local':
  file.managed:
    - source: salt://files/jail.local
    - makedirs: True

'/etc/fail2ban/filter.d/ssh-ban-root.conf':
  file.managed:
    - source: salt://files/ssh-ban-root.conf
    - makedirs: True

'fail2ban-client reload':
  cmd.run
