#!/bin/bash

# Exit on error
set -e

# Clone the repository
git clone git@github.com:stanleyvarga/wallpaper-ngn.git ~/wallpaper-ngn

# Copy the wp-ngn binary to the dotfiles bin directory
cp ~/wallpaper-ngn/wp-ngn ~/.dotfiles/bin/bin/
chmod +x ~/.dotfiles/bin/bin/wp-ngn

echo "Installing LaunchAgent plist files..."
# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy the plist files
echo "Copying plist files to ~/Library/LaunchAgents/"
cp "$SCRIPT_DIR/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist" ~/Library/LaunchAgents/
cp "$SCRIPT_DIR/Library/LaunchAgents/wallpaper_scheduler.plist" ~/Library/LaunchAgents/

# Set correct permissions
chmod 644 ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
chmod 644 ~/Library/LaunchAgents/wallpaper_scheduler.plist

# Unload previous versions if they exist (will fail silently if they don't)
launchctl unload ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist 2>/dev/null || true
launchctl unload ~/Library/LaunchAgents/wallpaper_scheduler.plist 2>/dev/null || true

# Load the agents
echo "Loading LaunchAgents..."
launchctl load ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
launchctl load ~/Library/LaunchAgents/wallpaper_scheduler.plist

echo "LaunchAgents installed and loaded successfully!"
echo "The sleepwatcher agent will run on sleep/wake events"
echo "The wallpaper scheduler will run every 5 minutes"
