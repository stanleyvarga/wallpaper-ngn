#!/bin/bash

# Exit on error
set -e

echo "Installing LaunchAgent plist files..."
# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Ensure the LaunchAgents directory exists with proper permissions
mkdir -p ~/Library/LaunchAgents
chmod 755 ~/Library/LaunchAgents

# Check if destination files exist and are writable, if not, try to fix or notify
for plist_file in "de.bernhard-baehr.sleepwatcher.plist" "wallpaper_scheduler.plist"; do
  destination="$HOME/Library/LaunchAgents/$plist_file"
  if [ -f "$destination" ] && [ ! -w "$destination" ]; then
    echo "Warning: Cannot write to existing file: $destination"
    echo "Attempting to change permissions..."
    if ! chmod u+w "$destination" 2>/dev/null; then
      echo "Failed to modify permissions. Trying with sudo (you may be prompted for password):"
      sudo chmod u+w "$destination" || {
        echo "Error: Could not modify permissions. Please remove or fix permissions on $destination manually."
        exit 1
      }
    fi
  fi
done

# Copy the plist files
echo "Copying plist files to ~/Library/LaunchAgents/"
cp "$SCRIPT_DIR/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist" ~/Library/LaunchAgents/ || {
  echo "Failed to copy sleepwatcher plist. Trying with sudo:"
  sudo cp "$SCRIPT_DIR/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist" ~/Library/LaunchAgents/
}

cp "$SCRIPT_DIR/Library/LaunchAgents/wallpaper_scheduler.plist" ~/Library/LaunchAgents/ || {
  echo "Failed to copy wallpaper scheduler plist. Trying with sudo:"
  sudo cp "$SCRIPT_DIR/Library/LaunchAgents/wallpaper_scheduler.plist" ~/Library/LaunchAgents/
}

# Set correct permissions
chmod 644 ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist 2>/dev/null || sudo chmod 644 ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
chmod 644 ~/Library/LaunchAgents/wallpaper_scheduler.plist 2>/dev/null || sudo chmod 644 ~/Library/LaunchAgents/wallpaper_scheduler.plist

# Ensure current user owns the files
chown $(whoami) ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist 2>/dev/null || sudo chown $(whoami) ~/Library/LaunchAgents/de.bernhard-baehr.sleepwatcher.plist
chown $(whoami) ~/Library/LaunchAgents/wallpaper_scheduler.plist 2>/dev/null || sudo chown $(whoami) ~/Library/LaunchAgents/wallpaper_scheduler.plist

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
