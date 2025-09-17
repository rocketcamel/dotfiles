workspaces=$(hyprctl workspaces -j | jq -r '.[].name')

target=$(echo "$workspaces" | rofi -dmenu -config ~/.config/rofi/oneline-config.rasi -p "Switch to workspace:")

if [[ -n "$target" ]]; then
  hyprctl dispatch workspace "$target"
fi
