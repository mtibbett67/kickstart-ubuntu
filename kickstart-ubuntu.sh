#!/bin/bash

## This script needs to be run with superuser (root) privileges.

if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Prompt for the new username
read -p "Enter the username for the new user: " USERNAME

# Check if the username is already taken
if id -u "$USERNAME" &> /dev/null; then
  echo "User '$USERNAME' already exists. Exiting."
  exit 1
fi

# --- Add Local User ---
echo "Adding local user: $USERNAME"
useradd -m "$USERNAME"
echo "Setting password for user: $USERNAME"
passwd "$USERNAME"
echo "Adding user $USERNAME to the sudo group..."
usermod -aG sudo "$USERNAME"
echo "User '$USERNAME' added successfully."

# --- System Updates and Upgrade ---
echo "Running system updates and upgrading to the newest distribution..."
echo "After reboot login a new user and wget post-ubuntu.sh and run."
apt update && apt upgrade -y && do-release-upgrade
echo "System update and upgrade complete."

echo "Script execution complete."
