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
   "neovim"
   "yazi"
   "pdfarranger"
   "cmatrix"
   "xmonad"
   "xmonad-contrib"
   "xorg"
   "xinit"
   "ddcutil"
)

for package in "${void_packages[@]}"; do
   if ! sudo xbps-install -Sy "$package"; then
      echo "Failed to install $package"
      exit 1
fi
done

git config --global init.defaultBranch main

# TODO install a browser cli compatible for "gh auth login"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

# TODO install oh-my-zsh

# TODO install atuin

# TODO install zoxide

# TODO configure xmonad

# TODO install smt for night shift for warmer colors at night

# TODO clone dotfiles from "git clone ..." to .config folder

# TODO autostart xinit (& xmonad ?)

# TODO change grub to automatically select void 

# TODO change grup to automatically choose enriicola user (?)

# TODO install smt for bluetooth control from cli

# TODO install smt for audio and brightness slider

# TODO install smt for taking screenshots from cli

# TODO install smt for controlling external displays position permanently from cli

# TODO install nix
	# TODO install nix packages 
		# beeper
		# spotify
		# ...



