# Realtek RTL8152/RTL8153 Based USB Ethernet Adapters
LICENSE_${PN}-rtl8153 = "Firmware-rtlwifi_firmware"
RDEPENDS_${PN}-rtl8153 += "${PN}-rtl-license"
FILES_${PN}-rtl8153 = " \
  ${nonarch_base_libdir}/firmware/rtl_nic/rtl8153*.fw \
"
PACKAGES_prepend = " ${PN}-rtl8153 "

# Samsung MFC video encoder/decoder driver
RDEPENDS_${PN}-s5pmfcv8 += "${PN}-whence-license"
LICENSE_${PN}-s5pmfcv8 = "WHENCE"
FILES_${PN}-s5pmfcv8 = " \
  ${nonarch_base_libdir}/firmware/s5p-mfc-v8.fw \
"
PACKAGES_prepend = " ${PN}-s5pmfcv8 "

do_install_append_rpi () {
    ln -s brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.bin
}
