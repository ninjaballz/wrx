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

sed -i 's/LEDE/Hynix/g' package/base-files/files/bin/config_generate
sed -i 's/LEDE/Hynix/g' package/base-files/luci2/bin/config_generate

# 修改 WiFi 名称（SSID）从 LEDE → Hynix
sed -i 's/set wireless.default_radio${devidx}.ssid=LEDE/set wireless.default_radio${devidx}.ssid=Hynix/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改加密方式 (none → psk2)
sed -i 's/set wireless.default_radio${devidx}.encryption=none/set wireless.default_radio${devidx}.encryption=psk2/' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 在加密行后新增密码行 (确保格式对齐)
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a \\t\tset wireless.default_radio${devidx}.key=888vxzss' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

sed -i "s|DISTRIB_DESCRIPTION=.*|DISTRIB_DESCRIPTION=\"NiggaWrt R$(TZ=UTC-8 date +'%y.%m.%d') (By @SxLvIo build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"|g" package/base-files/files/etc/openwrt_release
sed -i "s|OPENWRT_RELEASE=.*|OPENWRT_RELEASE=\"NiggaWrt R$(TZ=UTC-8 date +'%y.%m.%d') (By @SxLvIo build $(TZ=UTC-8 date '+%Y-%m-%d %H:%M'))\"|g" package/base-files/files/usr/lib/os-release

sed -i '/CPU usage/a\                <tr><td width="33\%"><\%:最新固件\%></td><td><a target="_blank" href="https://github.com/ninjaballz/wrx/releases">👇查看</a></td></tr>' package/lean/autocore/files/arm/index.htm
sed -i '/CPU usage/a\                <tr><td width="33%\"><%:最新固件%></td><td><a target="_blank" href="https://github.com/ninjaballz/wrx/releases">👇查看</a></td></tr>' package/lean/autocore/files/arm/index.htm


sed -i "s/timezone='.*'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
if ! grep -q "zonename=" package/base-files/files/bin/config_generate; then
    sed -i "/timezone='CST-8'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Asia/Shanghai'" package/base-files/files/bin/config_generate
else
    sed -i "s/zonename='.*'/zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
fi

sed -i '$a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf
