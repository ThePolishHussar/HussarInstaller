#! /bin/bash
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                               Automated Arch Linux                                             ==
==                                               installation script                                              ==
===================================================================================================================="
#TODO:  - no conf by default
#       - detect prexisting conf file
#       - guide user through making conf file
source ./install.conf
#temp, ill work on a propper script for this later
echo "Mirror Country(s):        $mirror"
echo "Parallel Downloads:       $parallelDL"
echo "Locale:                   $locale"
echo "Timezone:                 $timezone"
echo "Language:                 $lang"
echo "Keymap:                   $keymap"
echo "Hostname:                 $hostname"
echo "Root Password:            $rootpass"
echo "Username:                 $username"
echo "User password:            $userpass"
echo "CPU Brand:                $cpu"
echo "GPU Driver Package(s):    $gpu"
echo "Disk for installation:    $disk"
echo "Respect old home:         $respectHome"
echo "Root Partition Size:      $rootSize"
echo "Swap Partition Size:      $swapSize"
echo "Use Chaotic AUR?:         $chaoticAUR"
while true; do
    read -p "Are you ok with these settings? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo 'Then edit install.conf. Canceling installation'; exit;;
        * ) echo "Please answer y or n.";;
    esac
done
sleep 3
clear
while true; do
    read -p "
===========================================
==   Are you sure you want to install    ==
==  Arch? This will wipe $disk !  ==
===========================================
[y/n] " yn
sleep 2
    # * if respectHome = true then home partion will not be wiped
    case $yn in
        [Yy]* ) bash ./scripts/partions.sh; break;;
        [Nn]* ) echo 'Canceling installation'; exit;;
        * ) echo "Please answer y or n.";;
    esac
done
#install linux
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                                Begining Install                                                ==
===================================================================================================================="
sleep 2
bash ./scripts/install.sh
cp -R ../HussarInstaller /mnt/root/HussarInstaller
chmod a+rwx /mnt/root/HussarInstaller/scripts/*
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                                Configuring System                                              ==
===================================================================================================================="
sleep 2
clear
mount -o remount,exec /mnt
arch-chroot /mnt $HOME/HussarInstaller/scripts/sysconf.sh
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                               Installing Programs                                              ==
===================================================================================================================="
sleep 2
#temp set no pass requirement for package management
sed -i 82c"%wheel ALL=(ALL:ALL) NOPASSWD: ALL" /mnt/etc/sudoers

cp -R ../HussarInstaller /mnt/home/$username/HussarInstaller
chmod a+rwx /mnt/home/$username/HussarInstaller/scripts/*
arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/HussarInstaller/scripts/packages.sh

#removal of temp requirement removal
sed -i 82c"%wheel ALL=(ALL:ALL) ALL" /mnt/etc/sudoers

#enable system services
arch-chroot /mnt $HOME/HussarInstaller/scripts/system_services.sh
#copy dotfiles
cp ./configs/home/* /mnt/home/$username/
cp -r ./configs/home/* /mnt/home/$username/.config
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                               Customizing Apps                                                 ==
===================================================================================================================="
sleep 2
bash scripts/customize.sh
#cleanup
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                                  Cleaning Up                                                   ==
===================================================================================================================="
sleep 2
rm -r /mnt/root/HussarInstaller
rm -r /mnt/home/$username/HussarInstaller
rm -r /mnt/home/$username/yay-bin
clear
echo "
 _     _ _     _ _______ _______ _______  ______ _____ __   _ _______ _______ _______               _______  ______
 |_____| |     | |______ |______ |_____| |_____/   |   | \  | |______    |    |_____| |      |      |______ |_____/
 |     | |_____| ______| ______| |     | |    \_ __|__ |  \_| ______|    |    |     | |_____ |_____ |______ |    \_
====================================================================================================================
==                                         Installation complete. You may                                         ==
==                                            reboot into new system.                                             ==
===================================================================================================================="
arch-chroot /mnt neofetch
umount ${disk}4
umount ${disk}1
umount ${disk}3
swapoff ${disk}2
