#!/bin/bash

# === CONFIGURATION ===
# Directories to back up (space-separated).  If you want to add folder, not commas are needed
SOURCE_DIRS=("/home/daniel/MagicMirror" )

# Destination directory for backups
BACKUP_DIR="/home/daniel/backup"

# Compression method: gzip, bzip2, xz, or none
COMPRESSION="gzip"

# Log file
LOG_FILE="$BACKUP_DIR/backup.log"

# === SCRIPT START ===
# Create backup filename with timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_$TIMESTAMP.tar"

# Set compression flags
case "$COMPRESSION" in
  gzip)   ARCHIVE_NAME+=".gz"; COMPRESS_FLAG="z" ;;
  bzip2)  ARCHIVE_NAME+=".bz2"; COMPRESS_FLAG="j" ;;
  xz)     ARCHIVE_NAME+=".xz"; COMPRESS_FLAG="J" ;;
  none)   COMPRESS_FLAG="" ;;
  *)      echo "Invalid compression method: $COMPRESSION"; exit 1 ;;
esac

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Run tar command
echo "[$(date)] Starting backup..." >> "$LOG_FILE"
tar -c${COMPRESS_FLAG}f "$BACKUP_DIR/$ARCHIVE_NAME" "${SOURCE_DIRS[@]}" >> "$LOG_FILE" 2>&1

# Check result
if [ $? -eq 0 ]; then
  echo "[$(date)] Backup successful: $ARCHIVE_NAME" >> "$LOG_FILE"
else
  echo "[$(date)] Backup failed!" >> "$LOG_FILE"
fi

