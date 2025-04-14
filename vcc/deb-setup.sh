# wget -qO - https://raw.githubusercontent.com/enriicola/dotfiles/refs/heads/main/vcc/deb-setup.sh | bash

export PATH="$HOME/.local/bin:$PATH"

sudo apt update && sudo apt upgrade

sudo apt install -y curl gh git snapd gnome-tweaks flatpak fzf zoxide gcc-12 libgcc-12-dev build-essential golang neofetch neovim
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

source ~/.bashrc


# install vagrant
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant

vagrant plugin install vagrant-vmware-desktop --plugin-version 3.0.1

# https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro&tab=Solutions
sudo ./vcc/VMware-Workstation-Full-17.6.2-24409262.x86_64.bundle
sudo ./vcc/code_1.99.2-1744250061_amd64.deb

sudo mkdir -p /opt/vagrant-vmware-desktop/certificates/vagrant-utility.client.crt

git clone https://github.com/hashicorp/vagrant-vmware-desktop.git
cd vagrant-vmware-desktop/go_src/vagrant-vmware-utility
go build
./vagrant-vmware-utility certificate generate

sudo cp ~/vagrant-vmware-desktop/go_src/vagrant-vmware-utility/certificates/vagrant-utility.* /opt/vagrant-vmware-desktop/certificates

sudo ./vagrant-vmware-utility api &
