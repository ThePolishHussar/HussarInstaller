#!bin/bash
source ./install.conf

if [ "${respectHome}" = "true" ]; then
	#preserve preexisting home partion
	#delete boot, swap and root partion
	sgdisk ${disk} -d=1
	sgdisk ${disk} -d=2
	sgdisk ${disk} -d=3
	#boot part
	sgdisk ${disk} -n=1:0:+512M -t=1:ef00 -c=:'UEFI_BOOT'
	mkfs.fat -F 32 ${disk}1
	#swap part
	sgdisk ${disk} -n=2:0:+${swapSize} -t=2:8200 -C=2:'SWAP'
	mkswap ${disk}2
	#root part
	sgdisk ${disk} -n=3:0:0 -t=3:8300 -c=3:'ROOT'
	mkfs.ext4 ${disk}3
	echo 'Disk repartioned'; sleep 1;
elif [ "${respectHome}" = "false" ]; then
	#wipe drive and make new partions
	#make table
	parted ${disk} mklabel gpt
	echo 'New partion table made'; sleep 1;
	#boot part
	sgdisk ${disk} -n=1:0:+512M -t=1:ef00 -c=1:'UEFI_BOOT'
	mkfs.fat -F 32 ${disk}1
	#swap part
	sgdisk ${disk} -n=2:0:+${swapSize} -t=2:8200 -C=2:'SWAP'
	mkswap ${disk}2
	#root part
	sgdisk ${disk} -n=3:0:+${rootSize} -t=3:8300 -c=3:'ROOT'
	mkfs.ext4 ${disk}3
	#home part
	sgdisk ${disk} -n=4:0:0 -t=4:8300 -c=4:'HOME'
	mkfs.ext4 ${disk}4
	echo 'Disk partioned'; sleep 1;
fi
mount -o noatime,commit=120 ${disk}3 /mnt
mkdir -p /mnt/boot/efi
mkdir -p /mnt/home
mount -o noatime,commit=120 ${disk}4 /mnt/home
mount ${disk}1 /mnt/boot/efi
swapon ${disk}2
