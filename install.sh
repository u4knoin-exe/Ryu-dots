#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config ~/.local/bin

for dir in hypr waybar kitty rofi cava fastfetch; do
    rm -rf "$HOME/.config/$dir"
    cp -r "$DOTFILES/$dir" "$HOME/.config/$dir"
done

cp -r "$DOTFILES/.local/bin/." "$HOME/.local/bin/"
cp "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
cp "$DOTFILES/.bashrc" "$HOME/.bashrc"

chmod +x ~/.local/bin/*

echo "Dotfiles installed."
echo "Restart your shell or log out/in to apply everything."
