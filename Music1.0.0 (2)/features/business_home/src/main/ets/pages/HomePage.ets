import {
  CommonConstants,
  LinearColumnModifier,
  PlaylistModel,
  RouterMap,
  RouterUtils,
  SearchModel,
  SettingModel
} from 'lib_common';
import { getMusicModel, MediaService, MusicModel, SongItem } from 'module_musicplay';
import { HomeViewModel } from '../viewmodels/HomeViewModel';
import { PersistenceV2 } from '@kit.ArkUI';
import { ThemeController } from 'module_theme';
import { PlaylistCards } from '../components/PlaylistCards';
import { DynamicGrid } from '../components/DynamicGrid';
import { PlaylistSection } from '../components/PlaylistSection';
import { PlaylistCard } from '../components/PlaylistCard';
import { SongServiceApi } from 'lib_music_api';

interface SearchPageParams {
  initialKeyword: string;
}

@Builder
export function HomePageBuilder() {
  HomePage()
}

@ComponentV2
struct HomePage {
  @Local homeViewModel: HomeViewModel = new HomeViewModel();
  @Local modifier: LinearColumnModifier = new LinearColumnModifier(ThemeController.theme.themeColor);
  @Local settingInfo: SettingModel = PersistenceV2.connect(SettingModel, () => new SettingModel())!;
  @Local musicModel: MusicModel = getMusicModel();
  private searchController: SearchModel = SearchModel.instance;
  @Local currentPlaceholderIndex: number = 0;
  private placeholderTimer: number = -1;
  @Local hotSearchList: Array<string> = [];

  aboutToAppear(): void {
    this.homeViewModel.initPlaylist()
    //获取当天第一次登录时间
    // 生成首页搜索热词并使用“热搜榜”内容（前10条）作为轮播来源
    this.searchController.generateHotSearch(this.getHotSongs());
    this.hotSearchList = this.searchController.hotSearch.slice(0, 10);
    this.startPlaceholderRotation();
  }

  startPlaceholderRotation() {
    if (this.placeholderTimer !== -1) {
      return;
    }
    this.placeholderTimer = setInterval(() => {
      const total: number = this.hotSearchList.length;
      if (total > 0) {
        this.currentPlaceholderIndex = (this.currentPlaceholderIndex + 1) % total;
      }
    }, 3000);
  }

  stopPlaceholderRotation() {
    if (this.placeholderTimer !== -1) {
      clearInterval(this.placeholderTimer);
      this.placeholderTimer = -1;
    }
  }

  getHotSongs(): Array<SongItem> {
    return SongServiceApi.queryAllSongList()
  }

  getPlaylist1Data(): PlaylistModel[] {
    return this.homeViewModel.playlist1;
  }

  getPlaylist2Data(): PlaylistModel[] {
    return this.homeViewModel.playlist2;
  }

  getPlaylist3Data(): PlaylistModel[] {
    return this.homeViewModel.playlist3;
  }

  getCategorySongs(): SongItem[] {
    return [...this.homeViewModel.categorySong1, ...this.homeViewModel.categorySong2];
  }

  getMemorySongs(): SongItem[] {
    return [...this.homeViewModel.memorySong1, ...this.homeViewModel.memorySong2];
  }

  build() {
    NavDestination() {
      Column() {
        // 自定义搜索框组件 只显示轮播热搜，不支持直接输入
        Row() {
          Image($r('app.media.search'))
            .width(20)
            .height(20)
            .margin({ left: 16, right: 12 })
            .fillColor(ThemeController.theme.themeColors[4])

          Text(this.hotSearchList[this.currentPlaceholderIndex] || '请输入搜索关键词')
            .fontSize(16)
            .fontColor(ThemeController.theme.themeColors[4])
            .layoutWeight(1)
            .textAlign(TextAlign.Start)
        }
        .width('90%')
        .height(40)
        .backgroundColor(ThemeController.theme.themeColors[6])
        .borderRadius(24)
        .margin({ top: 50, bottom: 20 })
        .onClick(() => {
          const params: SearchPageParams = {
            initialKeyword: this.hotSearchList[this.currentPlaceholderIndex] || ''
          };
          RouterUtils.pushPathByName(RouterMap.SEARCH_PAGE, params);
        })

        Scroll() {
          Column() {
            PlaylistCards({
              playlists: this.getPlaylist1Data(),
              onCardClick: (card: PlaylistCard) => {
                const index: number = Number(card.id) - 1;
                const playlist: PlaylistModel | undefined = this.getPlaylist1Data()[index];
                if (playlist) {
                  RouterUtils.pushPathByName(RouterMap.SONG_LIST_PAGE, playlist);
                }
              }
            })

            Column() {
              Row() {
                Text('心情氛围')
                  .fontSize(18)
                  .fontColor(ThemeController.theme.themeColors[2])
                  .fontWeight(FontWeight.Bold)
                  .onClick(() => {
                    RouterUtils.pushPathByName(RouterMap.STARTGUIDE_PAGE, null, undefined, false);
                  })
                Blank()
              }
              .width('100%')
              .padding({
                left: 16,
                right: 16,
                top: 20,
                bottom: 12
              })

              DynamicGrid({
                songs: this.getCategorySongs(),
                uniqueKey: 'mood',
                currentSongId: this.musicModel.currentSong?.id ?? '',
                currentSongSrc: this.musicModel.currentSong?.src ?? '',
                isPlaying: this.musicModel.isPlay,
                onSongClick: (song: SongItem) => {
                  const currentId: string = this.musicModel.currentSong?.id ?? '';
                  const currentSrc: string = this.musicModel.currentSong?.src ?? '';
                  const isCurrent: boolean = (currentSrc && currentSrc === (song.src ?? '')) ||
                    (!currentSrc && currentId !== '' && currentId === (song.id ?? ''));
                  if (isCurrent) {
                    MediaService.getInstance().playAndPause()
                  } else {
                    MediaService.getInstance().playSong(song);
                  }
                },
                onSongAreaClick: (song: SongItem) => {
                  // 非按钮区域：打开播放页并播放该歌曲
                  MediaService.getInstance().playSong(song, true);
                }
              })
            }
            .margin({ top: 10 })

            PlaylistSection({
              title: '影视原声',
              playlists: this.getPlaylist2Data()
            })

            Column() {
              Row() {
                Text('回忆歌单')
                  .fontSize(18)
                  .fontColor(ThemeController.theme.themeColors[2])
                  .fontWeight(FontWeight.Bold)
                Blank()
              }
              .width('100%')
              .padding({
                left: 16,
                right: 16,
                top: 20,
                bottom: 12
              })

              DynamicGrid({
                songs: this.getMemorySongs(),
                uniqueKey: 'memory',
                currentSongId: this.musicModel.currentSong?.id ?? '',
                currentSongSrc: this.musicModel.currentSong?.src ?? '',
                isPlaying: this.musicModel.isPlay,
                onSongClick: (song: SongItem) => {
                  const currentId: string = this.musicModel.currentSong?.id ?? '';
                  const currentSrc: string = this.musicModel.currentSong?.src ?? '';
                  const isCurrent: boolean = (currentSrc && currentSrc === (song.src ?? '')) ||
                    (!currentSrc && currentId !== '' && currentId === (song.id ?? ''));
                  if (isCurrent) {
                    MediaService.getInstance().playAndPause()
                  } else {
                    MediaService.getInstance().playSong(song);
                  }
                },
                onSongAreaClick: (song: SongItem) => {
                  // 非按钮区域：打开播放页并播放该歌曲
                  MediaService.getInstance().playSong(song, true);
                }
              })
            }

            PlaylistSection({
              title: '国风流行',
              playlists: this.getPlaylist3Data()
            })
              .margin({ bottom: 130 })
          }
        }
        .layoutWeight(1)
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .padding({
          left: CommonConstants.PADDING_PAGE,
          right: CommonConstants.PADDING_PAGE,
          top: CommonConstants.SPACE_M,
        })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor(Color.Transparent)
    }
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
  }
}