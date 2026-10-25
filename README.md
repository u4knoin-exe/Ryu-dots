# Ryu-dots

Minimal monochrome glass Hyprland rice. Hyprland 0.55+ **Lua** config. One command brings the whole setup back on a new distro.

## Install (any distro)

```sh
git clone https://github.com/u4knoin-exe/Ryu-dots ~/Ryu-dots
cd ~/Ryu-dots
./install.sh --dry-run          # preview
./install.sh                    # interactive
./install.sh --yes --all        # distro-hop mode: everything, no questions
```

| Distro family | Core packages | Notes |
|---|---|---|
| Arch / CachyOS / EndeavourOS | pacman + AUR (paru bootstrapped if missing) | fully supported |
| Fedora | dnf + COPR `solopasha/hyprland` | best effort, failures are listed |
| Debian / Ubuntu | apt | Hyprland 0.55+ usually must be installed separately |
| NixOS / other | skipped | configs still deploy |

### Extras (optional, asked unless you pass a flag)

| Flag | Installs |
|---|---|
| `--brave` | Brave Origin (AUR `brave-origin-bin`, Brave's apt/dnf repos, or Brave's install script) |
| `--spotify` | Spotify (`spotify-launcher`, or Flatpak off Arch) then Spicetify + Marketplace |
| `--flatpak` | Flatpak + Flathub |
| `--all` / `--no-extras` | all / none |

Spicetify needs Spotify opened and logged in **once**. The installer offers to do it; otherwise run `ryu-spicetify` later. Re-run it after a Spotify update.

Other flags: `--yes`, `--dry-run`, `--no-pkgs`, `--no-backup`, `--uninstall`.

## Keep your stuff in the repo

- `wallpapers/` : images copied to `~/Pictures/Wallpapers` on install
- `assets/face.png` : becomes `~/.face` (lockscreen avatar)

## How it works

| Folder | Goes to | Notes |
|---|---|---|
| `config/` | `~/.config/` | files symlinked, `*.tpl` rendered |
| `home/` | `~/` | dotfiles |
| `bin/` | `~/.local/bin/` | scripts (`ryu-wall`, `wifi-menu`, `nightlight`, `ryu-spicetify`) |
| `theme/palette.env` | | single source of colors and font |

Change a color in `theme/palette.env`, run `./theme/apply.sh`. Hyprland, Waybar, Kitty, Rofi, Dunst, Hyprlock and Starship follow.

Old configs are backed up to `~/ryu-backup-*.tar.gz` and moved aside to `~/.config/<name>.old-*`, so stale files never leak in.

## Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Kitty |
| `Super + Space` | Launcher |
| `Super + W` / `+ Ctrl` | Wallpaper picker / random |
| `Super + Shift + W` | Wi-Fi menu |
| `Super + N` | Night light (auto 19:00 to 06:30) |
| `Super + V` | Clipboard history |
| `Super + E` | Thunar |
| `Super + L` | Lock |
| `Super + Q` | Close window |
| `Super + Shift + F` | Toggle float |
| `Super + 1..9` | Workspace (add `Shift` to move window) |
| `Super + S` | Scratchpad |
| `Print` / `Shift + Print` | Screenshot to clipboard / file |

## Troubleshooting

- Lua API names: `/usr/share/hypr/stubs/hl.meta.lua` is the ground truth for your Hyprland version.
- Lockscreen preview: `hyprlock` (run it inside the session).
- Blur missing on bar/launcher: check layer names with `hyprctl layers`.
