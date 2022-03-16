# Only build ext4 and tar.bz2 for 'genimage'
IMAGE_FSTYPES = "ext4 tar.bz2"

# No splash screen
unset SPLASH

#
# Bootloader
#
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"
PREFERRED_PROVIDER_u-boot = "u-boot"
PREFERRED_PROVIDER_u-boot-default-script = "u-boot-scr"
UBOOT_BINARY = "u-boot.bin"

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
# RPi should boot bootloader instead of linux kernel
RPI_KERNEL = "u-boot.bin"
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
