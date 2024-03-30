#!/bin/bash

adduser () {
    username=$1
    password=$2
    operation_success=false

    if id "$username" &>/dev/null; then
        echo "Username $username already exists."
    else
        while [ "$operation_success" = false ]; do
            sudo useradd -m -s /bin/bash "$username"
            echo "$username:$password" | sudo chpasswd
            if [ $? -eq 0 ]; then
                operation_success=true
                echo "$username created with password: $password"
                exit 0
            else
                echo "ERROR: $?"
                exit 1
            fi
        done
    fi
}

deleteuser () {
    username=$1

    if ! id "$username" &>/dev/null; then
        echo "Username $username does not exist"
    else
        sudo killall -u "$username"
        sudo userdel -f "$username"
        if ! id "$username" &>/dev/null; then
            echo "$username was deleted successfully."
            exit 0
        else
            echo "Could not delete user $username. Operation failed."
            exit 1
        fi
    fi
}

addgroup () {
    group=$1

    if grep -q $group /etc/group; then
        echo "Group $group already exists."
    else
        sudo groupadd "$group"
        if grep -q $group /etc/group; then
            echo "Group $group was created sucessfully"
            exit 0
        else
            echo "Could not create group $group. Operation failed."
            exit 1
        fi
    fi     
}

deleteroup () {
    group=$1

    if ! grep -q $group /etc/group; then
        echo "Group $group does not exist."
    else
        sudo groupdel "$group"
        if ! grep -q $group /etc/group; then
            echo "Group $group was deleted sucessfully"
            exit 0
        else
            echo "Could not delete group $group. Operation failed."
            exit 1
        fi
    fi     
}

addusertogroup () {
    username=$1
    groupname=$2

    if ! id "$username" &>/dev/null; then
        echo "Username $username does not exists."

    elif ! grep -q $groupname /etc/group; then
        echo "Group $groupname does not exist."
    elif groups "$username" | grep -qw "$groupname"; then
        echo "$username already in group $groupname"
    else
        sudo usermod -aG "$groupname" "$username"
        if groups "$username" | grep -q "\b$groupname\b"; then
            echo "$username was added to group $groupname"
            exit 0
        fi
        if ! groups "$username" | grep -q "\b$groupname\b"; then
            echo "Could not add $username to group $groupname. Operation failed."
            exit 1
        fi
    fi
}

changuserpassword() {
    username=$1
    password=$2
    operation_success=false 

    if ! id "$username" &>/dev/null; then
        echo "Username $username does not exist"
    else
        while [ "$operation_success" = false ]; do
            echo "$username:$password" | sudo chpasswd
            if [ $? -eq 0 ]; then
                operation_success=true
                echo "$username's password chnage to: $password"
            else
                echo "ERROR: $?"
                exit 1
            fi
        done
    fi
}

listgroups () {
    echo "$(sed -n '30,32p' main_menu.txt)"
    cat /etc/group
    echo "$(sed -n '32p' main_menu.txt)"
}

listusers () {
    echo "$(sed -n '28,30p' main_menu.txt)"
    cat /etc/passwd
    echo "$(sed -n '32p' main_menu.txt)"
}

main () {
    while true; do
        echo "$(sed -n '1,14p' main_menu.txt)"
        read 

        if [[ "${REPLY}" = "1" ]]; then
            while true; do
                read -p "Enter username: " username
                read -sp "Enter Password: " password
                echo
                if [[ -z "$username" || -z "$password" ]]; then
                    echo "$(sed -n '16p' main_menu.txt)"
                else
                    adduser "$username" "$password"
                    sleep 1
                    main
                fi
            done
        fi
        if [[ "${REPLY}" = "2" ]]; then
            while true; do
                read -p "Enter username to delete: " username
                echo
                if [[ -z "$username" ]]; then
                    echo "$(sed -n '22p' main_menu.txt)"
                else
                    deleteuser "$username"
                    sleep 1
                    main
                fi
            done
        fi
        if [[ "${REPLY}" = "3" ]]; then
            while true; do
                read -p "Enter group name: " group
                echo
                if [[ -z "$group" ]]; then
                    echo "$(sed -n '20p' main_menu.txt)"
                else
                    addgroup "$group"
                    sleep 1
                    main
                fi
            done
        fi
        if [[ "${REPLY}" = "4" ]]; then
            while true; do
                read -p "Enter group name to delete: " group
                echo
                if [[ -z "$group" ]]; then
                    echo "$(sed -n '20p' main_menu.txt)"
                else
                    deleteroup "$group"
                    sleep 1
                    main
                fi
            done
        fi
        if [[ "${REPLY}" = "5" ]]; then
            while true; do
                read -p "Enter username: " username
                read -p "Enter group name: " group
                echo
                if [[ -z "$username" || -z "$group" ]]; then
                    echo "$(sed -n '18p' main_menu.txt)"
                else
                    addusertogroup "$username" "$group"
                    sleep 1
                    main
                fi
            done
        fi
        if [[ "${REPLY}" = "6" ]]; then
            while true; do
                read -p "Enter new username: " username
                read -p "Enter new user password: " password
                echo
                if [[ -z "$username" || -z "$password" ]]; then
                    echo "$(sed -n '16p' main_menu.txt)"
                    sleep 1
                    main
                else
                    changuserpassword "$username" "$password"
                fi
            done
        fi 
        if [[ "${REPLY}" = "7" ]]; then
            listgroups
            exit
        fi
        if [[ "${REPLY}" = "8" ]]; then
            listusers
            exit
        fi 
        if [[ "${REPLY}" = "9" ]]; then
            echo "Exiting..."
            sleep 1
            exit
        fi
    done

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi