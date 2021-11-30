inherit genimage


# Create bmap file
fakeroot do_genimage_append() {
    bmaptool create -o ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.bmap ${B}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}
}
do_genimage[depends] += " \
    bmap-tools-native:do_populate_sysroot \
"

# Link to bmap file
do_deploy_append() {
    ln -sf ${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.bmap ${DEPLOYDIR}/${GENIMAGE_IMAGE_LINK_NAME}.${GENIMAGE_IMAGE_SUFFIX}.bmap
}

# Link rootfs image to genimage image name
do_linkrootfs () {
    # Link to rootfs image to be used in genimage.config
    ln -s ${DEPLOY_DIR_IMAGE}/${GENIMAGE_ROOTFS_IMAGE}-${MACHINE}.ext4 ${DEPLOY_DIR_IMAGE}/${GENIMAGE_IMAGE_NAME}.${GENIMAGE_IMAGE_SUFFIX}.rootfs.ext4
}
addtask linkrootfs after before do_genimage
do_linkrootfs[depends] += "${@'${GENIMAGE_ROOTFS_IMAGE}:do_image_complete' if '${GENIMAGE_ROOTFS_IMAGE}' else ''}"
do_linkrootfs[nostamp] = "1"
