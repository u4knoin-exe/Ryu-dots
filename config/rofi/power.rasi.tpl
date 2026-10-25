* {
  bg:      #{{bg}}c0;
  accent:  #{{accent}};
  fg:      #{{fg}};
  muted:   #{{muted}};
  background-color: transparent;
  text-color: @fg;
}
window {
  width: 260px;
  background-color: @bg;
  border: 1px;
  border-color: @accent;
  border-radius: 0;
}
mainbox { padding: 10px; children: [ listview ]; }
listview { lines: 5; spacing: 4px; scrollbar: false; dynamic: true; }
element { padding: 10px 14px; border-radius: 0; }
element selected.normal { background-color: @accent; text-color: #{{bg}}; }
