#! /bin/bash
source $HOME/HussarInstaller/install.conf && echo config cources
# set time, local, etc.
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone ${timezone}
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
ln -s /usr/share/zoneinfo/${timezone} /etc/localtime
# Set keymaps
localectl --no-ask-password set-keymap ${keymap}
#tried before but it refuesed to work :P
#=========
#ln -sf "/usr/share/zoneinfo/${timezone}" /etc/localtime  && echo timezone linked
#hwclock --systohc  && echo adjtime generated
#sed -i "s/^#${locale}/${locale}/" /etc/locale.gen && echo locale.gen edited
#locale-gen && echo locale generated
#echo "LANG=${lang}" > /etc/locale.conf && echo locale.conf written}
#=========
echo "${hostname}" > /etc/hostname 
#set rootpass
echo "root:${rootpass}" | chpasswd
#make & config new user
useradd -m -G wheel -s /bin/bash $username
echo "$username:$userpass" | chpasswd
sed -i 82c"%wheel ALL=(ALL:ALL) ALL" /etc/sudoers
#grub setup
grub-install $disk
sed -i '6s/ quiet"/"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
#download speed up
reflector -a 24 -c ${mirror} -f 7 -l 15 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 37c"ParallelDownloads = ${parallelDL}" /etc/pacman.conf
#enable multilib
sed -i 's/^#[multilib]/[multilib]/' /etc/pacman.conf
sed -i 's/^#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/' /etc/pacman.conf
pacman -Sy --noconfirm
