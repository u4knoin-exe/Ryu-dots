-- GLASS: premium translucent, blur-forward, neutral
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 14,
        border_size = 2,
        col = {
            active_border = { colors = {"rgba(ffffffcc)", "rgba(ffffff55)"}, angle = 45 },
            inactive_border = "rgba(ffffff1a)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 16,
        rounding_power = 3,
        active_opacity = 0.98,
        inactive_opacity = 0.90,
        dim_inactive = true,
        dim_strength = 0.05,
        shadow = { enabled = true, range = 24, render_power = 3, color = 0x99000000, color_inactive = 0x5f000000 },
        blur = { enabled = true, size = 7, passes = 4, vibrancy = 0.25, special = true, popups = true },
    },
})
hl.animation({ leaf = "borderangle", enabled = false })
