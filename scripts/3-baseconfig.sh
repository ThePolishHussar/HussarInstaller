#!/bin/bash
source ./install.conf

ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
hwclock --systohc

sed -i "s/#$LOCALE/$LOCALE/" /etc/locale.gen
locale-gen

echo LANG="$LANGUAGE" > /etc/locale.conf

echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

echo "$HOSTNAME" > /etc/hostname

echo root:"$ROOTPASS" > chpasswd

useradd -m -G wheel -s /bin/zsh "$USERNAME"
sed -i 82c'%wheel ALL=(ALL:ALL) ALL' /etc/sudoers

grub-install "$DISK"
sed i- '6s/ quiet//' /etc/default/grub

### edit these 2 lines
reflector -a 24 -c "$MIRROR" -f 7 -l 15 --sort rare --save /etc/pacman.d/mirrorlist
sed -i "s/ParallelDownloads = 5/ParallelDownloads = $PARALLEL_DL" /etc/pacman.conf

sed -i 's_#[multilib]
#Include = /etc/pacman.d/mirrorlist_[multilib]
Include = /etc/pacman.d/mirrorlist_' /etc/pacman.conf

for MODULE in "${MODULES[@]}"; do
	source ./modules/"$MODULE"
	baseconfig
	unset -f baseconfig
done

