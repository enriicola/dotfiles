#!/bin/bash

echo repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc | sudo tee /etc/xbps.d/hyprland-void.conf


sudo xbps-install -Sy


sudo xbps-install -Sy hyprland xdg-desktop-portal-hyprland
sudo xbps-install -Sy mesa-dri


exit


sudo xbps-install -Sy dbus elogind
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/elogind /var/service/
sudo sv start dbus
sudo sv start elogind