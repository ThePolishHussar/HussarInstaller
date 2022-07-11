#!/bin/bash
source $HOME/HussarInstaller/install.conf

ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
hwclock --systohc

sed -i "s/^#$LOCALE/$LOCALE/" /etc/locale.gen
locale-gen

echo LANG="$LANGUAGE" > /etc/locale.conf

echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

echo "$HOSTNAME" > /etc/hostname

echo root:"$ROOTPASS" > chpasswd

useradd -m -G wheel -s /bin/zsh "$USERNAME"
sed -i 85c'%wheel ALL=(ALL:ALL) ALL' /etc/sudoers

grub-install "$DISK"
sed -i '6s/ quiet//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

### update these 2 lines
reflector -a 24 -c "$MIRROR" -f 7 -l 15 --sort rate --save /etc/pacman.d/mirrorlist
sed -i "s/^#ParallelDownloads = 5/ParallelDownloads = $PARALLEL_DL/" /etc/pacman.conf

### TODO - properly make this line-independent
sed -i 93c'[multilib]' /etc/pacman.conf
sed -i 94c'Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf

rm /bin/sh
ln -s /bin/dash /bin/sh

for MODULE in "${MODULES[@]}"; do
	source "$HOME/HussarInstaller/modules/$MODULE"
	type 'baseconfig' 2>/dev/null | grep -q 'function' && baseconfig
	unset -f baseconfig
done


