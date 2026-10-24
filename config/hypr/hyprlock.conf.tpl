general {
    hide_cursor = true
}
background {
    monitor =
    path = screenshot
    blur_passes = 3
    blur_size = 6
    brightness = 0.55
}
# layout (center-origin): time 300 > date 225 > avatar 80 > input -80 (no overlap)
label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%H:%M")"
    color = rgba({{fg}}ff)
    font_size = 84
    font_family = {{font}}
    position = 0, 300
    halign = center
    valign = center
}
label {
    monitor =
    text = cmd[update:60000] echo "$(date +"%A, %d %B")"
    color = rgba({{muted}}ff)
    font_size = 18
    font_family = {{font}}
    position = 0, 225
    halign = center
    valign = center
}
image {
    monitor =
    path = ~/.face
    size = 110
    rounding = 0
    border_size = 1
    border_color = rgba({{accent}}ff)
    position = 0, 80
    halign = center
    valign = center
}
input-field {
    monitor =
    size = 280, 48
    outline_thickness = 1
    outer_color = rgba({{accent}}ff)
    inner_color = rgba({{surface}}cc)
    font_color = rgba({{fg}}ff)
    fade_on_empty = true
    placeholder_text = <i>password</i>
    rounding = 0
    position = 0, -80
    halign = center
    valign = center
}
