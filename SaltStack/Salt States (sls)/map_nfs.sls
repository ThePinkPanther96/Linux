/DirectoryName1:
  mount.mounted:
    - device: server.example-domain.com/DirectoryName1
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev

/DirectoryName2:
  mount.mounted:
    - device: server.example-domain.com/DirectoryName2
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev

/DirectoryName3:
  mount.mounted:
    - device: server.example-domain.com/DirectoryName3
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev


# And so on...