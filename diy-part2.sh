#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 修改 WiFi 名称（SSID）从 LEDE → HYNIX-5G
sed -i 's/set wireless.default_radio${devidx}.ssid=LEDE/set wireless.default_radio${devidx}.ssid=H29K/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改加密方式 (none → psk2)
sed -i 's/set wireless.default_radio${devidx}.encryption=none/set wireless.default_radio${devidx}.encryption=psk2/' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 在加密行后新增密码行 (确保格式对齐)
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a \\t\tset wireless.default_radio${devidx}.key=888xvzss' package/kernel/mac80211/files/lib/wifi/mac80211.sh

sed -i "s/timezone='.*'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
if ! grep -q "zonename=" package/base-files/files/bin/config_generate; then
    sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
else
    sed -i "s/zonename='.*'/zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
fi

sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf
