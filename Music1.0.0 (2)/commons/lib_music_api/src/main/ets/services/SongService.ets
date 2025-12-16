import { getSongListData } from './mockdata/SongListData';
import { SongItem } from '../params/response/SongItem';

/**
 * 音乐播放服务类
 */
export class SongService {
  public queryAllSongList(): SongItem[] {
    return getSongListData();
  }
}

const instance = new SongService();

export { instance as SongServiceApi };