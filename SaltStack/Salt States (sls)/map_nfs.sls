/MountPoint1:
  mount.mounted:
    - device: server.example-domain.com/Drive1
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev

/MountPoint2:
  mount.mounted:
    - device: server.example-domain.com/Drive2
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev

/MountPoint3:
  mount.mounted:
    - device: server.example-domain.com/Drive3
    - fstype: nfs
    - mkmnt: True
    - opts:
      - async,defaults,_netdev


# And so on...