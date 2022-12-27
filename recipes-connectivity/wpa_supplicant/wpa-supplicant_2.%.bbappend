FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

RDEPENDS:${PN} += " \
    iw \
"

SRC_URI += " \
    file://wpa_supplicant-p2p@.service \
"

SYSTEMD_AUTO_ENABLE = "disable"
SYSTEMD_SERVICE:${PN} = "wpa_supplicant-p2p@wlan0.service"

do_install:append() {
    # wpa-supplicant systemd services
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/wpa_supplicant-p2p@.service ${D}${systemd_unitdir}/system/wpa_supplicant-p2p@.service
}
