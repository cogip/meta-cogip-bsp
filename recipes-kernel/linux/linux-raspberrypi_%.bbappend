# Auto-load i2c-dev at boot so /dev/i2c-N char devices appear for the i2c
# buses enabled in config.txt (dtparam=i2c1=on). The bus adapter exists
# without it, but the /dev node -- which the OLED tool (and the compose
# device list) needs -- does not. Unlike the CAN driver (which auto-loads
# via the device-tree overlay's modalias), i2c-dev is a generic char
# interface with no device to trigger it, so it must be listed explicitly.
# Generates /etc/modules-load.d/i2c-dev.conf.
KERNEL_MODULE_AUTOLOAD += "i2c-dev"
