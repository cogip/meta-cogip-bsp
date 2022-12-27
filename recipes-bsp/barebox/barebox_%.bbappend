FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://bootchoser.cfg \
    file://disable-usb.cfg \
    file://overlays.cfg \
    file://readf.cfg \
    file://0001-WIP.patch \
    file://env \
"

do_compile:prepend() {
    sed -i 's!@@COGIP_KERNEL_DEVICETREE@@!${COGIP_KERNEL_DEVICETREE}!g' ${WORKDIR}/env/boot/system*
}
