#!/usr/bin/env bash

projects=$(find ~/src -maxdepth 1 -type d -not -path ~/src | xargs -I {} basename {})
projects="$projects"$'\n'"dotfiles"

selected=$(echo "$projects" | rofi -dmenu -p "Select project:")

if [[ -n "$selected" ]]; then
    if [[ "$selected" == "dotfiles" ]]; then
        project_path="$HOME/dotfiles"
    else
        project_path="$HOME/src/$selected"
    fi
    
    if [[ -d "$project_path" ]]; then
        ghostty --working-directory="$project_path" -e bash -c "
            # Check if tmux session already exists
            if tmux has-session -t '$selected' 2>/dev/null; then
                tmux attach-session -t '$selected'
            else
                tmux new-session -s '$selected' -c '$project_path'
            fi
        "
    else
        notify-send "Error" "Project directory $project_path does not exist"
    fi
fi
