require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc

SRCREV = "d637294e264adfeb29f390dfc393106fd4d41b17"

SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master \
"

DEPENDS += "bc-native dtc-native"
