#!/bin/bash

# yt-dlp YouTube Music downloader script
# Make sure yt-dlp is installed: pip install -U yt-dlp
# Usage: ./ytmusic-dl.sh "URL or search query"

# Check if a URL or search term is provided
if [ -z "$1" ]; then
    echo "Usage: $0 \"YouTube Music URL or search query\""
    exit 1
fi

# Output directory (change if you want)
OUTPUT_DIR="$HOME/Music/YouTubeMusic"
mkdir -p "$OUTPUT_DIR"

# Filename format: Artist - Title.ext
FILENAME_FORMAT="%(artist)s - %(title)s.%(ext)s"

# Download audio only (best quality)
# Convert to mp3 after download
yt-dlp \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    --output "$OUTPUT_DIR/$FILENAME_FORMAT" \
    "$1"

echo "Download finished. Files saved to $OUTPUT_DIR"
