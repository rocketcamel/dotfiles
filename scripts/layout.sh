#!/usr/bin/env bash
# Rofi-based keyboard layout switcher for Hyprland

layouts="🇨🇦 Canadian (CA)
🇯🇵 Japanese (JP)"

selected=$(echo "$layouts" | rofi -dmenu -p "Layout")

case "$selected" in
  *"Canadian"*)
    hyprctl switchxkblayout all 0
    notify-send -h string:synchronous:keyboard "Keyboard" "🇨🇦 Canadian (CA)"
    ;;
  *"Japanese"*)
    hyprctl switchxkblayout all 1
    notify-send -h string:synchronous:keyboard "Keyboard" "🇯🇵 Japanese (JP)"
    ;;
esac
