local c = require("colors")

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 1,
    col = {
      active_border = { colors = { c.rgba(c.accent, "ee"), c.rgba(c.accent2, "ee") }, angle = 45 },
      inactive_border = c.rgba(c.overlay, "aa"),
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 0,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = { enabled = false },
    blur = {
      enabled = true,
      size = 6,
      passes = 2,
      vibrancy = 0.17,
      noise = 0.01,
    },
  },

  dwindle = { preserve_split = true },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

-- scrolling layout (switch with Super+Shift+L, or ryu-layout)
hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
    column_width = 0.5,
    focus_fit_method = 1,
    follow_focus = true,
  },
})
