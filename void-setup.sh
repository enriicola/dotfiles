#!/bin/bash

# sudo xbps-install -Sy curl

sudo xbps-install -Syu

void_packages=(
   "git"
   "wget"
   "htop"
   "neofetch"
   "fastfetch"
   "btop"
   "vpm"
   "fzf"
   "github-cli"
   "trash-cli"
   "tmux"
   "unzip"
)

for package in "${void_packages[@]}"; do
   if ! sudo xbps-install -Sy "$package"; then
      echo "Failed to install $package"
      exit 1
fi
done

git config --global init.defaultBranch main

# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH