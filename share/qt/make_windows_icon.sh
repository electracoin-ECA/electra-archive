#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/Electra.ico

convert ../../src/qt/res/icons/Electra-16.png ../../src/qt/res/icons/Electra-32.png ../../src/qt/res/icons/Electra-48.png ${ICON_DST}
