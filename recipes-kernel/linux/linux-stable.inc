SUMMARY = "Linux mainline kernel"
SECTION = "kernel"
LICENSE = "GPLv2"

# Based on linux-yocto
require recipes-kernel/linux/linux-yocto.inc

# Source directory
S = "${WORKDIR}/git"

SRCREV = "v${LINUX_VERSION}"
LINUX_VERSION = "${@bb.parse.vars_from_file(d.getVar('FILE', False),d)[1] or '1.0'}"
PV = "${LINUX_VERSION}+git${SRCPV}"

SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git;protocol=git;branch=master;name=machine \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KCONFIG_MODE="--alldefconfig"

# Inherit kernel class
inherit kernel
