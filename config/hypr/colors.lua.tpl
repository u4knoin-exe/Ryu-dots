-- GENERATED from theme/palette.env by theme/apply.sh. Do not edit.
local M = {
  bg = "{{bg}}", surface = "{{surface}}", overlay = "{{overlay}}",
  fg = "{{fg}}", muted = "{{muted}}",
  accent = "{{accent}}", accent2 = "{{accent2}}", accent_dim = "{{accent_dim}}",
}
-- rgba("a78bfa", "ee") -> "rgba(a78bfaee)"
function M.rgba(hex, alpha) return "rgba(" .. hex .. alpha .. ")" end
return M
