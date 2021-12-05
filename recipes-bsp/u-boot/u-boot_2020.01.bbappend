FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}_${PV}:"

DEPENDS += "u-boot-mkimage-native"

SRC_URI += " \
    file://${UBOOT_ENV}.cmd;subdir=${BP} \
"

UBOOT_DIR = "${WORKDIR}/${BP}"

do_compile_append() {
    # Compile boot.scr script
    if [ -f ${UBOOT_DIR}/${UBOOT_ENV}.cmd ]; then
        uboot-mkimage -C none -A arm -T script -d ${UBOOT_DIR}/${UBOOT_ENV}.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
    fi
}

UBOOT_ENV = "boot"
UBOOT_ENV_SUFFIX = "scr"
