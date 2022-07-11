#!/bin/bash
source $HOME/HussarInstaller/install.conf

#sudo pacman -S --noconfirm [base packages]

sudo pacman -S --noconfirm --needed git 
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

exit
if [ "$CHAOTIC_AUR" = "true" ]; then
	pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
	pacman-key --lsign-key FBA220DFC880C036
	pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

	echo "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
fi

for MODULE in "${MODULES[@]}"; do
	source "$HOME/HussarInstaller/modules/$MODULE"
	sudo pacman -S --noconfirm --needed "${packages[@]}"
	yay -S --noconfirm --needed "${AURpackages[@]}"
	type 'user' 2>/dev/null | grep -q 'function' && user	
	unset -f user
	unset -v packages
	unset -v AURpackages	
done
