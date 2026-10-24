#!/usr/bin/env bash
# ==========================================================
# Cloudflare Pages 构建脚本
#
# 为什么需要它：Butterfly 主题有 400 多个文件，GitHub 网页上传
# 一次只能 100 个。所以主题不进仓库，改为在构建时自动拉取。
#
# Cloudflare 的构建命令填：bash build.sh
# 本地如果想预览，装好 Node 之后也能直接跑：bash build.sh
# ==========================================================

set -euo pipefail

THEME_DIR="themes/butterfly"
THEME_REPO="https://github.com/jerryc127/hexo-theme-butterfly.git"
THEME_VERSION="5.7.0"

echo "==> 检查主题"
if [ -f "$THEME_DIR/_config.yml" ]; then
  echo "    已存在 $THEME_DIR，跳过拉取"
else
  echo "    拉取 Butterfly $THEME_VERSION → $THEME_DIR"
  rm -rf "$THEME_DIR"
  git clone --depth 1 -b "$THEME_VERSION" "$THEME_REPO" "$THEME_DIR"
fi

echo "==> 安装依赖"
npm install --no-audit --no-fund

echo "==> 生成静态文件"
npm run build

echo "==> 构建完成"
echo "    public/ 下共 $(find public -type f | wc -l) 个文件"
