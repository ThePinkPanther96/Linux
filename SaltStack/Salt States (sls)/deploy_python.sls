fe_be_pkgs:
  pkg.installed:
   - pkgs:
     - glibc-devel.i686
     - libstdc++-devel.i686
     - gcc
     - libffi-devel
     - python-devel
     - openssl-devel
     - python-paramiko
     - python-pandas
     - python2-backports_abc
     - python-singledispatch
     - salt
     - libcurl-devel



python pip install:
  pkg.installed:
    - pkgs:
      - python2-pip
    - bin_env: '/usr/bin/python2'

python pip3 install:
  pkg.installed:
    - pkgs:
      - python3-pip
    - bin_env: '/usr/bin/pip3'


python3_pandas:
  pip.installed:
    - name: pandas
    - bin_env: '/usr/bin/pip3'


python2_pkgs:
  pip.installed:
    - pkgs:
      - Babel
      - backports-abc
      - backports.ssl-match-hostname
      - cffi
      - chardet
      - cloud-init
      - configobj
        - cryptography
        - decorator
        - docutils
        - enum34
        - fail2ban
    - futures
    - idna
    - iniparse
    - ipaddress
    - IPy
    - isc
