add_newline = false
format = "$directory$git_branch$git_status$character"

[directory]
style = "bold #{{accent}}"
truncation_length = 3

[git_branch]
format = "[ $branch]($style) "
style = "#{{accent2}}"

[git_status]
style = "#{{yellow}}"

[character]
success_symbol = "[❯](bold #{{accent}})"
error_symbol = "[❯](bold #{{red}})"
