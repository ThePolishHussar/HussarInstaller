#! /bin/bash
source $HOME/HussarInstaller/install.conf
source /home/${username}/HussarInstaller/packages/pacman
for PKG in "${PKGS[@]}"; do
    sudo pacman -S "$PKG" --noconfirm --needed
done

#install yay-bin
cd ~/
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
if [ "${chaoticAUR}" = "false" ]; then
    source /home/${username}/HussarInstaller/packages/yay
    for PKG in "${PKGS[@]}"; do
    yay -S "$PKG" --noconfirm --needed
done
elif [ "${chaoticAUR}" = "true" ]
    sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key FBA220DFC880C036
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    sudo echo '[chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf
    source /home/${username}/HussarInstaller/packages/chaotic_pacman
    for PKG in "${PKGS[@]}"; do
        sudo pacman -S "$PKG" --noconfirm --needed
    done
    source /home/${username}/HussarInstaller/packages/chaotic_yay
    for PKG in "${PKGS[@]}"; do
        yay -S "$PKG" --noconfirm --needed
    done
fi
