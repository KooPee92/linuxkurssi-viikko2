#!/usr/bin/env bash

# Week 3 - Server status report

# Collect server information
GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z %z')
UPTIME_TEXT=$(uptime -p)
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

# Check disk space status
check_disk_status() {
    local usage=$1

    if (( usage >= 80 )); then
        echo "WARNING"
    else
        echo "OK"
    fi
}


# Remove the % character
DISK_PERCENT=${DISK_USAGE%\%}

# Call the function
DISK_STATUS=$(check_disk_status "$DISK_PERCENT")


# Display collected information
echo "Server Status Report"
echo "--------------------"
echo "Generated at: $GENERATED_AT"
echo "Server uptime: $UPTIME_TEXT"
echo "Root disk usage: $DISK_USAGE"
echo "Disk space status: $DISK_STATUS"
echo "Total RAM: $MEM_TOTAL MiB"
echo "Available RAM: $MEM_AVAILABLE MiB"
