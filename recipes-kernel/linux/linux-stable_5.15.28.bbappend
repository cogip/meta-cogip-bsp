FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}_${LINUX_VERSION}/:"

SRC_URI += " \
    file://defconfig \
"

unset KBUILD_DEFCONFIG
