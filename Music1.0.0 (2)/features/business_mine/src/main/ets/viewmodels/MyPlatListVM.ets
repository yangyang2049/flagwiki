import { BaseViewModel, MyPlayListModel, PlaylistModel, SongItem } from 'lib_common';
import { AppStorageV2, promptAction } from '@kit.ArkUI';
import { SelectPlayList } from '../constants/SelectPlayList';
import { SongServiceApi } from 'lib_music_api';
import { getMusicModel } from 'module_musicplay';

@ObservedV2
export class MyPlatListVM extends BaseViewModel {
  // 多个歌单列表
  @Trace myPlayListModel: MyPlayListModel = AppStorageV2.connect(MyPlayListModel, () => new MyPlayListModel())!;

  //设置一个默认歌单
  initMyPlayList() {
    let allSongList: SongItem[] = SongServiceApi.queryAllSongList()
    const songList1: SongItem[] = allSongList.slice(21, 26)
    const songList2: SongItem[] = allSongList.slice(22, 26)
    const songList3: SongItem[] = allSongList.slice(23, 26)
    this.myPlayListModel.playList.push(new PlaylistModel('我的歌单1', '歌单1的描述', songList1[0].label, songList1));
    this.myPlayListModel.playList.push(new PlaylistModel('我的歌单2', '歌单2的描述', songList2[1].label, songList2));
    this.myPlayListModel.playList.push(new PlaylistModel('我的歌单3', '歌单3的描述', songList3[2].label, songList3));
  }

  deletePlayList(selectedFlags: Array<boolean>): PlaylistModel[] {
    //从0的位置开始删除元素
    let num: number = 0
    selectedFlags.forEach((isSelect: boolean, index: number) => {
      if (isSelect) {
        this.myPlayListModel.playList.splice(index - num, 1)
        num++;
      }
    })
    return this.myPlayListModel.playList
  }

  deleteOnePlayList(index: number): PlaylistModel[] {
    //从0的位置开始删除元素
    let playList: PlaylistModel[] = this.myPlayListModel.playList.splice(index, 1)
    // 遍历playList
    playList.forEach((element: PlaylistModel) => {
      element.songList.forEach((element: SongItem) => {
        this.upataGedan(element.id)
      })
    })
    return this.myPlayListModel.playList
  }

  // 添加一个歌单
  addPlayList(playlistModel: PlaylistModel): PlaylistModel[] {
    this.myPlayListModel.playList.push(playlistModel);
    return this.myPlayListModel.playList
  }

  deleteTheMusic(selectedFlags: Array<boolean>, indexs: number): PlaylistModel {
    let num: number = 0
    selectedFlags.forEach((isSelect: boolean, index: number) => {
      if (isSelect) {
        this.myPlayListModel.playList[indexs].songList.splice(index - num, 1)
        num++;
      }
    })
    //从0的位置开始删除元素
    return this.myPlayListModel.playList[indexs]
  }

  // 单行删除
  deleteOneMusic(index: number, indexs: number): PlaylistModel {
    let songItem: SongItem[] = this.myPlayListModel.playList[indexs].songList.splice(index, 1)
    this.upataGedan(songItem[0].id)
    //从0的位置开始删除元素
    return this.myPlayListModel.playList[indexs]
  }

  // 添加 一个歌单
  addMusicList(model: PlaylistModel): boolean {
    let end: boolean = true
    this.myPlayListModel.playList.forEach((element: PlaylistModel) => {
      if (element.title === model.title) {
        promptAction.showToast({ message: '歌单已经存在' })
        end = false
      }
    })
    if (end) {
      this.myPlayListModel.playList.push(model);
    }
    return end
  }

  // 更新一个歌单信息
  updateMusicListInfo(selectPlayList: SelectPlayList): boolean {
    let end: boolean = true
    this.myPlayListModel.playList.forEach((element: PlaylistModel, index: number) => {
      if (element.title === selectPlayList.playlistModel.title && index !== selectPlayList.selectIndex) {
        promptAction.showToast({ message: '歌单已经存在' })
        end = false
      }
    })
    if (end) {
      this.myPlayListModel.playList[selectPlayList.selectIndex] = selectPlayList.playlistModel
    }
    return end
  }

  upataGedan(songId: string) {
    // 所有歌曲元数据
    let songDataList: SongItem[] = SongServiceApi.queryAllSongList()
    if (!songDataList) {
      return
    }
    // 根据id查找歌曲元数据
    let songData: SongItem = songDataList.find((item) => item.id === songId) as SongItem;
    getMusicModel().upataGedanNum(songData, 'reduce');
  }
}