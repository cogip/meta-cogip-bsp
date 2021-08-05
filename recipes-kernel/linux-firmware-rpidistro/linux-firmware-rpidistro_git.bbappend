do_install_append() {
    ln -s brcmfmac43430-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43430-sdio.raspberrypi,model-zero-w.txt
}
