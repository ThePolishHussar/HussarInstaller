#!/bin/bash
source ./install.conf
umount "${DISK}?*"

if [ "${RESPECT_HOME}" = "true" ]; then
	#preserve preexisting home partion
	#delete boot, swap and root partion
	sgdisk ${DISK} -d=1
	sgdisk ${DISK} -d=2
	sgdisk ${DISK} -d=3
	
	sgdisk ${DISK} -n=1:0:+512M -t=1:ef00 -c=:'UEFI_BOOT'
	sgdisk ${DISK} -n=2:0:+${SWAP_SIZE} -t=2:8200 -C=2:'SWAP'
	sgdisk ${DISK} -n=3:0:0 -t=3:8300 -c=3:'ROOT'
	if [[ "$DISK" =~ "nvme" ]] then;
		mkfs.fat -F 32 ${DISK}p1
		mkswap ${DISK}p2
		mkfs.ext4 ${DISK}p3
	else
		mkfs.fat -F 32 ${DISK}1
		mkswap ${DISK}2
		mkfs.ext4 ${DISK}3
	fi
elif [ "${RESPECT_HOME}" = "false" ]; then
	parted ${DISK} mklabel gpt
	
	sgdisk ${DISK} -n=1:0:+512M -t=1:ef00 -c=1:'UEFI_BOOT'
	sgdisk ${DISK} -n=2:0:+$SWAP_SIZE -t=2:8200 -C=2:'SWAP'
	sgdisk ${DISK} -n=3:0:+$ROOT_SIZE -t=3:8300 -c=3:'ROOT'
	sgdisk ${DISK} -n=4:0:0 -t=4:8300 -c=4:'HOME'
	
	if [[ "$DISK" =~ "nvme" ]] then;
		mkfs.fat -F 32 ${DISK}p1
		mkswap ${DISK}p2
		mkfs.ext4 ${DISK}p3
		mkfs.ext4 ${DISK}p4
	else
		mkfs.fat -F 32 ${DISK}1
		mkswap ${DISK}2
		mkfs.ext4 ${DISK}3
		mkfs.ext4 ${DISK}4
	fi
fi

if [[ "$DISK" =~ "nvme" ]] then;
	mount ${DISK}p3 /mnt
	mkdir -p /mnt/boot/efi
	mkdir -p /mnt/home
	mount ${DISK}p4 /mnt/home
	mount ${DISK}p1 /mnt/boot/efi
	swapon ${DISK}p2
else
	mount ${DISK}3 /mnt
	mkdir -p /mnt/boot/efi
	mkdir -p /mnt/home
	mount ${DISK}4 /mnt/home
	mount ${DISK}1 /mnt/boot/efi
	swapon ${DISK}2
fi

