bluetoothctl devices | fzf | awk '{print $2}' | xargs -r bluetoothctl connect
