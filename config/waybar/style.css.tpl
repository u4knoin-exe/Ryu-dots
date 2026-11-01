@define-color bg      #{{bg}};
@define-color surface #{{surface}};
@define-color fg      #{{fg}};
@define-color muted   #{{muted}};
@define-color accent  #{{accent}};
@define-color accent_dim #{{accent_dim}};
@define-color red     #{{red}};
@define-color yellow  #{{yellow}};

* {
  font-family: "{{font}}";
  font-size: {{font_size}}pt;
  border: none;
  border-radius: 0;
  min-height: 0;
}
window#waybar {
  background: alpha(@bg, 0.60);
  border-bottom: 1px solid alpha(@accent, 0.45);
  color: @fg;
}
#clock, #network, #wireplumber, #battery, #tray { padding: 0 12px; }
#workspaces button {
  color: @muted;
  padding: 0 10px;
  background: transparent;
  border-bottom: 2px solid transparent;
}
#workspaces button.active { color: @fg; border-bottom: 2px solid @accent; }
#workspaces button:hover { background: alpha(@accent, 0.2); }
#wireplumber.muted { color: @muted; }
#battery.warning { color: @yellow; }
#battery.critical { color: @red; }
tooltip { background: @surface; border: 1px solid @accent; border-radius: 0; }

/* workspace buttons: custom modules, so clicks work on any Waybar version */
#custom-ws1, #custom-ws2, #custom-ws3, #custom-ws4, #custom-ws5 {
  padding: 0 11px;
  color: @accent_dim;
  border-bottom: 2px solid transparent;
}
#custom-ws1.occupied, #custom-ws2.occupied, #custom-ws3.occupied, #custom-ws4.occupied, #custom-ws5.occupied { color: @muted; }
#custom-ws1.active, #custom-ws2.active, #custom-ws3.active, #custom-ws4.active, #custom-ws5.active {
  color: @fg;
  border-bottom: 2px solid @accent;
}
#custom-ws1:hover, #custom-ws2:hover, #custom-ws3:hover, #custom-ws4:hover, #custom-ws5:hover { background: alpha(@accent, 0.2); }
