import {
  CommonMyPlayDialog,
  DownloadFileUtil,
  PlaylistModel,
  ResManager,
  RouterMap,
  RouterUtils,
  UserInfoModel
} from 'lib_common';
import { getMusicModel, MediaService, MusicModel, MusicPlayController, SongItem } from 'module_musicplay';
import { NavHeaderBar } from 'lib_widget';
import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Share } from 'module_share';
import { LoginSheetUtils } from 'lib_account';
import { SongServiceApi } from 'lib_music_api';

@Builder
export function SongListPageBuilder() {
  SongListPage()
}

@ComponentV2
struct SongListPage {
  stack: NavPathStack = RouterUtils.getStack();
  @Local songs: Array<SongItem> = [];
  @Local playlist?: PlaylistModel;
  @Local musicModel: MusicModel = getMusicModel();
  @Local isShowActionSheet: boolean = false;
  @Local selectedSong?: SongItem;
  @Local userInfoModel: UserInfoModel = PersistenceV2.connect(UserInfoModel, () => new UserInfoModel())!;
  // 判断是否喜欢
  @Local isLove: boolean = false;

  aboutToAppear(): void {
    const param = RouterUtils.getParamByName<PlaylistModel>(RouterMap.SONG_LIST_PAGE);
    if (param) {
      this.playlist = param;
      this.songs = param.songList;
    } else {
      this.songs = SongServiceApi.queryAllSongList()
    }
  }

  @Monitor('isShowActionSheet')
  onEditMusic() {
    this.isLove = this.musicModel.isLikeSong(this.selectedSong?.id ?? '')
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          showBackBtn: true,
        })

        List() {
          ListItem() {
            Stack() {
              Row() {
                Image((ResManager.getPic(this.playlist?.cover)) || this.songs[0]?.label ||
                $r('app.media.ic_music_icon'))
                  .width(140)
                  .height(140)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)

                Column() {
                  Text(this.playlist?.title || '歌单')
                    .fontSize(20)
                    .fontColor('#333333')
                    .fontWeight(FontWeight.Bold)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ bottom: 4 })

                  Text(`简介:${this.playlist?.subTitle || '歌单简介'}`)
                    .fontSize(14)
                    .fontColor('#999999')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 15 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 16 })
              }
              .width('100%')
              .padding({
                left: 16,
                right: 16,
                top: 20,
                bottom: 20
              })
              .align(Alignment.Center)
            }
            .width('100%')
            .margin({ bottom: 16 })
          }

          ListItem() {
            Column() {
              Row() {
                Row() {
                  SymbolGlyph($r('sys.symbol.play_round_triangle_fill'))
                    .fontSize(32)
                    .fontColor([$r('app.color.app_theme')])
                    .margin({ right: 8 })
                  Text(`全部播放 ${this.songs.length}`)
                    .fontSize(16)
                    .fontColor('#333333')
                    .fontWeight(FontWeight.Medium)
                }
                .alignItems(VerticalAlign.Center)
                .onClick(() => {
                  // 播放第一首歌曲
                  if (this.songs.length > 0) {
                    // 打开播放页并替换歌曲列表播放
                    MediaService.getInstance().playAllSongs(this.songs, true);
                  }
                })
              }
              .width('100%')
              .height(48)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .padding({ left: 16, right: 16 })

              Column() {
                ForEach(this.songs, (song: SongItem) => {
                  Row() {
                    Image(ResManager.getPic(song.label))
                      .width(60)
                      .height(60)
                      .borderRadius(6)
                      .objectFit(ImageFit.Cover)

                    Column() {
                      Row() {
                        Text(song.title)
                          .fontSize(16)
                          .fontColor('#333333')
                          .fontWeight(FontWeight.Medium)
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .alignItems(VerticalAlign.Center)

                      Row() {
                        // 标识：本地 > VIP（非VIP不显示）
                        if (song.isLocal) {
                          Image($r('app.media.ic_local'))
                            .height(16)
                            .width(25)
                            .margin({ right: 6 })
                        } else if (song.isVip) {
                          Image($r('app.media.ic_vip'))
                            .height(16)
                            .width(25)
                            .margin({ right: 6 })
                        }
                        Text(song.singer)
                          .fontSize(14)
                          .fontColor('#666666')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .alignItems(VerticalAlign.Center)
                      .margin({ top: 4 })
                    }
                    .layoutWeight(1)
                    .alignItems(HorizontalAlign.Start)
                    .margin({ left: 12 })

                    Image($r('app.media.liangdian'))
                      .backgroundColor('#E6E8EA')
                      .width(30)
                      .height(30)
                      .borderRadius('50%')
                      .onClick(() => {
                        this.selectedSong = song;
                        this.isShowActionSheet = true;
                      })
                  }
                  .width('100%')
                  .height(64)
                  .padding({ left: 16, right: 16 })
                  .margin({ top: 15 })
                  .onClick(() => {
                    MediaService.getInstance().playSong(song, true);
                  })
                }, (song: SongItem, index: number) => `${song.title}-${index}`)
              }
            }
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius({ topLeft: 25, topRight: 25 })
            .padding({ top: 4, bottom: 8 })
            .margin({ bottom: 8 })
          }
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 半模态弹窗
        Blank()
          .bindSheet($$this.isShowActionSheet, this.ActionSheetBuilder(this.selectedSong), {
            detents: [SheetSize.MEDIUM],
            blurStyle: BlurStyle.Regular,
            showClose: true,
          })
        // 底部播放条
        MusicPlayController()
          .margin({ bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [['#FFE5E5', 0.0], ['#E5F3FF', 0.5], ['#FFFFFF', 1.0]]
      })

    }
    .hideTitleBar(true)
  }

  @Builder
  ActionSheetBuilder(song?: SongItem) {
    Column() {
      if (song) {
        Row() {
          Image(ResManager.getPic(song.label))
            .width(44)
            .height(44)
            .borderRadius(6)
            .objectFit(ImageFit.Cover)
          Column() {
            Text(song.title)
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row() {
              if (song.isLocal) {
                Image($r('app.media.ic_local'))
                  .height(16)
                  .width(25)
                  .margin({ right: 6 })
              } else if (song.isVip) {
                Image($r('app.media.ic_vip'))
                  .height(16)
                  .width(25)
                  .margin({ right: 6 })
              }

              Text(song.singer)
                .fontSize(12)
                .fontColor('#999999')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .alignItems(VerticalAlign.Center)
            .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
        }
        .margin({ top: 20 })
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }

      Column() {
        Row() {
          Image($r('app.media.bianji_')).width(18).height(18)
          Text('添加到播放列表')
            .fontSize(16)
            .fontColor('#333333')
            .margin({ left: 12 })
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.addToPlayQueue(song);
        })

        Row() {
          if (this.isLove) {
            Image($r('app.media.xihuan_2')).width(18).height(18).fillColor('#FF5E5E')
            Text('取消喜欢')
              .fontSize(16)
              .fontColor('#333333')
              .margin({ left: 12 })
          } else {
            Image($r('app.media.xihuan')).width(18).height(18)
            Text('喜欢')
              .fontSize(16)
              .fontColor('#333333')
              .margin({ left: 12 })
          }
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.addToLike(song);
        })

        Row() {
          Image($r('app.media.tianjia_3')).width(18).height(18)
          Text('添加到歌单')
            .fontSize(16)
            .fontColor('#333333')
            .margin({ left: 12 })
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.addToPlaylist(song);
        })

        Row() {
          Image($r('app.media.xiazai')).width(18).height(18)
          Text('下载')
            .fontSize(16)
            .fontColor('#333333')
            .margin({ left: 12 })
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.downloadSong(song);
        })

        // 分享
        this.shareBuilder(song)

        Row() {
          Image($r('app.media.bofang_copy')).width(18).height(18)
          Text('播放MV')
            .fontSize(16)
            .fontColor('#333333')
            .margin({ left: 12 })
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          // 播放带有mv地址的歌曲
          if (song?.mvUrl && song.mvUrl.length > 0) {
            MediaService.getInstance().pause();
            MediaService.getInstance().playMv(song.mvUrl);
            this.isShowActionSheet = false;
          } else {
            promptAction.showToast({ message: '无MV文件' });
          }
        })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 20, topRight: 20 })
  }

  // 添加到播放列表（不立即播放）
  addToPlayQueue(song?: SongItem): void {
    if (MediaService.getInstance().addToSongList(song)) {
      promptAction.showToast({ message: '已加入播放列表' });
      this.isShowActionSheet = false;
    }
  }

  // 添加到喜欢
  addToLike(song?: SongItem): void {
    if (!this.userInfoModel.isLogin) {
      promptAction.showToast({ message: '请先登录' });
      LoginSheetUtils.open();
      return;
    }
    if (!song) {
      return;
    }
    const songId: string = song.id ?? '';
    if (!songId) {
      promptAction.showToast({ message: '无法添加到喜欢：缺少歌曲ID' });
      return;
    }
    if (this.isLove) {
      MediaService.getInstance().unCollect(songId);
      song.isCollected = false;
      promptAction.showToast({ message: '已取消喜欢' });
    } else {
      MediaService.getInstance().collect(songId);
      song.isCollected = true;
      promptAction.showToast({ message: '已添加到我喜欢' });
    }
    this.isShowActionSheet = false;
  }

  // 添加到歌单
  addToPlaylist(song?: SongItem): void {
    if (!this.userInfoModel.isLogin) {
      promptAction.showToast({ message: '请先登录' });
      LoginSheetUtils.open();
      return;
    }
    if (!song) {
      return;
    }
    const songId: string = song.id ?? '';
    if (!songId) {
      promptAction.showToast({ message: '无法添加到歌单：缺少歌曲ID' });
      return;
    }
    // 调用歌单选择对话框
    CommonMyPlayDialog.show({
      songId: songId,
      confirm: () => {
        // 所有歌曲元数据
        let songs: SongItem[] = SongServiceApi.queryAllSongList()
        if (!songs) {
          return
        }
        // 根据id查找歌曲元数据
        let songData: SongItem = songs.find((item) => item.id === songId) as SongItem;
        getMusicModel().upataGedanNum(songData, 'add');
      }
    });

    this.isShowActionSheet = false;
  }

  // 下载
  downloadSong(song?: SongItem): void {
    if (!this.userInfoModel.isLogin) {
      promptAction.showToast({ message: '请先登录' });
      LoginSheetUtils.open();
      return;
    }
    if (!song) {
      return;
    }
    let downUrl: string = song?.src ?? '';
    switch (this.musicModel.qualitySwitch) {
      case 1:
        downUrl = song?.srcMedium ?? '';
        break;
      case 2:
        downUrl = song?.srcHigh ?? '';
        break;
      case 3:
        downUrl = song?.srcLossless ?? '';
        break;
      default:
        downUrl = song?.src ?? '';
        break;
    }
    if (downUrl === '') {
      downUrl = this.musicModel.currentSong?.src ?? '';
    }
    if (!downUrl) {
      promptAction.showToast({ message: '无法下载：缺少歌曲文件地址' });
      return;
    }
    DownloadFileUtil.startDownFile(downUrl, getContext(this) as common.UIAbilityContext);
    promptAction.showToast({ message: '下载歌单' });
    this.isShowActionSheet = false;
    getMusicModel().updateDownloadNum(song);
  }

  // 分享
  @Builder
  shareBuilder(song?: SongItem) {
    Share({
      qrCodeInfo: {
        id: song?.id ?? '',
        type: 2,
        articleFrom: song?.singer ?? '',
        title: song?.title ?? '',
        createTime: new Date().toLocaleString(),
        isVideo: false,
        coverUrl: ResManager.getPic(typeof song?.label === 'string' ? song.label : '') as string,
      },
      shareRenderBuilder: this.shareCommentBuilder
    })
  }

  @Builder
  shareCommentBuilder() {
    Row() {
      Image($r('app.media.fenxiang'))
        .width(18)
        .height(18)
        .fillColor('#333333')
      Text('分享')
        .fontSize(16)
        .fontColor('#333333')
        .margin({ left: 12 })
    }
    .width('100%')
    .height(44)
    .padding({ left: 16, right: 16 })
  }
}