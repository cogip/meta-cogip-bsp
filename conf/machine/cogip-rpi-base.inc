# Base COGIP machine configuration
require cogip-base.inc

# Only build ext4 and tar.bz2 for 'genimage'
IMAGE_FSTYPES = "ext4 tar.bz2"

# No splash screen
unset SPLASH

# Enable VC4
MACHINE_FEATURES = " \
    vc4graphics \
"

#
# Bootloader
#
PREFERRED_PROVIDER_virtual/bootloader = "barebox"
PREFERRED_VERSION_barebox = "2022.12.0"
COMPATIBLE_MACHINE_pn-barebox = "${MACHINE}"
BAREBOX_CONFIG = "rpi_v8a_defconfig"

#
# Kernel
#
PREFERRED_PROVIDER_virtual/kernel = "linux-stable"
# Overlays
RPI_KERNEL_DEVICETREE_OVERLAYS = " \
"
KERNEL_IMAGETYPE_DIRECT = "Image"

# Override cmdline as SD card is mmcblk1
CMDLINE_ROOTFS = "root=/dev/mmcblk1p4 ${CMDLINE_ROOT_FSTYPE} rootwait"

#
# Firmwares
#
MACHINE_EXTRA_RRECOMMENDS = " \
    kernel-modules \
    linux-firmware-bcm43455 \
    udev-rules-rpi \
    wireless-regdb-static \
"

#
# RPi options
#
# Always use 64 bits architecture
RPI_64BIT = "1"
# Always turn on UART for debug
ENABLE_UART = "1"
# Enable UART output for second stage bootloader
RPI_UART_2NDSTAGE = "1"
# RPi should boot bootloader instead of linux kernel
RPI_KERNEL = "barebox-raspberry-pi.img"
# Remove comments from config.txt
RPI_CONFIG_STRIP = "1"
# Miscellanous configuration
RPI_CONFIG_MISC = "\n\
max_usb_current=1\n\
hdmi_group=2\n\
hdmi_mode=87\n\
hdmi_cvt 800 480 60 6 0 0 0\n\
hdmi_drive=1\n\
"

# Where downloaded Raspberry bootfiles are extracted
BOOTFILES_DIR_NAME = "${MACHINE}-bootfiles"

# COGIP_BOOT_FILES is similar to IMAGE_BOOT_FILES with separator ';' replaced
# by ':'. ';' separator cannot be used in shell functions.
COGIP_BOOT_FILES = " \
    ${BOOTFILES_DIR_NAME}/cmdline.txt \
    ${BOOTFILES_DIR_NAME}/config.txt \
    Image:kernel8.img \
    ${RPI_KERNEL} \
"
