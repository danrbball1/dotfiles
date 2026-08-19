#!/usr/bin/env bash

set -euo pipefail

LOCAL_PATH="$1"
REMOTE_SPEC="$2"

REMOTE_HOST="${REMOTE_SPEC%%:*}"
REMOTE_PATH="${REMOTE_SPEC#*:}"

TMP_LOCAL=$(mktemp)
TMP_REMOTE=$(mktemp)

trap 'rm -f "$TMP_LOCAL" "$TMP_REMOTE"' EXIT

(
    cd "$LOCAL_PATH"
    find . | sort
) > "$TMP_LOCAL"

ssh "$REMOTE_HOST" "
cd \"$REMOTE_PATH\" &&
find . | sort
" > "$TMP_REMOTE"

echo
echo "Files/directories only on LOCAL:"
comm -23 "$TMP_LOCAL" "$TMP_REMOTE"

echo
echo "Files/directories only on REMOTE:"
comm -13 "$TMP_LOCAL" "$TMP_REMOTE"

echo
echo "Common entries:"
comm -12 "$TMP_LOCAL" "$TMP_REMOTE"
