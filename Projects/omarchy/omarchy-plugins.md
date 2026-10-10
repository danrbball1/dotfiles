# Omarchy Plugins

## Installed Plugins
1. omaplug
2. omarchy-notification-center
3. shell-font
4. spaces

## [omaplug](https://github.com/fross100/omaplug)
Standalone Omarchy plugin manager: enable/disable, update, install, and remove plugins

*Install*:
`omarchy plugin add https://github.com/fross100/omaplug --enable`


## [omarchy-notification-center](https://github.com/jankeesvw/omarchy-notification-center)
An Omarchy bar widget that keeps the notifications you were sent. A bell on the right of the bar, a dot on it when something has come in, and a panel of everything you were told, still there tomorrow.

*Install*:
`omarchy plugin add https://github.com/jankeesvw/omarchy-notification-center.git --enable`

## shell font
Pick the font family and weight used by the Omarchy Quickshell bar and shell UI.

*Install*:
`omarchy plugin add https://github.com/skuthus/omarchy-shell-font.git --enable`

Click **Aa** on the bar, or:

`omarchy-shell shell toggle skuthus.shell-font`

*Remove*:
```
omarchy plugin remove skuthus.shell-font --yes
rm -f ~/.config/fontconfig/conf.d/50-omarchy-shell-font.conf
rm -rf ~/.local/share/fonts/omarchy-shell-font
rm -f ~/.config/omarchy/shell-font.json
omarchy restart shell
```


## [spaces](https://github.com/tornikegomareli/omarchy-spaces)
See what runs on every workspace. An Omarchy bar widget that shows the apps open on each workspace.

*Install*:
```
omarchy plugin add https://github.com/tornikegomareli/omarchy-spaces.git --enable
omarchy plugin disable omarchy.workspaces   # optional: replace the built-in switcher
```
```

To open settings with a key, add this to `~/.config/hypr/bindings.lua`:
o.bind("SUPER + CTRL + ALT + S", "Spaces settings", "omarchy-shell tornikegomareli.spaces toggle")
