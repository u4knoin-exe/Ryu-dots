#!/usr/bin/env bash
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PKGS=(hyprland hyprlock hypridle waybar kitty rofi dunst fastfetch starship btop
      playerctl brightnessctl wireplumber networkmanager wl-clipboard cliphist
      grim slurp imagemagick hyprsunset thunar ttf-jetbrains-mono-nerd xdg-desktop-portal-hyprland)
AUR=(awww)

if command -v pacman >/dev/null 2>&1; then
  echo ">> Installing packages (Arch/CachyOS)"
  sudo pacman -S --needed --noconfirm "${PKGS[@]}"
  helper=""; for h in paru yay; do command -v "$h" >/dev/null 2>&1 && helper="$h" && break; done
  if [ -n "$helper" ]; then "$helper" -S --needed --noconfirm "${AUR[@]}"
  else echo "!! no AUR helper found, install manually: ${AUR[*]}"; fi
else
  echo "!! Not Arch-based: skipping packages. Install these yourself (or via Nix):"
  echo "   ${PKGS[*]} ${AUR[*]}"
fi

stamp="$HOME/ryu-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
existing=()
for d in hypr waybar kitty rofi dunst starship.toml; do
  if [ -e "$HOME/.config/$d" ] && [ ! -L "$HOME/.config/$d" ]; then existing+=(".config/$d"); fi
done
if [ -e "$HOME/.bashrc" ]; then existing+=(".bashrc"); fi
if [ ${#existing[@]} -gt 0 ]; then
  tar -czf "$stamp" -C "$HOME" "${existing[@]}" && echo ">> backup: $stamp"
fi

chmod +x "$REPO"/bin/* "$REPO"/theme/apply.sh
"$REPO/theme/apply.sh"
echo ">> done. Log out, pick Hyprland, enjoy."
