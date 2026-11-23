#!/usr/bin/bash

omarchy plugin add https://github.com/tornikegomareli/omarchy-spaces.git --enable
omarchy plugin disable omarchy.workspaces   # optional: replace the built-in switcher

omarchy plugin add https://github.com/ukkit/omarchy-universal-font-sizer --enable
omarchy plugin add https://github.com/skuthus/omarchy-shell-font.git --enable

omarchy-shell shell toggle skuthus.shell-font

omarchy plugin add https://github.com/fross100/omaplug --enable

omarchy plugin add https://github.com/typecraft-dev/oma-cast --enable
~/.config/omarchy/plugins/typecraft.omacast/bin/omacast install   # link the omacast CLI into ~/.local/bin

#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Configuration
###############################################################################

PLUGINS=(
    "https://github.com/tornikegomareli/omarchy-spaces.git|tornikegomareli/omarchy-spaces"
    "https://github.com/ukkit/omarchy-universal-font-sizer|ukkit/omarchy-universal-font-sizer"
    "https://github.com/skuthus/omarchy-shell-font.git|skuthus/omarchy-shell-font"
    "https://github.com/fross100/omaplug|fross100/omaplug"
    "https://github.com/typecraft-dev/oma-cast|typecraft-dev/oma-cast"
)

###############################################################################
# Helper Functions
###############################################################################

log() {
    printf "\n==> %s\n" "$1"
}

plugin_installed() {
    local search_string="$1"

    omarchy plugin list 2>/dev/null | grep -qi "$search_string"
}

install_plugin() {
    local repo="$1"

    log "Installing $repo..."
    omarchy plugin add "$repo" --enable
}

###############################################################################
# Main
###############################################################################

log "Checking installed Omarchy plugins..."

for plugin in "${PLUGINS[@]}"; do
    IFS="|" read -r repo detect <<< "$plugin"

    if plugin_installed "$detect"; then
        log "$detect is already installed."
    else
        log "$detect not found. Installing..."
        install_plugin "$repo"

        case "$detect" in

            "tornikegomareli/omarchy-spaces")
                log "Disabling built-in workspace switcher..."
                omarchy plugin disable omarchy.workspaces
                ;;

            "skuthus/omarchy-shell-font")
                log "Enabling shell font integration..."
                omarchy-shell shell toggle skuthus.shell-font
                ;;

            "typecraft-dev/oma-cast")
                log "Installing OMACast CLI..."
                ~/.config/omarchy/plugins/typecraft.omacast/bin/omacast install
                ;;

        esac

        log "$detect installation complete."
    fi
done

log "All plugin checks completed."
