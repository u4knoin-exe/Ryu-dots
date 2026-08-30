
# Fastfetch on new Kitty terminals
if [[ -n "$KITTY_WINDOW_ID" && $- == *i* ]]; then
    fastfetch
fi

