#! /bin/bash
source ./install.conf

pacman -S --noconfirm --needed reflector
sed -i 37c"ParallelDownloads = $PARALLEL_DL" /etc/pacman.conf
reflector -a 48 -c "$MIRROR" -f 15 -l 25 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt \
base base-devel linux linux-firmware \
grub efibootmgr \
networkmanager 
#pacman-contrib git reflector

lscpu | grep GenuineIntel && CPU=intel-ucode
lscpu | grep AuthenticAMD && CPU=amd-ucode

lspci | grep VGA | grep -E "Intel" && GPU="xf86-video-intel mesa"
lspci | grep VGA | grep -E "NVIDIA|GeForce" && GPU="nvidia nvidia-utils"
lspci | grep VGA | grep -E "Radeon|AMD" && GPU="xf86-video-amdgpu mesa"

pacstap -S --noconfirm --needed "$CPU" "$GPU"

genfstab -U /mnt > /mnt/etc/fstab
