import { PlaylistModel } from 'lib_common';

@ObservedV2
export class SelectPlayList {
  // 歌曲列表
  @Trace playlistModel: PlaylistModel;
  @Trace selectIndex: number; //目标歌单

  constructor(playlistModel: PlaylistModel, selectIndex: number) {
    this.playlistModel = playlistModel;
    this.selectIndex = selectIndex;
  }
}