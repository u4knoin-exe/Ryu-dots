[global]
    follow = mouse
    width = 340
    origin = top-right
    offset = 12x56
    corner_radius = 0
    frame_width = 1
    frame_color = "#{{accent}}"
    separator_color = frame
    font = {{font}} {{font_size}}
    padding = 12
    horizontal_padding = 14
    gap_size = 8
    icon_position = left
    max_icon_size = 48
    format = "<b>%s</b>\n%b"

[urgency_low]
    background = "#{{surface}}d9"
    foreground = "#{{muted}}"
    timeout = 4

[urgency_normal]
    background = "#{{surface}}d9"
    foreground = "#{{fg}}"
    timeout = 7

[urgency_critical]
    background = "#{{surface}}f2"
    foreground = "#{{fg}}"
    frame_color = "#{{red}}"
    timeout = 0
