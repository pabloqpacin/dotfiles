#!/usr/bin/env bash

if command -v asciiquarium; then
  exit 1
fi

if ! docker image ls | grep asciiquarium; then
  docker compose build
fi

if ! grep asciiquarium ~/.zshrc; then
  tee -a ~/.zshrc << EOF

asciiquarium(){
  docker run --rm --tty asciiquarium
}
EOF
fi

