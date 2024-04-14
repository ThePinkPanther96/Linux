#!/bin/bash

set -x

generatesslcert () {
    keyname=$1 certname=$2 lease=$3 hostname=$4 passphrase=$5
    
    keypath="/etc/ssl/private/$keyname.key"
    certpath="/etc/ssl/certs/$certname.crt"

    if [ -f "$keypath" ] && [ -f "$certpath" ]; then
       echo "Both files already exits"
    elif [ -f "$keypath" ] || [ -f "$certpath" ]; then
        echo "One of the files already exists in the required paths."
        echo "Please resolve the conflict before executing the script again."
    elif ! [ -f "$keypath" ] && ! [ -f "$certpath" ]; then
        openssl req -x509 \
        -newkey rsa:4096 \
        -keyout "$keypath" \
        -out "$certpath" \
        -days $lease \
        -subj "/CN=$hostname" \
        -passout "pass:$passphrase"
        if [ -f "$keypath" ] && [ -f "$certpath" ]; then
            echo "Both Certificates were created successfully."
            exit 0
        else
            echo "One or more certificates failed to generate."
            exit 1
        fi 
    fi   
}

setupinstallations() {
    local package_list=("$@")

    for pkg in "${package_list[@]}"; do
        if apt-cache show "$pkg" &> /dev/null; then 
            if ! dpkg -l | grep -q "$pkg"; then
                echo "Installing $pkg ..."
                sudo apt-get install -y "$pkg"
                if apt-cache show "$pkg" &> /dev/null; then
                    echo "Package: $pkg installed successfully."
                else
                    echo "Failed to install package: $pkg"
                fi    
            else
                echo "Package: $pkg already installed."
            fi
        else 
            echo "Package: $pkg does not exist. Moving to next package."
        fi
    done   
}

editconfig() {
    keypath=$1 certpath=$2
    keyentry=$3 certentry=$4
    configpath=$5

    if [ -f "$configpath" ]; then
        if [ -f "$keypath" ] && [ -f "$certpath" ]; then
            echo "Editing $configpath ..."
            sed -i "s|^\s*$keyentry\s*.*$|$keyentry $keypath|" $configpath
            sed -i "s|^\s*$certentry\s*.*$|$certentry $certpath|" $configpath
            echo "Done"
        else
            echo "One or more certificates not found. Aborting opration."
            exit 1
        fi
    else
        echo "No config file found. Aborting operation."
        exit 1
    fi
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    generatesslcert "keyname" "certname" "365" "hostname" "1111"
    setupinstallations "apache2"
    sudo systemctl restart apache2 # edit
    editconfig "/etc/ssl/private/server.key" "/etc/ssl/certs/server.crt" "SSLCertificateKeyFile" "SSLCertificateFile" "/etc/apache2/sites-available/default-ssl.conf"
    sudo a2ensite default-ssl
    sudo systemctl restart apache2
fi


#checkservice() {
#    local package_list=("$@")
#
#    for pkg in "${package_list[@]}"; do
#        if apt-cache show "$pkg" &> /dev/null; then
#            service_name=$(dpkg -L "$pkg" | grep '\.service')
#            sudo systemctl enable $service_name
#            sudo systemctl start $service_name
#        else
#            echo "No service for $pkg"
#        fi
#    done
#}
#

#dpkg -L openssh-server | grep '\.service'
