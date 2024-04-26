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
# rm -rf package/feeds/luci/luci-app-ssr-plus
# rm -rf package/feeds/luci/luci-app-filetransfer
#移除不用软件包  
rm -rf feeds/packages/libs/libwebsockets
rm -rf feeds/luci/applications/luci-app-ttyd
rm -rf feeds/packages/utils/ttyd

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.254/g' package/base-files/files/bin/config_generate

#　web登陆密码从password修改为空
# sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root::0:0:99999:7:::/g' package/extra/default-settings/files/99-default-settings

#　固件版本号添加个人标识和日期
sed -i "s/DISTRIB_DESCRIPTION='OpenWrt '/DISTRIB_DESCRIPTION='Jarod(\$\(TZ=UTC-8 date +%Y-%m-%d\))@OpenWrt '/g" package/extra/default-settings/files/99-default-settings

#　编译的固件文件名添加日期
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=360V6-$(shell TZ=UTC-8 date "+%Y%m%d")-$(VERSION_DIST_SANITIZED)/g' include/image.mk


# Modify default theme
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

#加载ipk
git clone https://github.com/jarod360/luci-app-ttyd package/luci-app-ttyd
git clone https://github.com/jarod360/packages package/mypackge
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush.git packge/luci-app-serverchan
