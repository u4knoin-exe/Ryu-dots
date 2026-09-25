#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Ryu-dots installer — Arch Linux
# ============================================================

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.dotfiles-backup/$STAMP"
AUR_TMP="${TMPDIR:-/tmp}/ryu-dots-aur-$STAMP"

trap 'printf "\n\033[1;31m✗ Installer stopped at line %s.\033[0m\n" "$LINENO"' ERR

log()  { printf "\033[1;36m==>\033[0m %s\n" "$*"; }
ok()   { printf "\033[1;32m✓\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!\033[0m %s\n" "$*"; }
die()  { printf "\033[1;31m✗\033[0m %s\n" "$*" >&2; exit 1; }

[[ -f "$DOTFILES/install.sh" ]] || die "Run this from the Ryu-dots repository."
command -v pacman >/dev/null 2>&1 || die "This installer requires Arch Linux."

mkdir -p "$HOME/.config" "$HOME/.local/bin"

echo
echo "╭────────────────────────────────────────────╮"
echo "│              RYU-DOTS INSTALLER             │"
echo "╰────────────────────────────────────────────╯"
echo
echo "Source : $DOTFILES"
echo "Backup : $BACKUP"
echo

# ============================================================
# Packages
# ============================================================

OFFICIAL=(
    hyprland
    waybar
    kitty
    rofi
    dunst
    hyprlock
    hypridle

    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    awww

    cava
    fastfetch
    starship
    playerctl
    brightnessctl
    gammastep
    jq
    imagemagick

    wl-clipboard
    cliphist
    grim
    slurp

    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    pavucontrol
    alsa-utils

    networkmanager

    thunar
    thunar-volman
    gvfs
    tumbler
    btop

    qt6ct
    breeze-icons

    ttf-iosevka-nerd
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols-mono
    noto-fonts
    noto-fonts-emoji
)

log "Updating Arch and installing Ryu-dots packages..."
echo

# IMPORTANT:
# Never use pacman -Sy by itself.
# Full upgrade + package installation in one transaction.
sudo pacman -Syu --needed "${OFFICIAL[@]}"

# ============================================================
# Services
# ============================================================

log "Enabling required services..."

sudo systemctl enable --now NetworkManager.service

systemctl --user enable --now \
    pipewire.service \
    pipewire-pulse.service \
    wireplumber.service

ok "Services enabled"

# ============================================================
# AUR packages
# ============================================================

AUR_PKGS=(
    waypaper
    matugen-bin
    bibata-cursor-theme-bin
)

install_aur_helper() {
    local helper="$1"

    log "Installing AUR packages with $helper..."
    "$helper" -S --needed "${AUR_PKGS[@]}"
}

install_aur_direct() {
    log "No yay/paru found — building AUR packages directly."

    sudo pacman -Syu --needed base-devel git

    rm -rf "$AUR_TMP"
    mkdir -p "$AUR_TMP"

    local pkg

    for pkg in "${AUR_PKGS[@]}"; do
        log "Building $pkg..."

        rm -rf "$AUR_TMP/$pkg"

        git clone --depth=1 \
            "https://aur.archlinux.org/${pkg}.git" \
            "$AUR_TMP/$pkg"

        (
            cd "$AUR_TMP/$pkg"
            makepkg -si --noconfirm
        )

        ok "$pkg installed"
    done
}

if command -v yay >/dev/null 2>&1; then
    install_aur_helper yay
elif command -v paru >/dev/null 2>&1; then
    install_aur_helper paru
else
    install_aur_direct
fi

# ============================================================
# Backup helpers
# ============================================================

backup_path() {
    local target="$1"

    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP"
        mv "$target" "$BACKUP/"
        ok "Backed up $target"
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

    local file
    local name
    local dest

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

# ============================================================
# Install configs
# ============================================================

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
    btop
    gtk-3.0
    gtk-4.0
    qt6ct
    matugen
)

for dir in "${CONFIG_DIRS[@]}"; do
    copy_config_dir "$dir"
done

copy_bin_dir "$DOTFILES/scripts"
copy_bin_dir "$DOTFILES/.local/bin"

copy_home_file "starship.toml"
copy_home_file ".bashrc"

# ============================================================
# Make Ryu's NEW Waybar the actual default
# ============================================================

if [[ -f "$HOME/.config/waybar/profiles/new/config" ]]; then
    cp -af \
        "$HOME/.config/waybar/profiles/new/config" \
        "$HOME/.config/waybar/config"

    ok "Ryu NEW Waybar installed as default"
fi

if [[ -f "$HOME/.config/waybar/profiles/new/style.css" ]]; then
    cp -af \
        "$HOME/.config/waybar/profiles/new/style.css" \
        "$HOME/.config/waybar/style.css"

    ok "Ryu NEW Waybar style installed as default"
fi

# ============================================================
# Matugen helper
# ============================================================

if [[ -f "$HOME/.config/matugen/wallpaper-theme" ]]; then
    backup_path "$HOME/.local/bin/wallpaper-theme"

    cp -a \
        "$HOME/.config/matugen/wallpaper-theme" \
        "$HOME/.local/bin/wallpaper-theme"

    chmod +x "$HOME/.local/bin/wallpaper-theme"

    ok "Installed wallpaper-theme"
fi

# ============================================================
# DARK MODE — SYSTEM WIDE
# ============================================================

log "Applying permanent dark appearance..."

if command -v gsettings >/dev/null 2>&1; then

    # GTK / GNOME color preference
    gsettings set \
        org.gnome.desktop.interface \
        color-scheme \
        'prefer-dark' || true

    # GTK dark theme
    if [[ -d /usr/share/themes/Adwaita-dark ]]; then
        gsettings set \
            org.gnome.desktop.interface \
            gtk-theme \
            'Adwaita-dark' || true
    fi

    ok "GTK dark mode enabled"
fi

# GTK 3
mkdir -p "$HOME/.config/gtk-3.0"

cat > "$HOME/.config/gtk-3.0/settings.ini" <<'GTK3'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-application-prefer-dark-theme=true
gtk-icon-theme-name=Adwaita
GTK3

# GTK 4
mkdir -p "$HOME/.config/gtk-4.0"

cat > "$HOME/.config/gtk-4.0/settings.ini" <<'GTK4'
[Settings]
gtk-application-prefer-dark-theme=true
GTK4

ok "GTK 3/4 dark preference configured"

# ============================================================
# Persistent environment
# ============================================================

mkdir -p "$HOME/.config/environment.d"

cat > "$HOME/.config/environment.d/10-ryu-dark.conf" <<'ENV'
# Ryu-dots appearance
GTK_THEME=Adwaita:dark
QT_QPA_PLATFORMTHEME=qt6ct
ENV

ok "Persistent dark environment configured"

# ============================================================
# Cursor
# ============================================================

if command -v gsettings >/dev/null 2>&1; then
    if [[ -d "$HOME/.icons/Bibata-Modern-Classic" ]] ||
       [[ -d "/usr/share/icons/Bibata-Modern-Classic" ]]; then

        gsettings set \
            org.gnome.desktop.interface \
            cursor-theme \
            'Bibata-Modern-Classic' || true

        ok "Bibata cursor configured"
    fi
fi

# ============================================================
# Font cache
# ============================================================

log "Refreshing font cache..."
fc-cache -f >/dev/null 2>&1 || true

# ============================================================
# PATH
# ============================================================

if ! grep -Fqx \
    'export PATH="$HOME/.local/bin:$PATH"' \
    "$HOME/.bashrc" 2>/dev/null; then

    cat >> "$HOME/.bashrc" <<'PATHRC'

# Ryu-dots local scripts
export PATH="$HOME/.local/bin:$PATH"
PATHRC
fi

# ============================================================
# Verification
# ============================================================

log "Verifying installation..."

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
    warn "$missing runtime command(s) are missing."
fi

echo
echo "╭────────────────────────────────────────────╮"
echo "│          RYU-DOTS INSTALL COMPLETE         │"
echo "╰────────────────────────────────────────────╯"
echo
echo "Backup: $BACKUP"
echo
echo "Dark mode: enabled"
echo "Waybar: Ryu NEW profile"
echo "Wallpaper: awww + Waypaper + Matugen"
echo "Audio: PipeWire + WirePlumber"
echo
echo "Log out/in or restart Hyprland to apply environment changes."
