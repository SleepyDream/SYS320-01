#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <log_file> <ioc_file>"
    exit 1
fi

# Assign the arguments to variables
log_file=$1
ioc_file=$2

# Process the log file
awk 'BEGIN {OFS=","} {print $1, $4$5, $7}' $log_file | grep -F -f $ioc_file > report.txt