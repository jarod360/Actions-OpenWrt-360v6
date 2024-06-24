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

#移除不用软件包  
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/luci/applications/luci-app-ttyd
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/luci/applications/luci-app-serverchan
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/packages/libs/libwebsockets
rm -rf feeds/packages/utils/ttyd
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/multimedia/xupnpd
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/kenzo/luci-app-wechatpush
rm -rf feeds/kenzo/luci-app-alist

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/emortal/default-settings/files/99-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Jarod/g" package/emortal/default-settings/files/99-default-settings

# 修改本地时间格式
#sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/emortal/autocore/files/*/index.htm

# 修改插件名字
sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`

# 把局域网内所有客户端对外ipv4的53端口查询请求，都劫持指向路由器(iptables -n -t nat -L PREROUTING -v --line-number)(iptables -t nat -D PREROUTING 2)
echo 'iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo 'iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user

# Modify default IP
sed -i 's/192.168.1.1/192.168.0.254/g' package/base-files/files/bin/config_generate

#　web登陆密码从password修改为空
# sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root::0:0:99999:7:::/g' package/extra/default-settings/files/99-default-settings

#　编译的固件文件名添加日期
sed -i 's/IMG_PREFIX:=$(VERSION_DIST_SANITIZED)/IMG_PREFIX:=360V6-$(shell TZ=UTC-8 date "+%Y%m%d")-$(VERSION_DIST_SANITIZED)/g' include/image.mk

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

#添加额外插件
git clone --depth=1 https://github.com/jarod360/luci-app-ttyd package/luci-app-ttyd
git clone --depth=1 https://github.com/jarod360/packages package/mypackge
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush.git package/luci-app-serverchan
git clone --depth=1 https://github.com/jarod360/luci-app-xupnpd package/luci-app-xupnpd
git clone --depth=1 https://github.com/jarod360/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git_sparse_clone master https://github.com/coolsnowwolf/packages multimedia/xupnpd
git_sparse_clone master https://github.com/kenzok8/small chinadns-ng
git_sparse_clone master https://github.com/kenzok8/openwrt-packages luci-app-alist

#调整alist到服务菜单及修改名称
sed -i 's/+alist //g' package/luci-app-alist/Makefile
sed -i 's/nas/services/g' package/luci-app-alist/luasrc/controller/alist.lua
sed -i 's/NAS/Services/g' package/luci-app-alist/luasrc/controller/alist.lua
sed -i 's/nas/services/g' package/luci-app-alist/luasrc/view/alist/admin_info.htm
sed -i 's/nas/services/g' package/luci-app-alist/luasrc/view/alist/alist_log.htm
sed -i 's/nas/services/g' package/luci-app-alist/luasrc/view/alist/alist_status.htm
sed -i 's/Alist 文件列表/Alist/g' package/luci-app-alist/po/zh-cn/alist.po
sed -i 's|rm -rf /tmp/luci-*|rm -rf /tmp/luci-* && rm -f /etc/init.d/alist|g' package/luci-app-alist/root/etc/uci-defaults/50-luci-alist

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
