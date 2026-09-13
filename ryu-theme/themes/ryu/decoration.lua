-- RYU: deep black, single accent (red), subtle glow
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 12,
        border_size = 2,
        col = {
            active_border = "rgba(e6455aee)",
            inactive_border = "rgba(15151add)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        active_opacity = 1.0,
        inactive_opacity = 0.92,
        dim_inactive = true,
        dim_strength = 0.10,
        shadow = { enabled = true, range = 18, render_power = 3, color = 0xaae6455a, color_inactive = 0x33000000 },
        blur = { enabled = true, size = 5, passes = 3, vibrancy = 0.10 },
    },
})
hl.animation({ leaf = "borderangle", enabled = true, speed = 20, bezier = "linear", style = "loop" })
