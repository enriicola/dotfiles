#!/bin/bash
# https://raw.githubusercontent.com/enriicola/dotfiles/refs/heads/main/void/install-hyprland.sh


curl https://raw.githubusercontent.com/enriicola/dotfiles/void/install-hyprland.bash | bash


echo repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc | sudo tee /etc/xbps.d/hyprland-void.conf


sudo xbps-install -S | yes


sudo xbps-install -Sy hyprland xdg-desktop-portal-hyprland
sudo xbps-install -Sy mesa-dri dbus elogind noto-fonts-cjk

sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/elogind /var/service/

sudo sv start dbus
sudo sv start elogind
