import { PersistenceV2 } from '@kit.ArkUI';
import { BaseViewModel, PlaylistModel, SettingModel, SongItem } from 'lib_common';
import { SongServiceApi } from 'lib_music_api';

@ObservedV2
export class HomeViewModel extends BaseViewModel {
  @Trace settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;
  //默认歌单列表
  @Trace playlist1: PlaylistModel[] = []
  @Trace playlist2: PlaylistModel[] = []
  @Trace playlist3: PlaylistModel[] = []
  //分类歌曲列表
  @Trace categorySong1: SongItem[] = [];
  @Trace categorySong2: SongItem[] = [];
  // 回忆歌单
  @Trace memorySong1: SongItem[] = [];
  @Trace memorySong2: SongItem[] = [];

  // 初始化歌单
  initPlaylist() {
    let allSongList: SongItem[] = SongServiceApi.queryAllSongList()

    // 分类歌曲
    this.categorySong1 = allSongList.slice(0, 4)
    this.categorySong2 = allSongList.slice(13, 20)
    // 回忆歌单独立数据源（与分类歌曲不同区间）
    this.memorySong1 = allSongList.slice(20, 26)
    this.memorySong2 = allSongList.slice(25, 32)
    //歌单1歌曲
    const songList1: SongItem[] = this.categorySong1;
    const songList2: SongItem[] = this.categorySong2;
    const songList3: SongItem[] = allSongList.slice(21, 26)
    // 新增3个歌单到playlist1
    const songList4: SongItem[] = allSongList.slice(3, 8)
    const songList5: SongItem[] = allSongList.slice(4, 10)
    const songList6: SongItem[] = allSongList.slice(11, 17)


    const playlistModel1: PlaylistModel = new PlaylistModel('今日限定', '千秋', songList1[0].label, songList1)
    const playlistModel2: PlaylistModel = new PlaylistModel('热门歌曲', '这个歌单好听', songList2[0].label, songList2)
    const playlistModel3: PlaylistModel = new PlaylistModel('多元旋律', '好声音', songList3[0].label, songList3)

    this.playlist1.push(playlistModel1)
    this.playlist1.push(playlistModel2)
    this.playlist1.push(playlistModel3)


    const playlistModel4: PlaylistModel = new PlaylistModel('入坑必听', '收藏过千', songList4[0].label, songList4)
    const playlistModel5: PlaylistModel = new PlaylistModel('南京热门', '私人雷达', songList5[0].label, songList5)
    const playlistModel6: PlaylistModel = new PlaylistModel('国风流行', '古风精选', songList6[0].label, songList6)

    this.playlist1.push(playlistModel4)
    this.playlist1.push(playlistModel5)
    this.playlist1.push(playlistModel6)

    // 影视原声歌单 9个
    const songList21: SongItem[] = allSongList.slice(12, 18)
    const songList22: SongItem[] = allSongList.slice(15, 21)
    const songList23: SongItem[] = allSongList.slice(21, 28)
    const songList24: SongItem[] = allSongList.slice(22, 24)
    const songList25: SongItem[] = allSongList.slice(25, 26)
    const songList26: SongItem[] = allSongList.slice(17, 19)
    const songList27: SongItem[] = allSongList.slice(18, 21)
    const songList28: SongItem[] = allSongList.slice(19, 23)
    const songList29: SongItem[] = allSongList.slice(14, 19)

    const playlistModel21: PlaylistModel =
      new PlaylistModel('经典老哥', '80-90年代的回忆', songList21[0].label, songList21)
    const playlistModel22: PlaylistModel = new PlaylistModel('抖音热曲', '一秒沦陷', songList22[0].label, songList22)
    const playlistModel23: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList23[0].label, songList23)
    const playlistModel24: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList24[0].label, songList24)
    const playlistModel25: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList25[0].label, songList25)
    const playlistModel26: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList26[0].label, songList26)
    const playlistModel27: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList27[0].label, songList27)
    const playlistModel28: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList28[0].label, songList28)
    const playlistModel29: PlaylistModel =
      new PlaylistModel('国风伤情', '一曲桃花断', songList29[0].label, songList29)

    this.playlist2.push(playlistModel21)
    this.playlist2.push(playlistModel22)
    this.playlist2.push(playlistModel23)
    this.playlist2.push(playlistModel24)
    this.playlist2.push(playlistModel25)
    this.playlist2.push(playlistModel26)
    this.playlist2.push(playlistModel27)
    this.playlist2.push(playlistModel28)
    this.playlist2.push(playlistModel29)

    // 国风流行歌单 9个
    const songList31: SongItem[] = allSongList.slice(1, 8)
    const songList32: SongItem[] = allSongList.slice(4, 12)
    const songList33: SongItem[] = allSongList.slice(13, 18)
    const songList34: SongItem[] = allSongList.slice(14, 16)
    const songList35: SongItem[] = allSongList.slice(2, 5)
    const songList36: SongItem[] = allSongList.slice(3, 7)
    const songList37: SongItem[] = allSongList.slice(5, 9)
    const songList38: SongItem[] = allSongList.slice(10, 15)
    const songList39: SongItem[] = allSongList.slice(6, 13)

    const playlistModel31: PlaylistModel = new PlaylistModel('古风雅韵', '千年古韵', songList31[0].label, songList31)
    const playlistModel32: PlaylistModel = new PlaylistModel('汉唐风华', '盛世华章', songList32[0].label, songList32)
    const playlistModel33: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList33[0].label, songList33)
    const playlistModel34: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList34[0].label, songList34)
    const playlistModel35: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList35[0].label, songList35)
    const playlistModel36: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList36[0].label, songList36)
    const playlistModel37: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList37[0].label, songList37)
    const playlistModel38: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList38[0].label, songList38)
    const playlistModel39: PlaylistModel = new PlaylistModel('江南烟雨', '水墨丹青', songList39[0].label, songList39)

    this.playlist3.push(playlistModel31)
    this.playlist3.push(playlistModel32)
    this.playlist3.push(playlistModel33)
    this.playlist3.push(playlistModel34)
    this.playlist3.push(playlistModel35)
    this.playlist3.push(playlistModel36)
    this.playlist3.push(playlistModel37)
    this.playlist3.push(playlistModel38)
    this.playlist3.push(playlistModel39)
  }
}
