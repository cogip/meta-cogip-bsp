FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://rpi-cogip.cfg \
"

EXTRA_OECONF += "--enable-sysfsgpio --enable-bcm2835gpio"

do_install_append() {
    install -m 0644 ${WORKDIR}/rpi-cogip.cfg \
        ${D}${datadir}/openocd/scripts/interface/rpi-cogip.cfg
}
