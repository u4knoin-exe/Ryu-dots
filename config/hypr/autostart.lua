-- One launcher. It starts the essentials first and defers the rest (see bin/ryu-session).
hl.on("hyprland.start", function()
  hl.exec_cmd("~/.local/bin/ryu-session")
end)
