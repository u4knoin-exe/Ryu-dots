* {
  bg:      #{{bg}}b8;
  surface: #{{surface}}d0;
  accent:  #{{accent}};
  accent2: #{{accent2}};
  fg:      #{{fg}};
  muted:   #{{muted}};
  background-color: transparent;
  text-color: @fg;
}
window {
  width: 560px;
  background-color: @bg;
  border: 1px;
  border-color: @accent;
  border-radius: 0;
}
mainbox { padding: 14px; spacing: 10px; }
inputbar {
  padding: 10px 14px;
  background-color: @surface;
  border-radius: 0;
  children: [ prompt, entry ];
  spacing: 8px;
}
prompt { text-color: @accent2; }
entry { placeholder: "search"; placeholder-color: @muted; }
listview { lines: 8; spacing: 4px; scrollbar: false; }
element { padding: 8px 12px; border-radius: 0; spacing: 10px; }
element selected.normal { background-color: @accent; text-color: #{{bg}}; }
element-icon { size: 1.4em; }
