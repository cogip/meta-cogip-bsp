FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}_${LINUX_VERSION}/:"

SRC_URI += " \
    file://defconfig \
    file://rauc.cfg \
    file://wifi.cfg \
"

unset KBUILD_DEFCONFIG
