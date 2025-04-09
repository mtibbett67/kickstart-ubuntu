#!/bin/bash

# --- Install Packages ---
PACKAGES="net-tools zsh neovim git"
echo "Installing packages: $PACKAGES"
sudo apt install -y $PACKAGES
echo "Packages installed."

# Set Zsh as default shell for new user
echo "Changing default shell to Zsh for "$USERNAME"..."
chsh -s "$(which zsh)" "$USERNAME"
echo "Default shell for $USERNAME changed to Zsh."

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
ZSHRC_DEST="~/"
echo "Copying Zsh configuration from '$ZSHRC_SOURCE' to '$ZSHRC_DEST'..."
cp "$ZSHRC_SOURCE" "$ZSHRC_DEST"
source ~/.zshrc
echo "Zsh configuration copied."

# --- Get System IP Address ---
echo "Getting system IP address..."
ip a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d'/' -f1
echo "IP address displayed."

echo "Script execution complete."
