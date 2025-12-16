import fs from '@ohos.file.fs';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { Logger } from './Logger';
import { BaseViewModel } from './BaseViewModel';
import { CommonConstants } from '../constants/CommonConstants';
import { EventBus } from './EventBus';
import { promptAction } from '@kit.ArkUI';


/**
 * 下载文件及打开工具类
 */
export class DownloadFileUtil extends BaseViewModel {
  /**
   * 开始下载文件 设置文件下载路径 校验文件是否存在
   */
  static startDownFile(downPath: string, context: Context) {
    let cachepath: string = AppStorage.get(CommonConstants.STORAGE_CACHE_PATH) as string
    if (!cachepath || cachepath === '') {
      cachepath = '/music'
      AppStorage.setOrCreate(CommonConstants.STORAGE_CACHE_PATH, cachepath)
    }

    // 检测应用沙箱目录是否存在
    let filesDir = `${context.filesDir}${cachepath}`;
    try {
      if (!fs.accessSync(filesDir)) {
        fs.mkdirSync(filesDir);
      }
    } catch (err) {
      Logger.error('创建目录失败：', err.message);
    }

    //文件名称
    let fileName = DownloadFileUtil.parseFileNameAndType(downPath)
    //文件保存在应用沙箱路径
    let filePath = filesDir + '/' + fileName
    Logger.info('DownloadFileUtil 文件名：' + fileName)
    Logger.info('DownloadFileUtil 文件路径：' + filePath)
    Logger.info('DownloadFileUtil 下载地址：' + downPath)
    try {
      // 判断沙箱内文件是否存在
      fs.access(filePath).then((res: boolean) => {
        if (res) {
          Logger.info('DownloadFileUtil 文件存在')
          promptAction.showToast({message:'本地已存在该歌曲'})
        } else {
          Logger.info('DownloadFileUtil 文件不存在')
          DownloadFileUtil.downloadFile(context, downPath, filePath)
        }
      }).catch((err: BusinessError) => {
        Logger.error('DownloadFileUtil access failed with error message: ' + err.message + ', error code: ' + err.code);
      });

    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error('DownloadFileUtil startDownFile：' + err.message)
    }
  }

  /**
   * 根据downPath判断歌曲在沙箱内是否存在
   */
  static async isFileExist(downPath: string, context: Context): Promise<boolean> {
    let cachepath: string = AppStorage.get('cache_path') as string
    if (!cachepath || cachepath === '') {
      cachepath = '/music'
      AppStorage.setOrCreate('cache_path', cachepath)
    }
    let filesDir = `${context.filesDir}${cachepath}`;
    try {
      if (!fs.accessSync(filesDir)) {
        fs.mkdirSync(filesDir);
      }
    } catch (err) {
      Logger.error('DownloadFileUtil 文件夹创建失败：', err.message);
    }
    let fileName = DownloadFileUtil.parseFileNameAndType(downPath)
    let filePath = filesDir + '/' + fileName
    return fs.accessSync(filePath)
  }

  /**
   * 下载文件
   * @param downPath 下载地址
   * @param filePath  下载保存路径
   */
  static downloadFile(context: Context, downPath: string, filePath: string) {
    request.downloadFile(context, {
      url: downPath,
      filePath: filePath
    }).then((downloadTask: request.DownloadTask) => {
      let progressCallback = (receivedSize: number, totalSize: number) => {
        Logger.info('DownloadFileUtil download receivedSize:' + receivedSize + ' totalSize:' + totalSize);
      };
      downloadTask.on('progress', progressCallback); //下载进度变化

      downloadTask.on('complete', () => { //下载完成
        Logger.info('DownloadFileUtil download complete');
        Logger.error('DownloadFileUtil 文件大小:' + fs.lstatSync(filePath).size) //看看文件是否下载正常
        EventBus.send('updateLocalSongs')
      })
    }).catch((err: BusinessError) => {
      Logger.error(`DownloadFileUtil Invoke downloadTask failed, code is ${err.code}, message is ${err.message}`);
    });
  }

  //获取存放地址
  static getFilePath(context: Context) {
    return AppStorage.get(CommonConstants.STORAGE_CACHE_PATH) as string
  }

  // 解析URL中的文件名和文件类型
  static parseFileNameAndType(url: string): string {
    // 解码URL并提取路径部分
    const decodedUrl = decodeURIComponent(url);
    // 提取文件名（最后一个斜杠后的内容，问号前的部分）
    const pathParts = decodedUrl.split('/');
    const fileNameWithQuery = pathParts[pathParts.length - 1];
    const fileName = fileNameWithQuery.split('?')[0];
    // 提取文件扩展名
    const fileType = fileName.split('.').pop() || '';

    return fileName;
  }
}
