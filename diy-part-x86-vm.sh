#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part-x86-vm.sh
# Description: OpenWrt DIY script part x86-vm (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.100/g' package/base-files/files/bin/config_generate

# Modify default heme
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile
sed -i 's/the default bootstrap theme/the default Material theme/g' feeds/luci/collections/luci/Makefile
