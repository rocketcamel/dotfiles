workspaces=$(hyprctl workspaces -j | jq -r '.[].name')

target=$(echo "$workspaces" | wofi -d -p "Switch to workspace:")

if [[ -n "$target" ]]; then
  hyprctl dispatch workspace "$target"
fi
