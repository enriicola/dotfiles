#!/bin/bash

sudo xbps-install -Sy curl

void-packages=("git" "wget" "htop" "neofetch" "fastfetch" "btop" "vpm" "fzf" "github-cli")
    
for package in "${!void-packages[@]}"; do
   sudo xbps-install -S $package
done

for package in ${!void-packages[@]}; do
   sudo xbps-install -Sy ${void-packages[$package]}
done


git config --global init.defaultBranch main