@define-color bg      #{{bg}};
@define-color surface #{{surface}};
@define-color fg      #{{fg}};
@define-color muted   #{{muted}};
@define-color accent  #{{accent}};
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
