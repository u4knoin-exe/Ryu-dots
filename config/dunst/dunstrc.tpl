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
    progress_bar = true
    progress_bar_height = 8
    progress_bar_frame_width = 1
    progress_bar_min_width = 160
    progress_bar_corner_radius = 0

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

[osd]
    stack_tag = "ryu-osd"
    history_ignore = yes
    timeout = 1
