import { SongItem } from 'lib_music_api';

@ObservedV2
export class PlaylistModel {
  // 歌曲列表
  @Trace songList: SongItem[] = [];
  @Trace title: string = ''; //歌单名称
  @Trace subTitle: ResourceStr = ''; //介绍
  @Trace cover: string | Resource = $r('app.media.song_default'); // 封面图

  constructor(title: string, subTitle: ResourceStr, cover: string | Resource, value: SongItem[]) {
    this.title = title;
    this.subTitle = subTitle;
    this.cover = cover;
    this.songList = value;
  }
}