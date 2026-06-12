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
