#!/bin/bash

red="\e[31m"
end="\e[0m"

# sudo xbps-install -Sy curl

sudo xbps-install -Syu

URL="https://raw.githubusercontent.com/enriicola/dotfiles/main/packages.txt"

FILE_CONTENT=$(wget -qO - "$URL")
if [[ $? -ne 0 ]]; then
   echo -e "${red}Failed to download the file.${end}"
   exit 1
fi

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





# TODO install and setup lazyvim

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



# TODO install hyprland and dependencies
   # TODO add keybindings for ddcutil
   #	super b +- -> my_script.sh
   #	myscript.sh{
   #		getvcp 10
   #		sevcp @ result +- 5
   #	}
   # TODO add master-stack layout
      # TODO add master-stack layout keybindings (expand, shrink, decrese/increase number of masters)
      # TODO add spriral mode layout for the stack windows
   # TODO add full-screen/tabbed layout
      # TODO add window specific full-screen/tabbed layout
   # TODO add floating layout
      # TODO add window specific floating keybinding
   # TODO add column layout
   # TODO add toggle layout keybinding
   # TODO add toggle borders keybinding
   # TODO add toggle gaps keybinding
   # TODO add toggle status bar keybinding
   # TODO add grab and move windows keybinding
   # TODO add adjustable space between windows keybinding
   # TODO add adjustable space from borders keybinding
   # TODO add workspace specific keybindings
   # TODO add prompt for terminal keybinding
   # TODO add prompt for browser keybinding
   # TODO add prompt for file manager keybinding
   # TODO add prompt for calculator keybinding
   # TODO add prompt for battery status keybinding
   # TODO add prompt for volume control keybinding
   # TODO add prompt for brightness control keybinding
   # TODO add prompt for date and time keybinding
   # TODO add prompt for shutdown/reboot keybinding
   # TODO add prompt for lock screen keybinding
   # TODO add prompt for suspend keybinding
   # TODO unfocused windows transparency
   # TODO add keybinding for moving windows between workspaces
   # TODO add keybinding for moving windows between monitors or workspaces
   # TODO add keybinding for moving windows to a specific workspace
