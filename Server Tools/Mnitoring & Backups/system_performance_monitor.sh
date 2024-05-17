#!/bin/bash

LOG_DIR="/home"

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


cpu_load () {
    # Three types of thresholds to easily configure according to requerments
    FIRST_ALERT=60
    SECOND_ALERT=85
    THIRD_ALERT=95

    CPULOAD=$(top -b -n 2 -d 1 | grep "Cpu(s)" | tail -n 1 | awk '{print $2}' | awk -F. '{print $1}') #Get the CPU Load in percentage
    if [ -n "$CPULOAD" ]; then
        if [ "$CPULOAD" -ge "$FIRST_ALERT" ]; then
            logging "cpu_load" "INFO" "CPU load is over 50% at $CPULOAD% - On $(hostname)"
        elif [ "$CPULOAD" -ge "$SECOND_ALERT" ]; then
            logging "cpu_load" "ALERT" "CPU load is getting HIGH at $CPULOAD% - On $(hostname)"
        elif [ "$CPULOAD" -ge "$THIRD_ALERT" ]; then
            logging "cpu_load" "CRITICAL" "CPU load is getting CRITICLY HIGH at $CPULOAD% - On $(hostname)"
        else
            logging "cpu_load" "INFO" "CPU load is stable under 50% at $CPULOAD% - On $(hostname)"
        fi
    fi
}


memory_load () {
    # Three types of thresholds to easily configure according to requerments
    FIRST_ALERT=60
    SECOND_ALERT=85
    THIRD_ALERT=95

    MEMORY_LOAD=$(free | grep Mem | awk '{printf "%d\n", $3/$2 * 100.0}') # Get memory load in percentage
    MEMORY_USED=$(free -m | awk '/Mem:/ {print $3}') # Get memory used in MB
    TOTAL_MEMORY=$(free -m | awk '/Mem:/ {print $2}') # Get free memory in MB
    if [ -n "$MEMORY_LOAD" ] && [ -n "$MEMORY_USED" ] && [ -n "$TOTAL_MEMORY" ]; then
        if [ "$MEMORY_LOAD" -ge "$FIRST_ALERT" ]; then
            logging "memory_load" "INFO" "Memory load is over 50% at $MEMORY_LOAD% | $MEMORY_USED MB/$TOTAL_MEMORY MB - On $(hostname)"
        elif [ "$MEMORY_LOAD" -ge "$SECOND_ALERT" ]; then
            logging "memory_load" "ALERT" "Memory load is getting HIGH at $MEMORY_LOAD% | $MEMORY_USED MB/$TOTAL_MEMORY MB - On $(hostname)"
        elif [ "$MEMORY_LOAD" -ge "$THIRD_ALERT" ]; then
            logging "memory_load" "CRITICAL" "Memory is getting CRITICLY HIGH at $MEMORY_LOAD% | $MEMORY_USED MB/$TOTAL_MEMORY MB - On $(hostname)"
        else
            logging "memory_load" "INFO" "Memory load is stable under 50% at $MEMORY_LOAD% | $MEMORY_USED MB/$TOTAL_MEMORY MB - On $(hostname)"
        fi
    fi
} 


storage_usage () {
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


main () {
    while true; do
        cpu_load
        memory_load
        storage_usage
        sleep 10
    done
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
