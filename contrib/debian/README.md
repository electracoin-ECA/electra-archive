
Debian
====================
This directory contains files used to package electrad/electra-qt
for Debian-based Linux systems. If you compile electrad/electra-qt yourself, there are some useful files here.

## electra: URI support ##


electra-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install electra-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your electraqt binary to `/usr/bin`
and the `../../share/pixmaps/electra128.png` to `/usr/share/pixmaps`

electra-qt.protocol (KDE)

