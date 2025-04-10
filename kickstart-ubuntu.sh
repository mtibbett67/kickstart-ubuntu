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

# --- Copy post-ubuntu.sh file to new users home dir ---
cd /home/"$USERNAME"
wget https://github.com/mtibbett67/kickstart-ubuntu/raw/refs/heads/main/post-ubuntu.sh
chown "$USERNAME":"$USERNAME" post-ubuntu.sh
chmod +x post-ubuntu.sh

# --- System Updates and Upgrade ---
echo -e "\n\n\n\n\n"
echo "Running system updates and upgrading to the newest distribution..."
echo "Do not reboot at end of update!"
read -p "Press Enter to continue..."
apt update && apt upgrade -y && do-release-upgrade
echo "System update and upgrade complete."

# --- Install Packages ---
PACKAGES="net-tools zsh neovim git"
echo "Installing packages: $PACKAGES"
sudo apt install -y $PACKAGES
echo "Packages installed."

# Set Zsh as default shell for new user
echo "Changing default shell to Zsh for "$USERNAME"..."
chsh -s "$(which zsh)" "$USERNAME"
echo "Default shell for $USERNAME changed to Zsh."

echo -e "\n\n\n\n\n"
echo "login a new user and run post-ubuntu.sh"
echo "Script execution complete reboot the system."
read -p "Press Enter to continue..."
reboot
