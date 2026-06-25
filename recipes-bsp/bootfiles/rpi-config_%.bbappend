# Cogip kiosk display fix.
#
# By default the boot firmware configures HDMI itself and forces a
# 640x480 mode with overscan margins onto the kernel (active area
# 576x416). The vc4 KMS driver refuses that geometry when Cog allocates
# its DRM framebuffer ("failed to create framebuffer: Invalid argument"),
# so the screen stays frozen on the boot logo while cog-kiosk runs blind.
#
# Hand the display over to the kernel: disable_fw_kms_setup stops the
# firmware from configuring HDMI / appending its video= line, so the vc4
# driver reads the EDID and uses the panel's native preferred mode
# (800x480 on the kiosk touchscreen). Drop the overscan margins too.
DISABLE_OVERSCAN = "1"
RPI_EXTRA_CONFIG:append = "\ndisable_fw_kms_setup=1"

# Boot-time trims for the firmware/bootloader phase (power-on -> kernel):
# no boot delay, no rainbow splash, and full CPU clock from the start
# (initial_turbo + arm_boost) so early boot and the kernel decompress run
# at speed. Shaves the firmware phase the kernel-side systemd-analyze does
# not even measure.
RPI_EXTRA_CONFIG:append = "\nboot_delay=0\ndisable_splash=1\ninitial_turbo=30\narm_boost=1"

# Overclock the SD card clock to 100 MHz (the MMC framework's 50 MHz request).
# Boot blame showed dev-mmcblk0p2.device taking ~2.3s, and the whole rootfs
# (kernel modules, the Python site-packages cold start) is read from SD; a
# faster SD clock cuts that across the board. Use the base dtparam, not the
# old sdtweak overlay (removed from the 6.12 kernel). Requires a card that
# tolerates 100 MHz (the team's raspios cards already run this).
RPI_EXTRA_CONFIG:append = "\ndtparam=sd_overclock=100"

# Peripherals (CAN-FD on SPI1, uart2/4/5, i2c1, PCF8523 RTC) are no longer
# config.txt overlays: with the mainline kernel they are nodes in the board
# device tree (meta-cogip-bsp linux-stable: bcm2711-rpi-4-b-cogip.dts). The
# firmware must be told to load that DTB by name -- it is not auto-detected by
# board model. No dtoverlay= here: mainline ships no RPi overlay set.
RPI_EXTRA_CONFIG:append = "\ndevice_tree=bcm2711-rpi-4-b-cogip.dtb"

# Further firmware boot-phase trims (validated live on the board). Skip the
# auto-probe of CSI camera and DSI/HDMI display (we describe everything in the
# board DTB, mainline ships no overlays to inject anyway), drop the legacy
# bcm2835 audio (no audio on the kiosk; this is the DT node, not the kernel SND
# that vc4 HDMI still needs), and zero the remaining bootcode/bootloader delays.
# bootloader_delay applies on this pi4-only image without a [pi4] guard.
RPI_EXTRA_CONFIG:append = "\ncamera_auto_detect=0\ndisplay_auto_detect=0\ndtparam=audio=off\nbootcode_delay=0\nbootloader_delay=0"
