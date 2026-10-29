-- Ryu-dots animations. Switch with Super+Shift+A (ryu-anim) or edit the two lines below.
local preset      = "snappy"   -- snappy | smooth | off
local spin_border = true       -- slow rotating border gradient on the focused window

hl.curve("easeOutExpo",  { type = "bezier", points = { {0.16, 1},   {0.3, 1}  } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},   {0.32, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},   {0.1, 1}  } })
hl.curve("inOut",        { type = "bezier", points = { {0.65, 0},   {0.35, 1} } })
hl.curve("linear",       { type = "bezier", points = { {0, 0},      {1, 1}    } })

-- { leaf, speed (x100ms, lower = faster), curve, style }
local presets = {
  snappy = {
    { "global",           10,  "default" },
    { "windowsIn",        3.5, "easeOutExpo",  "popin 90%" },
    { "windowsOut",       3,   "quick",        "popin 85%" },
    { "windowsMove",      3.5, "easeOutQuint" },
    { "fade",             2.5, "quick" },
    { "layers",           3,   "easeOutQuint", "popin 94%" },
    { "border",           4,   "easeOutQuint" },
    { "workspaces",       3,   "easeOutExpo",  "slidefade 20%" },
    { "specialWorkspace", 3,   "easeOutExpo",  "slidefadevert 20%" },
  },
  smooth = {
    { "global",           10,  "default" },
    { "windowsIn",        6,   "easeOutQuint", "popin 80%" },
    { "windowsOut",       5,   "inOut",        "popin 80%" },
    { "windowsMove",      6,   "easeOutQuint" },
    { "fade",             5,   "inOut" },
    { "layers",           5,   "easeOutQuint", "popin 90%" },
    { "border",           6,   "easeOutQuint" },
    { "workspaces",       6,   "easeOutQuint", "slidefade 30%" },
    { "specialWorkspace", 6,   "easeOutQuint", "slidefadevert 30%" },
  },
}

if preset == "off" then
  hl.config({ animations = { enabled = false } })
else
  hl.config({ animations = { enabled = true } })
  for _, a in ipairs(presets[preset] or presets.snappy) do
    hl.animation({ leaf = a[1], enabled = true, speed = a[2], bezier = a[3], style = a[4] })
  end
  if spin_border then
    hl.animation({ leaf = "borderangle", enabled = true, speed = 60, bezier = "linear", style = "loop" })
  end
end
