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

-- Terminal Mappings
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Launch Terminal", hl.dsp.exec_cmd("uwsm-app -- alacritty"))

-- Customkeybinding
local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		end
	end
end

hl.bind(
	"SUPER + N",
	layout_bind({
		scrolling = hl.dsp.layout("focus r"), -- Scrolling: swap column with left one
		dwindle = hl.dsp.layout("swapsplit"), -- Dwindle: swap window split
		monocle = hl.dsp.layout("cyclenext"), -- Monocle and master: cycle prev window
		master = hl.dsp.layout("cyclenext"),
	})
)

hl.bind(
	"SUPER + B",
	layout_bind({
		scrolling = hl.dsp.layout("focus l"), -- Scrolling: swap column with right one
		dwindle = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
		monocle = hl.dsp.layout("cycleprev"), -- Monocle and master: cycle next window
		master = hl.dsp.layout("cycleprev"),
	})
)

-- o.bind("SUPER + N", "Cycle Forward", hl.dsp.layout("cyclenext"))
-- o.bind("SUPER + B", "Cyble Backward", hl.dsp.layout("cycleprev"))

o.bind("SUPER + M", "Swap with Mater", hl.dsp.layout("swapwithmaster"))
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Custom Layhout Binding
hl.unbind("SUPER + L")
o.bind(
	"SUPER + L",
	"Launch Terminal",
	hl.dsp.exec_cmd("uwsm-app -- $HOME/.bin/omarchy-hyprland-workspace-layout-toggle")
)

-- Launch Terminal
hl.unbind("SUPER + SHIFT + Return")
o.bind("SUPER + SHIFT + RETURN", "Launch Thunar", hl.dsp.exec_cmd("uwsm-app -- thunar"))
