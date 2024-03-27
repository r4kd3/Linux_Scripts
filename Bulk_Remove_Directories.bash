#!/bin/bash

# Set default path for directories list file
list=""

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit 1
fi

# Check if an argument is provided for directories list file
if [ -n "$1" ]; then
  list="$1"
fi

# Check if the input file exists
if [ ! -f "$list" ]; then
  echo "Error: Input file '$list' not found"
  exit 1
fi

# Loop through the directories in the input file
while IFS= read -r dirname; do
  # Check if the directory exists
  if [ -d "$dirname" ]; then
    # Attempt to remove the directory
    if rm -rf "$dirname" &>/dev/null; then
      echo "Successfully removed directory $dirname"
    else
      echo "Error: Failed to remove directory $dirname"
    fi
  else
    echo "Error: Directory $dirname does not exist"
  fi
done < "$list"