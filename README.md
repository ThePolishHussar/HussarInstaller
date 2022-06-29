# HussarInstaller
A highly customizable modular arch install script.

This branch is not functional. Do not use for now. We are open to module subbmissions. [See details bellow.](#module-making-guidelines=)


## Usage

Download the [Arch Linux iso ](https://archlinux.org/download/) and burn it to a USB stick.
Boot into the install medium and connect to the internet.

Then to download the script :
```
# pacman -Sy git
# git clone 
```

If using community made modules, copy the module file into the modules directory:
```
# cp *path/to/module/file* HussarInstaller/modules/*module_name*
```

Finally, executing the script: 
```
# cd HussarInstaller
# sh HussarInstaller.sh
```

If execution fails, ensure execute permissions are given to the main script:
```
# ls -l
-rwxrwxrwx [...] HussarInstaller.sh

# chmod a+rwx HussarInstaller.sh
```


## Features

- Modules
- Multiple small tweaks to polish things out
- Out of the box [ChaoticAUR](https://aur.chaotic.cx/) setup



## Modules

Modules are mini-scripts that allow easy management of aspects of the install process and addition of features.

As of now, community made modules are installed manually, but plans to make this process more user friendly are under way.

### Some community made modules:
| Name  | Desc | git link |
| ------ | ------| ------ |
| oops | its empy | plz make submissions |

## Todo
- Disk encryption, secure boot and TPM support
- Legacy BIOS support
- Module manager & repository in config generator for simpler usage
- TUI/whiptail rewrite of 0-config.sh
- and more...

## Development

Want to contribute? Great!

I'm mainly looking for minmal DE package lists / modules, but improvements, suggestions and documentationa are welcome.

### Module Making Guidelines:

##### Template:
```
#!/bin/bash

# Git Repo Link
# contact details

scriptmod () {
	echo > ./modules/*modulename*.conf
}


baseconfig () {

}

packages=(

)

AURpackages=(

)
	
user () {
	
}

postconfig () {

}
```

#### Basic Rules / Behavior
- scriptmod function is executed at the end of 0-config.sh
- baseconfig function is executed at the end of 3-baseconfig.sh
- Packages listed in packages array are installed using pacman during 4-user.sh
- Packages listed in AURpackages are installed using yay during 4-user.sh
- user function is executed at the end of 4-user.sh
- postconfig function is executed at the end of 5-postconfig.sh
- Additional arrays and functions should be referenced within the above listed ones
- Avoid executing commands outside of functions whenever possible
- Please reserve names that start with 'a' for modules that modify the script or other modules. This ensures they come first alphabetically, thus get executed first.
- All modules must generate a .conf file to allow the function that ensures all configs are present to work properly


Contact me via [matrix](https://matrix.org/) to get your module featured here
@thewingedhussar:matrix.org 



## License

GPL-3.0
