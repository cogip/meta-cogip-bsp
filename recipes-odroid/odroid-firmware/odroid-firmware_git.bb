LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://LICENSE;md5=84dcc94da3adb52b53ae4fa38fe49e5d"

SRC_URI = " \
    https://raw.githubusercontent.com/hardkernel/u-boot/${ODROID_FIRMWARE_BRANCH}/sd_fuse/bl1.bin.hardkernel;name=bl1 \
    https://raw.githubusercontent.com/hardkernel/u-boot/${ODROID_FIRMWARE_BRANCH}/sd_fuse/bl2.bin.hardkernel.720k_uboot;name=bl2 \
    https://raw.githubusercontent.com/hardkernel/u-boot/${ODROID_FIRMWARE_BRANCH}/sd_fuse/tzsw.bin.hardkernel;name=tzsw \
"

SRC_URI[bl1.sha256sum] = "7b940288acfcabd9388d59b785d1527b2d5ff9aaa36e63f970e054a9b695be31"
SRC_URI[bl2.sha256sum] = "d23504b1bdafbc63ad39fd89c23002f536658e1b4fe4516462dc261a9c8ca698"
SRC_URI[tzsw.sha256sum] = "dacbe8e367c13272477066f84f81d20fe47078154007ed1f2773722354639810"

DEPENDS = " \
    coreutils-native\
"

S = "${WORKDIR}"

do_deploy () {
    install -d ${DEPLOYDIR}/odroid-firmware/
    install -m 755 ${S}/*.hardkernel* ${DEPLOYDIR}/odroid-firmware/

    # Extracted from buildroot:
    # The bl1.bin.hardkernel file provided by the uboot hardkernel repository is overwritten
    # by the bl2.bin.hardkernel in the sd_fusing.sh script because it is too big.
    # In order to implement this in genimage, we need to truncate the bl1.bin file
    # so that it does not exceed the available place.
    # An issue has been filled about this: https://github.com/hardkernel/u-boot/issues/45
    truncate -s 15360 ${DEPLOYDIR}/odroid-firmware/bl1.bin.hardkernel
}
addtask deploy before do_build after do_install

inherit deploy
