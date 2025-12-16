import { promptAction } from '@kit.ArkUI';
import { BaseViewModel, EventBus } from 'lib_common';
import { SongItem } from 'lib_music_api/src/main/ets/params/response/SongItem';
import { getMusicModel, MediaService, MusicModel } from 'module_musicplay';
import { SondDataSource } from '../common/SondDataSource';

@ObservedV2
export class MarkViewModel extends BaseViewModel {
  @Trace sondDataSource: SondDataSource = new SondDataSource();
  @Trace num: number = 0;
  // 本地歌曲列表
  @Trace localSongs: Array<SongItem> = [];
  @Trace mediaService: MediaService = MediaService.getInstance()
  @Trace musicModel: MusicModel = getMusicModel();

  constructor() {
    super();
    this.queryList();
    EventBus.listen<Record<string, string>>('updateCollectList', (param) => {
      this.queryList()
    })
  }

  queryList() {
    // 收藏列表
    this.sondDataSource.setData([...this.musicModel.collectList]);
    this.num = this.sondDataSource.originDataArray.length;
  }

  cancelMark(v: SongItem) {
    promptAction.showToast({ message: '取消收藏成功' });
    this.queryList();
  }
}