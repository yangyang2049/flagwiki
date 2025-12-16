import { fileIo as fs, ListFileOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { CommonConstants } from '../constants/CommonConstants';
import { ImportSongUtil } from './ImportSongUtil';
import fileIo from '@ohos.file.fs';
import { media } from '@kit.MediaKit';
import { SongItem } from 'lib_music_api/src/main/ets/params/response/SongItem';
import util from '@ohos.util';
import { Logger } from './Logger';

const TAG = 'LocalSongsPage';

// 扫描沙箱路径下所有歌曲文件（递归遍历子目录）
export function scanSandboxMusicFiles(context: common.UIAbilityContext): Promise<Array<SongItem>> {
  return new Promise(async (resolve) => {
    let sandboxMusicPath: string = `${context.filesDir}${ImportSongUtil.getCachepath()}`;
    let localSongs: Array<SongItem> = []
    // 递归遍历函数
    const traverseDir = async (currentPath: string) => {
      try {
        // 检查路径是否存在
        if (!fs.accessSync(sandboxMusicPath)) {
          fs.mkdirSync(sandboxMusicPath);
        }

        // 读取当前目录下所有文件/子目录
        const listFileOptions: ListFileOptions = {
          recursion: false,
          listNum: 0,
          filter: { suffix: ['.mp3', '.flac', '.wav', '.aac'] }
        }
        const list = fileIo.listFileSync(currentPath, listFileOptions);
        for (const file of list) {
          await resolveVideo(currentPath + '/' + file, context).then(songItem => {
            localSongs.push(songItem);
          })
        }
        await resolve(localSongs);
      } catch (err) {
        Logger.error('扫描文件失败：', err.message);
      }
    };

    // 开始扫描根路径
    traverseDir(sandboxMusicPath);
  })
}

async function resolveVideo(path: string, context: common.UIAbilityContext): Promise<SongItem> {
  return new Promise(async (resolve) => {
    if (path) {
      if (canIUse('SystemCapability.Multimedia.Media.AVMetadataExtractor')) {
        // 创建AVMetadataExtractor对象
        let avMetadataExtractor = await media.createAVMetadataExtractor();
        try {
          // 设置fdSrc
          avMetadataExtractor.fdSrc = fs.openSync(path);
          let metadata = await avMetadataExtractor.fetchMetadata();
          Logger.info(TAG, `get meta data, mimeType:` + JSON.stringify(metadata));
          let song: SongItem = new SongItem();
          song.title = metadata.title !== '' ? metadata.title ?? '未知歌曲' : '未知歌曲';
          song.singer = metadata.artist !== '' ? metadata.artist ?? '未知歌手' : '未知歌手';
          song.src = path;
          song.isLocal = true;
          song.isCollected = false;
          song.label = 'song_default'
          song.id = getUniqueId()
          // 释放资源（promise模式）
          avMetadataExtractor.release();
          resolve(song);
        } catch (error) {
          Logger.error(`resolveVideo error：${JSON.stringify(error)}`);
        } finally {
          if (avMetadataExtractor.fdSrc) {
            fs.closeSync(avMetadataExtractor.fdSrc.fd);
          }
        }
      }
    }
  })
}

// 获取存储目录
export function getCachepath() {
  let cachepath: string = AppStorage.get(CommonConstants.STORAGE_CACHE_PATH) as string;
  if (!cachepath || cachepath === '') {
    cachepath = '/music';
    AppStorage.setOrCreate(CommonConstants.STORAGE_CACHE_PATH, cachepath);
  }
  return cachepath;
}

export function getUniqueId() {
  return util.generateRandomUUID().replace(/-/g, '').substring(2, 15)
}