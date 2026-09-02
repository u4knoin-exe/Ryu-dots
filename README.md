# u4knoin's dotfiles

My personal Linux rice/configuration focused on a dark, minimal Hyprland setup.

## Includes

- Hyprland
- Waybar
- Kitty
- Rofi
- Fastfetch
- Starship
- Dunst
- Hyprlock
- Hypridle
- Gammastep
- awww
- Waypaper
- Thunar
- Zed
- btop
- Custom scripts

## Supported distros

The installer detects the available package manager automatically:

- NixOS
- Arch Linux
- Fedora
- Debian / Ubuntu

> NixOS users: the installer does not modify `/etc/nixos` or install packages imperatively. Manage system packages through your Nix configuration.

## Dependencies

The installer can install the required packages automatically.

Main dependencies include:

- Hyprland
- Waybar
- Kitty
- Rofi
- Fastfetch
- Starship
- Playerctl
- Brightnessctl
- WirePlumber
- NetworkManager
- Dunst
- wl-clipboard
- Cliphist
- Grim
- Slurp
- Hyprlock
- Hypridle
- Gammastep

## Installation

Clone the repository:

```bash
git clone git@github.com:u4knoin-exe/Ryu-dots.git ~/dotfiles
cd ~/dotfiles
./install.sh
