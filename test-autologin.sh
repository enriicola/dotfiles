# use sed to change GETTY autologin

sudo sed -i 's/^#.*GETTY_ARGS.*$/GETTY_ARGS="--no-clear -n -o enriicola"/' /etc/sv/agetty-tty1/conf