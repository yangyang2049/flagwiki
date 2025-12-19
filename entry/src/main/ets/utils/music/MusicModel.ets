import { SongItem } from './SongItem';
import { MusicPlayMode } from './MusicData';

/**
 * 音乐模型
 */
@ObservedV2
export class MusicModel {
  @Trace isPlay: boolean = false;
  @Trace songList: SongItem[] = [];
  @Trace currentSong: SongItem | undefined = undefined;
  @Trace totalTime: string = '';
  @Trace progressMax: number = 0;
  @Trace progress: number = 0;
  @Trace selectIndex: number = 0;
  @Trace currentTime: string = '00:00';
  @Trace playMode: MusicPlayMode = MusicPlayMode.ORDER;
  @Trace isShowPlay: boolean = false;
  @Trace themeColor: string = '#FF1949';
  
  private static instance: MusicModel | null = null;

  public static getInstance(): MusicModel {
    if (!MusicModel.instance) {
      MusicModel.instance = new MusicModel();
    }
    return MusicModel.instance;
  }

  public setSongList(value: SongItem[]): void {
    this.songList = value;
  }

  public setCurrentSong(value: SongItem | undefined): void {
    if (value) {
      this.currentSong = value;
    }
  }
}

export function getMusicModel(): MusicModel {
  return MusicModel.getInstance();
}


