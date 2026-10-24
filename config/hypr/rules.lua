hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

hl.window_rule({
  name = "float-utils",
  match = { class = "^(pavucontrol|nm-connection-editor|blueman-manager)$" },
  float = true,
})

-- Liquid glass: blur behind bar / launcher / notifications.
-- If blur does not show, check key names in /usr/share/hypr/stubs/hl.meta.lua
hl.layer_rule({
  name = "glass-layers",
  match = { namespace = "^(waybar|rofi|notifications|dunst)$" },
  blur = true,
  ignore_alpha = 0.15,
})
