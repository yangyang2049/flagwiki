# 优化脚本说明

本目录包含用于优化项目资源和代码的脚本。

## 脚本列表

### 1. optimize-svgs.js - SVG资源压缩

**功能**: 压缩SVG文件，移除不必要的元数据、注释和空白字符

**使用方法**:
```bash
node scripts/optimize-svgs.js
```

**优化内容**:
- 移除XML注释
- 移除DOCTYPE声明
- 移除不必要的元数据（sodipodi, inkscape等）
- 压缩空白字符
- 移除行首行尾空白

**处理的文件**:
- **图标文件**：仅处理以 `icon` 或 `ic_` 开头的SVG文件
  - `entry/src/main/resources/base/media/` (图标文件)
  - `entry/src/main/resources/dark/media/` (图标文件)
- **州旗文件**：处理所有SVG文件
  - `entry/src/main/resources/rawfile/state_flags/` (所有州旗SVG文件)

**注意**: 国旗SVG文件（flags、paint_flags）不会被处理，以保持其完整性和质量

**输出**: 显示优化统计信息，包括节省的空间大小和百分比

---

### 2. check-unused-imports.js - 检查未使用的导入

**功能**: 分析代码中的import语句，找出可能未使用的导入

**使用方法**:
```bash
node scripts/check-unused-imports.js
```

**检查内容**:
- 命名空间导入 (`import * as ...`)
- 默认导入 (`import ...`)
- 命名导入 (`import { ... }`)

**注意**: 
- 某些导入可能通过装饰器或其他方式使用，需要手动验证
- 建议在删除前仔细检查每个未使用的导入

---

### 3. remove-unused-files.js - 移除未使用的文件

**功能**: 根据文档审查报告，移除确认未使用的文件

**使用方法**:
```bash
# 模拟运行（不实际删除）
node scripts/remove-unused-files.js --dry-run

# 实际删除
node scripts/remove-unused-files.js
```

**将删除的文件**:
- `entry/src/main/ets/utils/CoatOfArmsDownloader.ets` (未使用)
- `entry/src/main/ets/utils/CoatOfArmsDatabase.ets` (未使用)
- `download_anthems.py` (未使用的Python脚本)

**注意**: 建议先使用 `--dry-run` 参数查看将要删除的文件

---

## 使用建议

### 资源优化流程

1. **运行SVG优化脚本**:
   ```bash
   node scripts/optimize-svgs.js
   ```
   这将压缩所有SVG文件，通常可以节省10-30%的空间。

2. **检查未使用的导入**:
   ```bash
   node scripts/check-unused-imports.js
   ```
   手动检查输出，确认哪些导入确实未使用。

3. **移除未使用的文件**:
   ```bash
   node scripts/remove-unused-files.js --dry-run
   node scripts/remove-unused-files.js
   ```

### Tree Shaking

项目已配置为在构建时自动进行tree shaking：
- `entry/build-profile.json5` 中已设置 `runtimeOnly: false`，确保未使用的代码被移除
- HarmonyOS编译器会自动分析代码依赖关系，移除未使用的导出

### 构建优化

在发布构建时，确保：
1. 使用 `release` 构建模式
2. 启用代码混淆（可选，在 `entry/build-profile.json5` 中配置）
3. 资源压缩已通过SVG优化脚本完成

---

## 注意事项

1. **备份**: 在运行删除脚本前，建议先提交代码到版本控制系统
2. **验证**: 优化后请测试应用功能，确保没有破坏任何功能
3. **增量优化**: 可以多次运行优化脚本，但后续运行的效果会递减
4. **手动检查**: 自动检测工具可能无法识别所有情况，需要人工审查

---

## 预期效果

- **SVG文件大小**: 减少10-30%
- **代码体积**: 通过tree shaking和移除未使用文件，减少5-15%
- **构建时间**: 可能略有提升（因为需要处理的文件更少）
- **运行时性能**: 无明显影响，但应用体积减小可能提升加载速度
