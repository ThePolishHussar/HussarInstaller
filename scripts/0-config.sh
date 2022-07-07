#!/bin/bash
### TODO whiptail rewrite ###

config () {

	clear

 	PS3='Select Disk Number: '
 	lsblk -n --output TYPE,KNAME,SIZE | awk '$1=="disk" {print "/dev/"$2" | "$3}'
 	echo 'Choose Disk:'
	DISK=''
	while [ -z "$DISK" ]; do

	 	select DISK in $(lsblk -n --output TYPE,KNAME | awk '$1=="disk"{print "/dev/"$2}'); do
		 	DISK=$(echo "$DISK" | awk '{print $1}')
     		break
 		done
	done

 	echo "How much swap space do you want?"
 	MEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
 	MEM=$((${MEM::-6}*2))
 	echo Recomended "$MEM"G
 	read -p "Enter amount in GBs : " SWAP_SIZE
 	SWAP_SIZE="${SWAP_SIZE//[!0-9]/}"
 	[ -z "$SWAP_SIZE" ] && SWAP_SIZE="$MEM"
 	SWAP_SIZE="${SWAP_SIZE}G"
 	echo "Do you want to leave a pre-existing home partion intact?"

 	while true; do
	 	read -p "Note: This only works if the home partion is the 4th partion!! [Y/n] " YN
	 	case $YN in
		 	[Nn]* ) RESPECT_HOME="false"; break;;
		 	* ) RESPECT_HOME="true"; break;;
	 	esac
 	done		

 	if [ "$RESPECT_HOME" = "false" ]; then
	 	read -p "How large do you want your root partition to be?
 	Recomended: 100G " ROOT_SIZE
	 	ROOT_SIZE="${ROOT_SIZE//[!0-9]/}"
	 	[ -z "$ROOT_SIZE" ] && ROOT_SIZE=100
	 	ROOT_SIZE="${ROOT_SIZE}G"
 	fi

 	read -p "Choose a hostname: " HOSTNAME
 	[ -z "$HOSTNAME" ] && HOSTNAME="archbox"

 	read -p "Choose a username: " USERNAME
 	[ -z "$USERNAME" ] && USERNAME="user"

 	read -p "Choose a password: " USERPASS
 	[ -z "$USERPASS" ] && USERPASS="password"

 	while true; do
     	read -p "Use same password for root? [Y/n] " yn
     	case $yn in
         	[Nn]* ) read -p "Choose a root password: " ROOTPASS
		 	[ -z "$ROOTPASS" ] && ROOTPASS="password"
		 	break;;
         	* ) ROOTPASS=$USERPASS; break;;
     	esac
 	done

 	localeconf () {
     	read -p "Enter locale: " LOCALE
     	read -p "Enter language: " LANGUAGE
     	read -p "Enter keymap: " KEYMAP
 	}

 	while true; do
	 	read -p "Use US English for language / keyboard layout? [Y/n] " yn
	 	case $yn in
		 	[Nn]* ) localeconf; break;;
		 	* ) LOCALE="en_US.UTF-8 UTF-8" && LANGUAGE="en_US.UTF-8" && KEYMAP="us"; break;;
	 	esac
 	done

 	TIMEZONE=$(curl -s https://ipapi.co/timezone)

 	MIRROR=$(curl -s https://ipapi.co/country)

 	read -p "How many parallel pacman downloads do yau want to allow? (Recomended: 5) " PARALLEL_DL
 	PARALLEL_DL="${PARALLEL_DL//[!0-9]/}"
 	[ -z "$PARALLEL_DL" ] && PARALLEL_DL=5

 	while true; do
	 	read -p "Add and use Chaotic-AUR repository [y/N] " yn
	 	case $yn in
		 	[Yy]* ) CHAOTIC_AUR="true"; break;;
		 	* ) CHAOTIC_AUR="false"; break;;
	 	esac
 	done

 	while true; do
	 	read -p "Enable colored pacman output? [Y/n] " YN
	 	case $yn in
		 	[Nn]* ) PAC_COLOR="false"; break;;
		 	* ) PAC_COLOR="true"; break;;
	 	esac
 	done

 	while true; do
	 	read -p "Enable ILoveCandy easer egg? [Y/n] " YN
	 	case $yn in
		 	[Nn]* ) CANDY="false"; break;;
		 	* ) CANDY="true"; break;;
	 	esac
 	done

 	while true; do
	 	read -p "Leave a coty of script on installed system? [y/N] " YN
	 	case $yn in
		 	[YY]* ) SCRIPT_COPY="true"; break;;
		 	* ) SCRIPT_COPY="false"; break;;
	 	esac
 	done

	MODULES=($(ls ./modules | grep -v '.conf'))

 	for MOD in "${MODULES[@]}"; do
	 	while true; do
		 	read -p "Run $MOD module? [Y/n] " YN
		 	case $YN in
			 	[Nn]* ) declare "$MOD"="false"; break;;
			 	* ) declare "$MOD"="true"; break;;
		 	esac
	 	done
 	done

	[ -f ./install.conf ] && rm ./install.conf

 	SETTINGS=(
 	DISK
 	SWAP_SIZE
 	RESPECT_HOME
 	HOSTNAME
 	USERNAME
 	USERPASS
 	ROOTPASS
 	PARALLEL_DL
 	CHAOTIC_AUR
 	CANDY
 	TIMEZONE
 	MIRROR
 	LANGUAGE
 	KEYMAP
	PAC_COLOR
	SCRIPT_COPY
 	)
	{
 	 	for SET in "${SETTINGS[@]}"; do
	 	 	echo "$SET=${!SET}"
 	 	done
 	 	
 	 	echo 'MODULES=('
 	 	for MOD in "${MODULES[@]}"; do
	 	 	[ "${!MOD}" = true ] && echo "$MOD"
 	 	done
 	 	echo ')'
	} >> ./install.conf
} 	

if [ -f ./install.conf ]; then
	clear
	cat ./install.conf
	while true; do
		read -p "Use these settings? [Y/n] " YN
		case $YN in
			[Nn]* ) config;;
			* ) break;;
		esac
	done

else
	config	

	clear
	cat ./install.conf
	while true; do
		read -p "Use these settings? [Y/n] " YN
		case $YN in
			[Nn]* ) config;;
			* ) break;;
		esac

	done

fi

### Module Configuration

module_config () {
 	for MOD in "${MODULES[@]}"; do
	 	source ./modules/"$MOD"
	 	scriptmod
		unset -f scriptmod
 	done
}

source ./install.conf

for MOD in "${MODULES[@]}"; do
	[ -f modules/"$MOD".conf ] || MODCONFIGS='incomplete' && break
done

[ "$MODCONFIGS" = 'incomplete' ] && module_config

while true; do

[ -f temp_all_mod_confs ] && rm temp_all_mod_confs

for MOD in "${MODULES[@]}"; do
	echo "============================================================" >> temp_all_mod_confs
	echo "$MOD Settings:">> temp_all_mod_confs
	cat "./modules/$MOD.conf" >> temp_all_mod_confs
	echo
done

	clear

	read -p "Use these configs? [View/YES/No] " VYN
	case $VYN in
		[Nn]* )	rm ./modules/*.conf; module_config;; 
		[Vv]* )	less temp_all_mod_confs;;
		* ) break;;
	esac
done

rm temp_all_mod_confs

### TODO add menu to git clone community made modules ###
### TODO make a repo of modules / module manager if this installer gains traction ###

