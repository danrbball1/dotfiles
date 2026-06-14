#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./timelapse.sh video1.mp4 video2.mp4 video3.mp4 output.mp4

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <video1> <video2> <video3> <output>"
    exit 1
fi

V1="$1"
V2="$2"
V3="$3"
OUT="$4"

# --- Convert to absolute paths ---
abs_path() {
    local f="$1"
    if [[ "$f" = /* ]]; then
        echo "$f"
    else
        echo "$(pwd)/$f"
    fi
}

A1=$(abs_path "$V1")
A2=$(abs_path "$V2")
A3=$(abs_path "$V3")

# Validate files exist
for f in "$A1" "$A2" "$A3"; do
    if [ ! -f "$f" ]; then
        echo "Error: '$f' does not exist."
        exit 1
    fi
done

# --- Create concat list ---
LISTFILE=$(mktemp)
cat <<EOF > "$LISTFILE"
file '$A1'
file '$A2'
file '$A3'
EOF

echo "🔗 Combining videos..."
ffmpeg -y -f concat -safe 0 -i "$LISTFILE" -c copy combined_temp.mp4

echo "⏩ Creating timelapse..."
# Adjust speed multiplier as needed:
#   0.1 = 10× faster
#   0.05 = 20× faster
#   0.5 = 2× faster
ffmpeg -y -i combined_temp.mp4 -filter:v "setpts=0.004*PTS" -an "$OUT"

echo "🧹 Cleaning up..."
rm -f "$LISTFILE" combined_temp.mp4

echo "✅ Done. Output saved to: $OUT"

