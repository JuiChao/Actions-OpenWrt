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

# Delete somefeeds
# rm -rf ./openwrt/feeds/luci/applications/luci-app-passwall 
# rm -rf ./openwrt/feeds/luci/applications/luci-app-passwall2

# 修改 package/kernel/mt76/Makefile 启用 360T7 MTK 无线硬件加速
if ! grep -q "wed_enable=Y" package/kernel/mt76/Makefile; then
    sed -i '/AutoProbe,mt7915e/a\  ifdef CONFIG_TARGET_mediatek_filogic\n    MODPARAMS.mt7915e:=wed_enable=Y\n  endif' package/kernel/mt76/Makefile
fi

# 修正 PassWall uci-defaults 对 fw3 的误判（仅在未适配 fw4 时修补）
pw_defaults="feeds/passwall_luci/luci-app-passwall/root/etc/uci-defaults/luci-app-passwall"
if [ -f "$pw_defaults" ] && ! grep -q "/sbin/fw4" "$pw_defaults"; then
    sed -i 's/\[ -x "\/sbin\/fw3" \]/\[ -x "\/sbin\/fw3" \] \&\& \[ ! -x "\/sbin\/fw4" \]/g' "$pw_defaults"
fi

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile
#sed -i 's/the default Bootstrap theme/the default Material theme/g' feeds/luci/collections/luci/Makefile
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile
#sed -i 's/the default Bootstrap theme/the default Argon theme/g' feeds/luci/collections/luci-light/Makefile
#sed -i 's/the default Bootstrap theme/the default Argon theme/g' feeds/luci/collections/luci-nginx/Makefile

# Modify KERNEL version
#sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/g' target/linux/ramips/Makefile
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=5.15/g' target/linux/mediatek/Makefile
#sed -i 's/DEPENDS:=@!LINUX_5_15/DEPENDS:=@!LINUX_6_1/g' package/utils/fitblk/Makefile
#sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' target/linux/mediatek/Makefile
#sed -i 's/DEPENDS:=@!LINUX_5_15/DEPENDS:=@!LINUX_6_12/g' package/utils/fitblk/Makefile
