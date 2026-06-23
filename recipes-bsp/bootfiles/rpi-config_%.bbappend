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

# CAN bus for the copilot tool: an MCP251xFD CAN-FD controller on SPI1
# (CS0 = GPIO16, 20 MHz crystal, IRQ on GPIO4), as on the robots. The
# overlay creates can0; systemd-networkd brings it up (cogip-net's
# 00-can0.network). The kernel ships CONFIG_CAN* + CONFIG_CAN_MCP251XFD as
# modules (in kernel-modules). On a board without the CAN HAT the driver
# just fails to probe and can0 does not appear -- harmless.
RPI_EXTRA_CONFIG:append = "\ndtoverlay=spi1-1cs,cs0_pin=16\ndtoverlay=mcp251xfd,spi1-0,oscillator=20000000,interrupt=4"

# Robot peripherals (match raspios). disable-bt frees the UARTs; expose the
# extra PL011 UARTs the tools use -- uart2 = ttyAMA2 (mcu-logger), uart4 =
# ttyAMA4 (detector lidar), uart5 spare. Enable i2c (OLED on i2c-1) and the
# PCF8523 RTC so the clock is correct without NTP (explains the bogus dates
# seen so far). The tool containers still need these devices in compose's
# device list to see them.
RPI_EXTRA_CONFIG:append = "\ndtoverlay=disable-bt\ndtoverlay=uart2\ndtoverlay=uart4\ndtoverlay=uart5\ndtparam=i2c_arm=on\ndtparam=i2c1=on\ndtoverlay=i2c-rtc,pcf8523"
