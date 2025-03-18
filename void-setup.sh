#!/bin/bash

# sudo xbps-install -Sy curl

void_packages=("git" "wget" "htop" "neofetch" "fastfetch" "btop" "vpm" "fzf" "github-cli")

for package in "${void_packages[@]}"; do
   sudo xbps-install -S "$package"
done

git config --global init.defaultBranch main