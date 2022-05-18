# Realtek RTL8152/RTL8153 Based USB Ethernet Adapters
LICENSE:${PN}-rtl8153 = "Firmware-rtlwifi_firmware"
RDEPENDS:${PN}-rtl8153 += "${PN}-rtl-license"
FILES:${PN}-rtl8153 = " \
  ${nonarch_base_libdir}/firmware/rtl_nic/rtl8153*.fw \
"
PACKAGES:prepend = " ${PN}-rtl8153 "

# Samsung MFC video encoder/decoder driver
RDEPENDS:${PN}-s5pmfcv8 += "${PN}-whence-license"
LICENSE:${PN}-s5pmfcv8 = "WHENCE"
FILES:${PN}-s5pmfcv8 = " \
  ${nonarch_base_libdir}/firmware/s5p-mfc-v8.fw \
"
PACKAGES:prepend = " ${PN}-s5pmfcv8 "

do_install:append_rpi () {
    ln -s brcmfmac43455-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.bin
}
