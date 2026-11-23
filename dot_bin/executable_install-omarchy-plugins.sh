#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false
READ_ONLY=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

Options:
  --install    Install missing plugins
  --dry-run    Show what would be installed
  --read-only  Report plugin status only
  --help, -h   Show this help

Examples:
  $(basename "$0") --read-only
  $(basename "$0") --dry-run
  $(basename "$0") --install
EOF
}

MODE="help"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --install)
            MODE="install"
            ;;
        --dry-run)
            MODE="dry-run"
            ;;
        --read-only)
            MODE="read-only"
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo
            usage
            exit 1
            ;;
    esac
    shift
done

case "$MODE" in
    help)
        usage
        exit 0
        ;;
    install)
        DRY_RUN=false
        READ_ONLY=false
        ;;
    dry-run)
        DRY_RUN=true
        READ_ONLY=false
        ;;
    read-only)
        DRY_RUN=false
        READ_ONLY=true
        ;;
esac

run() {
    if $DRY_RUN; then
        echo "[DRY-RUN] $*"
    else
        "$@"
    fi
}

# plugin-id|repo-url|optional-post-install-command
PLUGINS=(
'tornikegomareli.spaces|https://github.com/tornikegomareli/omarchy-spaces.git|omarchy plugin disable omarchy.workspaces'
'ukkit.universal-font-sizer|https://github.com/ukkit/omarchy-universal-font-sizer|'
'skuthus.shell-font|https://github.com/skuthus/omarchy-shell-font.git|omarchy shell toggle skuthus.shell-font'
'fross100.omaplug|https://github.com/fross100/omaplug|'
'typecraft.omacast|https://github.com/typecraft-dev/oma-cast|$HOME/.config/omarchy/plugins/typecraft.omacast/bin/omacast install'
)

for plugin in "${PLUGINS[@]}"; do
    IFS='|' read -r id repo post_cmd <<< "$plugin"

    plugin_dir="$HOME/.config/omarchy/plugins/$id"

    if [[ -d "$plugin_dir" ]]; then
        echo "✓ $id already installed"
        continue
    fi

    if $READ_ONLY; then
        echo "✗ $id not installed"
        continue
    fi

    echo "Installing $id..."
    run omarchy plugin add "$repo" --enable

    if [[ -n "$post_cmd" ]]; then
        echo "Running post-install step for $id..."

        if $DRY_RUN; then
            echo "[DRY-RUN] $post_cmd"
        else
            eval "$post_cmd"
        fi
    fi
done

echo "Done."
