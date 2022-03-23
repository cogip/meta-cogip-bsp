inherit cogip-genimage

# Boot partition size in MB.
COGIP_BOOT_SIZE ?= "64"

# Aggregate all boot files into a dedicated vfat boot partition
fakeroot do_genimage_prepend () {
    # Create boot vfat partition
    rm -f ${B}/${GENIMAGE_IMAGE_NAME}*.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat
    dd if=/dev/zero of=${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat count=${COGIP_BOOT_SIZE} bs=1M
    mkfs.vfat  ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat

    # Copy boot files to vfat
    for f in ${COGIP_BOOT_FILES}; do
        source=$(echo $f | cut -d ':' -f1)
        dest=$(echo $f | cut -d ':' -f2 -s)

        echo $dest | grep "/" && mmd -i ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat -Ds $(dirname $dest) || true
        mcopy -v -n -i ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ${DEPLOY_DIR_IMAGE}/$source ::$dest || \
            (bberror "Error copying ${B}/$source to ::$dest ! Possible cause: the file already exists."; exit 1)
    done

    # As genimage is using @IMAGE@ placeholder, replaced with GENIMAGE_ROOTFS_IMAGE which points to the final deployment directory DEPLOY_DIR_IMAGE,
    # vfat boot partition file has to be placed there too temporarily (see do_genimage_append below).
    cp -f ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat
}
do_genimage[depends] += " \
    bootfiles:do_deploy \
    dosfstools-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    rpi-config:do_deploy \
    virtual/bootloader:do_deploy \
    virtual/fakeroot-native:do_populate_sysroot \
    virtual/kernel:do_deploy \
"

fakeroot do_genimage_append () {
    # Remove temporarily added vfat boot partition from final deployment directory DEPLOY_DIR_IMAGE (see do_genimage_prepend above).
    rm -f ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat
}

# Link to vfat boot partition file
do_deploy_append() {
    # Copy vfat boot partition file to temporary deploy dir, to be cached into shared state cache
    cp -f ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ${DEPLOYDIR}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat

    # Create human readable symlink
    if [ -f ${DEPLOYDIR}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ]; then
        ln -sf ${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat ${DEPLOYDIR}/${GENIMAGE_IMAGE_LINK_NAME}.${GENIMAGE_IMAGE_SUFFIX}.boot.vfat
    fi
}
