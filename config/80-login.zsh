if [[ -o LOGIN ]]; then
    (( $#commands[tmux] )) && tmux list-sessions 2>/dev/null
fi
