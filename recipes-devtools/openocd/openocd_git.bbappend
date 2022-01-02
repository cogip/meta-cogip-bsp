FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = " \
    file://COPYING;md5=599d2d1ee7fc84c0467b3d19801db870 \
"

SRCREV_openocd = "d27d66bc1bdbef0cbfe43d88597576e173317c01"

SRC_URI_remove = " \
    file://0001-Do-not-include-syscrtl.h-with-glibc.patch \
"

SRC_URI += " \
    file://0001-drivers-linuxgpiod-stub-khz-and-speed-callbacks.patch \
    file://0002-drivers-bitbang-add-call-to-keep_alive.patch \
    file://openocd@.service \
    file://cogip.cfg \
"

### COGIP Odroid XU4
DEPENDS_cogip-odroid-xu4 += " \
    libgpiod \
"
RDEPENDS_${PN}_cogip-odroid-xu4 += " \
    libgpiod \
"
EXTRA_OECONF_cogip-odroid-xu4 += "--enable-linuxgpiod"

### COGIP Raspberry Pi0
EXTRA_OECONF_cogip-raspberrypi0-wifi += "--enable-bcm2835gpio"

do_install_append() {
    install -m 0644 ${WORKDIR}/cogip.cfg \
        ${D}${datadir}/openocd/scripts/interface/cogip.cfg

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/openocd@.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE_${PN} = "openocd@cogip.service"
SYSTEMD_AUTO_ENABLE = "enable"

FILES_${PN} += " \
    ${systemd_unitdir}/system/openocd@.service \
"

REQUIRED_DISTRO_FEATURES += "systemd"
inherit systemd features_check
