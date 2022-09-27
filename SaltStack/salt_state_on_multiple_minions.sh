
#!/bin/bash
VM_NAMES="VM1 VM2 VM3 VM..."
for VM_NAME in $(echo ${VM_NAMES} | tr ' ' '\n'); do
    /srv/salt/script.sh ${VM_NAME} &
                                                                
