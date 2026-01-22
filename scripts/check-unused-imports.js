#!/usr/bin/env node
/**
 * 检查未使用的导入
 * 分析代码中的import语句，找出可能未使用的导入
 * 
 * 使用方法：
 * node scripts/check-unused-imports.js
 */

const fs = require('fs');
const path = require('path');

const ETS_DIR = 'entry/src/main/ets';

// 解析import语句
function parseImports(content) {
  const imports = [];
  const importRegex = /^import\s+(?:(?:\*\s+as\s+(\w+))|(?:\{([^}]+)\})|(\w+))\s+from\s+['"]([^'"]+)['"]/gm;
  
  let match;
  while ((match = importRegex.exec(content)) !== null) {
    const [, namespace, named, defaultName, modulePath] = match;
    
    if (namespace) {
      imports.push({ type: 'namespace', name: namespace, module: modulePath });
    } else if (defaultName) {
      imports.push({ type: 'default', name: defaultName, module: modulePath });
    } else if (named) {
      const items = named.split(',').map(item => {
        const trimmed = item.trim();
        const parts = trimmed.split(/\s+as\s+/);
        return {
          original: parts[0].trim(),
          alias: parts[1] ? parts[1].trim() : parts[0].trim()
        };
      });
      imports.push({ type: 'named', items, module: modulePath });
    }
  }
  
  return imports;
}

// 检查导入是否被使用
function checkUsage(content, imports) {
  const unused = [];
  
  for (const imp of imports) {
    if (imp.type === 'namespace') {
      const regex = new RegExp(`\\b${imp.name}\\b`, 'g');
      if (!regex.test(content)) {
        unused.push(imp);
      }
    } else if (imp.type === 'default') {
      const regex = new RegExp(`\\b${imp.name}\\b`, 'g');
      // 排除import语句本身
      const matches = content.match(new RegExp(`\\b${imp.name}\\b`, 'g'));
      if (!matches || matches.length <= 1) {
        unused.push(imp);
      }
    } else if (imp.type === 'named') {
      const unusedItems = [];
      for (const item of imp.items) {
        const regex = new RegExp(`\\b${item.alias}\\b`, 'g');
        const matches = content.match(regex);
        // 排除import语句本身
        if (!matches || matches.length <= 1) {
          unusedItems.push(item);
        }
      }
      if (unusedItems.length > 0) {
        unused.push({ ...imp, unusedItems });
      }
    }
  }
  
  return unused;
}

// 递归查找所有.ets文件
function findETSFiles(dir) {
  const files = [];
  if (!fs.existsSync(dir)) {
    return files;
  }
  
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      // 跳过node_modules等目录
      if (!entry.name.startsWith('.') && entry.name !== 'node_modules') {
        files.push(...findETSFiles(fullPath));
      }
    } else if (entry.isFile() && entry.name.endsWith('.ets')) {
      files.push(fullPath);
    }
  }
  return files;
}

// 主函数
function main() {
  console.log('🔍 开始检查未使用的导入...\n');
  
  const files = findETSFiles(ETS_DIR);
  const results = [];
  
  for (const file of files) {
    try {
      const content = fs.readFileSync(file, 'utf8');
      const imports = parseImports(content);
      
      if (imports.length > 0) {
        const unused = checkUsage(content, imports);
        if (unused.length > 0) {
          results.push({
            file: path.relative(ETS_DIR, file),
            unused
          });
        }
      }
    } catch (error) {
      console.error(`Error processing ${file}:`, error.message);
    }
  }
  
  // 输出结果
  if (results.length === 0) {
    console.log('✅ 未发现未使用的导入！');
    return;
  }
  
  console.log(`⚠️  发现 ${results.length} 个文件包含可能未使用的导入:\n`);
  
  for (const result of results) {
    console.log(`📄 ${result.file}:`);
    for (const imp of result.unused) {
      if (imp.type === 'namespace' || imp.type === 'default') {
        console.log(`   - ${imp.type}: ${imp.name} from '${imp.module}'`);
      } else if (imp.type === 'named') {
        const items = imp.unusedItems.map(item => item.alias).join(', ');
        console.log(`   - named: { ${items} } from '${imp.module}'`);
      }
    }
    console.log('');
  }
  
  console.log('\n💡 提示: 请手动检查这些导入，某些可能通过装饰器或其他方式使用。');
}

if (require.main === module) {
  main();
}

module.exports = { parseImports, checkUsage };
