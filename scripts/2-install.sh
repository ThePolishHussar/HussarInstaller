#!/bin/bash
source $HOME/HussarInstaller/install.conf

pacman -Sy --noconfirm --needed reflector
sed -i 37c"ParallelDownloads = $PARALLEL_DL" /etc/pacman.conf
reflector -a 48 -c "$MIRROR" -f 15 -l 15 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel linux linux-firmware grub efibootmgr networkmanager reflector zsh dash 

lscpu | grep GenuineIntel && pacstrap /mnt intel-ucode
lscpu | grep AuthenticAMD && pacstrap /mnt amd-ucode

lspci | grep VGA | grep -E "Intel" && pacstrap /mnt 'xf86-video-intel mesa'
lspci | grep VGA | grep -E "NVIDIA|GeForce" && pacstrap /mnt 'nvidia nvidia-utils'
lspci | grep VGA | grep -E "Radeon|AMD" && pacstrap /mnt 'xf86-video-amdgpu mesa'

[[ "$DISK" =~ 'nvme' ]] && pacman -S --noconfirm --needed util-linux

genfstab -U /mnt > /mnt/etc/fstab
