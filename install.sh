#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "╭─ Ryu-dots installer"
echo "├─ Source: $DOTFILES"
echo "╰─ Backup: $BACKUP"
echo

detect_distro() {
    if command -v pacman >/dev/null 2>&1; then
        DISTRO="arch"
    elif command -v dnf >/dev/null 2>&1; then
        DISTRO="fedora"
    elif command -v apt >/dev/null 2>&1; then
        DISTRO="debian"
    elif command -v nixos-rebuild >/dev/null 2>&1; then
        DISTRO="nixos"
    else
        DISTRO="unknown"
    fi
}

install_deps() {
    case "$DISTRO" in
        arch)
            sudo pacman -S --needed \
                hyprland waybar kitty rofi cava fastfetch starship \
                playerctl brightnessctl wireplumber networkmanager \
                dunst wl-clipboard cliphist grim slurp \
                hyprlock hypridle gammastep \
                qt6ct breeze-icons jq imagemagick

            if command -v yay >/dev/null 2>&1; then
                yay -S --needed bibata-cursor-theme-bin matugen-bin
            elif command -v paru >/dev/null 2>&1; then
                paru -S --needed bibata-cursor-theme-bin matugen-bin
            else
                echo "  note: bibata-cursor-theme and matugen are AUR-only — install manually, e.g.:"
                echo "        yay -S bibata-cursor-theme-bin matugen-bin"
            fi
            ;;
        fedora)
            sudo dnf install -y \
                hyprland waybar kitty rofi cava fastfetch starship \
                playerctl brightnessctl wireplumber NetworkManager \
                dunst wl-clipboard cliphist grim slurp \
                hyprlock hypridle gammastep \
                qt6ct breeze-icon-theme jq ImageMagick
            echo "  note: matugen isn't packaged for Fedora — build from source:"
            echo "        cargo install matugen"
            ;;
        debian)
            sudo apt update
            sudo apt install -y \
                hyprland waybar kitty rofi cava fastfetch \
                playerctl brightnessctl wireplumber network-manager \
                dunst wl-clipboard cliphist grim slurp \
                qt6ct breeze-icon-theme jq imagemagick
            echo "  note: matugen isn't packaged for Debian — build from source:"
            echo "        cargo install matugen"
            ;;
        nixos)
            echo "NixOS detected — skipping package installation."
            echo "Manage packages declaratively through your NixOS configuration."
            ;;
        *)
            echo "Unknown distro/package manager — skipping dependency installation."
            ;;
    esac
}

backup_path() {
    local target="$1"

    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP"
        mv "$target" "$BACKUP/"
        echo "  backup: $target"
    fi
}

copy_dir() {
    local src="$DOTFILES/$1"
    local dest="$HOME/.config/$1"

    [ -d "$src" ] || return 0

    backup_path "$dest"
    cp -a "$src" "$dest"
    echo "  installed: ~/.config/$1"
}

copy_file() {
    local src="$DOTFILES/$1"
    local dest="$HOME/$1"

    [ -f "$src" ] || return 0

    backup_path "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    echo "  installed: ~/$1"
}

detect_distro

echo "Detected: $DISTRO"
echo

read -r -p "Install missing packages too? [Y/n] " answer
if [[ ! "$answer" =~ ^[Nn]$ ]]; then
    install_deps
    echo
fi

mkdir -p "$HOME/.config" "$HOME/.local/bin"

for dir in hypr waybar kitty rofi fastfetch dunst gammastep waypaper Thunar zed btop gtk-3.0 gtk-4.0 qt6ct matugen; do
    copy_dir "$dir"
done

# matugen's own script is committed alongside its templates, but it needs
# to live in ~/.local/bin to actually be on PATH and callable by waypaper's
# post_command / the boot-time autostart line.
if [ -f "$HOME/.config/matugen/wallpaper-theme" ]; then
    cp -a "$HOME/.config/matugen/wallpaper-theme" "$HOME/.local/bin/wallpaper-theme"
    chmod +x "$HOME/.local/bin/wallpaper-theme"
    echo "  installed: ~/.local/bin/wallpaper-theme"
fi

# Standalone utility scripts (clip-manager, game-mode, rofi-emoji, change-blur)
if [ -d "$DOTFILES/scripts" ]; then
    for file in "$DOTFILES/scripts/"*; do
        [ -f "$file" ] || continue
        name="$(basename "$file")"
        dest="$HOME/.local/bin/$name"

        backup_path "$dest"
        cp -a "$file" "$dest"
        chmod +x "$dest"

        echo "  installed: ~/.local/bin/$name"
    done
fi

# Placeholder colors so kitty/waybar/rofi/GTK don't error before matugen's
# first real run against an actual wallpaper.
if [ -d "$HOME/.config/matugen/defaults" ]; then
    cp -a "$HOME/.config/matugen/defaults/kitty-colors.conf" "$HOME/.config/kitty/colors.conf" 2>/dev/null || true
    cp -a "$HOME/.config/matugen/defaults/waybar-colors.css" "$HOME/.config/waybar/colors.css" 2>/dev/null || true
    cp -a "$HOME/.config/matugen/defaults/rofi-colors.rasi" "$HOME/.config/rofi/colors.rasi" 2>/dev/null || true
    cp -a "$HOME/.config/matugen/defaults/hyprlock-colors.conf" "$HOME/.config/hypr/hyprlock-colors.conf" 2>/dev/null || true
    cp -a "$HOME/.config/matugen/defaults/gtk-colors.css" "$HOME/.config/gtk-3.0/gtk.css" 2>/dev/null || true
    cp -a "$HOME/.config/matugen/defaults/gtk-colors.css" "$HOME/.config/gtk-4.0/gtk.css" 2>/dev/null || true
    echo "  installed: matugen default color placeholders"
fi

if [ -d "$DOTFILES/.local/bin" ]; then
    for file in "$DOTFILES/.local/bin/"*; do
        [ -f "$file" ] || continue
        name="$(basename "$file")"
        dest="$HOME/.local/bin/$name"

        backup_path "$dest"
        cp -a "$file" "$dest"
        chmod +x "$dest"

        echo "  installed: ~/.local/bin/$name"
    done
fi

copy_file "starship.toml"
copy_file ".bashrc"

echo
echo "╭─ Done!"
echo "├─ Dotfiles installed successfully."
if [ -d "$BACKUP" ]; then
    echo "├─ Backup: $BACKUP"
else
    echo "├─ Backup: none needed"
fi
echo "╰─ Restart your shell/session to apply changes."
