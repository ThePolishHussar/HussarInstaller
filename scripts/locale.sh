#! /bin/bash
source $HOME/HussarArchInstall/install.conf

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone ${timezone}
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
ln -s /usr/share/zoneinfo/${timezone} /etc/localtime
# Set keymaps
localectl --no-ask-password set-keymap ${keymap}

#ln -sf "/usr/share/zoneinfo/${timezone}" /etc/localtime  && echo timezone linked
#hwclock --systohc  && echo adjtime generated
#sed -i "s/^#${locale}/${locale}/" /etc/locale.gen && echo locale.gen edited
#locale-gen && echo locale generated
#echo "LANG=${lang}" > /etc/locale.conf && echp locale.conf written}
