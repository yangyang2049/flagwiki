import { VideoItem } from '../../viewmodel/VideoItem';
import { resourceManager } from '@kit.LocalizationKit';
import { Logger } from './Logger';

export interface IVideoData {
  name: string,
  type: string,
  isLocal: boolean,
  src?: string,
  episode?: string
}

export async function getVideoList(videoData: IVideoData[]) {
  const videoList: VideoItem[] = [];
  for (let index = 0; index < videoData.length; index++) {
    const item = videoData[index]
    if (item.isLocal) {
      const video = await getLocalVideo(item.name, item.type, item.episode)
      if (video) {
        videoList.push(video);
      }
    } else {
      if (item.src) {
        const video = setInternetVideo(item.name, item.src, item.episode)
        videoList.push(video)
      } else {
        Logger.info('online video lack src')
      }
    }
  }
  return videoList
}

async function getLocalVideo(name: string, type: string, episode?: string) {
  try {
    const uri = await getContext().resourceManager.getRawFd(name + '.' + type)
    return new VideoItem(name, uri, '', episode)
  } catch (e) {
    Logger.info(`get mp4 file failed ${e.message}`);
    return null
  }
}

function setInternetVideo(name: string, src: string, episode?: string) {
  return new VideoItem(name, {} as resourceManager.RawFileDescriptor, src, episode)
}

export class MyRowModifier implements AttributeModifier<RowAttribute> {
  isTop: boolean = false

  applyNormalAttribute(instance: RowAttribute): void {
    if (this.isTop) {
      instance.position({ x: 0, y: 0 })
    } else {
      instance.offset({ x: 0, y: 0 })
    }
  }
}