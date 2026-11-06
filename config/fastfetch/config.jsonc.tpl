{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "arch",
    "padding": {
      "top": 1,
      "left": 2,
      "right": 4
    },
    "color": {
      "1": "38;2;{{accent_rgb}}"
    }
  },
  "display": {
    "separator": "  ",
    "color": {
      "keys": "38;2;{{accent_rgb}}",
      "title": "38;2;{{accent2_rgb}}",
      "output": "38;2;{{fg_rgb}}",
      "separator": "38;2;{{muted_rgb}}"
    }
  },
  "modules": [
    {
      "type": "custom",
      "format": "\u250c\u2500 hardware \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500"
    },
    {
      "type": "host",
      "key": "\u2502 \uf109  host   "
    },
    {
      "type": "cpu",
      "key": "\u2502 \uf2db  cpu    "
    },
    {
      "type": "gpu",
      "key": "\u2502 \uf108  gpu    "
    },
    {
      "type": "memory",
      "key": "\u2502 \uf538  memory "
    },
    {
      "type": "disk",
      "key": "\u2502 \uf0a0  disk   ",
      "folders": "/"
    },
    {
      "type": "custom",
      "format": "\u251c\u2500 software \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500"
    },
    {
      "type": "os",
      "key": "\u2502 \uf303  os     "
    },
    {
      "type": "kernel",
      "key": "\u2502 \uf085  kernel "
    },
    {
      "type": "wm",
      "key": "\u2502 \uf2d0  wm     "
    },
    {
      "type": "shell",
      "key": "\u2502 \uf120  shell  "
    },
    {
      "type": "terminal",
      "key": "\u2502 \uf489  term   "
    },
    {
      "type": "packages",
      "key": "\u2502 \uf187  pkgs   "
    },
    {
      "type": "uptime",
      "key": "\u2502 \uf017  uptime "
    },
    {
      "type": "custom",
      "format": "\u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500"
    },
    {
      "type": "colors",
      "symbol": "block",
      "paddingLeft": 2
    }
  ]
}
