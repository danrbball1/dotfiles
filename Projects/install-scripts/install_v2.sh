#!/usr/bin/env bash

set -euo pipefail

LOGFILE="install.log"
REPO_PKGS="packages.txt"
AUR_PKGS="aur_packages.txt"
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
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            show_help
            exit 1
            ;;
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

read_packages() {
    sed -E '
        s/[[:space:]]*#.*$//;
        s/^[[:space:]]+//;
        s/[[:space:]]+$//;
        /^$/d
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
}

#
# Package selection menu
#
choose_install_mode() {
    echo
    echo "Select packages to install:"
    echo "  1) Official repository packages"
    echo "  2) AUR packages"
    echo "  3) Both"
    echo

    read -rp "Selection [3]: " choice
    choice=${choice:-3}

    case "$choice" in
        1|r|R) INSTALL_MODE="repo" ;;
        2|a|A) INSTALL_MODE="aur" ;;
        3|b|B) INSTALL_MODE="both" ;;
        *)
            echo "Invalid selection." | tee -a "$LOGFILE"
            exit 1
            ;;
    esac
}

choose_install_mode

#
# Update system
#
if ! $DRYRUN; then
    if ! command -v yay >/dev/null 2>&1; then
        echo "Error: yay is not installed." | tee -a "$LOGFILE"
        exit 1
    fi

    echo "Updating system..." | tee -a "$LOGFILE"
    log "Running: yay -Syu --noconfirm"
    yay -Syu --noconfirm | tee -a "$LOGFILE"
fi

#
# Install based on selection
#
case "$INSTALL_MODE" in
    repo)
        [[ -f "$REPO_PKGS" ]] || {
            echo "Error: $REPO_PKGS not found." | tee -a "$LOGFILE"
            exit 1
        }

        echo "--- Installing repo packages ---" | tee -a "$LOGFILE"
        install_group "$REPO_PKGS" "sudo pacman -S --needed --noconfirm"
        ;;

    aur)
        [[ -f "$AUR_PKGS" ]] || {
            echo "Error: $AUR_PKGS not found." | tee -a "$LOGFILE"
            exit 1
        }

        echo "--- Installing AUR packages ---" | tee -a "$LOGFILE"
        install_group "$AUR_PKGS" "yay -S --needed --noconfirm"
        ;;

    both)
        [[ -f "$REPO_PKGS" ]] || {
            echo "Error: $REPO_PKGS not found." | tee -a "$LOGFILE"
            exit 1
        }

        [[ -f "$AUR_PKGS" ]] || {
            echo "Error: $AUR_PKGS not found." | tee -a "$LOGFILE"
            exit 1
        }

        echo "--- Installing repo packages ---" | tee -a "$LOGFILE"
        install_group "$REPO_PKGS" "sudo pacman -S --needed --noconfirm"

        echo "--- Installing AUR packages ---" | tee -a "$LOGFILE"
        install_group "$AUR_PKGS" "yay -S --needed --noconfirm"
        ;;
esac

echo "=== Installation completed at $(date) ===" | tee -a "$LOGFILE"
