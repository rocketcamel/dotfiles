#!/usr/bin/env bash

projects=$(find ~/src -maxdepth 1 -type d -not -path ~/src | xargs -I {} basename {})
projects="$projects"$'\n'"dotfiles"
projects="$projects"$'\n'"new"

selected=$(echo "$projects" | rofi -dmenu -p "Select project:")

create_new_project() {
    local project_name
    project_name=$(rofi -dmenu -p "Enter new project name:")
    
    if [[ -z "$project_name" ]]; then
        return
    fi
    
    local project_path="$HOME/src/$project_name"
    
    if [[ -d "$project_path" ]]; then
        notify-send "Error" "Project $project_name already exists"
        return
    fi
    
    mkdir -p "$project_path"
    cd "$project_path"
    notify-send "Success" "Created new project: $project_name"
    
    ghostty --working-directory="$project_path" -e bash -c "
    open_project() {
      local name=\"\$1\"
      local path=\"\$2\"
      if tmux has-session -t \"\$name\" 2>/dev/null; then
        tmux attach-session -t \"\$name\"
      else
        tmux new-session -s \"\$name\" -c \"\$path\"
      fi
    }; open_project '$project_name' '$project_path'"
}

open_existing_project() {
    local name="$1"
    local path="$2"
    
    if [[ ! -d "$path" ]]; then
        notify-send "Error" "Project directory $path does not exist"
        return
    fi
    
    ghostty --working-directory="$path" -e bash -c "
    open_project() {
      local name=\"\$1\"
      local path=\"\$2\"
      if tmux has-session -t \"\$name\" 2>/dev/null; then
        tmux attach-session -t \"\$name\"
      else
        tmux new-session -s \"\$name\" -c \"\$path\"
      fi
    }; open_project '$name' '$path'"
}

[[ -z "$selected" ]] && exit 0

case "$selected" in
    "new")
        create_new_project
        ;;
    "dotfiles")
        open_existing_project "$selected" "$HOME/dotfiles"
        ;;
    *)
        open_existing_project "$selected" "$HOME/src/$selected"
        ;;
esac
