#!/usr/bin/env bash

# Remove old package cache files .. /var/cache/pacman/pkg & /var/lib/pacman
sudo pacman -Sc

# Remove...
sudo pacman -Rns "$(pacman -Qdtq)" || true
