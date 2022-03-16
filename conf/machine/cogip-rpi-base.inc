# Only build ext4 and tar.bz2 for 'genimage'
IMAGE_FSTYPES = "ext4 tar.bz2"

# No splash screen
unset SPLASH

#
# Bootloader Barebox
#
PREFERRED_PROVIDER_virtual/bootloader = "barebox"
PREFERRED_VERSION_barebox = "2021.03.0"
COMPATIBLE_MACHINE_pn-barebox = "${MACHINE}"
BAREBOX_CONFIG = "rpi_defconfig"

#
# Kernel
#
PREFERRED_PROVIDER_virtual/kernel = "linux-stable"
RPI_KERNEL_DEVICETREE_OVERLAYS = ""

#
# Firmwares
#
MACHINE_EXTRA_RRECOMMENDS = " \
    kernel-modules \
    linux-firmware-bcm43455 \
    udev-rules-rpi \
"

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
    bootfiles/config.txt \
    boot.scr \
    Image \
    u-boot.bin \
"
