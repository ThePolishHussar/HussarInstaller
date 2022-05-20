#! /bin/bash
source ./install.conf
# 1. Pull Fastest mirror and enable parrallel downloads
pacman -S --noconfirm reflector
sed -i 37c"ParallelDownloads = ${parallelDL}" /etc/pacman.conf
reflector -a 24 -c ${mirror} -f 7 -l 15 --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware base-devel grub efibootmgr nano networkmanager reflector $cpu-ucode $gpu
genfstab -U /mnt > /mnt/etc/fstab
