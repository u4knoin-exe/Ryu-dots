-- VOID: minimal monochrome, restrained
hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border = "rgba(e8e8e8ff)",
            inactive_border = "rgba(2a2a2aaa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 6,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        dim_inactive = false,
        shadow = { enabled = true, range = 10, render_power = 2, color = 0x99000000 },
        blur = { enabled = true, size = 4, passes = 2, vibrancy = 0.0 },
    },
})
hl.animation({ leaf = "borderangle", enabled = false })
