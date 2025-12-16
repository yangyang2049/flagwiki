import { SongItem } from 'lib_music_api';
import { PlaylistModel } from './PlayListModel';

@ObservedV2
export class MyPlayListModel {
  //多个歌单列表
  @Trace playList: PlaylistModel[] = [];
  // 歌曲原数据
  @Trace songList: SongItem[] = [];
}