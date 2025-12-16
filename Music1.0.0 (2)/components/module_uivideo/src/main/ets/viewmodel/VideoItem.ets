import { resourceManager } from '@kit.LocalizationKit';

@ObservedV2
export class VideoItem {
  @Trace name: string;
  @Trace src: resourceManager.RawFileDescriptor;
  @Trace iSrc: string;
  @Trace episode?: string;

  constructor(name: string, src: resourceManager.RawFileDescriptor, iSrc: string, episode?: string) {
    this.name = name;
    this.src = src;
    this.iSrc = iSrc;
    this.episode = episode
  }
}