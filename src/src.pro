TEMPLATE=subdirs

CONFIG += ordered

SUBDIRS= \
    core \
    gui

core.file=core.pro

gui.file=gui.pro
gui.depends=core
