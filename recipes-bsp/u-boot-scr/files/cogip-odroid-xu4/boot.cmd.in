# U-Boot Parameters
setenv bootrootfs "console=tty1 console=ttySAC2,115200n8 quiet root=/dev/mmcblk1p2 rootwait rw fsck.repair=yes net.ifnames=0"
setenv bootcmd "load mmc 2:1 ${kernel_addr_r} zImage; load mmc 2:1 ${fdt_addr_r} exynos5422-odroidxu4.dtb; bootz ${kernel_addr_r} - ${fdt_addr_r}"

# final boot args
setenv bootargs "${bootrootfs}"

boot
