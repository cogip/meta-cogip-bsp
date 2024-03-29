# Only build ext4 and tar.bz2 for 'genimage'
IMAGE_FSTYPES = "ext4 tar.bz2"

#
# Bootloader Barebox
#
PREFERRED_PROVIDER_virtual/bootloader = "barebox"
PREFERRED_VERSION_barebox = "2021.03.0"
COMPATIBLE_MACHINE_pn-barebox = "${MACHINE}"
BAREBOX_CONFIG = "rpi_defconfig"

#
# RPi options
#
# Always turn on UART for debug
ENABLE_UART = "1"
# RPi should boot barebox instead of linux kernel
RPI_KERNEL = "barebox.img"
# Remove comments from config.txt
RPI_CONFIG_STRIP = "1"

# COGIP_BOOT_FILES is similar to IMAGE_BOOT_FILES with separator ';' replaced
# by ':'. ';' separator cannot be used in shell functions.
COGIP_BOOT_FILES = " \
    bootfiles/*.bin \
    bootfiles/*.dat \
    bootfiles/*.dtb \
    bootfiles/*.elf \
    bootfiles/cmdline.txt \
    bootfiles/config.txt \
    bootfiles/overlays \
    zImage:kernel.img \
"
