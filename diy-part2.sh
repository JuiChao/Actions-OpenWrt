#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.123.1/g' package/base-files/files/bin/config_generate

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i 's/the default Bootstrap theme/the default Argon theme/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/the default Bootstrap theme/the default Argon theme/g' feeds/luci/collections/luci-nginx/Makefile

# Modify KERNEL version
sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/g' target/linux/ramips/Makefile
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=5.15/g' target/linux/mediatek/Makefile
#sed -i 's/DEPENDS:=@!LINUX_5_15/DEPENDS:=@!LINUX_6_1/g' package/utils/fitblk/Makefile
sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' target/linux/mediatek/Makefile
sed -i 's/DEPENDS:=@!LINUX_5_15/DEPENDS:=@!LINUX_6_6/g' package/utils/fitblk/Makefile
