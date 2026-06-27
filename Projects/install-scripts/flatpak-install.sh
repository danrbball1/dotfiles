#!/usr/bin/env bash

set -uo pipefail

APP_LIST="flatpak-apps.txt"
REMOTE="flathub"

# Verify Flatpak is installed
if ! command -v flatpak >/dev/null 2>&1; then
    echo "ERROR: flatpak is not installed."
    exit 1
fi

# Verify app list exists
if [[ ! -f "$APP_LIST" ]]; then
    echo "ERROR: $APP_LIST not found."
    exit 1
fi

# Add Flathub if missing
if ! flatpak remote-list | awk '{print $1}' | grep -qx "$REMOTE"; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists "$REMOTE" \
        https://flathub.org/repo/flathub.flatpakrepo
fi

echo "Installing Flatpak applications from $APP_LIST..."
echo

while IFS= read -r app || [[ -n "$app" ]]; do
    # Trim whitespace
    app="$(echo "$app" | xargs)"

    # Skip blank lines and comments
    [[ -z "$app" || "$app" =~ ^# ]] && continue

    if flatpak info "$app" >/dev/null 2>&1; then
        echo "[SKIP] $app already installed"
        continue
    fi

    echo "[INSTALL] $app"

    if flatpak install -y "$REMOTE" "$app"; then
        echo "[OK] $app"
    else
        echo "[FAILED] $app"
    fi

    echo
done < "$APP_LIST"

echo "Done."
