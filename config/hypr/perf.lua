-- Performance mode: no blur, no shadows, no animations. Toggle with Super+Shift+P (ryu-perf).
local mode = "normal"   -- normal | performance

if mode == "performance" then
  hl.config({
    decoration = { blur = { enabled = false }, shadow = { enabled = false } },
    animations = { enabled = false },
  })
end
