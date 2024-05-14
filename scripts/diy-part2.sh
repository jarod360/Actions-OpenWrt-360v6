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
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/multimedia/xupnpd/
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/kenzo/luci-app-wechatpush

#修改alist分类
sed -i 's/+alist //g' feeds/kenzo/luci-app-alist/Makefile
sed -i 's/nas/services/g' feeds/kenzo/luci-app-alist/luasrc/controller/alist.lua
sed -i 's/NAS/Services/g' feeds/kenzo/luci-app-alist/luasrc/controller/alist.lua
sed -i 's/nas/services/g' feeds/kenzo/luci-app-alist/luasrc/controller/alist.lua
sed -i 's/nas/services/g' feeds/kenzo/luci-app-alist/luasrc/view/alist/admin_info.htm
sed -i 's/nas/services/g' feeds/kenzo/luci-app-alist/luasrc/view/alist/alist_log.htm
sed -i 's/nas/services/g' feeds/kenzo/luci-app-alist/luasrc/view/alist/alist_status.htm
sed -i 's/Alist 文件列表/Alist小雅/g' feeds/kenzo/luci-app-alist/po/zh-cn/alist.po

# 修改版本信息
date=`date +%y.%m.%d`
sed -i 's/OpenWrt/OpenWrt Build '$date' By Jarod/g' package/addition/default-settings/files/99-default-settings
sed -i 's/R23.11.20/R24.05.01/g' package/addition/default-settings/files/99-default-settings

#修改设备型号
sed -i 's/Qihoo V6/Qihoo Router 360V6/g' /target/linux/ipq60xx/image/Makefile

# 修改插件名字
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.254/g' package/base-files/files/bin/config_generate

#　web登陆密码从password修改为空
# sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root::0:0:99999:7:::/g' package/extra/default-settings/files/99-default-settings

#　固件版本号添加个人标识和日期
#sed -i "s/DISTRIB_DESCRIPTION='OpenWrt '/DISTRIB_DESCRIPTION='Jarod(\$\(TZ=UTC-8 date +%Y-%m-%d\))@OpenWrt '/g" package/extra/default-settings/files/99-default-settings

#　编译的固件文件名添加日期
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=360V6-$(shell TZ=UTC-8 date "+%Y%m%d")-$(VERSION_DIST_SANITIZED)/g' include/image.mk


# Modify default theme
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

#加载ipk
git clone https://github.com/jarod360/luci-app-ttyd package/luci-app-ttyd
git clone https://github.com/jarod360/packages package/mypackge
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush.git package/luci-app-serverchan
git clone https://github.com/jarod360/luci-app-xupnpd package/luci-app-xupnpd
git clone https://github.com/jarod360/luci-app-msd_lite package/luci-app-msd_lite
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
curl -L -o msd_lite.tar.gz https://github.com/coolsnowwolf/packages/archive/master.tar.gz
tar -xzf msd_lite.tar.gz
#mv packages-master/net/msd_lite/ package/msd_lite
mv packages-master/multimedia/xupnpd/ package/xupnpd
rm msd_lite.tar.gz

#去除serverchan无效检测网址
sed -i 's|https://www.baidu.com https://www.qidian.com https://www.douban.com|https://www.baidu.com|g' package/luci-app-serverchan/root/usr/share/serverchan/serverchan

# 调整argon登录框为居中
sed -i "/.login-page {/i\\
.login-container {\n\
  margin: auto;\n\
  height: 620px\!important;\n\
  min-height: 420px\!important;\n\
  left: 0;\n\
  right: 0;\n\
  bottom: 0;\n\
  margin-left: auto\!important;\n\
  border-radius: 15px;\n\
  width: 350px\!important;\n\
}\n\
.login-form {\n\
  background-color: rgba(255, 255, 255, 0.4)\!important;\n\
  border-radius: 15px;\n\
}\n\
.login-form .brand {\n\
  margin: 15px auto\!important;\n\
}\n\
.login-form .form-login {\n\
    padding: 10px 50px\!important;\n\
}\n\
.login-form .errorbox {\n\
  padding: 10px\!important;\n\
}\n\
.login-form .cbi-button-apply {\n\
  margin: 15px auto\!important;\n\
}\n\
.input-group {\n\
  margin-bottom: 1rem\!important;\n\
}\n\
.input-group input {\n\
  margin-bottom: 0\!important;\n\
}\n\
.ftc {\n\
  bottom: 0\!important;\n\
}" package/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
sed -i "s/margin-left: 0rem \!important;/margin-left: auto\!important;/g" package/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
