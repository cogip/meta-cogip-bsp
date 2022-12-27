# Use mainline devicetree for VC4
unset VC4GRAPHICS
unset VC4DTBO

do_deploy:append () {
    # Image is for 64 bit architecture
    if [ "${RPI_64BIT}" = "1" ]; then
        echo "# Kernel image is for 64 bit architecture" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "arm_64bit=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Image to launch
    if [ -n "${RPI_KERNEL}" ]; then
        echo "# Change default booted image" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "kernel=${RPI_KERNEL}" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Device tree used by image
    if [ -n "${RPI_DEVICE_TREE}" ]; then
        echo "# Change default device tree" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "device_tree=${RPI_DEVICE_TREE}" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Device tree overlays
    if [ -n "${RPI_KERNEL_DEVICETREE_OVERLAYS}" ]; then
        echo "# Device tree overlays" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        for overlay in ${RPI_KERNEL_DEVICETREE_OVERLAYS}
        do
            echo "dtoverlay=${overlay}" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        done
    fi

    # Use second stage bootloader UART (debug)
    if [ "${RPI_UART_2NDSTAGE}" = "1" ]; then
        echo "# Use second stage bootloader UART (debug)" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "uart_2ndstage=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Miscellanous configuration
    if [ -n "${RPI_CONFIG_MISC}" ]; then
        echo "# Miscellanous configuration" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "${RPI_CONFIG_MISC}" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Clean comments and empty lines
    if [ "${RPI_CONFIG_STRIP}" = "1" ]; then
        sed -i '/^#/d' ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        sed -i '/^$/d' ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi
}
