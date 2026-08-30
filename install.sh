#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "Installing dotfiles from: $DOTFILES"

mkdir -p "$HOME/.config" "$HOME/.local/bin"

for dir in hypr waybar kitty rofi cava fastfetch; do
    if [ -e "$HOME/.config/$dir" ]; then
        mkdir -p "$BACKUP"
        mv "$HOME/.config/$dir" "$BACKUP/"
    fi
    cp -r "$DOTFILES/$dir" "$HOME/.config/"
done

for file in "$DOTFILES/.local/bin/"*; do
    cp "$file" "$HOME/.local/bin/"
done

cp "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
cp "$DOTFILES/.bashrc" "$HOME/.bashrc"

chmod +x "$HOME/.local/bin/"*

echo
echo "Done."
echo "Backup: $BACKUP"
echo "Restart your shell or log out/in to apply everything."
