#!/bin/bash

# Define backup directory and timestamp
BACKUP_DIR="$HOME/Flatpak-Backups/$(date +%Y-%m-%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting Flatpak backup..."

# 1. Backup list of installed applications
echo "Saving list of installed applications..."
flatpak list --app --columns=application > "$BACKUP_DIR/flatpak-apps.txt"

# 2. Backup repository configuration (remotes)
echo "Saving repository configurations..."
flatpak remotes --columns=name,url > "$BACKUP_DIR/flatpak-remotes.txt"

# 3. Backup custom permissions and overrides
echo "Saving application overrides..."
flatpak override --show > "$BACKUP_DIR/flatpak-overrides.txt" 2>/dev/null

# 4. Backup user settings and data (excluding heavy cache files)
echo "Archiving application user data (skipping caches)..."
tar -czf "$BACKUP_DIR/flatpak-userdata.tar.gz" \
    --exclude='*.var/app/*/cache' \
    -C "$HOME" .var/app

echo "Flatpak backup completed successfully!"
echo "Saved to: $BACKUP_DIR"

