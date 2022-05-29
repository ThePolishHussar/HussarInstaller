#  HussarInstaller
A simple automated arch installer

# Featuring:

Simple install.conf file for system adaptation

Dedicated /home/ partition

homefolder copying supported (copy contents into /configs/home

# Planned Features:
- (in dev branch) Automated or guided config setup if prexisting install.conf not found (auto detect cpu gpu etc. ask user about prefrences regarding system configuration)
- Legacy BIOS support
- more options

# Known Bugs:
aur packages may fail to install, including ly, the display manager. You will boot into a tty.
configs may fail to copy
