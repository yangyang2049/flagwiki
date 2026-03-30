#!/usr/bin/env node
/**
 * SVG优化脚本
 * 压缩SVG文件，移除不必要的元数据、注释和空白
 * - 图标文件：仅处理以 "icon" 或 "ic_" 开头的文件
 * - state_flags：处理所有SVG文件
 * 
 * 使用方法：
 * node scripts/optimize-svgs.js
 */

const fs = require('fs');
const path = require('path');

// SVG目录列表
// - 图标文件：仅处理以 icon 或 ic_ 开头的文件
// - state_flags：处理所有SVG文件
const SVG_DIRS = [
  {
    path: 'entry/src/main/resources/base/media',
    filter: (fileName) => {
      const lower = fileName.toLowerCase();
      return lower.startsWith('icon') || lower.startsWith('ic_');
    }
  },
  {
    path: 'entry/src/main/resources/dark/media',
    filter: (fileName) => {
      const lower = fileName.toLowerCase();
      return lower.startsWith('icon') || lower.startsWith('ic_');
    }
  },
  {
    path: 'entry/src/main/resources/rawfile/state_flags',
    filter: () => true // 处理所有SVG文件
  }
];

// 简单的SVG优化函数（移除注释、多余空白、元数据）
function optimizeSVG(content) {
  let optimized = content;
  
  // 移除XML注释
  optimized = optimized.replace(/<!--[\s\S]*?-->/g, '');
  
  // 移除DOCTYPE声明
  optimized = optimized.replace(/<!DOCTYPE[^>]*>/gi, '');
  
  // 移除不必要的元数据（保留viewBox和基本属性）
  optimized = optimized.replace(/<metadata>[\s\S]*?<\/metadata>/gi, '');
  optimized = optimized.replace(/<sodipodi:[\s\S]*?>/gi, '');
  optimized = optimized.replace(/<inkscape:[\s\S]*?>/gi, '');
  optimized = optimized.replace(/xmlns:sodipodi="[^"]*"/gi, '');
  optimized = optimized.replace(/xmlns:inkscape="[^"]*"/gi, '');
  optimized = optimized.replace(/sodipodi:[^=]*="[^"]*"/gi, '');
  optimized = optimized.replace(/inkscape:[^=]*="[^"]*"/gi, '');
  
  // 压缩空白字符
  optimized = optimized.replace(/\s+/g, ' ');
  optimized = optimized.replace(/>\s+</g, '><');
  optimized = optimized.replace(/\s*>\s*/g, '>');
  optimized = optimized.replace(/\s*<\s*/g, '<');
  
  // 移除行首行尾空白
  optimized = optimized.trim();
  
  return optimized;
}

// 处理单个文件
function processFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const originalSize = Buffer.byteLength(content, 'utf8');
    
    const optimized = optimizeSVG(content);
    const optimizedSize = Buffer.byteLength(optimized, 'utf8');
    
    if (optimizedSize < originalSize) {
      fs.writeFileSync(filePath, optimized, 'utf8');
      const saved = originalSize - optimizedSize;
      const percent = ((saved / originalSize) * 100).toFixed(1);
      return {
        file: path.basename(filePath),
        original: originalSize,
        optimized: optimizedSize,
        saved: saved,
        percent: percent
      };
    }
    return null;
  } catch (error) {
    console.error(`Error processing ${filePath}:`, error.message);
    return null;
  }
}

// 递归查找所有SVG文件（根据过滤器）
function findSVGFiles(dir, filter) {
  const files = [];
  if (!fs.existsSync(dir)) {
    return files;
  }
  
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...findSVGFiles(fullPath, filter));
    } else if (entry.isFile() && entry.name.endsWith('.svg')) {
      // 根据过滤器决定是否处理
      if (filter(entry.name)) {
        files.push(fullPath);
      }
    }
  }
  return files;
}

// 主函数
function main() {
  console.log('🚀 开始优化SVG文件...\n');
  console.log('   - 图标文件：仅处理以 icon 或 ic_ 开头的文件');
  console.log('   - state_flags：处理所有SVG文件\n');
  
  let totalFiles = 0;
  let optimizedFiles = 0;
  let totalOriginalSize = 0;
  let totalOptimizedSize = 0;
  const results = [];
  
  for (const dirConfig of SVG_DIRS) {
    const fullDir = path.resolve(dirConfig.path);
    if (!fs.existsSync(fullDir)) {
      console.warn(`⚠️  目录不存在: ${fullDir}`);
      continue;
    }
    
    console.log(`📁 处理目录: ${dirConfig.path}`);
    const files = findSVGFiles(fullDir, dirConfig.filter);
    totalFiles += files.length;
    
    for (const file of files) {
      const result = processFile(file);
      if (result) {
        optimizedFiles++;
        totalOriginalSize += result.original;
        totalOptimizedSize += result.optimized;
        results.push(result);
      }
    }
  }
  
  // 输出结果
  console.log('\n✅ 优化完成！\n');
  console.log(`📊 统计信息:`);
  console.log(`   - 总文件数: ${totalFiles}`);
  console.log(`   - 已优化: ${optimizedFiles}`);
  console.log(`   - 原始大小: ${(totalOriginalSize / 1024).toFixed(2)} KB`);
  console.log(`   - 优化后大小: ${(totalOptimizedSize / 1024).toFixed(2)} KB`);
  console.log(`   - 节省空间: ${((totalOriginalSize - totalOptimizedSize) / 1024).toFixed(2)} KB (${(((totalOriginalSize - totalOptimizedSize) / totalOriginalSize) * 100).toFixed(1)}%)`);
  
  if (results.length > 0) {
    console.log('\n📋 优化详情（前10个文件）:');
    results
      .sort((a, b) => b.saved - a.saved)
      .slice(0, 10)
      .forEach((r, i) => {
        console.log(`   ${i + 1}. ${r.file}: ${(r.saved / 1024).toFixed(2)} KB (${r.percent}%)`);
      });
  }
}

if (require.main === module) {
  main();
}

module.exports = { optimizeSVG, processFile };
