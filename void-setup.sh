#!/bin/bash

red="\e[31m"
end="\e[0m"

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
   "xrandr"
   "fzf"
   "github-cli"
   "trash-cli"
   "tmux"
   "unzip"
   "neovim"
   "yazi"
   "pdfarranger"
   "cmatrix"
   "ddcutil"
   "handbrake"
   "vscode"
)


for package in "${void_packages[@]}"; do
   if ! sudo xbps-install -Sy "$package"; then
      echo -e "${red}Error installing $package${end}"
      exit 1
fi
done

git config --global init.defaultBranch main
# git config --global user.email "enriicola@proton.me"
# git config --global user.name "enriicola"

# TODO install a browser cli compatible for "gh auth login"

# gh auth login

# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH

# TODO install oh-my-zsh

# TODO install atuin

# TODO install python

# TODO install pip

# TODO install zoxide

# TODO install auto-cpu-freq

# TODO install hyprland and dependencies
# TODO add keybindings for ddcutil
#	super b +- -> my_script.sh
#	myscript.sh{
#		getvcp 10
#		sevcp @ result +- 5
#	}

# TODO setup sudoers for ddcutil, reboot and poweroff

# TODO install smt for night shift for warmer colors at night

# TODO clone dotfiles from "git clone ..." to .config folder

# TODO autostart xinit (& xmonad ?)

sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
if [[ $? -ne 0 ]]; then
   echo -e "${red}Error changing GRUB_TIMEOUT${end}"
   exit 1
fi
sudo update-grub
if [[ $? -ne 0 ]]; then
   echo -e "${red}Error updating GRUB${end}"
   exit 1
fi







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



