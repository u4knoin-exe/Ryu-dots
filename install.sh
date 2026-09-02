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
                hyprlock hypridle gammastep
            ;;
        fedora)
            sudo dnf install -y \
                hyprland waybar kitty rofi cava fastfetch starship \
                playerctl brightnessctl wireplumber NetworkManager \
                dunst wl-clipboard cliphist grim slurp \
                hyprlock hypridle gammastep
            ;;
        debian)
            sudo apt update
            sudo apt install -y \
                hyprland waybar kitty rofi cava fastfetch \
                playerctl brightnessctl wireplumber network-manager \
                dunst wl-clipboard cliphist grim slurp
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

for dir in hypr waybar kitty rofi fastfetch dunst gammastep waypaper Thunar zed btop; do
    copy_dir "$dir"
done

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
