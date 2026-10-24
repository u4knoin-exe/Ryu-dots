* {
  bg:      #{{bg}}d0;
  surface: #{{surface}}e0;
  accent:  #{{accent}};
  fg:      #{{fg}};
  muted:   #{{muted}};
  background-color: transparent;
  text-color: @fg;
}
window {
  width: 1100px;
  background-color: @bg;
  border: 1px;
  border-color: @accent;
  border-radius: 0;
}
mainbox { padding: 16px; spacing: 14px; children: [ inputbar, listview ]; }
inputbar {
  padding: 8px 12px;
  background-color: @surface;
  border-radius: 0;
  children: [ prompt, entry ];
  spacing: 8px;
}
prompt { text-color: @muted; }
entry { placeholder: "search wallpapers"; placeholder-color: @muted; }
listview {
  columns: 4;
  lines: 3;
  fixed-columns: true;
  spacing: 10px;
  scrollbar: false;
}
element {
  orientation: vertical;
  padding: 8px;
  spacing: 6px;
  border: 1px;
  border-color: transparent;
  border-radius: 0;
}
element selected.normal {
  background-color: @surface;
  border-color: @accent;
}
element-icon { size: 200px; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; text-color: @muted; }
element selected.normal element-text { text-color: @fg; }
