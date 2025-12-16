import { PlaylistModel } from '../models/PlayListModel';
import { SongItem } from 'lib_music_api/src/main/ets/params/response/SongItem';
import { BaseViewModel } from '../utils/BaseViewModel';

@ObservedV2
export class PlayListMV extends BaseViewModel {
  /**
   * 新建歌单且加入歌单
   * @param songId
   * @param value 歌单名
   */
  newPlayList(songId: string, value: string) {
    let song = this.getSongById(songId)
    if (song) {
      //向列表表头插入一条歌曲
      this.myPlayListModel.playList.unshift(new PlaylistModel(value, $r('app.string.playlist_cover_default'),
        'song_default', [song]))
    }
  }

  // 根据歌曲id获取歌曲
  getSongById(id: string): SongItem | undefined {
    let song: SongItem | undefined = undefined
    if (this.myPlayListModel.songList.length > 0) {
      song = this.myPlayListModel.songList.find(item => item.id === id)
    }
    return song
  }

  // 根据歌曲id加入歌单
  addSongToPlayList(songId: string, playListTitle: string) {
    let song: SongItem | undefined = this.getSongById(songId)
    if (song) {
      //向列表表头插入一条歌曲
      let playList: PlaylistModel[] = this.myPlayListModel.playList
      //遍历歌单且向对应歌单加入歌曲
      for (let i = 0; i < playList.length; i++) {
        if (playList[i].title === playListTitle) {
          playList[i].songList.unshift(song)
          break
        }
      }
      this.myPlayListModel.playList = playList
    }
  }
}