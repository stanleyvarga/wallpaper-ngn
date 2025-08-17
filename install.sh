#!/bin/bash

# Exit on error
set -e

echo "Installing LaunchAgent plist files..."
# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install wp-ngn CLI into ~/bin for easy command-line use
echo "Installing wp-ngn CLI to $HOME/bin..."
mkdir -p "$HOME/bin"
if [ -f "$SCRIPT_DIR/wp-ngn" ]; then
  cp "$SCRIPT_DIR/wp-ngn" "$HOME/bin/wp-ngn" 2>/dev/null || {
    echo "Failed to copy wp-ngn to ~/bin. Trying with sudo:"
    sudo cp "$SCRIPT_DIR/wp-ngn" "$HOME/bin/wp-ngn"
  }
  chmod 755 "$HOME/bin/wp-ngn" 2>/dev/null || sudo chmod 755 "$HOME/bin/wp-ngn"
  echo "Installed: $HOME/bin/wp-ngn"
else
  echo "Warning: wp-ngn not found at $SCRIPT_DIR/wp-ngn"
fi

# Notify if ~/bin is not on PATH
if ! echo ":$PATH:" | grep -q ":$HOME/bin:"; then
  echo "Note: $HOME/bin is not currently in your PATH. Add this to your shell config to use 'wp-ngn' directly:"
  echo "  export PATH=\"$HOME/bin:$PATH\""
fi

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

# Update wallpaper_scheduler.plist to point to the installed wp-ngn path
if [ -f "$HOME/Library/LaunchAgents/wallpaper_scheduler.plist" ]; then
  echo "Updating wallpaper_scheduler.plist to use $HOME/bin/wp-ngn"
  # Preferred: use plutil to set the ProgramArguments array
  plutil -replace ProgramArguments -json "[\"/bin/zsh\", \"$HOME/bin/wp-ngn\", \"--dynamic\", \"--sync-screens\"]" "$HOME/Library/LaunchAgents/wallpaper_scheduler.plist" 2>/dev/null || {
    echo "plutil update failed; attempting sed-based replacement"
    # macOS sed in-place edit
    sed -i '' -E "s#<string>/Users/[^<]*/wp-ngn</string>#<string>${HOME}/bin/wp-ngn</string>#" "$HOME/Library/LaunchAgents/wallpaper_scheduler.plist" 2>/dev/null || true
  }
fi

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
