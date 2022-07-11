#!/bin/bash
source $HOME/HussarInstaller/install.conf

# Pacman Configuration
[ "$PAC_COLOR" = "true" ] && sed -i 's/#Color/Color' /etc/pacman.conf
[ "$CANDY" = "true" ] && sed -i 38a'ILoveCandy' /etc/pacman.conf

# Reflector Configuration
sed -i 's/--sort age/--sort rate' /etx/xdg/reflector/reflector.conf
sed -i 's/--latest 5/--latest 15' /etx/xdg/reflector/reflector.conf
echo "# Use only mirrors syncronized in the past n hours. \n--age 48" >> /etc/xdg/reflector/reflector.conf
echo "# Use mirrors fore defined region. \n-- country $MIRROR" >> /etc/xdg/reflector/reflector.conf
echo "# Return the n fastest mirrors.\n--fastest 15" >> /etc/xdg/reflector/reflector.conf
systemctl enable reflector.service

# Enable NetworkManager
systemctl enable NetworkManager.service

# Enable SSD Trim
[[ "$DISK" =~ 'nvme' ]] && systemctl enable ftrim.timer

for MODULE in "${MODULES[@]}"; do
	source "$HOME/HussarInstaller/modules/$MODULE"
	type 'postconfig' 2>/dev/null | grep -q 'function' && postconfig
	unset -f postconfig
done

