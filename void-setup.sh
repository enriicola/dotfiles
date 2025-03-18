#!/bin/bash

sudo xbps-install git
git config --global init.defaultBranch main

void-packages=(
   "curl"
   "wget"
   "htop"
   "neofetch"
   "fastfetch"
   "btop"
   "vpm"
   "fzf"
   "github-cli"
)
    
for package in "${void-packages[@]}"; do
   sudo xbps-install -S $package
done
