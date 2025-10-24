#!/usr/bin/env bash

SESSION="realtube"

# Start a detached session with the first window
tmux new-session -d -s "$SESSION" -c "$HOME/projects/react/realtube-frontend" -n frontend-vim
tmux send-keys -t "$SESSION:0" "vim ./src" C-m

# Backend Vim window
tmux new-window -t "$SESSION" -c "$HOME/projects/express/realtube" -n backend-vim
tmux send-keys -t "$SESSION:1" "vim ./src" C-m

# Frontend dev server
tmux new-window -t "$SESSION" -c "$HOME/projects/react/realtube-frontend" -n frontend-host
tmux send-keys -t "$SESSION:2" "bun dev" C-m

# Backend dev server
tmux new-window -t "$SESSION" -c "$HOME/projects/express/realtube" -n backend-host
tmux send-keys -t "$SESSION:3" "pnpm run dev" C-m

# Attach to the session
tmux attach -t "$SESSION"

