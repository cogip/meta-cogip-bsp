inherit cogip-genimage

DEPENDS += " \
    mtools-native \
"

fakeroot do_configure:prepend () {
    sed -i 's!@BOOTLOADER@!${UBOOT_BINARY}!g' ${WORKDIR}/genimage.config
}
