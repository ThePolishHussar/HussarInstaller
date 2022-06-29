#! /bin/bash
source ./install.conf

pacman -S --noconfirm --needed reflector
sed -i 37c"ParallelDownloads = ${parallelDL}" /etc/pacman.conf
reflector -a 48 -c ${mirror} -f 15 -l 25 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt \
base base-devel linux linux-firmware \
grub efibootmgr \
networkmanager 
#pacman-contrib git reflector

lscpu | grep GenuineIntel && cpu=intel-ucode
lscpu | grep AuthenticAMD && cpu=amd-ucode

lspci | grep VGA | grep -E "Intel" && gpu="xf86-video-intel mesa"
lspci | grep VGA | grep -E "NVIDIA|GeForce" && gpu="nvidia nvidia-utils"
lspci | grep VGA | grep -E "Radeon|AMD" && gpu="xf86-video-amdgpu mesa"

pacstap -S --noconfirm --needed $cpu $gpu

genfstab -U /mnt > /mnt/etc/fstab
