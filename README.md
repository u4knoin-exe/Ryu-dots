# Ryu-dots

Minimal monochrome glass Hyprland rice. Hyprland 0.55+ **Lua** config.

## Install

```sh
git clone git@github.com:u4knoin-exe/Ryu-dots.git ~/Ryu-dots
cd ~/Ryu-dots && ./install.sh
```

Arch / CachyOS: installs packages (pacman + AUR helper), backs up old configs to `~/ryu-backup-*.tar.gz`, then deploys.
Other distros / NixOS: packages are skipped (list is printed), configs still deploy.

## How it works

| Folder | Goes to | Notes |
|---|---|---|
| `config/` | `~/.config/` | files symlinked, `*.tpl` rendered |
| `home/` | `~/` | dotfiles |
| `bin/` | `~/.local/bin/` | scripts |
| `theme/palette.env` | | **single source of colors and font** |

Change a color in `theme/palette.env`, run `./theme/apply.sh`. Hyprland, Waybar, Kitty, Rofi, Dunst, Hyprlock and Starship all follow.

## Hyprland modules (`config/hypr/`)

`env` `monitors` `look` `input` `binds` `rules` `autostart`, plus generated `colors.lua`.

## Keybinds

| Key | Action |
|---|---|
| `SUPER + Return` | Kitty |
| `SUPER + Space` | Rofi launcher |
| `SUPER + SHIFT + W` | Wi-Fi menu |
| `SUPER + V` | Clipboard history |
| `SUPER + E` | Thunar |
| `SUPER + L` | Lock |
| `SUPER + Q` | Close window |
| `SUPER + SHIFT + F` | Toggle float |
| `SUPER + 1..9` | Workspace (add `SHIFT` to move window) |
| `SUPER + W` | Wallpaper picker (`+ CTRL` random) |
| `SUPER + N` | Night light toggle |
| `SUPER + S` | Scratchpad |
| `Print` / `SHIFT + Print` | Screenshot to clipboard / file |

## Troubleshooting

- Lua API names: `/usr/share/hypr/stubs/hl.meta.lua` is the ground truth for your Hyprland version.
- Kitty opaque: keep `background_opacity` after any `include`, and make sure no window rule forces `opaque`.
