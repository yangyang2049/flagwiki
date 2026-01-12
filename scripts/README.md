# 脚本说明

## download_coats_of_arms.js

批量下载所有国家的国徽到media文件夹的脚本。

### 使用方法

```bash
# 下载所有国家的国徽（跳过已存在的）
node scripts/download_coats_of_arms.js

# 只重新下载失败的国徽
node scripts/download_coats_of_arms.js --retry
# 或
node scripts/download_coats_of_arms.js -r
```

### 功能说明

1. 从 REST Countries API 获取所有国家的国徽URL
2. 下载SVG格式的国徽图片
3. 保存到 `entry/src/main/resources/base/media/` 目录
4. 文件命名格式：`coat_of_arms_xx.svg`（xx为国家代码，如 `coat_of_arms_cn.svg`）
5. 生成下载结果报告到 `scripts/download_coats_result.json`
6. **自动跳过已下载的文件**，避免重复下载
7. **自动重试机制**：对于网络错误和HTTP 521错误，会自动重试3次
8. **重试模式**：使用 `--retry` 参数可以只重新下载之前失败的国家

### 重试机制

- 对于HTTP 521错误（Cloudflare保护），会自动重试3次，每次间隔2秒
- 对于网络错误，会自动重试3次，每次间隔2秒
- 失败后延迟时间更长（2秒），避免频繁请求

### 注意事项

- 需要网络连接
- 下载过程可能需要较长时间（约200+个国家）
- 部分国家可能没有国徽数据，会跳过
- 如果下载中断，可以运行 `--retry` 模式继续下载失败的
- 下载完成后，需要在HarmonyOS项目中注册这些资源文件


