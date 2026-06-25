FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}_${LINUX_VERSION}:"

# Cogip config: trimmed defconfig + monolithic wifi (=y) + board peripherals
# (CAN/SPI/RTC, all =y). KBUILD_DEFCONFIG unset so our `defconfig` is used.
SRC_URI += " \
    file://defconfig \
    file://wifi.cfg \
    file://cogip-peripherals.cfg \
    file://cogip-trim.cfg \
"
unset KBUILD_DEFCONFIG

# --- BCM43455 wifi firmware, embedded in the kernel image ---------------------
# brcmfmac is built-in (=y, no modules), so it probes early and its
# request_firmware() can run before the rootfs is mounted -> a /lib/firmware
# blob would not be found. We embed the firmware INTO vmlinux (CONFIG_EXTRA_
# FIRMWARE, see wifi.cfg) so it is always available.
#
# Source: linux-firmware-RPIDISTRO, not mainline linux-firmware. Mainline froze
# the cyfmac43455 firmware at the June-2021 build (7.45.234), which ignores the
# regulatory country (NVRAM ccode AND runtime `iw reg set` both fail) -> stuck
# in worldwide/DFS-UNSET -> 5 GHz DFS channels disabled -> 5 GHz APs invisible.
# RPi-distro ships the current (2024), Pi-validated Cypress build where the
# country applies and 5 GHz works -- the firmware runs on the wifi chip's own
# CPU, so it is independent of the kernel being mainline. Use the "standard"
# variant (full features; CYFMAC43455_SDIO_FIRMWARE set in the distro conf).
# Staged into the kernel recipe-sysroot via DEPENDS (like the regdb).
#
# Aggregated data run by the wifi chip, not GPL code: the kernel stays GPL-2.0;
# the blobs keep their Cypress/RPi-distro redistributable licence.
DEPENDS += "linux-firmware-rpidistro wireless-regdb"

# Stage every firmware brcmfmac/cfg80211 requests where CONFIG_EXTRA_FIRMWARE_DIR
# ="firmware" expects it (relative to the kernel srctree = ${S}), before the
# firmware objects are linked at do_compile. Goal: 0 firmware-load warnings at
# boot -> every requested name must resolve by direct (embedded) load.
do_configure:prepend() {
    fwsrc="${RECIPE_SYSROOT}${nonarch_base_libdir}/firmware"
    install -d ${S}/firmware/brcm
    # Cypress 43455 firmware (the cyfmac43455-sdio.bin symlink resolves to the
    # selected variant). Install under both the base name and the board-specific
    # name brcmfmac requests FIRST, so neither lookup misses (no "-2" log).
    install -m 0644 ${fwsrc}/cypress/cyfmac43455-sdio.bin      ${S}/firmware/brcm/brcmfmac43455-sdio.bin
    install -m 0644 ${fwsrc}/cypress/cyfmac43455-sdio.bin      "${S}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.bin"
    install -m 0644 ${fwsrc}/cypress/cyfmac43455-sdio.clm_blob ${S}/firmware/brcm/brcmfmac43455-sdio.clm_blob
    install -m 0644 "${fwsrc}/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt" "${S}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt"
    # Pin the regulatory country in the NVRAM (read at firmware init) so the
    # chip comes up in FR / DFS-ETSI and the 5 GHz DFS channels are enabled.
    printf 'ccode=FR\nregrev=0\n' >> "${S}/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt"
    # Regulatory DB + signature (CFG80211_REQUIRE_SIGNED_REGDB needs both).
    install -m 0644 ${fwsrc}/regulatory.db     ${S}/firmware/
    install -m 0644 ${fwsrc}/regulatory.db.p7s ${S}/firmware/
}
