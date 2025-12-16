const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// 排除的目录
const EXCLUDED_DIRS = [
  'IconPark - Icons Pack (Community)',
  'Music1.0.0 (2)',
  'coat of arms svg backup',
  'node_modules',
  'oh_modules',
  '.git',
  'entry/build',
  'entry/src/main/resources/rawfile' // 资源文件通常通过代码动态引用，难以静态分析
];

// 排除的文件扩展名（通常不需要检查）
const EXCLUDED_EXTENSIONS = ['.png', '.svg', '.ogg', '.mp3', '.jpg', '.jpeg', '.json', '.json5', '.md', '.html'];

// 项目根目录
const PROJECT_ROOT = path.resolve(__dirname, '..');

// 结果存储
const results = {
  duplicateFiles: [], // 内容相同的文件
  similarNames: [], // 相似名称的文件
  unusedFiles: [], // 未使用的文件
  duplicateNames: [] // 同名但不同位置的文件
};

/**
 * 计算文件的MD5哈希
 */
function getFileHash(filePath) {
  try {
    const content = fs.readFileSync(filePath);
    return crypto.createHash('md5').update(content).digest('hex');
  } catch (err) {
    return null;
  }
}

/**
 * 检查路径是否在排除列表中
 */
function isExcluded(filePath) {
  const relativePath = path.relative(PROJECT_ROOT, filePath);
  return EXCLUDED_DIRS.some(dir => relativePath.includes(dir));
}

/**
 * 获取所有文件
 */
function getAllFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  
  files.forEach(file => {
    const filePath = path.join(dir, file);
    
    if (isExcluded(filePath)) {
      return;
    }
    
    const stat = fs.statSync(filePath);
    
    if (stat.isDirectory()) {
      getAllFiles(filePath, fileList);
    } else {
      const ext = path.extname(file).toLowerCase();
      // 只检查代码文件，资源文件通过其他方式检查
      if (!EXCLUDED_EXTENSIONS.includes(ext) || ext === '.ets' || ext === '.ts' || ext === '.js') {
        fileList.push(filePath);
      }
    }
  });
  
  return fileList;
}

/**
 * 查找重复文件（相同内容）
 */
function findDuplicateFiles(files) {
  const hashMap = new Map();
  
  files.forEach(file => {
    if (isExcluded(file)) return;
    
    const hash = getFileHash(file);
    if (!hash) return;
    
    if (!hashMap.has(hash)) {
      hashMap.set(hash, []);
    }
    hashMap.get(hash).push(file);
  });
  
  hashMap.forEach((fileList, hash) => {
    if (fileList.length > 1) {
      results.duplicateFiles.push({
        hash,
        files: fileList.map(f => path.relative(PROJECT_ROOT, f))
      });
    }
  });
}

/**
 * 计算字符串相似度（Levenshtein距离）
 */
function similarity(str1, str2) {
  const longer = str1.length > str2.length ? str1 : str2;
  const shorter = str1.length > str2.length ? str2 : str1;
  
  if (longer.length === 0) return 1.0;
  
  const distance = levenshteinDistance(longer, shorter);
  return (longer.length - distance) / longer.length;
}

function levenshteinDistance(str1, str2) {
  const matrix = [];
  
  for (let i = 0; i <= str2.length; i++) {
    matrix[i] = [i];
  }
  
  for (let j = 0; j <= str1.length; j++) {
    matrix[0][j] = j;
  }
  
  for (let i = 1; i <= str2.length; i++) {
    for (let j = 1; j <= str1.length; j++) {
      if (str2.charAt(i - 1) === str1.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j] + 1
        );
      }
    }
  }
  
  return matrix[str2.length][str1.length];
}

/**
 * 查找相似名称的文件
 */
function findSimilarNames(files) {
  const fileMap = new Map();
  
  // 按文件名分组
  files.forEach(file => {
    if (isExcluded(file)) return;
    
    const fileName = path.basename(file, path.extname(file));
    const ext = path.extname(file);
    const key = fileName.toLowerCase();
    
    if (!fileMap.has(key)) {
      fileMap.set(key, []);
    }
    fileMap.get(key).push({
      name: fileName + ext,
      path: path.relative(PROJECT_ROOT, file),
      fullPath: file
    });
  });
  
  // 查找同名文件（不同位置）
  fileMap.forEach((fileList, key) => {
    if (fileList.length > 1) {
      results.duplicateNames.push({
        name: fileList[0].name,
        files: fileList.map(f => f.path)
      });
    }
  });
  
  // 查找相似名称
  const fileArray = Array.from(fileMap.entries());
  for (let i = 0; i < fileArray.length; i++) {
    for (let j = i + 1; j < fileArray.length; j++) {
      const [name1, files1] = fileArray[i];
      const [name2, files2] = fileArray[j];
      
      const sim = similarity(name1, name2);
      if (sim > 0.7 && sim < 1.0) { // 相似度在70%-100%之间
        results.similarNames.push({
          name1,
          name2,
          similarity: (sim * 100).toFixed(2) + '%',
          files1: files1.map(f => f.path),
          files2: files2.map(f => f.path)
        });
      }
    }
  }
}

/**
 * 检查文件是否在代码中被引用
 */
function findUnusedFiles(files) {
  const codeFiles = files.filter(f => {
    const ext = path.extname(f).toLowerCase();
    return ['.ets', '.ts', '.js'].includes(ext);
  });
  
  // 读取所有代码文件内容
  const codeContent = new Map();
  codeFiles.forEach(file => {
    try {
      const content = fs.readFileSync(file, 'utf8');
      codeContent.set(file, content);
    } catch (err) {
      // 忽略读取错误
    }
  });
  
  // 检查每个文件是否被引用
  codeFiles.forEach(file => {
    if (isExcluded(file)) return;
    
    const fileName = path.basename(file, path.extname(file));
    const relativePath = path.relative(PROJECT_ROOT, file);
    
    // 跳过入口文件和配置文件
    if (fileName.includes('EntryAbility') || 
        fileName.includes('Index') ||
        fileName.includes('main_pages') ||
        relativePath.includes('test') ||
        relativePath.includes('ohosTest')) {
      return;
    }
    
    let isUsed = false;
    
    // 检查是否在其他文件中被导入
    codeContent.forEach((content, otherFile) => {
      if (otherFile === file) return;
      
      // 检查import语句
      const importPatterns = [
        new RegExp(`from\\s+['"].*${fileName}['"]`, 'i'),
        new RegExp(`import\\s+.*from\\s+['"].*${fileName}['"]`, 'i'),
        new RegExp(`require\\(['"].*${fileName}['"]\\)`, 'i')
      ];
      
      // 检查相对路径引用
      const relativePathPattern = relativePath.replace(/\\/g, '/').replace(/\.(ets|ts|js)$/, '');
      const relativeImportPattern = new RegExp(`['"]\\.\\.?/.*${fileName}`, 'i');
      
      if (importPatterns.some(pattern => pattern.test(content)) || 
          relativeImportPattern.test(content)) {
        isUsed = true;
      }
    });
    
    // 检查是否在module.json5等配置文件中被引用
    const configFiles = [
      path.join(PROJECT_ROOT, 'entry/src/main/module.json5'),
      path.join(PROJECT_ROOT, 'entry/src/main/resources/base/profile/main_pages.json')
    ];
    
    configFiles.forEach(configFile => {
      if (fs.existsSync(configFile)) {
        try {
          const configContent = fs.readFileSync(configFile, 'utf8');
          if (configContent.includes(fileName) || configContent.includes(relativePath)) {
            isUsed = true;
          }
        } catch (err) {
          // 忽略
        }
      }
    });
    
    if (!isUsed) {
      results.unusedFiles.push({
        file: relativePath,
        name: fileName
      });
    }
  });
}

/**
 * 生成报告
 */
function generateReport() {
  const report = {
    timestamp: new Date().toISOString(),
    summary: {
      duplicateFiles: results.duplicateFiles.length,
      duplicateNames: results.duplicateNames.length,
      similarNames: results.similarNames.length,
      unusedFiles: results.unusedFiles.length
    },
    details: results
  };
  
  // 保存JSON报告
  const reportPath = path.join(PROJECT_ROOT, 'scripts', 'file_review_result.json');
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2), 'utf8');
  console.log(`报告已保存到: ${reportPath}`);
  
  // 生成Markdown报告
  let mdReport = `# 文件审查报告\n\n`;
  mdReport += `生成时间: ${new Date().toLocaleString('zh-CN')}\n\n`;
  mdReport += `## 摘要\n\n`;
  mdReport += `- 重复文件（相同内容）: ${results.duplicateFiles.length} 组\n`;
  mdReport += `- 同名文件（不同位置）: ${results.duplicateNames.length} 组\n`;
  mdReport += `- 相似名称文件: ${results.similarNames.length} 组\n`;
  mdReport += `- 未使用文件: ${results.unusedFiles.length} 个\n\n`;
  
  // 重复文件
  if (results.duplicateFiles.length > 0) {
    mdReport += `## 1. 重复文件（相同内容）\n\n`;
    results.duplicateFiles.forEach((group, index) => {
      mdReport += `### ${index + 1}. 文件组 ${index + 1}\n\n`;
      mdReport += `**哈希**: ${group.hash}\n\n`;
      mdReport += `**文件列表**:\n`;
      group.files.forEach(file => {
        mdReport += `- ${file}\n`;
      });
      mdReport += `\n`;
    });
  }
  
  // 同名文件
  if (results.duplicateNames.length > 0) {
    mdReport += `## 2. 同名文件（不同位置）\n\n`;
    results.duplicateNames.forEach((group, index) => {
      mdReport += `### ${index + 1}. ${group.name}\n\n`;
      mdReport += `**文件位置**:\n`;
      group.files.forEach(file => {
        mdReport += `- ${file}\n`;
      });
      mdReport += `\n`;
    });
  }
  
  // 相似名称
  if (results.similarNames.length > 0) {
    mdReport += `## 3. 相似名称文件\n\n`;
    results.similarNames.forEach((group, index) => {
      mdReport += `### ${index + 1}. ${group.name1} ↔ ${group.name2}\n\n`;
      mdReport += `**相似度**: ${group.similarity}\n\n`;
      mdReport += `**文件位置**:\n`;
      mdReport += `- ${group.name1}:\n`;
      group.files1.forEach(file => {
        mdReport += `  - ${file}\n`;
      });
      mdReport += `- ${group.name2}:\n`;
      group.files2.forEach(file => {
        mdReport += `  - ${file}\n`;
      });
      mdReport += `\n`;
    });
  }
  
  // 未使用文件
  if (results.unusedFiles.length > 0) {
    mdReport += `## 4. 未使用文件\n\n`;
    mdReport += `⚠️ **注意**: 这些文件可能未被直接引用，但请仔细检查后再删除。\n\n`;
    results.unusedFiles.forEach((item, index) => {
      mdReport += `${index + 1}. **${item.name}**\n`;
      mdReport += `   - 路径: ${item.file}\n\n`;
    });
  }
  
  const mdReportPath = path.join(PROJECT_ROOT, 'scripts', 'file_review_report.md');
  fs.writeFileSync(mdReportPath, mdReport, 'utf8');
  console.log(`Markdown报告已保存到: ${mdReportPath}`);
  
  return report;
}

/**
 * 主函数
 */
function main() {
  console.log('开始审查项目文件...');
  console.log('排除目录:', EXCLUDED_DIRS.join(', '));
  
  const allFiles = getAllFiles(PROJECT_ROOT);
  console.log(`找到 ${allFiles.length} 个文件`);
  
  console.log('\n1. 查找重复文件（相同内容）...');
  findDuplicateFiles(allFiles);
  console.log(`   找到 ${results.duplicateFiles.length} 组重复文件`);
  
  console.log('\n2. 查找同名和相似名称文件...');
  findSimilarNames(allFiles);
  console.log(`   找到 ${results.duplicateNames.length} 组同名文件`);
  console.log(`   找到 ${results.similarNames.length} 组相似名称文件`);
  
  console.log('\n3. 查找未使用文件...');
  findUnusedFiles(allFiles);
  console.log(`   找到 ${results.unusedFiles.length} 个可能未使用的文件`);
  
  console.log('\n4. 生成报告...');
  generateReport();
  
  console.log('\n审查完成！');
}

main();

