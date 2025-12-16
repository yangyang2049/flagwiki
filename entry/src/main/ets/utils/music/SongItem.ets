/**
 * 歌曲信息实体类
 */
@ObservedV2
export class SongItem {
  @Trace id: string = '';
  @Trace title: string = '';
  @Trace singer: string = '';
  @Trace src: string = '';
  @Trace isLocal: boolean = false;
  @Trace label: string | Resource = $r('app.media.icon_tab_home');
  @Trace isCollected: boolean = false;
  @Trace isVip: boolean = false;
  @Trace collectedCount: number = 0;
  @Trace playlistCount: number = 0;
  @Trace downloadCount: number = 0;
  @Trace shareCount: number = 0;
}

