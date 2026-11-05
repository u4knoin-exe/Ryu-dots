/* Film strip along the bottom of the screen. Colors come from theme/palette.env. */
* {
  bg:      #{{bg}}dd;
  surface: #{{surface}}ee;
  accent:  #{{accent}};
  fg:      #{{fg}};
  muted:   #{{muted}};
  background-color: transparent;
  text-color: @fg;
}
window {
  location: south;
  anchor: south;
  width: 100%;
  padding: 18px 24px 22px 24px;
  background-color: @bg;
  border: 1px 0 0 0;
  border-color: @accent;
  border-radius: 0;
}
mainbox { spacing: 14px; children: [ inputbar, message, listview ]; }
inputbar {
  padding: 8px 12px;
  background-color: @surface;
  border-radius: 0;
  children: [ prompt, entry ];
  spacing: 10px;
}
prompt { text-color: @muted; }
entry { placeholder: "search wallpapers"; placeholder-color: @muted; }
message { padding: 0; border: 0; }
textbox { text-color: @muted; }
listview {
  layout: horizontal;
  lines: 5;
  spacing: 14px;
  scrollbar: false;
  cycle: true;
  fixed-height: true;
}
element {
  orientation: vertical;
  padding: 10px;
  spacing: 8px;
  border: 1px;
  border-color: transparent;
  border-radius: 0;
}
element selected.normal {
  background-color: @surface;
  border-color: @accent;
}
element-icon { size: 230px; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; text-color: @muted; }
element selected.normal element-text { text-color: @fg; }
