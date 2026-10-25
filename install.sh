#!/usr/bin/env bash
# Ryu-dots installer: your whole setup, on any distro.
#   ./install.sh                         interactive
#   ./install.sh --yes --all             everything, no questions (distro-hop mode)
#   ./install.sh --dry-run               preview only, changes nothing
#   ./install.sh --brave --spotify --flatpak     pick extras
#   ./install.sh --no-pkgs | --no-backup | --no-extras | --uninstall
set -Eeuo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${XDG_CONFIG_HOME:-$HOME/.config}"
OSREL="${RYU_OS_RELEASE:-/etc/os-release}"
STAMP="$(date +%Y%m%d-%H%M%S)"
YES=0; DRY=0; DO_PKGS=1; DO_BACKUP=1; UNINSTALL=0
BRAVE=ask; SPOTIFY=ask; FLATPAK=ask
STEP=0; TOTAL=6
MANAGED_DIRS=(hypr waybar kitty rofi dunst)
MIN_HYPR="0.55.0"
FAMILY=unknown; DISTRO_NAME="unknown"
AUR_HELPER=""; MISSING=()

# ---------- package lists ----------
PKGS_ARCH=(hyprland hyprlock hypridle hyprsunset xdg-desktop-portal-hyprland
  waybar kitty rofi dunst libnotify thunar fastfetch starship btop
  playerctl brightnessctl wireplumber networkmanager
  wl-clipboard cliphist grim slurp imagemagick swaybg
  ttf-jetbrains-mono-nerd awww)
PKGS_FEDORA=(hyprland hyprlock hypridle hyprsunset xdg-desktop-portal-hyprland
  waybar kitty dunst libnotify Thunar fastfetch starship btop
  playerctl brightnessctl wireplumber NetworkManager
  wl-clipboard cliphist grim slurp ImageMagick swaybg)
PKGS_DEBIAN=(hyprland hyprlock hypridle xdg-desktop-portal-hyprland
  waybar kitty rofi dunst libnotify-bin thunar fastfetch btop
  playerctl brightnessctl wireplumber network-manager
  wl-clipboard grim slurp imagemagick swaybg)

# ---------- ui ----------
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  B=$(tput bold); D=$(tput dim); R=$(tput sgr0)
  RED=$(tput setaf 1); GRN=$(tput setaf 2); YEL=$(tput setaf 3)
else
  B=""; D=""; R=""; RED=""; GRN=""; YEL=""
fi
step() { STEP=$((STEP+1)); printf '\n%s[%s/%s]%s %s%s%s\n' "$D" "$STEP" "$TOTAL" "$R" "$B" "$*" "$R"; }
ok()   { printf '  %s✔%s %s\n' "$GRN" "$R" "$*"; }
info() { printf '  %s•%s %s\n' "$D" "$R" "$*"; }
warn() { printf '  %s!%s %s\n' "$YEL" "$R" "$*"; }
die()  { printf '  %s✘%s %s\n' "$RED" "$R" "$*" >&2; exit 1; }
run()  { if [ "$DRY" -eq 1 ]; then printf '  %s$ %s%s\n' "$D" "$*" "$R"; else "$@"; fi; }
ask()  { # default yes
  [ "$YES" -eq 1 ] && return 0
  local a; read -r -p "  ? $1 [Y/n] " a </dev/tty || return 1
  [[ -z "$a" || "$a" =~ ^[Yy] ]]
}
askn() { # default no (extras)
  [ "$YES" -eq 1 ] && return 1
  local a; read -r -p "  ? $1 [y/N] " a </dev/tty || return 1
  [[ "$a" =~ ^[Yy] ]]
}
banner() {
  printf '%s\n' "$B" "   ┌─┐┬ ┬┬ ┬   ┌┬┐┌─┐┌┬┐┌─┐" "   ├┬┘└┬┘│ │─── │││ │ │ └─┐" "   ┴└─ ┴ └─┘  ─┴┘└─┘ ┴ └─┘" "$R"
  if [ "$DRY" -eq 1 ]; then warn "dry-run: nothing will be changed"; fi
  return 0
}
usage() { sed -n '2,7p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0; }

trap 'printf "\n  %s✘%s failed at line %s. Backups (if any): ~/ryu-backup-*.tar.gz\n" "$RED" "$R" "$LINENO" >&2' ERR

for a in "$@"; do
  case "$a" in
    -y|--yes) YES=1 ;;
    -n|--dry-run) DRY=1 ;;
    --no-pkgs) DO_PKGS=0 ;;
    --no-backup) DO_BACKUP=0 ;;
    --brave) BRAVE=yes ;;
    --spotify) SPOTIFY=yes ;;
    --flatpak) FLATPAK=yes ;;
    --all) BRAVE=yes; SPOTIFY=yes; FLATPAK=yes ;;
    --no-extras) BRAVE=no; SPOTIFY=no; FLATPAK=no ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help) usage ;;
    *) die "unknown option: $a (try --help)" ;;
  esac
done
[ "$(id -u)" -eq 0 ] && die "do not run as root"

# ---------- distro ----------
osval() { sed -n "s/^$1=//p" "$OSREL" 2>/dev/null | head -1 | tr -d '"'; }
detect_family() {
  local id like
  id="$(osval ID)"; like="$(osval ID_LIKE)"; DISTRO_NAME="$(osval PRETTY_NAME)"; [ -n "$DISTRO_NAME" ] || DISTRO_NAME="$id"
  case " $id $like " in
    *" arch "*|*" cachyos "*|*" endeavouros "*|*" manjaro "*|*" garuda "*) FAMILY=arch ;;
    *" fedora "*|*" rhel "*|*" nobara "*) FAMILY=fedora ;;
    *" debian "*|*" ubuntu "*) FAMILY=debian ;;
    *" nixos "*) FAMILY=nix ;;
    *)
      if command -v pacman >/dev/null 2>&1; then FAMILY=arch
      elif command -v dnf >/dev/null 2>&1; then FAMILY=fedora
      elif command -v apt-get >/dev/null 2>&1; then FAMILY=debian
      fi ;;
  esac
}

# ---------- uninstall ----------
walk_targets() {
  local pair src dst f rel
  for pair in "$REPO/config:$CONF" "$REPO/home:$HOME" "$REPO/bin:$HOME/.local/bin"; do
    src="${pair%%:*}"; dst="${pair#*:}"
    [ -d "$src" ] || continue
    while IFS= read -r -d '' f; do
      rel="${f#"$src"/}"
      printf '%s\t%s\n' "$f" "$dst/${rel%.tpl}"
    done < <(find "$src" -type f -print0)
  done
}
do_uninstall() {
  banner; TOTAL=2
  step "Removing Ryu-dots files"
  local n=0 src dst
  while IFS=$'\t' read -r src dst; do
    if [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$REPO"/* ]]; then run rm -f "$dst"; n=$((n+1))
    elif [[ "$src" == *.tpl ]] && [ -f "$dst" ] && [ ! -L "$dst" ]; then run rm -f "$dst"; n=$((n+1)); fi
  done < <(walk_targets)
  for d in "${MANAGED_DIRS[@]}"; do run rm -f "$CONF/$d/.ryu-managed"; done
  ok "removed $n files"
  step "Restore previous setup"
  local latest; latest="$(ls -1t "$HOME"/ryu-backup-*.tar.gz 2>/dev/null | head -1 || true)"
  if [ -n "$latest" ] && ask "restore $(basename "$latest")?"; then
    run tar -xzf "$latest" -C "$HOME"; ok "restored $latest"
  else
    info "no backup restored. Moved-aside folders look like ~/.config/<name>.old-*"
  fi
  exit 0
}
[ "$UNINSTALL" -eq 1 ] && do_uninstall

# ---------- helpers: packages ----------
ensure_aur_helper() {
  [ -n "$AUR_HELPER" ] && return 0
  local h; for h in paru yay; do command -v "$h" >/dev/null 2>&1 && { AUR_HELPER="$h"; return 0; }; done
  ask "no AUR helper found. Build paru-bin?" || return 1
  run sudo pacman -S --needed git base-devel
  local tmp; tmp="$(mktemp -d)"
  run git clone https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
  if [ "$DRY" -eq 0 ]; then (cd "$tmp/paru-bin" && makepkg -si); else info "(makepkg -si in $tmp/paru-bin)"; fi
  AUR_HELPER=paru
}
arch_install() {
  local p repo=() aur=() flags=(--needed)
  [ "$YES" -eq 1 ] && flags+=(--noconfirm)
  for p in "$@"; do
    pacman -Qq "$p" >/dev/null 2>&1 && continue
    if pacman -Si "$p" >/dev/null 2>&1; then repo+=("$p"); else aur+=("$p"); fi
  done
  if [ ${#repo[@]} -gt 0 ]; then run sudo pacman -S "${flags[@]}" "${repo[@]}"; fi
  if [ ${#aur[@]} -gt 0 ]; then
    if ensure_aur_helper; then run "$AUR_HELPER" -S "${flags[@]}" "${aur[@]}"
    else MISSING+=("${aur[@]}"); fi
  fi
  return 0
}
best_effort_install() { # fedora / debian: one by one, collect failures
  if [ "$DRY" -eq 1 ]; then info "would install (best effort): $*"; return 0; fi
  local p; for p in "$@"; do
    case "$FAMILY" in
      fedora) rpm -q "$p" >/dev/null 2>&1 && continue
              run sudo dnf install -y "$p" >/dev/null 2>&1 || MISSING+=("$p") ;;
      debian) dpkg -s "$p" >/dev/null 2>&1 && continue
              run sudo apt-get install -y "$p" >/dev/null 2>&1 || MISSING+=("$p") ;;
    esac
  done
  return 0
}
pkg_install() { # generic: used by extras
  case "$FAMILY" in
    arch) arch_install "$@" ;;
    fedora|debian) best_effort_install "$@" ;;
    *) MISSING+=("$@") ;;
  esac
}
nerd_font_fallback() {
  fc-list 2>/dev/null | grep -qi 'JetBrainsMono.*Nerd' && return 0
  info "installing JetBrainsMono Nerd Font (user)"
  run bash -c 'mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd && curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts/JetBrainsMonoNerd && fc-cache -f' \
    || MISSING+=("JetBrainsMono-Nerd-Font")
  return 0
}

# ---------- 1 preflight ----------
banner
step "Preflight"
[ -f "$REPO/theme/apply.sh" ] || die "run this from the Ryu-dots repo"
ok "repo: $REPO"
detect_family
case "$FAMILY" in
  arch|fedora) ok "distro: $DISTRO_NAME  (family: $FAMILY)" ;;
  debian) ok "distro: $DISTRO_NAME  (family: debian)"; warn "Hyprland 0.55+ is usually not in Debian/Ubuntu repos. Install it separately." ;;
  nix) warn "NixOS: packages must come from your Nix config. Configs will still deploy."; DO_PKGS=0 ;;
  *) warn "unknown distro: packages skipped, configs will still deploy"; DO_PKGS=0 ;;
esac
if [ "$DO_PKGS" -eq 1 ]; then command -v sudo >/dev/null 2>&1 || die "sudo is required for packages"; fi

# ---------- 2 core packages ----------
step "Core packages"
install_core() {
  case "$FAMILY" in
    arch)
      local list=("${PKGS_ARCH[@]}")
      pacman -Qq 2>/dev/null | grep -qi '^bibata' || list+=(bibata-cursor-theme-bin)
      info "checking ${#list[@]} packages"
      ask "install missing ones now?" || { warn "skipped"; return 0; }
      arch_install "${list[@]}" ;;
    fedora)
      ask "enable COPR solopasha/hyprland (newest Hyprland stack) and install?" || { warn "skipped"; return 0; }
      run sudo dnf install -y dnf-plugins-core
      run sudo dnf copr enable -y solopasha/hyprland
      local rofi=rofi; dnf info rofi-wayland >/dev/null 2>&1 && rofi=rofi-wayland
      best_effort_install "${PKGS_FEDORA[@]}" "$rofi" ;;
    debian)
      ask "install what apt has?" || { warn "skipped"; return 0; }
      run sudo apt-get update
      best_effort_install "${PKGS_DEBIAN[@]}" ;;
  esac
  if [ "$FAMILY" != arch ]; then
    nerd_font_fallback
    command -v starship >/dev/null 2>&1 || run bash -c 'curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin' || MISSING+=(starship)
  fi
  return 0
}
if [ "$DO_PKGS" -eq 1 ]; then install_core; ok "core step done"
else info "skipped. Needed: hyprland hyprlock hypridle hyprsunset waybar kitty rofi dunst thunar fastfetch starship btop playerctl brightnessctl wireplumber networkmanager wl-clipboard cliphist grim slurp imagemagick swaybg libnotify, JetBrainsMono Nerd Font, Bibata cursor"; fi

# ---------- 3 extras ----------
step "Extras"
want() { # name var -> returns 0 when wanted
  local label="$1" state="$2"
  case "$state" in yes) return 0 ;; no) return 1 ;; *) askn "install $label?" ;; esac
}
ensure_flatpak() {
  if ! command -v flatpak >/dev/null 2>&1; then pkg_install flatpak; fi
  if [ "$DRY" -eq 1 ] || command -v flatpak >/dev/null 2>&1; then
    run sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ok "Flatpak + Flathub ready"
  else warn "flatpak not available"; MISSING+=(flatpak); fi
  return 0
}
install_brave() {
  case "$FAMILY" in
    arch) arch_install brave-origin-bin ;;
    fedora)
      run sudo dnf install -y dnf-plugins-core
      if dnf --version 2>&1 | grep -qi dnf5; then
        run sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
      else
        run sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
      fi
      run sudo dnf install -y brave-origin ;;
    debian)
      run sudo apt-get install -y curl
      run sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
      run sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
      run sudo apt-get update
      run sudo apt-get install -y brave-origin ;;
    *) run bash -c 'curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh' ;;
  esac
  ok "Brave Origin step done"
  return 0
}
install_spotify() {
  if [ "$FAMILY" = arch ]; then
    arch_install spotify-launcher
  else
    ensure_flatpak
    run sudo flatpak install -y flathub com.spotify.Client
  fi
  ok "Spotify installed"
  chmod +x "$REPO/bin/ryu-spicetify"
  if [ "$YES" -eq 0 ] && [ "$DRY" -eq 0 ]; then
    info "Spicetify needs Spotify opened and logged in once."
    if ask "open Spotify now, log in, close it, then set up Spicetify + Marketplace?"; then
      (setsid spotify-launcher >/dev/null 2>&1 || setsid flatpak run com.spotify.Client >/dev/null 2>&1) &
      read -r -p "  press Enter after you logged in and closed Spotify... " _ </dev/tty || true
      "$REPO/bin/ryu-spicetify" || warn "Spicetify not finished. Run later: ryu-spicetify"
    else
      info "later: log into Spotify once, then run: ryu-spicetify"
    fi
  else
    info "after first Spotify login, run: ryu-spicetify"
  fi
  return 0
}
if [ "$FAMILY" != arch ] && [ "$FAMILY" != fedora ] && [ "$FAMILY" != debian ]; then
  info "extras are not supported on this distro: skipped"
else
  if want "Flatpak + Flathub" "$FLATPAK"; then ensure_flatpak; fi
  if want "Brave Origin browser" "$BRAVE"; then install_brave; fi
  if want "Spotify + Spicetify + Marketplace" "$SPOTIFY"; then install_spotify; fi
  info "extras done"
fi

# ---------- 4 backup ----------
step "Backup"
backup() {
  local items=() d
  for d in "${MANAGED_DIRS[@]}"; do
    if [ -d "$CONF/$d" ] && [ ! -L "$CONF/$d" ] && [ ! -e "$CONF/$d/.ryu-managed" ]; then items+=(".config/$d"); fi
  done
  if [ -f "$CONF/starship.toml" ] && [ ! -L "$CONF/starship.toml" ] && ! grep -q 'generated by Ryu-dots' "$CONF/starship.toml"; then
    items+=(".config/starship.toml")
  fi
  [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ] && items+=(".bashrc")
  if [ ${#items[@]} -eq 0 ]; then ok "nothing to back up (already managed or fresh)"; return 0; fi
  local out="$HOME/ryu-backup-$STAMP.tar.gz"
  [ -e "$out" ] && out="$HOME/ryu-backup-$STAMP-$$.tar.gz"
  run tar -czf "$out" -C "$HOME" "${items[@]}"
  ok "backup: $out"
  for d in "${MANAGED_DIRS[@]}"; do
    if [ -d "$CONF/$d" ] && [ ! -L "$CONF/$d" ] && [ ! -e "$CONF/$d/.ryu-managed" ]; then
      run mv "$CONF/$d" "$CONF/$d.old-$STAMP"; info "moved aside: ~/.config/$d -> $d.old-$STAMP"
    fi
  done
  return 0
}
if [ "$DO_BACKUP" -eq 1 ]; then backup; else info "skipped (--no-backup)"; fi

# ---------- 5 deploy ----------
step "Deploy configs"
run chmod +x "$REPO"/bin/* "$REPO"/theme/apply.sh
run "$REPO/theme/apply.sh"
for d in "${MANAGED_DIRS[@]}"; do if [ "$DRY" -eq 0 ] && [ -d "$CONF/$d" ]; then touch "$CONF/$d/.ryu-managed"; fi; done
ok "linked and rendered (colors from theme/palette.env)"
# your wallpapers + avatar travel with the repo
run mkdir -p "$HOME/Pictures/Wallpapers"
if compgen -G "$REPO/wallpapers/*.*" >/dev/null 2>&1; then
  for f in "$REPO"/wallpapers/*.*; do [ -e "$HOME/Pictures/Wallpapers/$(basename "$f")" ] || run cp "$f" "$HOME/Pictures/Wallpapers/"; done
  ok "wallpapers copied from repo"
fi
if [ -f "$REPO/assets/face.png" ] && [ ! -e "$HOME/.face" ]; then run cp "$REPO/assets/face.png" "$HOME/.face"; ok "avatar installed (~/.face)"; fi

# ---------- 6 final ----------
step "Final touches"
hv=""
for bin in Hyprland hyprland; do
  if command -v "$bin" >/dev/null 2>&1; then hv="$("$bin" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"; break; fi
done
if [ -n "$hv" ]; then
  if [ "$(printf '%s\n%s\n' "$MIN_HYPR" "$hv" | sort -V | head -1)" = "$MIN_HYPR" ]; then ok "Hyprland $hv (Lua config supported)"
  else warn "Hyprland $hv is older than $MIN_HYPR. The Lua config needs $MIN_HYPR+."; fi
else info "Hyprland not found yet"; fi
if command -v systemctl >/dev/null 2>&1 && ! systemctl is-enabled NetworkManager >/dev/null 2>&1; then
  ask "enable NetworkManager (Wi-Fi menu needs it)?" && run sudo systemctl enable --now NetworkManager
fi
if getent group video >/dev/null 2>&1 && ! id -nG | tr ' ' '\n' | grep -qx video; then
  ask "add $(id -un) to the 'video' group (brightness keys)?" && { run sudo usermod -aG video "$(id -un)"; warn "log out and back in for the group to apply"; }
fi
[ -e "$HOME/.face" ] || info "tip: put a square image at ~/.face (lockscreen avatar), or in the repo at assets/face.png"

if [ ${#MISSING[@]} -gt 0 ]; then
  printf '\n  %s!%s could not install automatically: %s\n' "$YEL" "$R" "${MISSING[*]}"
  info "install those manually, then re-run ./install.sh (it only does what is missing)"
fi
printf '\n%sDone.%s\n' "$B" "$R"
cat <<MSG
  Start:      log out, pick Hyprland   (or run: Hyprland)
  Recolor:    edit theme/palette.env, then ./theme/apply.sh
  Spotify:    ryu-spicetify   (after first login)
  Undo:       ./install.sh --uninstall
  Keys:       Super+Return term · Super+Space launcher · Super+W wallpapers
              Super+Shift+W wifi · Super+N night light · Super+L lock
MSG
