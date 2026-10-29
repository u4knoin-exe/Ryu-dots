#!/usr/bin/env bash
# Verifies every {{key}} used in a *.tpl exists in palette.env, and every palette defines the same colors.
set -u
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bad=0
keys="$(sed -n 's/^\([a-z_0-9]*\)=.*/\1/p' "$REPO/theme/palette.env") home"
while IFS= read -r -d '' f; do
  for k in $(grep -o '{{[a-z_0-9]*}}' "$f" | tr -d '{}' | sort -u); do
    grep -qx "$k" <<<"$(tr ' ' '\n' <<<"$keys")" || { echo "unknown key {{$k}} in ${f#"$REPO"/}"; bad=1; }
  done
done < <(find "$REPO/config" "$REPO/theme/sddm" -name '*.tpl' -print0)
for p in "$REPO"/theme/palettes/*.env; do
  for k in bg surface overlay fg muted accent accent2 accent_dim red green yellow blue cyan scheme gtk_theme icon_theme; do
    grep -q "^$k=" "$p" || { echo "$(basename "$p") is missing $k"; bad=1; }
  done
done
[ "$bad" -eq 0 ] && echo "templates and palettes ok"
exit "$bad"
