#! /bin/bash
#this portion is highly personal prefrence and may conflict with many people user experience. either comment out this portion in the main script or use the defaults, i will not adjust this portion of the script (customize.sh & configs directory) based on feedback
#IT IS BASED ENTIRLEY OFF OF MY PERSONAL PREF
source $HOME/HussarInstaller/install.conf

cp -r configs/home/.  /mnt/home/$username/

#pull HussarLibrary
mkdir /mnt/home/$username/Scripts
git clone https://github.com/ThePolishHussar/HussarLibrary/ $username/Scripts

#pull Derek Taylor's (aka DistroTube) wallpaper collection
mkdir -p /mnt/home/$username/Pictures/wallpapers
git clone https://gitlab.com/dwt1/wallpapers.git /mnt/home/$username/Pictures/wallpapers

#make and copy kde rice here
