#!/bin/bash
# DIY脚本
# https://github.com/P3TERX/Actions-OpenWrt
# 文件名: diy-part1.sh
# 功能说明: OpenWrt DIY脚本第1部分（更新feeds之前）
# 版权: (c) 2019-2024 P3TERX <https://p3terx.com>
# 基于 MIT 开源协议，详见 /LICENSE

# 1. 补齐 lkiuyu/immortalwrt (2026-05/06) 与最新 immortalwrt/packages 之间迁移至主仓库的基础库 (libffi 与 libstd-rust)
git clone --depth 1 --filter=blob:none --sparse https://github.com/immortalwrt/immortalwrt.git /tmp/imm_core
git -C /tmp/imm_core sparse-checkout set package/libs/libffi package/libs/libstd-rust
cp -rf /tmp/imm_core/package/libs/libffi package/libs/
cp -rf /tmp/imm_core/package/libs/libstd-rust package/libs/
rm -rf /tmp/imm_core

# 2. 添加第三方 feed 源（small-package 包含 passwall2 / sing-box / tailscale 等插件，名称必须保持 smpackage 以匹配工作流去重脚本）
echo 'src-git smpackage https://github.com/kenzok8/small-package' >> feeds.conf.default

# 3. 添加 4G/5G Modem 管理插件源（仅写入 feeds.conf.default，由后续工作流统一执行 feeds update -a 和 install -a -f）
echo 'src-git modem https://github.com/fildunsky/luci-app-5gmodem.git' >> feeds.conf.default
