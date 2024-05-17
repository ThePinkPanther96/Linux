#!/bin/bash

# log directory
LOG_DIR="/var/log/backup_logs"

# Backup files target directory
BACKUP_DIR="/mnt/backups"

# Directories to backup
SOURCE_DIR="/path/to/excluded/folder /path/to/excluded/folder" 


# logging outputs (INFO, WARNING, ERROR)
logging() {
    local function="$1"
    local level="$2"
    local message="$3"
    local current_date=$(date +"%d-%m-%Y %H:%M:%S") # Get date and time for content of log
    local log_file_path="${LOG_DIR}/$(date +"%d-%m-%Y").log" # Get date for log file name
    local log_entry="$current_date - [$level][$function] - $message" # Construct message

    mkdir -p "$LOG_DIR"
    echo "$log_entry" >>"$log_file_path"
}

# Check disk
check_disk_space () {
    # Three types of thresholds to easily configure according to requerments
    FIRST_ALERT=60
    SECOND_ALERT=85
    THIRD_ALERT=95

    df -h | grep "/dev/" | while read -r LINE; do # Get the disk
        DISK=$(echo "$LINE" | awk '{print $1}') 
        STORAGE_USAGE=$(echo "$LINE" | awk '{print $5}' | sed 's/%//') # Get disk usage percentage
        if [ -n "$STORAGE_USAGE" ] && [ -n "$DISK" ]; then
            if [ "$STORAGE_USAGE" -ge "$FIRST_ALERT" ]; then
                logging "storage_usage" "INFO" "Disk $DISK space is over 50% at $STORAGE_USAGE% - On $(hostname)"
            elif [ "$STORAGE_USAGE" -ge "$SECOND_ALERT" ]; then
                logging "storage_usage" "ALERT" "Disk $DISK space is getting HIGH at $STORAGE_USAGE% - On $(hostname)"
            elif [ "$STORAGE_USAGE" -ge "$THIRD_ALERT" ]; then
                logging "storage_usage" "CRITICAL" "Disk $DISK space is getting CRITICALLY LOW at $STORAGE_USAGE% - On $(hostname)"
            else
                logging "storage_usage" "INFO" "Disk $DISK space is stable under 50% at $STORAGE_USAGE% - On $(hostname)"
            fi
        fi
    done
}

# Creatig the backup package
package_backup () {
    source_dir="$SOURCE_DIR"
    backup_files="$BACKUP_DIR"
    
    # Parameters for file name
    local file_timestamp=$(date +"%A_%d_%m_%Y") 
    local hostname=$(hostname -s)
    local archive_file="$hostname-$file_timestamp.tgz"

    for dir in ${source_dir}; do
        if [ ! -d $dir ]; then
            logging "package_backup" "ERROR" "Target directory $dir does not exist!"
        else
            logging "package_backup" "INFO" "Target directory $dir checkup OK"
        fi
    done

    # Package the target items
    local backup_command="sudo tar czf \"$backup_files/$archive_file\" $source_dir"
    local console_output=$(eval "$backup_command" 2>&1)
    local exit_status=$?

    # Checks if the job was done successfully and everything is in place
    if [ $exit_status -eq 0 ]; then
        if [ -e "$backup_files/$archive_file" ]; then
            logging "package_backup" "INFO" "$archive_file was successfully saved to $backup_files"
        else
            logging "package_backup" "ERROR" "Failed to backup $archive_file: $console_output"
        fi
    else 
        logging "package_backup" "ERROR" "Failed to execute operation: $console_output"
    fi
}


main () {
    logging "main" "INFO" "Starting program..."
    logging "main" "INFO" "Getting disk space info..."
    check_disk_space
    logging "package_backup" "INFO" "Starting backup...."
    package_backup
    logging "main" "INFO" "Getting disk space again..."
    check_disk_space
    logging "main" "INFO" "script finished"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi