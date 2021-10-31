FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

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
