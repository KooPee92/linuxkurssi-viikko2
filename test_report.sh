#!/usr/bin/env bash

# Test disk space status logic

check_disk_status() {
    local usage=$1

    if (( usage >= 80 )); then
        echo "WARNING"
    else
        echo "OK"
    fi
}

echo "Disk space status tests"
echo "-----------------------"

echo "Test 50%: $(check_disk_status 50)"
echo "Test 80%: $(check_disk_status 80)"
echo "Test 90%: $(check_disk_status 90)"
