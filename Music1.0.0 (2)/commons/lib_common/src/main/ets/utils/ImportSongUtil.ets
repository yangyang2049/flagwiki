import { promptAction } from '@kit.ArkUI';
import { picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { CommonConstants } from '../constants/CommonConstants';
import { Logger } from '../../../../Index';


export class ImportSongUtil {
  // 导入本地歌曲，返回导入后的文件路径
  static async importLocalSong(context: common.UIAbilityContext): Promise<string | null> {
    promptAction.showToast({ message: '导入本地歌曲' });
    let file: fs.File | null = null;
    let file2: fs.File | null = null;
    try {
      // 1. 创建音频文件选择器
      const documentPicker = new picker.DocumentViewPicker();
      const selectOptions: picker.DocumentSelectOptions = {
        fileSuffixFilters: ['mp3', 'flac', 'wav', 'aac'],
        maxSelectNumber: 1
      };

      // 2. 打开选择器并获取用户选择的文件
      const selectResult: Array<string> = await documentPicker.select(selectOptions);
      if (selectResult.length === 0) {
        Logger.info('用户取消了文件选择');
        return null;
      }

      // 3. 获取源文件信息
      const sourceUri = selectResult[0];
      file = fs.openSync(sourceUri, fs.OpenMode.READ_ONLY)
      const fileName = sourceUri.split('/').pop() || 'unknown_audio.mp3';

      // 4. 构建沙箱目标路径
      let cachepath = ImportSongUtil.getCachepath();
      let targetDirPath = `${context.filesDir}${cachepath}`;
      const targetFilePath = `${targetDirPath}/${fileName}`;

      // 5. 确保目标目录存在
      try {
        if (!fs.accessSync(targetDirPath)) {
          fs.mkdirSync(targetDirPath);
          Logger.info(`创建沙箱目录：${targetDirPath}`);
        }
      } catch (err) {
        Logger.error(`目录操作失败：${JSON.stringify(err)}`);
        return null;
      }

      file2 = fs.openSync(targetFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      // 6. 使用 copyFileSync 直接复制文件
      fs.copyFileSync(file.fd, file2.fd);

      Logger.info(`歌曲导入成功：${targetFilePath}`);
      return targetFilePath;
    } catch (error) {
      Logger.error(`导入失败：${JSON.stringify(error)}`);
      return null;
    } finally {
      if (file) {
        fs.closeSync(file);
      }
      if (file2) {
        fs.closeSync(file2);
      }
    }
  }

  // 获取存储目录
  static getCachepath() {
    let cachepath: string = AppStorage.get(CommonConstants.STORAGE_CACHE_PATH) as string;
    if (!cachepath || cachepath === '') {
      cachepath = '/music';
      AppStorage.setOrCreate(CommonConstants.STORAGE_CACHE_PATH, cachepath);
    }
    return cachepath;
  }
}
