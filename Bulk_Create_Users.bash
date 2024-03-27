#!/bin/bash

# Set default path for usernames file
users_list="/mnt/c/Users/Administrator/Desktop/test-users.txt"

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
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
while IFS=':' read -r username password sudo_option; do
  # Check if the user already exists
  if id "$username" &>/dev/null; then
    echo "User $username already exists. Changing password..."
    # Change the password for the existing user
    echo "$username:$password" | chpasswd
    continue
  fi

  # Create the user with the given password
  if sudo useradd -m -p "$password" "$username" &>/dev/null; then
    create_message="User $username created"
    
    # If the sudo option is mentioned, add the user to sudoers group
    if [ "$sudo_option" == "sudo" ]; then
      sudo usermod -aG sudo "$username"
      create_message+=" and added to sudoers group"
    fi
    
    echo "$create_message"
  else
    echo "Error creating user $username"
  fi
done < "$users_list"
