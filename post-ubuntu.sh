#!/bin/bash

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
echo "Copying Zsh configuration from '$ZSHRC_SOURCE' to '$ZSHRC_DEST'..."
cp ~/Documents/dotfiles/zsh/.zshrc ~/
echo "Zsh configuration copied."

# --- Get System IP Address ---
echo "Getting system IP address..."
ip a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d'/' -f1
echo "IP address displayed."

echo "Script execution complete."
echo "Logging out to initialize zsh"
pause
exit
