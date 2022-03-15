FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = " \
    file://COPYING;md5=599d2d1ee7fc84c0467b3d19801db870 \
"

SRCREV_openocd = "d27d66bc1bdbef0cbfe43d88597576e173317c01"

SRC_URI_remove = " \
    file://0001-Do-not-include-syscrtl.h-with-glibc.patch \
"

SRC_URI += " \
    file://openocd@.service \
    file://cogip.cfg \
"

EXTRA_OECONF += "--enable-sysfsgpio --enable-bcm2835gpio"

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
