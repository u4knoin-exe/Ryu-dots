<div align="center">

```
   ┌─┐┬ ┬┬ ┬   ┌┬┐┌─┐┌┬┐┌─┐
   ├┬┘└┬┘│ │─── │││ │ │ └─┐
   ┴└─ ┴ └─┘  ─┴┘└─┘ ┴ └─┘
```

**minimal · monochrome · glass**

A Hyprland rice written in Lua, themed from one palette file, restorable on any distro with one command.

![Hyprland](https://img.shields.io/badge/Hyprland-0.55%2B-e8e8e8?style=flat-square&labelColor=0a0a0a)
![Config](https://img.shields.io/badge/config-Lua-e8e8e8?style=flat-square&labelColor=0a0a0a)
![Theme](https://img.shields.io/badge/theme-monochrome-e8e8e8?style=flat-square&labelColor=0a0a0a)
![Stars](https://img.shields.io/github/stars/u4knoin-exe/Ryu-dots?style=flat-square&labelColor=0a0a0a&color=e8e8e8)

</div>

---

## Preview

<table>
  <tr>
    <td><img src="assets/preview/desktop.png" alt="desktop"></td>
    <td><img src="assets/preview/launcher.png" alt="launcher"></td>
  </tr>
  <tr>
    <td align="center"><sub>desktop</sub></td>
    <td align="center"><sub>launcher</sub></td>
  </tr>
  <tr>
    <td><img src="assets/preview/wallpaper.png" alt="wallpaper picker"></td>
    <td><img src="assets/preview/lock.png" alt="lockscreen"></td>
  </tr>
  <tr>
    <td align="center"><sub>wallpaper picker</sub></td>
    <td align="center"><sub>lockscreen</sub></td>
  </tr>
</table>

## What's inside

| | |
|---|---|
| **Compositor** | Hyprland (Lua config, split into small modules) |
| **Bar** | Waybar, flat and full width |
| **Launcher** | Rofi, square and blurred |
| **Terminal** | Kitty with Iosevka Nerd Font, glass opacity |
| **Lock / idle** | Hyprlock (clock and a line) + Hypridle |
| **Notifications** | Dunst |
| **Prompt** | Starship |
| **Night light** | hyprsunset, warm from 19:00 to 06:30 |
| **Wallpapers** | `ryu-wall`: Rofi thumbnail grid, fade transitions, restores on login |
| **Themes** | `ryu-theme`: mono, amoled, light (add your own in `theme/palettes/`), switch live |
| **Apps** | GTK3/4, Qt6, btop, fastfetch, zathura, cava, lazygit and Spotify (Spicetify theme `Ryu`) follow the palette too |
| **OSD** | square volume / brightness / mic popup (via Dunst) |
| **Capture** | annotated screenshots (satty), screen recording, color picker |
| **Control center** | `ryu-center`: wifi, bluetooth, night light, DND, volume, animations, layout, theme (`Super + X`, or right-click the clock) |
| **Cheat sheet** | `ryu-keys`: searchable list of every keybind, built from the comments in `binds.lua` (`Super + /`) |
| **Layouts** | dwindle or Niri-style scrolling (`Super + Shift + L`) |
| **Login screen** | `ryu-sddm`: matching SDDM theme (preview first, one command to undo) |
| **Animations** | `ryu-anim`: snappy, smooth or off, plus an optional slow spinning border |
| **Power menu** | `ryu-power`: lock, logout, suspend, reboot, shutdown |
| **Wi-Fi** | `wifi-menu`: Rofi picker on top of NetworkManager |

One palette drives everything. Change a color in `theme/palette.env`, run `./theme/apply.sh`, and Hyprland, Waybar, Kitty, Rofi, Dunst, Hyprlock and Starship all follow.

## Install

```sh
git clone https://github.com/u4knoin-exe/Ryu-dots ~/Ryu-dots
cd ~/Ryu-dots
./install.sh --dry-run          # preview, changes nothing
./install.sh                    # interactive
./install.sh --yes --all        # distro-hop mode: everything, no questions
```

The installer backs up your old configs (`~/ryu-backup-*.tar.gz`), moves old folders aside, installs only what is missing, and deploys. Re-running is safe.

| Distro | Packages | Notes |
|---|---|---|
| Arch / CachyOS / EndeavourOS | pacman + AUR (paru built if missing) | fully supported |
| Fedora | dnf + COPR `solopasha/hyprland` | best effort, failures are listed |
| Debian / Ubuntu | apt | Hyprland 0.55+ usually needs a separate install |
| NixOS / other | skipped | configs still deploy |

<details>
<summary><b>Extras and flags</b></summary>

| Flag | Does |
|---|---|
| `--brave` | Brave Origin (AUR `brave-origin-bin`, or Brave's apt/dnf repos, or its install script) |
| `--spotify` | Spotify, then Spicetify + Marketplace (log into Spotify once, then `ryu-spicetify`) |
| `--flatpak` | Flatpak + Flathub |
| `--sddm` | Ryu login screen (preview first; never part of `--all`) |
| `--all` / `--no-extras` | all extras / none |
| `--yes` | no questions |
| `--dry-run` | print what would happen |
| `--no-pkgs` / `--no-backup` | skip packages / backup |
| `--uninstall` | remove everything it linked and offer to restore your backup |

</details>

## Keybinds

<details open>
<summary><b>Everyday</b></summary>

| Key | Action |
|---|---|
| `Super + Return` | Terminal |
| `Super + Space` | Launcher |
| `Super + W` | Wallpaper picker (`+ Ctrl` for random) |
| `Super + Shift + W` | Wi-Fi menu |
| `Super + N` | Night light toggle |
| `Super + V` | Clipboard history |
| `Super + E` | File manager |
| `Super + L` | Lock |
| `Super + Shift + Q` | Power menu |
| `Super + Shift + A` | Animation preset (snappy, smooth, off) |
| `Print` / `Shift + Print` | Screenshot to clipboard / file |
| `Ctrl + Print` | Screenshot, then annotate |
| `Super + R` | Record a region (press again to stop) |
| `Super + Shift + C` | Color picker (copies hex) |
| `Super + Shift + T` | Theme switcher |
| `Super + /` | Keybind cheat sheet |
| `Super + X` | Control center |
| `Super + Shift + L` | Layout: dwindle / scrolling |
| `Super + Shift + P` | Performance mode (no blur / animations) |

</details>

<details>
<summary><b>Windows and workspaces</b></summary>

| Key | Action |
|---|---|
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Toggle float |
| `Super + J` | Toggle split |
| `Super + Arrows` | Move focus |
| `Super + 1..9` | Go to workspace (`+ Shift` moves the window) |
| `Super + S` | Scratchpad (`+ Shift` sends the window) |
| `Super + Mouse L/R` | Drag / resize |
| `Super + Shift + M` | Exit Hyprland |

</details>

## Themes

```sh
ryu-theme              # menu (or Super + Shift + T)
ryu-theme light        # direct
```

`ryu-theme wall` keeps the mono base and tints the accent from your current wallpaper (it re-tints automatically when you pick a new one).

Palettes live in `theme/palettes/*.env`. Copy one, change the colors, and it shows up in the menu. Switching re-renders Hyprland, Waybar, Kitty (live), Rofi, Dunst, Hyprlock, Starship, GTK, Qt, btop and flips the system dark/light setting.

## Scrolling layout

`Super + Shift + L` switches between dwindle and a Niri-style scrolling layout. In scrolling mode: `Super + .` and `Super + ,` scroll columns, `Super + = / -` resize the column, `Super + Ctrl + arrows` swap, split out or merge columns.

## Login screen

```sh
ryu-sddm preview      # test window, changes nothing
ryu-sddm install      # needs sudo, takes effect at next login screen
ryu-sddm remove       # undo
```

## Make it yours

```sh
$EDITOR theme/palette.env       # colors and fonts, one place
./theme/apply.sh                # re-render everything
```

Drop wallpapers in `wallpapers/` and a square `assets/face.png` for the lockscreen avatar. Both travel with the repo to your next machine.

## Layout

```
Ryu-dots
├── install.sh          installer (multi-distro)
├── theme/
│   ├── palette.env     active colors + fonts
│   ├── palettes/       mono, amoled, light
│   ├── apply.sh        link static files, render *.tpl
│   └── check.sh        lint templates and palettes
├── config/             -> ~/.config   (hypr, waybar, kitty, rofi, dunst, gtk, qt6ct, btop, fastfetch, zathura, cava, lazygit, spicetify, starship)
├── home/               -> ~
├── bin/                -> ~/.local/bin (ryu-session, ryu-wall, ryu-theme, ryu-perf, ryu-doctor, ryu-bench, ryu-update, ryu-center, ryu-keys, ryu-layout, ryu-sddm, ryu-power, ryu-anim, ryu-osd, ryu-rec, wifi-menu, nightlight, ryu-spicetify, ryu-shot)
├── wallpapers/         your wallpapers
└── assets/             avatar + README previews
```

Files ending in `.tpl` are rendered from the palette; everything else is symlinked, so editing the repo changes your live config.

## Updating the previews

```sh
ryu-shot desktop          # arrange your windows first (3s delay)
ryu-shot launcher 5       # open the launcher during the 5s
ryu-shot wallpaper 5      # open the picker during the 5s
ryu-shot lock             # locks, captures, then unlock as normal
```

## Speed and memory

Hyprland itself is already light; the wins here are in everything around it.

| What | Change |
|---|---|
| Login | `ryu-session` starts wallpaper, bar and notifications first and defers polkit, idle, night light and clipboard by 2 s |
| Terminal | `Super + Return` uses one shared kitty process: new windows open instantly and share memory; lower input latency settings |
| Shell | starship's init is cached; fastfetch runs once per login, not in every terminal (`RYU_FETCH=always` to restore) |
| Wallpaper picker | thumbnails cached and rebuilt in parallel only when an image changes; no process spawned per image |
| Launcher | Rofi desktop-entry cache on |
| Bar | Waybar wakes less often (network 10 s, battery 60 s) |
| Installer | two bulk package queries instead of one per package |
| Battery | `Super + Shift + P` toggles performance mode: no blur, shadows or animations |

Measure it yourself:

```sh
ryu-bench --save      # RAM used by the rice, shell and terminal startup; compares with your last saved run
ryu-doctor            # health check: packages, fonts, services, links, config errors
ryu-update            # git pull, re-render, health check
```

## Troubleshooting

- **Lua API names:** `/usr/share/hypr/stubs/hl.meta.lua` is the source of truth for your Hyprland version.
- **Config errors:** `hyprctl configerrors`
- **Blur missing on bar or launcher:** check layer names with `hyprctl layers`.
- **Two bars or old styling:** the installer moves old folders to `~/.config/<name>.old-*`; check that nothing else autostarts a bar.
- **Lockscreen preview:** run `hyprlock` inside the session.
- **Admin prompts do nothing:** check `systemctl --user status hyprpolkitagent`.
- **GTK app still light:** restart the app; libadwaita reads settings at launch.
- **Lint locally:** `shellcheck -x -S warning install.sh theme/*.sh bin/*` and `./theme/check.sh` (CI runs both).

---

<div align="center"><sub>made by <a href="https://github.com/u4knoin-exe">u4knoin</a></sub></div>
