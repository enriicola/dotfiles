#!/bin/bash

atuin dotfiles alias set g 'git'
atuin dotfiles alias set gp 'git pull'
atuin dotfiles alias set gs 'git status'
atuin dotfiles alias set gc 'git commit'
atuin dotfiles alias set gcm 'git commit -m'
atuin dotfiles alias set gca 'git commit -am'
atuin dotfiles alias set gco 'git checkout'
atuin dotfiles alias set gb 'git branch'
atuin dotfiles alias set ga 'git add'
atuin dotfiles alias set gaa 'git add -A'
atuin dotfiles alias set gps 'git push'
atuin dotfiles alias set e 'exit'
atuin dotfiles alias set c 'clear'
atuin dotfiles alias set rh 'ranger --cmd="set show_hidden true"'
atuin dotfiles alias set r 'ranger'
atuin dotfiles alias set .r '. ranger'
atuin dotfiles alias set v 'vim'
atuin dotfiles alias set n 'nvim'
atuin dotfiles alias set o 'open'
atuin dotfiles alias set z- 'z -'
atuin dotfiles alias set cd.. 'cd ..'
atuin dotfiles alias set .. 'cd ..'
atuin dotfiles alias set py 'python3'
atuin dotfiles alias set f 'fzf'
atuin dotfiles alias set t 'trash'
atuin dotfiles alias set ada 'atuin dotfiles alias'

atuin dotfiles alias set ùgs 'sh ~/Documents/gs-all.sh'

atuin dotfiles alias set d 'date +"%A %d %B %Y %H:%M:%S"'
atuin dotfiles alias set b 'upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage'

# ada list
# ..=cd ..
# .r=. ranger
# ada=atuin dotfiles alias
# b=brilla
# bd=b && date
# brilla=sudo ddcutil setvcp 10
# c=clear
# cat=batcat
# cd..=cd ..
# d=date +"%A %d %B %Y %H:%M:%S"
# e=exit 0
# f=fzf
# fd=fdfind
# g=git
# ga=git add
# gaa=git add -A
# gb=git branch
# gc=git commit
# gca=git commit -am
# gcm=git commit -m
# gco=git checkout
# gp=git pull
# gps=git push
# gs=git status
# gu=sh ~/Documents/gitup.sh
# ls=eza
# mikai=cd ~/Documents/mikai && sudo ./new-mikai.sh
# n=nvim
# nl-set=gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature
# nloff=gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
# nlon=gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
# nls=sh ~/Documents/nl-switch.sh
# ns=notify-send
# o=open
# off=xset dpms force off
# py=python3
# python=python3
# r=ranger
# rh=ranger --cmd="set show_hidden true"
# s=sudo
# t=trash
# v=vagrant
# void=cd ~/void-vm && quickemu --vm void-20250202-glibc.conf && exit
# vvu=cd ~/vagrant-vmware-desktop/go_src/vagrant-vmware-utility && sudo ./vagrant-vmware-utility api
# y=yazi
# yt=yt-dlp -t mp4
# z-=z -
# è=exec
# ì=sudo $(fc -ln -1)
# ùgs=sh ~/Documents/gs-all.sh