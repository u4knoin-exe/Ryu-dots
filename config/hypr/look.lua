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

  animations = { enabled = true },
  dwindle = { preserve_split = true },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
})

hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "global",     enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.5, bezier = "easeOutQuint", style = "popin 90%" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.4, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3,   bezier = "quick" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3.8, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2,   bezier = "almostLinear", style = "fade" })
