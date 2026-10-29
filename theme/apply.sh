#!/usr/bin/env bash
# Deploy: config/ -> ~/.config, home/ -> ~, bin/ -> ~/.local/bin
# *.tpl files are rendered with theme/palette.env ({{key}} placeholders, plus {{home}}).
# Everything else is symlinked, so edits in the repo go live instantly.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PALETTE="$REPO/theme/palette.env"
SEDFILE="$(mktemp)"; trap 'rm -f "$SEDFILE"' EXIT

pv() { sed -n "s/^$1=//p" "$PALETTE" | head -1; }

while IFS='=' read -r k v; do
  [[ -z "$k" || "$k" == \#* ]] && continue
  printf 's|{{%s}}|%s|g\n' "$k" "$v" >> "$SEDFILE"
done < "$PALETTE"
printf 's|{{home}}|%s|g\n' "$HOME" >> "$SEDFILE"

deploy_tree() {
  local src="$1" dst="$2" f rel out
  [ -d "$src" ] || return 0
  while IFS= read -r -d '' f; do
    rel="${f#"$src"/}"
    if [[ "$f" == *.tpl ]]; then
      out="$dst/${rel%.tpl}"
      mkdir -p "$(dirname "$out")"
      rm -f "$out"
      sed -f "$SEDFILE" "$f" > "$out"
    else
      out="$dst/$rel"
      mkdir -p "$(dirname "$out")"
      ln -sfn "$f" "$out"
    fi
  done < <(find "$src" -type f -print0)
}

CONF="${XDG_CONFIG_HOME:-$HOME/.config}"
deploy_tree "$REPO/config" "$CONF"
deploy_tree "$REPO/home"   "$HOME"
deploy_tree "$REPO/bin"    "$HOME/.local/bin"

# btop: point at the ryu theme, keep its background transparent (glass)
mkdir -p "$CONF/btop"
if [ -f "$CONF/btop/btop.conf" ]; then
  sed -i -E 's/^color_theme *=.*/color_theme = "ryu"/; s/^theme_background *=.*/theme_background = False/' "$CONF/btop/btop.conf"
else
  printf 'color_theme = "ryu"\ntheme_background = False\n' > "$CONF/btop/btop.conf"
fi

# GTK / desktop settings (needs a session bus; skipped silently otherwise)
if command -v gsettings >/dev/null 2>&1 && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  s="$(pv scheme)"; [ "$s" = light ] && cs="prefer-light" || cs="prefer-dark"
  gsettings set org.gnome.desktop.interface color-scheme "$cs" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "$(pv gtk_theme)" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface icon-theme "$(pv icon_theme)" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface font-name "$(pv font) 10" 2>/dev/null || true
fi

echo "applied."
if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload >/dev/null 2>&1 || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  pkill -USR1 -x kitty 2>/dev/null || true      # live-reload kitty colors
  pkill -x dunst 2>/dev/null || true
  (setsid dunst >/dev/null 2>&1 &) || true
fi
