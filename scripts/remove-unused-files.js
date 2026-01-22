#!/usr/bin/env node
/**
 * 移除未使用的文件
 * 根据文档审查报告，移除确认未使用的文件
 * 
 * 使用方法：
 * node scripts/remove-unused-files.js [--dry-run]
 */

const fs = require('fs');
const path = require('path');

// 未使用的文件列表（来自文档审查）
const UNUSED_FILES = [
  'entry/src/main/ets/utils/CoatOfArmsDownloader.ets',
  'entry/src/main/ets/utils/CoatOfArmsDatabase.ets',
  'download_anthems.py'
];

function main() {
  const dryRun = process.argv.includes('--dry-run');
  
  console.log(dryRun ? '🔍 检查未使用的文件（模拟运行）...\n' : '🗑️  开始移除未使用的文件...\n');
  
  let removedCount = 0;
  let notFoundCount = 0;
  
  for (const filePath of UNUSED_FILES) {
    const fullPath = path.resolve(filePath);
    
    if (!fs.existsSync(fullPath)) {
      console.log(`⚠️  文件不存在: ${filePath}`);
      notFoundCount++;
      continue;
    }
    
    if (dryRun) {
      console.log(`📄 将删除: ${filePath}`);
      removedCount++;
    } else {
      try {
        fs.unlinkSync(fullPath);
        console.log(`✅ 已删除: ${filePath}`);
        removedCount++;
      } catch (error) {
        console.error(`❌ 删除失败 ${filePath}:`, error.message);
      }
    }
  }
  
  console.log(`\n📊 统计:`);
  console.log(`   - ${dryRun ? '将删除' : '已删除'}: ${removedCount} 个文件`);
  if (notFoundCount > 0) {
    console.log(`   - 未找到: ${notFoundCount} 个文件`);
  }
  
  if (dryRun) {
    console.log('\n💡 提示: 使用 --dry-run 参数进行模拟运行，移除该参数以实际删除文件。');
  }
}

if (require.main === module) {
  main();
}
