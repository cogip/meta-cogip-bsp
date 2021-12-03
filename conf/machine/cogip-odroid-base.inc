# Only build ext4 and tar.bz2 for 'genimage'
IMAGE_FSTYPES = "ext4 tar.bz2"

DEFAULTTUNE = "cortexa15thf-neon-vfpv4"
include conf/machine/include/tune-cortexa15.inc
SOC_FAMILY = "odroid"
include conf/machine/include/soc_family.inc

#
# Bootloader Barebox
#
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"
PREFERRED_PROVIDER_u-boot = "u-boot"
UBOOT_BINARY = "u-boot-dtb.bin"

#
# Kernel
#
PREFERRED_PROVIDER_virtual/kernel ?= "linux-stable"
# Default kernel configuration
KBUILD_DEFCONFIG ?= "exynos_defconfig"

#
# Dependencies
#
EXTRA_IMAGEDEPENDS += " \
    odroid-firmware \
    virtual/bootloader \
"
