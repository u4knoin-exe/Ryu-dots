# Ryu-dots lockscreen: just a clock and a line. Colors from theme/palette.env.
general {
    hide_cursor = true
    ignore_empty_input = true
}

background {
    monitor =
    path = screenshot
    blur_passes = 3
    blur_size = 7
    noise = 0.02
    contrast = 0.85
    brightness = 0.35
}

label {
    monitor =
    text = $TIME
    color = rgba({{fg}}f2)
    font_size = 200
    font_family = {{font}} ExtraBold
    position = 0, 70
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:60000] echo "$(date '+%A, %d %B' | tr a-z A-Z | sed 's/./& /g')"
    color = rgba({{muted}}ff)
    font_size = 14
    font_family = {{font}}
    position = 0, -90
    halign = center
    valign = center
}

input-field {
    monitor =
    size = 260, 36
    outline_thickness = 1
    dots_size = 0.2
    dots_spacing = 0.5
    dots_center = true
    outer_color = rgba({{muted}}88)
    inner_color = rgba({{bg}}00)
    font_color = rgba({{fg}}ff)
    fade_on_empty = true
    fade_timeout = 1500
    placeholder_text =
    hide_input = false
    rounding = 0
    check_color = rgba({{accent}}ff)
    fail_color = rgba({{red}}ff)
    fail_text =
    capslock_color = rgba({{yellow}}ff)
    position = 0, -170
    halign = center
    valign = center
}
