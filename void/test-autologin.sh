sudo sed -i 's/^\t\tGETTY_ARGS=.*/\t\tGETTY_ARGS="--no-clear -n -o enriicola"/' /etc/sv/agetty-tty1/conf

sudo sv restart agetty-tty1