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

# --- System Updates and Upgrade ---
echo "Running system updates and upgrading to the newest distribution..."
apt update && apt upgrade -y && do-release-upgrade
echo "System update and upgrade complete."

# --- Add Local User ---
echo "Adding local user: $USERNAME"
useradd -m "$USERNAME"
echo "Setting password for user: $USERNAME"
passwd "$USERNAME"
echo "Adding user $USERNAME to the sudo group..."
usermod -aG sudo "$USERNAME"
echo "User '$USERNAME' added successfully."

# --- Install Packages ---
PACKAGES="net-tools zsh neovim git"
echo "Installing packages: $PACKAGES"
apt install -y $PACKAGES
echo "Packages installed."

# Set Zsh as default shell for new user
echo "Changing default shell to Zsh for "$USERNAME"..."
chsh -s "$(which zsh)" "$USERNAME"
echo "Default shell for $USERNAME changed to Zsh."

# --- Switch to New User and Configure ---
echo "Switching to user: $USERNAME"
sudo su - "$USERNAME"

echo "Creating Documents directory..."
mkdir -p ~/Documents
cd ~/Documents
echo "Current directory: $(pwd)"

# --- Clone Dotfiles ---
DOTFILES_REPO="https://github.com/mtibbett67/dotfiles.git"
echo "Cloning dotfiles from: $DOTFILES_REPO"
git clone "$DOTFILES_REPO"
echo "Dotfiles cloned."

# --- Copy Zsh Configuration ---
ZSHRC_SOURCE="~/Documents/dotfiles/zsh/.zshrc"
ZSHRC_DEST="~/.zshrc"
echo "Copying Zsh configuration from '$ZSHRC_SOURCE' to '$ZSHRC_DEST'..."
cp "$ZSHRC_SOURCE" "$ZSHRC_DEST"
echo "Zsh configuration copied."

# --- Get System IP Address ---
echo "Getting system IP address..."
ip a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d'/' -f1
echo "IP address displayed."

echo "Script execution complete."
