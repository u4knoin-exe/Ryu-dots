local mod = "SUPER"
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + Space",  hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + SHIFT + W",      hl.dsp.exec_cmd("~/.local/bin/wifi-menu"))
hl.bind(mod .. " + V",      hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))

-- windows
hl.bind(mod .. " + Q",         hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mod .. " + J",         hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- focus
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
end

-- workspaces 1-9
for i = 1, 9 do
  hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- screenshots
hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Pictures/shot-$(date +%s).png'))

-- media / brightness
local lr = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lr)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), lr)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), lr)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), lr)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), lr)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- wallpapers
hl.bind(mod .. " + W",         hl.dsp.exec_cmd("~/.local/bin/ryu-wall"))
hl.bind(mod .. " + CTRL + W", hl.dsp.exec_cmd("~/.local/bin/ryu-wall --random"))

-- night light
hl.bind(mod .. " + N", hl.dsp.exec_cmd("~/.local/bin/nightlight"))
