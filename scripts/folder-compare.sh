#!/usr/bin/env bash
set -euo pipefail

#############################################
# CONFIG
#############################################

LOG_FILE="./sync.log"
DRY_RUN=false

#############################################
# FUNCTIONS
#############################################

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

usage() {
    cat <<EOF
Usage: $0 [--dry-run] <local_dir> <remote_host> <remote_dir>

Options:
  --dry-run    Show actions without performing rsync or remote mkdir
EOF
}

#############################################
# ARGUMENT PARSING
#############################################

if [[ $# -lt 3 ]]; then
    usage
    exit 1
fi

if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

LOCAL_DIR="$1"
REMOTE_HOST="$2"
REMOTE_DIR="$3"

#############################################
# TEMP FILES
#############################################

LOCAL_LIST=$(mktemp)
REMOTE_LIST=$(mktemp)
MISSING_LIST=$(mktemp)

#############################################
# BUILD LOCAL LIST
#############################################

log "Scanning local directory: $LOCAL_DIR"

find "$LOCAL_DIR" -type f -o -type d \
    | sed "s|$LOCAL_DIR/||" \
    | sort > "$LOCAL_LIST"

#############################################
# BUILD REMOTE LIST
#############################################

log "Scanning remote directory: $REMOTE_HOST:$REMOTE_DIR"

ssh "$REMOTE_HOST" "find '$REMOTE_DIR' -type f -o -type d 2>/dev/null" \
    | sed "s|$REMOTE_DIR/||" \
    | sort > "$REMOTE_LIST"

#############################################
# DIFF
#############################################

log "Comparing directory trees..."

comm -23 "$LOCAL_LIST" "$REMOTE_LIST" > "$MISSING_LIST"

if [[ ! -s "$MISSING_LIST" ]]; then
    log "Remote host is fully up to date. Nothing to sync."
    exit 0
fi

log "Missing items on remote:"
cat "$MISSING_LIST" | tee -a "$LOG_FILE"

#############################################
# SYNC
#############################################

log "Starting sync..."

while IFS= read -r item; do
    SRC="$LOCAL_DIR/$item"
    DEST="$REMOTE_HOST:$REMOTE_DIR/$item"

    if [[ -d "$SRC" ]]; then
        log "Ensuring remote directory exists: $REMOTE_DIR/$item"
        if [[ "$DRY_RUN" == false ]]; then
            ssh "$REMOTE_HOST" "mkdir -p '$REMOTE_DIR/$item'"
        fi
    fi

    log "Syncing: $SRC → $REMOTE_HOST:$REMOTE_DIR/"
    if [[ "$DRY_RUN" == false ]]; then
        rsync -av --relative "$SRC" "$REMOTE_HOST:$REMOTE_DIR/"
    fi

done < "$MISSING_LIST"

log "Sync complete."

#############################################
# CLEANUP
#############################################

rm "$LOCAL_LIST" "$REMOTE_LIST" "$MISSING_LIST"

