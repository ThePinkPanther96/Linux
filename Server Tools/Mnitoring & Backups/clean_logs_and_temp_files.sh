#!/bin/bash 

# Log directory
LOG_DIR="/home"

# Temporary files source directories
TMP_DIR=(
    "/tmp"
    "/var/tmp"
)

# log files to exclude from clearing 
LOG_EXCLUSIONS=(
    "/var/log/file.log" 
    "/var/log/file.log.1"
)

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


clean_logs () {
    local tmp_dir="/var/TMP"
    
    if [ ${#LOG_EXCLUSIONS[@]} -gt 0 ]; then 
        sudo mkdir -p "$tmp_dir"
        for file in "${LOG_EXCLUSIONS[@]}"; do
            cp "$file" "$tmp_dir"
        done
    fi
    # Find the log directory, detect .log files and .log files with numeric extensions (e.g. .log.1)
    # Deletes file with numeric extensions and clean log files that aren't excluded
    command="$(find /var/log \( -name "*.[0-9]" -o -name "*.*.[0-9]" -o -name "*.gz" \) -exec rm {} \; 2>&1)"
    command+="$(find /var/log/ -type f -name "*log" -exec cp /dev/null {} \; 2>&1)"
    local EXIT_STATUS=$?
    
    if [ $EXIT_STATUS -eq 0 ]; then
        logging "clean_logs" "INFO" "Log cleanup finished successfully: $command"
    else
        logging "clean_logs" "ERROR" "Failed to complete cleanup: $command"
    fi

    # Takes the the exculded files, place them in a temporary directory and moved them back to the original place when job finished. 
    # The temporary directory will be deleted.
    if [ ${#LOG_EXCLUSIONS[@]} -gt 0 ]; then
        for file in "${LOG_EXCLUSIONS[@]}"; do
            if [ -f "$tmp_dir/$(basename "$file")" ]; then
                if [ -d "$file" ]; then
                    cp -r "$tmp_dir/$(basename "$file")"/* "$file"
                else
                    cp "$tmp_dir/$(basename "$file")" "$file"
                fi
                logging "clean_logs" "INFO" "The following files were excluded: $file"
            else
                logging "clean_logs" "ERROR" "File '$tmp_dir/$(basename "$file")' does not exist."
            fi
        done
        sudo rm -rf "$tmp_dir"
    fi
}


# Deleteng temporary files in defined directories
clean_temp_files () {
    for dir in "${TMP_DIR[@]}"; do # finds the tmp files
        logging "clean_temp_files" "INFO" "Removing all temporary files from $dir"
        files=`ls -l $dir | wc -l` 
        logging "clean_temp_files" "INFO" "There are total $files temporary files/directory in $dir"
        rm -rf $dir/*
        if [[ "$?" == "0" ]];then
            logging "clean_temp_files" "INFO" "All temporary files successfully deleted"
        else
            logging "clean_temp_files" "ERROR" "Failed to delete temporary files"
        fi
        files=`ls -l $dir | wc -l` 
        logging "clean_temp_files" "INFO" "There are total $files temporary files/directory in $dir directory"
    done
}


main () {
    logging "main" "INFO" "Starting script..."
    logging "clean_logs" "INFO" "Starting log cleanup..."
    clean_logs
    logging "main" "INFO" "Starting temporary files cleanup..."
    clean_temp_files
    logging "main" "INFO" "Script finished."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi