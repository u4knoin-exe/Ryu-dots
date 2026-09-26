-- Ryu-dots V2 / Obsidian Glass
-- Cosmetic layer only. Keybinds and startup remain in hyprland.lua.

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 1,
        col = {
            active_border = { colors = {"rgba(8bdff2ff)", "rgba(7aa2f7ff)"}, angle = 35 },
            inactive_border = "rgba(ffffff18)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 12,
        rounding_power = 3,
        active_opacity = 1.0,
        inactive_opacity = 0.93,
        dim_inactive = true,
        dim_strength = 0.055,

        shadow = {
            enabled = true,
            range = 18,
            render_power = 3,
            color = 0x99000000,
            color_inactive = 0x55000000,
        },

        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            vibrancy = 0.10,
            new_optimizations = true,
            xray = false,
            special = true,
            popups = true,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "windows",     enabled = true, speed = 5, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "layers",      enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "layersIn",    enabled = true, speed = 4, bezier = "default", style = "fade" })
hl.animation({ leaf = "layersOut",   enabled = true, speed = 3, bezier = "default", style = "fade" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "zoomFactor",  enabled = true, speed = 5, bezier = "default" })

-- Keep layer-shell surfaces visually integrated without excessive blur.
hl.layer_rule({
    name = "ryu-v2-waybar",
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    name = "ryu-v2-rofi",
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    name = "ryu-v2-notifications",
    match = { namespace = "notifications" },
    blur = true,
    ignore_alpha = 0,
})
