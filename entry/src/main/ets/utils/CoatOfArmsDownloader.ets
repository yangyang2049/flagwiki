/**
 * 国徽下载管理器
 * 负责从网络下载国徽图片并保存到本地
 */

import { http } from '@kit.NetworkKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { coatOfArmsDatabase, CoatOfArmsInfo, DownloadProgress } from './CoatOfArmsDatabase';
import { Countries } from './countryData';

// REST Countries API 响应类型
interface RestCountryCoatOfArms {
  svg?: string;
  png?: string;
}

interface RestCountryResponse {
  coatOfArms?: RestCountryCoatOfArms;
}

// 批量下载结果接口
interface BatchDownloadResult {
  success: number;
  failed: number;
  total: number;
}

// 国徽图片URL模板（使用REST Countries API或类似服务）
// 注意：这里使用一个通用的URL模式，实际使用时可能需要根据具体API调整
const COAT_OF_ARMS_URL_TEMPLATE = 'https://flagcdn.com/coats/{code}.svg';
// 备用URL：使用REST Countries API
const REST_COUNTRIES_URL = 'https://restcountries.com/v3.1/alpha/{code}';

class CoatOfArmsDownloaderClass {
  private context: common.UIAbilityContext | null = null;
  private downloadDir: string = '';

  /**
   * 初始化下载管理器
   */
  async init(context: common.UIAbilityContext): Promise<void> {
    this.context = context;

    // 创建国徽存储目录
    const filesDir = context.filesDir;
    this.downloadDir = `${filesDir}/coats_of_arms`;

    try {
      // 确保目录存在
      if (!fs.accessSync(this.downloadDir)) {
        fs.mkdirSync(this.downloadDir, true);
      }
    } catch (err) {
      console.error('[CoatOfArmsDownloader] Failed to create directory:', err);
      const error = err instanceof Error ? err : new Error(`Failed to create directory: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 获取国徽图片URL
   */
  private getCoatOfArmsUrl(countryCode: string): string {
    // 使用REST Countries API获取国徽URL
    const code = countryCode.toLowerCase();
    return `https://restcountries.com/v3.1/alpha/${code}`;
  }

  /**
   * 解析JSON字符串为RestCountryResponse数组
   */
  private parseCountryResponse(jsonString: string): RestCountryResponse[] {
    // JSON.parse 返回 any 类型是 JavaScript 标准行为，需要通过类型断言转换
    const parsed: RestCountryResponse[] = JSON.parse(jsonString) as RestCountryResponse[];
    return parsed;
  }

  /**
   * 从REST Countries API获取国徽URL
   */
  private async fetchCoatOfArmsUrlFromAPI(countryCode: string): Promise<string | null> {
    let httpRequest: http.HttpRequest | null = null;
    try {
      const code = countryCode.toLowerCase();
      const url = `https://restcountries.com/v3.1/alpha/${code}`;
      httpRequest = http.createHttp();

      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      if (response.responseCode === 200 && response.result) {
        try {
          const parseResult: string = response.result as string;
          const data: RestCountryResponse[] = this.parseCountryResponse(parseResult);
          if (data.length > 0) {
            const country: RestCountryResponse = data[0];
            // REST Countries API中，国徽在coatOfArms字段
            if (country.coatOfArms && country.coatOfArms.svg) {
              return country.coatOfArms.svg;
            }
          }
        } catch (parseErr) {
          console.error('[CoatOfArmsDownloader] Failed to parse API response:', parseErr);
        }
      }

      return null;
    } catch (err) {
      console.error('[CoatOfArmsDownloader] Failed to fetch coat of arms URL:', err);
      return null;
    } finally {
      if (httpRequest) {
        httpRequest.destroy();
      }
    }
  }

  /**
   * 下载国徽图片
   */
  async downloadCoatOfArms(countryCode: string, onProgress?: (progress: number) => void): Promise<string> {
    if (!this.context) {
      throw new Error('Downloader not initialized');
    }

    // 更新下载状态为downloading
    await coatOfArmsDatabase.updateDownloadProgress({
      countryCode: countryCode,
      status: 'downloading',
      progress: 0,
      lastUpdateTime: Date.now()
    });

    try {
      // 先从API获取国徽URL
      const coatOfArmsUrl = await this.fetchCoatOfArmsUrlFromAPI(countryCode);
      if (!coatOfArmsUrl) {
        throw new Error('Failed to get coat of arms URL from API');
      }

      // 下载图片
      let httpRequest: http.HttpRequest | null = null;
      try {
        httpRequest = http.createHttp();

        // 更新进度
        if (onProgress) {
          onProgress(10);
        }
        await coatOfArmsDatabase.updateDownloadProgress({
          countryCode: countryCode,
          status: 'downloading',
          progress: 10,
          lastUpdateTime: Date.now()
        });

        const response = await httpRequest.request(coatOfArmsUrl, {
          method: http.RequestMethod.GET,
          header: {
            'Accept': 'image/svg+xml,image/*,*/*'
          }
        });

        if (response.responseCode !== 200 || !response.result) {
          throw new Error(`HTTP ${response.responseCode}`);
        }

        // 更新进度
        if (onProgress) {
          onProgress(50);
        }
        await coatOfArmsDatabase.updateDownloadProgress({
          countryCode: countryCode,
          status: 'downloading',
          progress: 50,
          lastUpdateTime: Date.now()
        });

        // 保存到本地文件
        const fileName = `${countryCode.toLowerCase()}.svg`;
        const filePath = `${this.downloadDir}/${fileName}`;

        // 将响应数据写入文件
        const file = await fs.open(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
        try {
          // 处理响应数据：可能是ArrayBuffer或字符串
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
          await fs.write(file.fd, data);
          await fs.close(file.fd);
        } catch (writeErr) {
          await fs.close(file.fd);
          const error = writeErr instanceof Error ? writeErr : new Error(`Failed to write file: ${String(writeErr)}`);
          throw error;
        }

        // 获取文件大小
        const fileStat = fs.statSync(filePath);
        const fileSize = fileStat.size;

        // 更新进度
        if (onProgress) {
          onProgress(100);
        }

        // 保存到数据库
        const coatOfArmsInfo: CoatOfArmsInfo = {
          countryCode: countryCode.toLowerCase(),
          filePath: filePath,
          downloadTime: Date.now(),
          fileSize: fileSize
        };
        await coatOfArmsDatabase.saveCoatOfArms(coatOfArmsInfo);

        // 更新下载状态为completed
        await coatOfArmsDatabase.updateDownloadProgress({
          countryCode: countryCode,
          status: 'completed',
          progress: 100,
          lastUpdateTime: Date.now()
        });

        return filePath;
      } finally {
        if (httpRequest) {
          httpRequest.destroy();
        }
      }
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : String(err);

      // 更新下载状态为failed
      await coatOfArmsDatabase.updateDownloadProgress({
        countryCode: countryCode,
        status: 'failed',
        progress: 0,
        errorMessage: errorMsg,
        lastUpdateTime: Date.now()
      });

      console.error('[CoatOfArmsDownloader] Failed to download coat of arms:', err);
      const error = err instanceof Error ? err : new Error(`Failed to download coat of arms: ${String(err)}`);
      throw error;
    }
  }

  /**
   * 批量下载国徽
   */
  async downloadBatch(countryCodes: string[], onProgress?: (current: number, total: number, countryCode: string, success: boolean) => void): Promise<BatchDownloadResult> {
    let successCount = 0;
    let failedCount = 0;

    for (let i = 0; i < countryCodes.length; i++) {
      const code = countryCodes[i];
      try {
        // 检查是否已下载
        const hasCoatOfArms = await coatOfArmsDatabase.hasCoatOfArms(code);
        if (hasCoatOfArms) {
          // 已存在，跳过
          if (onProgress) {
            onProgress(i + 1, countryCodes.length, code, true);
          }
          successCount++;
          continue;
        }

        // 检查下载进度，如果正在下载或已完成，跳过
        const progress = await coatOfArmsDatabase.getDownloadProgress(code);
        if (progress && (progress.status === 'downloading' || progress.status === 'completed')) {
          if (onProgress) {
            onProgress(i + 1, countryCodes.length, code, true);
          }
          successCount++;
          continue;
        }

        await this.downloadCoatOfArms(code);
        successCount++;
        if (onProgress) {
          onProgress(i + 1, countryCodes.length, code, true);
        }
      } catch (err) {
        failedCount++;
        console.error(`[CoatOfArmsDownloader] Failed to download ${code}:`, err);
        if (onProgress) {
          onProgress(i + 1, countryCodes.length, code, false);
        }
        // 继续下载下一个
      }
    }

    const result: BatchDownloadResult = {
      success: successCount,
      failed: failedCount,
      total: countryCodes.length
    };
    return result;
  }

  /**
   * 下载所有国家的国徽
   */
  async downloadAllCountries(onProgress?: (current: number, total: number, countryCode: string, success: boolean) => void): Promise<BatchDownloadResult> {
    const countryCodes = Countries.map((country) => country.code);
    return await this.downloadBatch(countryCodes, onProgress);
  }

  /**
   * 获取本地国徽文件路径
   */
  getLocalFilePath(countryCode: string): string {
    const fileName = `${countryCode.toLowerCase()}.svg`;
    return `${this.downloadDir}/${fileName}`;
  }
}

export const coatOfArmsDownloader = new CoatOfArmsDownloaderClass();

