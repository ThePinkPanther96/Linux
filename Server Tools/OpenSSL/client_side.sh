#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <srv_username> <server_ip> <crt_srv_path>"
    exit 1
fi

srv_username="$1"
server_ip="$2"
crt_srv_path="$3"


# SCP the server.crt file from the server machine to the client machine
scp $srv_username@$server_i:$crt_srv_path /usr/local/share/ca-certificates/

# Update Certificate(s)
sudo update-ca-certificates

# Test connection
curl https://$server_ip