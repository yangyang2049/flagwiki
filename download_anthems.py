#!/usr/bin/env python3
"""
下载国歌文件脚本
从Wikipedia Commons下载国歌OGG文件
"""

import os
import urllib.request
import urllib.parse

# 创建目录
anthems_dir = "entry/src/main/resources/base/media/anthems"
os.makedirs(anthems_dir, exist_ok=True)

# 国歌列表：国家代码 -> (文件名, URL)
anthems = {
    "es": ("anthem_es.ogg", "https://upload.wikimedia.org/wikipedia/commons/9/99/Spain_national_anthem.ogg"),
    "gb": ("anthem_gb.ogg", "https://upload.wikimedia.org/wikipedia/commons/5/5e/God_Save_the_King_%28Instrumental%29.ogg"),
    "de": ("anthem_de.ogg", "https://upload.wikimedia.org/wikipedia/commons/2/2e/Deutschlandlied_national_anthem_instrumental.ogg"),
    "fr": ("anthem_fr.ogg", "https://upload.wikimedia.org/wikipedia/commons/6/60/La_Marseillaise.ogg"),
    "jp": ("anthem_jp.ogg", "https://upload.wikimedia.org/wikipedia/commons/4/44/Kimigayo_%E5%9B%BD%E6%AD%8C.ogg"),
    "us": ("anthem_us.ogg", "https://upload.wikimedia.org/wikipedia/commons/4/4d/US_National_Anthem_-_Star_Spangled_Banner.ogg"),
    "ca": ("anthem_ca.ogg", "https://upload.wikimedia.org/wikipedia/commons/6/6f/O_Canada_instrumental.ogg"),
    "it": ("anthem_it.ogg", "https://upload.wikimedia.org/wikipedia/commons/4/42/Il_Canto_degli_Italiani_instrumental.ogg"),
    "nl": ("anthem_nl.ogg", "https://upload.wikimedia.org/wikipedia/commons/5/5d/Wilhelmus_national_anthem_instrumental.ogg"),
    "be": ("anthem_be.ogg", "https://upload.wikimedia.org/wikipedia/commons/8/8c/La_Braban%C3%A7onne_instrumental.ogg"),
}

print("开始下载国歌文件...\n")

headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
}

for code, (filename, url) in anthems.items():
    filepath = os.path.join(anthems_dir, filename)
    
    print(f"下载 {code}: {filename}")
    print(f"  URL: {url}")
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=30) as response:
            data = response.read()
            
            # 检查是否是错误页面
            if len(data) < 1000 or data.startswith(b'<!DOCTYPE') or data.startswith(b'<html'):
                print(f"  ⚠ 警告: 下载的文件可能是错误页面 ({len(data)} bytes)")
                print(f"  内容预览: {data[:200]}")
                continue
            
            # 保存文件
            with open(filepath, 'wb') as f:
                f.write(data)
            
            file_size = len(data)
            print(f"  ✓ 下载成功: {filename} ({file_size:,} bytes)")
            
    except Exception as e:
        print(f"  ✗ 下载失败: {filename}")
        print(f"  错误: {e}")

print(f"\n下载完成！文件保存在: {anthems_dir}")
print("\n注意: HarmonyOS支持OGG格式。如果播放有问题，可以使用ffmpeg转换为MP3:")
print("  ffmpeg -i input.ogg -acodec libmp3lame -ab 192k output.mp3")




