#!/usr/bin/env bash
# 将 flags/ 与 paint_flags/ 打成 STORED 压缩包，供 rawfile/compressed/flags_bundle.zip 使用。
# 解压由 FlagSvgBundleUnpacker 在首次启动/版本升级时完成。
#
# 用法（在仓库根目录）：
#   1. 将完整的 flags、paint_flags 目录放到 entry/src/main/resources/rawfile/ 下
#   2. 执行：bash scripts/pack-flags-bundle.sh
#   3. 在 FlagSvgBundleUnpacker.ets 中将 FLAG_SVG_BUNDLE_VERSION 加 1
#
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RAW="$ROOT/entry/src/main/resources/rawfile"
OUT="$RAW/compressed/flags_bundle.zip"

if [[ ! -d "$RAW/flags" ]] || [[ ! -d "$RAW/paint_flags" ]]; then
  echo "错误: 需要同时存在 $RAW/flags 与 $RAW/paint_flags（可先 unzip 现有包再替换文件）。" >&2
  exit 1
fi

mkdir -p "$RAW/compressed"
rm -f "$OUT"
(cd "$RAW" && zip -0 -r "compressed/flags_bundle.zip" flags paint_flags)
echo "已生成: $OUT"
echo "请递增 entry/.../FlagSvgBundleUnpacker.ets 中的 FLAG_SVG_BUNDLE_VERSION。"
