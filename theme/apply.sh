#!/usr/bin/env bash
# Deploy: config/ -> ~/.config, home/ -> ~, bin/ -> ~/.local/bin
# *.tpl files are rendered with theme/palette.env ({{key}} placeholders, plus {{home}}).
# Everything else is symlinked, so edits in the repo go live instantly.
# Written to be cheap on re-runs: no process per file for links, dirs or checks.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PALETTE="$REPO/theme/palette.env"
SEDFILE="$(mktemp)"; trap 'rm -f "$SEDFILE"' EXIT
declare -A P   # palette values, palette.env first so it wins over defaults.env

# "|| [ -n "$k" ]" keeps a last line that has no trailing newline.
for src in "$PALETTE" "$REPO/theme/defaults.env"; do
  [ -f "$src" ] || continue
  while IFS='=' read -r k v || [ -n "$k" ]; do
    [[ -z "$k" || "$k" == \#* ]] && continue
    [[ -n "${P[$k]+x}" ]] && continue
    P[$k]="$v"
    printf 's|{{%s}}|%s|g\n' "$k" "$v" >> "$SEDFILE"
  done < "$src"
done
# decimal "r;g;b" versions of the colors, e.g. {{accent_rgb}} -> 212;212;212 (pure bash, no processes)
for k in bg surface overlay fg muted accent accent2 accent_dim red green yellow blue cyan; do
  h="${P[$k]-}"
  [[ "$h" =~ ^[0-9a-fA-F]{6}$ ]] || continue
  printf 's|{{%s_rgb}}|%d;%d;%d|g\n' "$k" "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}" >> "$SEDFILE"
done
printf 's|{{home}}|%s|g\n' "$HOME" >> "$SEDFILE"

declare -A made
ensure_dir() { [[ -n "${made[$1]+x}" ]] || { mkdir -p "$1"; made[$1]=1; }; }

deploy_tree() {
  local src="$1" dst="$2" f rel out tmp content
  [ -d "$src" ] || return 0
  while IFS= read -r -d '' f; do
    rel="${f#"$src"/}"
    if [[ "$f" == *.tpl ]]; then
      out="$dst/${rel%.tpl}"; ensure_dir "${out%/*}"
      # render beside the target and move into place: atomic, and a broken render never replaces a working file
      tmp="$out.ryu-tmp"
      sed -f "$SEDFILE" "$f" > "$tmp"
      content="$(<"$tmp")"
      if [[ "$content" =~ \{\{[a-z_0-9]+\}\} ]]; then
        echo "apply.sh: kept the old ${out#"$HOME"/}, unresolved: $(grep -oE '\{\{[a-z_0-9]+\}\}' "$tmp" | sort -u | tr '\n' ' ')" >&2
        rm -f "$tmp"
      else
        [ -L "$out" ] && rm -f "$out"
        mv -f "$tmp" "$out"
      fi
    else
      out="$dst/$rel"; ensure_dir "${out%/*}"
      [ -L "$out" ] && [ "$out" -ef "$f" ] && continue    # already linked to the right file
      ln -sfn "$f" "$out"
    fi
  done < <(find "$src" -type f -print0)
}

CONF="${XDG_CONFIG_HOME:-$HOME/.config}"
deploy_tree "$REPO/config" "$CONF"
deploy_tree "$REPO/home"   "$HOME"
deploy_tree "$REPO/bin"    "$HOME/.local/bin"

# btop: point at the ryu theme, keep its background transparent (glass); only touch the file when needed
ensure_dir "$CONF/btop"
if [ -f "$CONF/btop/btop.conf" ]; then
  content="$(<"$CONF/btop/btop.conf")"
  if [[ "$content" != *'color_theme = "ryu"'* || "$content" != *'theme_background = False'* ]]; then
    sed -i -E 's/^color_theme *=.*/color_theme = "ryu"/; s/^theme_background *=.*/theme_background = False/' "$CONF/btop/btop.conf"
  fi
else
  printf 'color_theme = "ryu"\ntheme_background = False\n' > "$CONF/btop/btop.conf"
fi

# GTK / desktop settings: only when they changed since the last run (each gsettings call is a process)
if command -v gsettings >/dev/null 2>&1 && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  want="${P[scheme]-}|${P[gtk_theme]-}|${P[icon_theme]-}|${P[font]-}"
  stamp="$HOME/.cache/ryu/gsettings.stamp"
  have=""; [ -f "$stamp" ] && have="$(<"$stamp")"
  if [ "$have" != "$want" ]; then
    [ "${P[scheme]-}" = light ] && cs="prefer-light" || cs="prefer-dark"
    gsettings set org.gnome.desktop.interface color-scheme "$cs" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme "${P[gtk_theme]-}" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "${P[icon_theme]-}" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name "${P[font]-} 10" 2>/dev/null || true
    ensure_dir "${stamp%/*}"; printf '%s' "$want" > "$stamp"
  fi
fi

echo "applied."
if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
  hyprctl reload >/dev/null 2>&1 || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  pkill -USR1 -x kitty 2>/dev/null || true      # live-reload kitty colors
  pkill -x dunst 2>/dev/null || true
  (setsid dunst >/dev/null 2>&1 &) || true
fi
