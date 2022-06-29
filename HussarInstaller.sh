#!/bin/bash

### Branding

cmod a+rwx ./scripts/*

./scripts/0-config.sh

source ./install.conf

./scripts/1-paritions.sh

./scripts/2-install.sh

cp -r ../HussarInstaller /mnt/root/HussarInstaller

arch-chroot /mnt $HOME/HussarInstaller/scripts/3-baseconf.sh

sed -i 32c"%wheel ALL=(ALL:ALL) NOPASSWD: ALL" /mnt/etc/sudoers
cp -r ../HussarInstaller /mnt/home/$USERNAME/HussarInstaller
chmod a+rwx /mnt/home/$USERNAME/HussarInstaller/scripts/*
chmod a+rwx /mnt/home/$USERNAME/HussarInstaller/modules/*
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/HussarInstaller/scripts/4-user.sh

arch-chroot /mnt $HOME/HussarInstaller/scripts/5-postconfig.sh

clear
echo "Install Complete"

msg () {
	echo "Thank you for using HussarInstaller. 
            Consider making and sharing your modules. 
    See my other projects at https://github.com/ThePolishHussar
                   See github for details.
===================================================================
                     .0KOKW0KXKXOXKXKk0                                
                     okOKXxW0WOOXK0KK0: ;                             
                      0x0Kok000K0N00XOd.X                             
                      odO0ooNdOMOMK0NOdK.                             
                       XlNkdxXO00NXkKK0W                              
                       dlkd0,odOOKKOONKx  k.                          
                        okOOcoloxdOX0KX  00l.                         
                         ckkc:,;ll;O0K. x0XK.                         
         ..               .kkdxdo'ccO:.0XOK                           
     .oO0                  :xOOKOl.co0KXX:  o;                        
     ONl                    dx0kOxc.cOOk..;OO.                        
    :KK                      x0OKOkx.xol'k0OK;c                       
    .KO                      .kkx0Olc.0x0k:;oxo                       
     OK                       :kOkOo,,.OOOx00Ol.                      
     ,O.                   .,dloooxcl. ck0K0K0Ol                      
      Oo                  ,l:cxOOkcl:   O0OKKkK:.                     
      .k.                 ;:l:xoOOko'.. .OOK00Oll                     
     .'lo;..              ,oll;xkx,X0x;. :O000O';                     
      ,...;c:',....   ..,::co;lldok0MKWkkllxccd:                      
           .:lOkKx0lol:;kKo.0x0K0MOoMKKcx0XMW0kx.                     
               ;NWdXXMW0l. .'dokkokNK0;kd,lllkc:c                     
                     .     . ldXWNMMWx;:MKc.;cdkd,                    
                           ;l0OKN0000c' ,XWx..,:o0k,k0'.              
                           .'::kkKNMMX .,.:lc:' doo0K0X0,             
                            .clKOOONMM; l. .00oco0XXKooo.             
                              ,oOxOOo:o,o..;c:dKWWX0kc:               
                                :k:,..;0o'codxdl;, ....               
                                ,... 'WXX;:cl: ..;:dxOOOOxx:          
                             :;,kd;.o.do''l0OOldOONXX0oOkkK0d;        
                           lNKKK0XkNK,,,OO00dxNkWWNMMMKkkOOkKk; '     
                         .d00d:Xlokd :ocx0NNMMM0MMWXMMMOdkOOkkxxo     
                        'kWMMMOdd,. d0doNMMMMMMXWMMW0MKxkkOkxc0Mx'    
                       lXMMMMOodxd,;NxoWMMMMMMMMk0MWcN0dcOkK0oMM0o;   
                      lMMMMMWoOK0d'WxdNMMMMMMMMMMl0xcxKMW0OkO0MN,:k   
                     .NMMMWx'kXX0,0WxNMMMMMMMMMWkc;.,cccld:oxdkd.lo   
                     okKXdd..xX0dlMkXMMMMMMMMW0o'...,::,...'..'c, .   
                    lKMMMW'.'ol'dWO0MMMMMMMNMo.';OXWMM0x;,. ,....     
                    WMMMM0llWc.0MXlWMMMMMMWWM;xXWMMMMXl'     ., .     
                   .MMMM0xkMM,.kW;KMWMMMNMWNXlKcMMMMMMNxc, ..;l0.     
                    MMMKxdMMX.c.llWMNWMMKMMKOlc ;0MMMMMMXolkKWMMl     
                   ,WMKO'NMMd.Wc'kMMMXWMOMMKk0';,kMMMMMMMWWMMMMN'     
                   xxOxc:NMMXdMO;,0MMM0XNdMk'WlWWMMMMMMWWMMMMM:       
                  d:dOd:oKMMMMMN,c.:KMMdNd;,cM0NMMMMMMNXMMMMWk        
                 okW0O'l;KKMMMMMd:xl.'d:xMc.'N00MMMMMWkMWMMKN         
                 0x. 'c, dcXMMMMkdOll,:..,d..ldxMMMMM:KKNMx,          
                  oKX.   kX.dWMMW.K0WklxNx, ..lcMMWKOddOMX            
                        cMMMO'0MMK.kMMM0cc  ...l0xc;. ldW.            
                        xMMMMKXXXMk,;KMMK. ....'l;'.. .:.             
                        .NMMMMOMOxdNO,;k. .d,;c:;'....':              
                         'WMMMx0M. ,WW' .lxl' xMMM:.'  
================================================================="
	sleep 1
	echo 
	echo 'Options used::
================================================================='
	cat install.conf	
	echo 	
	for mod in "${MODULES[@]}"; do
		echo " ${mod^} options used: 
==================================================================="
		cat "./modules/$mod.conf"
		echo
	done
}

rm -r /mnt/root/HussarInstaller
[ "$SCRIPT_COPY" == "true" ] || rm -r /mnt/home/$USERNAME/HussarInstaller && msg > /mnt/home/$USERNAME/HussarInstaller

sed -i 32c"%wheel ALL=(ALL:ALL) ALL" /mnt/etc/sudoers
rm -r /mnt/root/HussarInstaller
rm -r /mnt/$USERNAME/HussarInstaller

umount /mnt/boot/efi
umount /mnt/home
swapoff ${DISK}2
umount /mnt 

