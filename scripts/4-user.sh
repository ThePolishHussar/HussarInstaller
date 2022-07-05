#!/bin/bash
source ./install.conf

sudo pacman -S --noconfirm [base packages]

sudo pacman -S --noconfirm --needed git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

if [ "$CHAOTIC_AUR" = "true" ]; then
	pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
	pacman-key --lsign-key FBA220DFC880C036
	pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

	echo "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
fi

for MODULE in "${MODULES[@]}"; do
	source ./modules/"$MODULE"
	sudo pacman -S --noconfirm --needed "${packages[@]}"
	yay -S --noconfirm --needed "${AURpackages[@]}"
	user	
	unset -f user
	unset -v packages
	unset -v AURpackages	
done
