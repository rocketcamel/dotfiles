session=$(tmux ls | fzf | cut -d: -f1)
if [ -n "$session" ]; then
    tmux a -t "$session"
fi
