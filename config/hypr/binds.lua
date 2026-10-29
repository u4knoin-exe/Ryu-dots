-- Keybinds. Each bind ends with ` -- @ description`: ryu-keys (Super + /) builds its cheat sheet from these.
local mod         = "SUPER"
local terminal    = "kitty --single-instance"   -- one kitty process: new windows open instantly, less RAM
local fileManager = "thunar"
local menu        = "rofi -show drun"

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal)) -- @ terminal
hl.bind(mod .. " + Space",  hl.dsp.exec_cmd(menu)) -- @ launcher
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager)) -- @ file manager
hl.bind(mod .. " + W",      hl.dsp.exec_cmd("~/.local/bin/ryu-wall")) -- @ wallpaper picker
hl.bind(mod .. " + CTRL + W", hl.dsp.exec_cmd("~/.local/bin/ryu-wall --random")) -- @ random wallpaper
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.local/bin/wifi-menu")) -- @ wifi menu
hl.bind(mod .. " + V",      hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")) -- @ clipboard history
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock")) -- @ lock
hl.bind(mod .. " + slash",  hl.dsp.exec_cmd("~/.local/bin/ryu-keys")) -- @ this cheat sheet
hl.bind(mod .. " + X",      hl.dsp.exec_cmd("~/.local/bin/ryu-center")) -- @ control center
hl.bind(mod .. " + N",      hl.dsp.exec_cmd("~/.local/bin/nightlight")) -- @ night light
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.local/bin/ryu-theme")) -- @ theme switcher
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd("~/.local/bin/ryu-anim")) -- @ animation preset
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("~/.local/bin/ryu-layout")) -- @ layout (dwindle / scrolling)
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.local/bin/ryu-perf")) -- @ performance mode (no blur / animations)
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.local/bin/ryu-power")) -- @ power menu

-- windows
hl.bind(mod .. " + Q",         hl.dsp.window.close()) -- @ close window
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) -- @ fullscreen
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" })) -- @ toggle float
hl.bind(mod .. " + P",         hl.dsp.window.pseudo()) -- @ pseudo-tile
hl.bind(mod .. " + J",         hl.dsp.layout("togglesplit")) -- @ toggle split (dwindle)
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")) -- @ exit Hyprland

-- focus (works in every layout)
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
end
-- keys: SUPER + arrows | move focus

-- scrolling layout (harmless no-ops while on dwindle)
hl.bind(mod .. " + period",       hl.dsp.layout("move +col")) -- @ scroll right (scrolling layout)
hl.bind(mod .. " + comma",        hl.dsp.layout("move -col")) -- @ scroll left (scrolling layout)
hl.bind(mod .. " + CTRL + Left",  hl.dsp.layout("swapcol l")) -- @ swap column left (scrolling layout)
hl.bind(mod .. " + CTRL + Right", hl.dsp.layout("swapcol r")) -- @ swap column right (scrolling layout)
hl.bind(mod .. " + CTRL + Up",    hl.dsp.layout("promote")) -- @ window to its own column (scrolling layout)
hl.bind(mod .. " + CTRL + Down",  hl.dsp.layout("consume")) -- @ window into previous column (scrolling layout)
hl.bind(mod .. " + equal",        hl.dsp.layout("colresize +conf")) -- @ wider column (scrolling layout)
hl.bind(mod .. " + minus",        hl.dsp.layout("colresize -conf")) -- @ narrower column (scrolling layout)

-- workspaces 1-9
for i = 1, 9 do
  hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
-- keys: SUPER + 1..9 | go to workspace
-- keys: SUPER + SHIFT + 1..9 | move window to workspace
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" })) -- @ next workspace (scroll)
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" })) -- @ previous workspace (scroll)

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic")) -- @ scratchpad
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })) -- @ send window to scratchpad

-- mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true }) -- @ drag window
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- @ resize window

-- capture
hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy')) -- @ screenshot to clipboard
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Pictures/shot-$(date +%s).png')) -- @ screenshot to file
hl.bind("CTRL + Print",  hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy')) -- @ screenshot then annotate
hl.bind(mod .. " + R",         hl.dsp.exec_cmd("~/.local/bin/ryu-rec")) -- @ record region (again to stop)
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a")) -- @ color picker

-- media / brightness (with on-screen popup)
local lr = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("~/.local/bin/ryu-osd vol up"),      lr) -- @ volume up
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("~/.local/bin/ryu-osd vol down"),    lr) -- @ volume down
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("~/.local/bin/ryu-osd vol mute"),    lr) -- @ mute
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("~/.local/bin/ryu-osd mic"),         lr) -- @ mute microphone
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.local/bin/ryu-osd bright up"),   lr) -- @ brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.local/bin/ryu-osd bright down"), lr) -- @ brightness down
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true }) -- @ next track
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- @ play / pause
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true }) -- @ previous track
