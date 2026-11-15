#!/usr/bin/env bash

set -euo pipefail

LOGFILE="install.log"
REPO_PKGS="packages.txt"
AUR_PKGS="aur_pacakges.txt"
DRYRUN=false
VERBOSE=false

show_help() {
    cat <<EOF
Usage: ./install-packages.sh [options]

Options:
  --dry-run       Show what would be installed without making changes
  --verbose       Print detailed command information
  -h, --help      Show this help message

Description:
  Installs packages listed in:
    - $REPO_PKGS (official repo packages)
    - $AUR_PKGS (AUR packages via yay)

  Logs are written to: $LOGFILE
EOF
}

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRYRUN=true ;;
        --verbose) VERBOSE=true ;;
        -h|--help) show_help; exit 0 ;;
    esac
done

log() {
    if $VERBOSE; then
        echo "$1"
    fi
}

echo "=== Installation started at $(date) ===" | tee "$LOGFILE"

log "Verbose mode enabled"
$DRYRUN && log "Dry-run mode enabled"

# Ensure package files exist
for f in "$REPO_PKGS" "$AUR_PKGS"; do
    if [[ ! -f "$f" ]]; then
        echo "Error: $f not found." | tee -a "$LOGFILE"
        exit 1
    fi
done

# Ensure yay is installed
if ! command -v yay >/dev/null 2>&1; then
    echo "Error: yay is not installed." | tee -a "$LOGFILE"
    exit 1
fi

# read_packages() {
#     grep -v '^\s*#' "$1" | grep -v '^\s*$'
# }
read_packages() {
    sed -E '
        s/[[:space:]]*#.*$//;   # remove inline comments
        s/^[[:space:]]+//;      # trim leading whitespace
        s/[[:space:]]+$//;      # trim trailing whitespace
        /^$/d                   # remove empty lines
    ' "$1"
}
install_pkg() {
    local pkg="$1"
    local cmd="$2"

    if $DRYRUN; then
        echo "[DRY RUN] Would install: $pkg" | tee -a "$LOGFILE"
    else
        echo "Installing: $pkg" | tee -a "$LOGFILE"
        log "Running command: $cmd \"$pkg\""
        eval "$cmd \"$pkg\"" | tee -a "$LOGFILE"
    fi
}

install_group() {
    local file="$1"
    local installer="$2"

    while IFS= read -r pkg; do
        install_pkg "$pkg" "$installer"
    done < <(read_packages "$file")


#     for pkg in $(read_packages "$file"); do
#         install_pkg "$pkg" "$installer"
#     done
}

if ! $DRYRUN; then
    echo "Updating system..." | tee -a "$LOGFILE"
    log "Running: yay -Syu --noconfirm"
    yay -Syu --noconfirm | tee -a "$LOGFILE"
fi

echo "--- Installing repo packages ---" | tee -a "$LOGFILE"
install_group "$REPO_PKGS" "sudo pacman -S --needed --noconfirm"

echo "--- Installing AUR packages ---" | tee -a "$LOGFILE"
install_group "$AUR_PKGS" "yay -S --needed --noconfirm"

echo "=== Installation completed at $(date) ===" | tee -a "$LOGFILE"
