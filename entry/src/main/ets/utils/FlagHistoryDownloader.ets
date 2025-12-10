/**
 * 历史国旗下载工具（开发工具）
 * 用于从维基百科下载历史国旗图片并保存到本地
 * 
 * 使用说明：
 * 1. 从维基百科页面 https://zh.wikipedia.org/wiki/各国国旗变迁时间轴 获取数据
 * 2. 解析表格中的图片链接和年份
 * 3. 下载图片并保存到 resources/base/media/ 目录
 * 4. 在 FlagHistoryData.ets 中添加数据条目
 * 
 * 注意：
 * - 此工具仅用于开发阶段预下载图片
 * - 图片需要手动添加到项目资源目录
 * - 运行时不会使用此下载器，所有图片都是预下载的
 */

import { http } from '@kit.NetworkKit';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';

// 历史国旗数据条目（用于下载）
export interface FlagHistoryDownloadItem {
  countryCode: string;
  year: number;
  imageUrl: string;  // 维基百科图片URL
  description?: string;
}

/**
 * 下载单个历史国旗图片
 * @param item 历史国旗数据
 * @param context 应用上下文
 * @returns 保存的本地文件路径
 */
export async function downloadFlagHistoryImage(
  item: FlagHistoryDownloadItem,
  context: common.UIAbilityContext
): Promise<string> {
  try {
    const httpRequest = http.createHttp();
    const response = await httpRequest.request(item.imageUrl, {
      method: http.RequestMethod.GET,
      header: {
        'Accept': 'image/png,image/jpeg,image/svg+xml,*/*'
      }
    });

    if (response.responseCode !== 200 || !response.result) {
      throw new Error(`HTTP ${response.responseCode}`);
    }

    // 保存到本地
    const filesDir = context.filesDir;
    const historyDir = `${filesDir}/flag_history`;
    
    // 确保目录存在
    if (!fs.accessSync(historyDir)) {
      fs.mkdirSync(historyDir, true);
    }

    // 生成文件名：{countryCode}_{year}.png
    const fileName = `${item.countryCode}_${item.year}.png`;
    const filePath = `${historyDir}/${fileName}`;

    // 写入文件
    let data: ArrayBuffer;
    if (response.result instanceof ArrayBuffer) {
      data = response.result;
    } else if (typeof response.result === 'string') {
      // 将字符串转换为ArrayBuffer
      const str = response.result;
      const buffer = new ArrayBuffer(str.length * 2);
      const view = new Uint16Array(buffer);
      for (let i = 0; i < str.length; i++) {
        view[i] = str.charCodeAt(i);
      }
      data = buffer;
    } else {
      throw new Error('Unsupported response type');
    }

    const file = await fs.open(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
    try {
      await fs.write(file.fd, data);
      await fs.close(file.fd);
    } catch (writeErr) {
      await fs.close(file.fd);
      throw writeErr;
    }

    httpRequest.destroy();
    return filePath;
  } catch (err) {
    console.error(`Failed to download flag history image for ${item.countryCode} ${item.year}:`, err);
    throw err;
  }
}

/**
 * 批量下载历史国旗图片
 * @param items 历史国旗数据列表
 * @param context 应用上下文
 * @param onProgress 进度回调
 */
export async function downloadFlagHistoryBatch(
  items: FlagHistoryDownloadItem[],
  context: common.UIAbilityContext,
  onProgress?: (current: number, total: number) => void
): Promise<void> {
  const total = items.length;
  for (let i = 0; i < total; i++) {
    try {
      await downloadFlagHistoryImage(items[i], context);
      if (onProgress) {
        onProgress(i + 1, total);
      }
    } catch (err) {
      console.error(`Failed to download item ${i + 1}/${total}:`, err);
      // 继续下载下一个
    }
  }
}

/**
 * 从维基百科URL获取图片URL
 * 维基百科图片URL格式：https://upload.wikimedia.org/wikipedia/commons/...
 * @param wikiUrl 维基百科图片URL
 * @returns 实际图片URL
 */
export function getWikiImageUrl(wikiUrl: string): string {
  // 如果已经是完整URL，直接返回
  if (wikiUrl.startsWith('http://') || wikiUrl.startsWith('https://')) {
    return wikiUrl;
  }
  
  // 如果是相对路径，转换为完整URL
  if (wikiUrl.startsWith('/wiki/File:')) {
    const fileName = wikiUrl.replace('/wiki/File:', '');
    return `https://upload.wikimedia.org/wikipedia/commons/${fileName}`;
  }
  
  return wikiUrl;
}

