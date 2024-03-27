#!/bin/bash

# Set default path for usernames file
users_list="usernames.txt"

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root"
  exit 1
fi

# Check if an argument is provided for usernames file
if [ -n "$1" ]; then
  users_list="$1"
fi

# Check if the input file exists
if [ ! -f "$users_list" ]; then
  echo "Error: Input file '$users_list' not found"
  exit 1
fi

# Loop through the usernames in the input file
while read -r username; do
  # Remove the user and its home directory
  if sudo userdel -r "$username" &>/dev/null; then
    echo "Successfully removed user $username"
  else
    echo "Error removing user $username"
  fi
done < "$users_list"