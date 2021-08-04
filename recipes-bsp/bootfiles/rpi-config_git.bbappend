do_deploy_append () {
    # Kernel image to launch
    if [ -n "${RPI_KERNEL}" ]; then
        echo "# Change default booted image" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "kernel=${RPI_KERNEL}" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi

    # Use mini-uart
    if [ "${RPI_UART_2NDSTAGE}" = "1" ]; then
        echo "# Use mini-uart" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
        echo "uart_2ndstage=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    fi
}
