
Debian
====================
This directory contains files used to package myced/myce-qt
for Debian-based Linux systems. If you compile myced/myce-qt yourself, there are some useful files here.

## myce: URI support ##


myce-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install myce-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your myceqt binary to `/usr/bin`
and the `../../share/pixmaps/myce128.png` to `/usr/share/pixmaps`

myce-qt.protocol (KDE)

