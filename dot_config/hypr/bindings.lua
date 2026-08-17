-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
--
--
--
-- # Application bindings
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Launch Terminal", hl.dsp.exec_cmd("uwsm-app -- alacritty"))
o.bind("SUPER + N", "Cycle Forward", hl.dsp.layout("cyclenext"))
o.bind("SUPER + B", "Cyble Backward", hl.dsp.layout("cycleprev"))
o.bind("SUPER + M", "Swap with Mater", hl.dsp.layout("swapwithmaster"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.unbind("SUPER + L")
o.bind(
	"SUPER + L",
	"Launch Terminal",
	hl.dsp.exec_cmd("uwsm-app -- $HOME/.bin/omarchy-hyprland-workspace-layout-toggle")
)
