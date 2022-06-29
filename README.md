# HussarInstaller
Customizable Arch Linux Install Script

This branch is not functional. Do not use for now. We are open to module subbmissions. See details:

### Module Making Guidelines:

##### Template:
```
#!/bin/bash

# https://github.com/username/repo/
# contact details

scriptmod () {
    
}


baseconfig () {

}

user () {
	packages=(

	)

	AURpackages=(

	)
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
