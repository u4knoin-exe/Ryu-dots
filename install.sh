#!/usr/bin/env bash
set -Eeuo pipefail

# Ryu-dots Arch installer
# Built for the current Ryu-dots layout:
# Hyprland + Waybar + Kitty + Rofi + awww + Waypaper + Matugen
#
# Safe behavior:
# - installs packages first
# - backs up existing configs before replacing them
# - keeps Waypaper + awww (does NOT switch to hyprpaper)
# - verifies important commands after installation
# - does not require an AUR helper; it can build AUR packages directly

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.dotfiles-backup/$STAMP"
AUR_TMP="${TMPDIR:-/tmp}/ryu-dots-aur-$STAMP"

trap 'printf "\n\033[1;31m✗ Installer stopped at line %s.\033[0m\n" "$LINENO"' ERR

log()  { printf "\033[1;36m==>\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m✓\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!\033[0m %s\n" "$*"; }
die()  { printf "\033[1;31m✗\033[0m %s\n" "$*" >&2; exit 1; }

[[ -f "$DOTFILES/install.sh" ]] || die "Run this installer from the Ryu-dots repository."

if ! command -v pacman >/dev/null 2>&1; then
    die "This installer is for Arch Linux."
fi

mkdir -p "$HOME/.config" "$HOME/.local/bin"

# ---------------------------------------------------------------------------
# Official Arch packages
# ---------------------------------------------------------------------------
OFFICIAL=(
    # Desktop / compositor
    hyprland waybar kitty rofi dunst hyprlock hypridle
    xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

    # Wallpaper / theme
    awww waypaper

    # Ryu tools
    cava fastfetch starship playerctl brightnessctl
    gammastep jq imagemagick

    # Clipboard / screenshots
    wl-clipboard cliphist grim slurp

    # Audio
    pipewire pipewire-pulse wireplumber pavucontrol alsa-utils

    # Network / tray
    networkmanager network-manager-applet

    # File manager / utilities
    thunar thunar-volman gvfs tumbler btop

    # Appearance
    qt6ct breeze-icons

    # Fonts
    ttf-iosevka-nerd
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols-mono
    noto-fonts noto-fonts-emoji
)

# Waypaper is handled separately through the AUR path below.
OFFICIAL=( "${OFFICIAL[@]/waypaper/}" )

log "Refreshing Arch package databases..."
sudo pacman -Sy

# Only pass packages that actually exist in the currently enabled repos.
# This prevents one unavailable package from aborting the whole installation.
AVAILABLE=()
SKIPPED=()

for pkg in "${OFFICIAL[@]}"; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
        AVAILABLE+=("$pkg")
    else
        SKIPPED+=("$pkg")
    fi
done

if ((${#AVAILABLE[@]})); then
    log "Installing available official packages..."
    sudo pacman -S --needed "${AVAILABLE[@]}"
fi

if ((${#SKIPPED[@]})); then
    warn "These packages are not available in your enabled Arch repositories:"
    printf '  - %s\n' "${SKIPPED[@]}"
    warn "They will not stop the installer; the final dependency check will show anything still missing."
fi

# ---------------------------------------------------------------------------
# Services needed by the desktop
# ---------------------------------------------------------------------------
log "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager.service

# PipeWire/WirePlumber are normally user services and start automatically.
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true

# ---------------------------------------------------------------------------
# AUR helper / direct AUR fallback
# ---------------------------------------------------------------------------
AUR_PKGS=(
    waypaper
    matugen-bin
    bibata-cursor-theme-bin
)

install_with_aur_helper() {
    local helper="$1"
    log "Using AUR helper: $helper"
    "$helper" -S --needed "${AUR_PKGS[@]}"
}

install_aur_direct() {
    log "No yay/paru found; building required AUR packages directly."
    sudo pacman -S --needed base-devel git

    rm -rf "$AUR_TMP"
    mkdir -p "$AUR_TMP"

    local pkg
    for pkg in "${AUR_PKGS[@]}"; do
        log "Building AUR package: $pkg"
        rm -rf "$AUR_TMP/$pkg"
        if git clone --depth=1 "https://aur.archlinux.org/${pkg}.git" "$AUR_TMP/$pkg"; then
            (
                cd "$AUR_TMP/$pkg"
                makepkg -si --noconfirm
            ) || warn "AUR package failed: $pkg"
        else
            warn "AUR package not found or could not be cloned: $pkg"
        fi
    done
}

if command -v yay >/dev/null 2>&1; then
    install_with_aur_helper yay
elif command -v paru >/dev/null 2>&1; then
    install_with_aur_helper paru
else
    install_aur_direct
fi

# ---------------------------------------------------------------------------
# Optional Zed editor
# ---------------------------------------------------------------------------
if pacman -Si zed >/dev/null 2>&1; then
    sudo pacman -S --needed zed
else
    warn "zed is not available in your enabled Arch repositories; leaving it alone."
fi

# ---------------------------------------------------------------------------
# Backup helpers
# ---------------------------------------------------------------------------
backup_path() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP"
        mv "$target" "$BACKUP/"
        ok "Backed up: $target"
    fi
}

copy_config_dir() {
    local name="$1"
    local src="$DOTFILES/$name"
    local dest="$HOME/.config/$name"

    [[ -d "$src" ]] || return 0
    backup_path "$dest"
    cp -a "$src" "$dest"
    ok "Installed ~/.config/$name"
}

copy_home_file() {
    local name="$1"
    local src="$DOTFILES/$name"
    local dest="$HOME/$name"

    [[ -f "$src" ]] || return 0
    backup_path "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    ok "Installed ~/$name"
}

copy_bin_dir() {
    local src="$1"
    [[ -d "$src" ]] || return 0

    local file name dest
    for file in "$src"/*; do
        [[ -f "$file" ]] || continue
        name="$(basename "$file")"
        dest="$HOME/.local/bin/$name"
        backup_path "$dest"
        cp -a "$file" "$dest"
        chmod +x "$dest"
        ok "Installed ~/.local/bin/$name"
    done
}

# ---------------------------------------------------------------------------
# Install Ryu-dots configs
# ---------------------------------------------------------------------------
log "Installing Ryu-dots configuration..."

CONFIG_DIRS=(
    hypr
    waybar
    kitty
    rofi
    fastfetch
    dunst
    gammastep
    waypaper
    Thunar
    zed
    btop
    gtk-3.0
    gtk-4.0
    qt6ct
    matugen
)

for dir in "${CONFIG_DIRS[@]}"; do
    copy_config_dir "$dir"
done

# Standalone scripts in scripts/
copy_bin_dir "$DOTFILES/scripts"

# Executables already stored under .local/bin/
copy_bin_dir "$DOTFILES/.local/bin"

# matugen wallpaper-theme helper
if [[ -f "$HOME/.config/matugen/wallpaper-theme" ]]; then
    backup_path "$HOME/.local/bin/wallpaper-theme"
    cp -a "$HOME/.config/matugen/wallpaper-theme" "$HOME/.local/bin/wallpaper-theme"
    chmod +x "$HOME/.local/bin/wallpaper-theme"
    ok "Installed ~/.local/bin/wallpaper-theme"
fi

# Placeholder colors
if [[ -d "$HOME/.config/matugen/defaults" ]]; then
    mkdir -p \
        "$HOME/.config/kitty" \
        "$HOME/.config/waybar" \
        "$HOME/.config/rofi" \
        "$HOME/.config/hypr" \
        "$HOME/.config/gtk-3.0" \
        "$HOME/.config/gtk-4.0"

    cp -af "$HOME/.config/matugen/defaults/kitty-colors.conf" "$HOME/.config/kitty/colors.conf" 2>/dev/null || true
    cp -af "$HOME/.config/matugen/defaults/waybar-colors.css" "$HOME/.config/waybar/colors.css" 2>/dev/null || true
    cp -af "$HOME/.config/matugen/defaults/rofi-colors.rasi" "$HOME/.config/rofi/colors.rasi" 2>/dev/null || true
    cp -af "$HOME/.config/matugen/defaults/hyprlock-colors.conf" "$HOME/.config/hypr/hyprlock-colors.conf" 2>/dev/null || true
    cp -af "$HOME/.config/matugen/defaults/gtk-colors.css" "$HOME/.config/gtk-3.0/gtk.css" 2>/dev/null || true
    cp -af "$HOME/.config/matugen/defaults/gtk-colors.css" "$HOME/.config/gtk-4.0/gtk.css" 2>/dev/null || true
fi

copy_home_file "starship.toml"
copy_home_file ".bashrc"

# ---------------------------------------------------------------------------
# Font cache
# ---------------------------------------------------------------------------
log "Refreshing font cache..."
fc-cache -f >/dev/null 2>&1 || true

# ---------------------------------------------------------------------------
# Make sure ~/.local/bin is on PATH for future shells
# ---------------------------------------------------------------------------
if ! grep -Fqx 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# Ryu-dots local scripts\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
fi

# Fish users: don't modify fish config automatically; ~/.local/bin is commonly
# already on PATH on Arch. The verification below catches missing commands.

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------
log "Checking Ryu-dots dependencies..."
warn "The check below is the final source of truth; missing optional components are reported instead of aborting the installer."

COMMANDS=(
    hyprland
    waybar
    kitty
    rofi
    cava
    fastfetch
    starship
    playerctl
    brightnessctl
    wpctl
    nmcli
    nm-applet
    dunst
    wl-copy
    cliphist
    grim
    slurp
    hyprlock
    hypridle
    gammastep
    jq
    magick
    awww
    awww-daemon
    waypaper
    matugen
    thunar
    btop
)

missing=0
for cmd in "${COMMANDS[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        ok "$cmd"
    else
        warn "MISSING: $cmd"
        missing=$((missing + 1))
    fi
done

echo
if (( missing == 0 )); then
    ok "All Ryu-dots runtime commands are installed."
else
    warn "$missing runtime command(s) are still missing."
fi

echo
log "Wallpaper stack: awww + Waypaper + Matugen"
log "Audio stack: PipeWire + WirePlumber"
log "Backup location: $BACKUP"
echo
printf '\033[1;32m╭─ Ryu-dots installation complete\033[0m\n'
printf '\033[1;32m╰─ Restart Hyprland/session before testing the full rice.\033[0m\n'
