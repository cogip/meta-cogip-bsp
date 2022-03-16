FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}_${PV}/:"

SRC_URI += " \
    file://defconfig \
"

unset KBUILD_DEFCONFIG
