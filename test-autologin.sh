echo ciao

sudo sed -i 's/^\t\tGETTY_ARGS=.*/\t\tGETTY_ARGS="--no-clear -n -o enriicola"/' /etc/sv/agetty-tty1/conf

echo ciao