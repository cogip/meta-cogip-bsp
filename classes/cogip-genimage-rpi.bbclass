inherit cogip-genimage

# Boot partition size in MB.
COGIP_BOOT_SIZE ?= "64"

# Add boot files to a dedicated vfat boot partition
fakeroot do_bootfiles () {
    # Create boot vfat partition
    rm -f ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat
    dd if=/dev/zero of=${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat count=${COGIP_BOOT_SIZE} bs=1M
    mkfs.vfat  ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat

    # Copy boot files to vfat
    for f in ${COGIP_BOOT_FILES}; do
        source=$(echo $f | cut -d ':' -f1)
        dest=$(echo $f | cut -d ':' -f2 -s)

        echo $dest | grep "/" && mmd -i ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat -Ds $(dirname $dest) || true
        mcopy -i ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ${DEPLOY_DIR_IMAGE}/$source ::$dest
    done
}
addtask bootfiles before do_genimage
do_bootfiles[depends] += " \
    ${@'${GENIMAGE_ROOTFS_IMAGE}:do_image_complete' if '${GENIMAGE_ROOTFS_IMAGE}' else ''} \
    dosfstools-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    rpi-config:do_deploy \
    virtual/bootloader:do_deploy \
    virtual/fakeroot-native:do_populate_sysroot \
    virtual/kernel:do_deploy \
"
do_bootfiles[nostamp] = "1"

# bootfiles
do_genimage[depends] += " \
    bootfiles:do_deploy \
"
