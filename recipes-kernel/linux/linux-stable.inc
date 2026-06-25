SUMMARY = "Linux mainline -stable kernel (kernel.org) for Cogip"
DESCRIPTION = "Vanilla kernel.org -stable tree (NOT the Raspberry Pi vendor \
fork), built fully monolithic (no modules) with a trimmed Cogip defconfig. \
The board is described by a real device tree (bcm2711-rpi-4-b-cogip.dts) \
dropped straight into the kernel source tree, instead of config.txt overlays. \
This is the Cogip 'mainline' BSP philosophy."
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

# Reuse the generic linux-yocto machinery (kernel-yocto config handling,
# defconfig + .cfg fragments), but point it at the vanilla -stable tree.
require recipes-kernel/linux/linux-yocto.inc

# Plain defconfig recipe: no yocto-kernel-cache / KERNEL_FEATURES metadata.
unset KERNEL_FEATURES

# Pin the git unpack to ${UNPACKDIR}/git (destsuffix=git in SRC_URI) so S is
# correct regardless of BB_GIT_DEFAULT_DESTSUFFIX (which defaults to ${BP} on
# wrynose, leaving S=.../git pointing at nothing -> do_symlink_kernsrc fails).
S = "${UNPACKDIR}/git"

# The recipe filename carries the version (linux-stable_<x.y.z>.bb -> PV);
# the matching git tag is v<x.y.z>.
LINUX_VERSION ?= "${PV}"
SRCREV = "v${LINUX_VERSION}"

# Vanilla -stable tree (tag fetch via nobranch=1) + the Cogip board DTS, which
# is injected into the source tree in do_configure (NOT via subdir=): the
# kernel-yocto checkout does a git reset that would wipe an untracked file
# dropped at unpack time.
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git;protocol=https;nobranch=1;name=machine;destsuffix=git \
    ${@ ('file://' + d.getVar('COGIP_KERNEL_DEVICETREE') + '.dts') if d.getVar('COGIP_KERNEL_DEVICETREE') else '' } \
"

KCONFIG_MODE = "--alldefconfig"

# This BSP only targets the Pi 4.
COMPATIBLE_MACHINE = "raspberrypi4-64"

inherit kernel

# Build (and, via the image, ship) only the Cogip board DTB.
KERNEL_DEVICETREE = "broadcom/${COGIP_KERNEL_DEVICETREE}.dtb"

# Inject the board DTS into the kernel source tree (after the kernel-yocto
# checkout/reset, hence here and not via SRC_URI subdir) and register it in the
# broadcom Makefile so `make broadcom/<name>.dtb` (run by kernel-devicetree)
# has a rule.
do_configure:append() {
    if [ -n "${COGIP_KERNEL_DEVICETREE}" ]; then
        dtsdir="${S}/arch/${ARCH}/boot/dts/broadcom"
        install -m 0644 "${UNPACKDIR}/${COGIP_KERNEL_DEVICETREE}.dts" "$dtsdir/"
        if ! grep -q "${COGIP_KERNEL_DEVICETREE}.dtb" "$dtsdir/Makefile"; then
            echo 'dtb-$(CONFIG_ARCH_BCM2835) += ${COGIP_KERNEL_DEVICETREE}.dtb' >> "$dtsdir/Makefile"
        fi
    fi
}
