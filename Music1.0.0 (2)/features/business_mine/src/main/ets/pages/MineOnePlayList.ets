import {
  CommonConfirmDialog,
  CommonConstants,
  DownloadFileUtil,
  PlaylistModel,
  ResManager,
  RouterMap,
  RouterUtils
} from 'lib_common';
import { getMusicModel, MediaService, MusicModel, MusicPlayController, SongItem } from 'module_musicplay';
import { SelectPlayList } from '../constants/SelectPlayList';
import { MarkViewModel } from '../viewmodels/MarkVM';
import { MyPlatListVM } from '../viewmodels/MyPlatListVM';
import { promptAction } from '@kit.ArkUI';
import { SondDataSource } from '../common/SondDataSource';
import { common } from '@kit.AbilityKit';
import { Share } from 'module_share';

@Builder
export function MineOnePlayListBuilder() {
  MineOnePlayList()
}

@Extend(Row)
function onPressedRow() {
  .stateStyles({
    normal: { .backgroundColor('#ffffff')
    },
    pressed: { .backgroundColor('#efefef')
    },
  })
}

@Extend(Column)
function onPressedColumn() {
  .stateStyles({
    normal: { .backgroundColor('#ffffff')
    },
    pressed: { .backgroundColor('#efefef')
    },
  })
}


@ComponentV2
struct MineOnePlayList {
  @Local editAllMusic: boolean = false
  @Local editMusic: boolean = false
  @Local selectIndex: number = 0;
  @Local vm: MyPlatListVM = new MyPlatListVM();
  @Local vmPlay: MarkViewModel = new MarkViewModel();
  // 选择的布尔集合
  @Local selectedFlags: Array<boolean> = [];
  @Local playlistModel?: PlaylistModel
  @Local selectList?: SelectPlayList
  @Local thisSelectSong?: SongItem;
  @Local sondDataSource: SondDataSource = new SondDataSource();
  // 判断是否喜欢
  @Local isLove: boolean = false;
  @Local musicModel: MusicModel = getMusicModel();

  aboutToAppear() {
    const param = RouterUtils.getParamByName<SelectPlayList>(RouterMap.MINE_ONE_PLAY_LIST);
    if (param) {
      this.selectList = param
      this.playlistModel = param?.playlistModel
    }
    this.selectedFlags = []
  }

  @Monitor('editMusic')
  onEditMusic() {
    this.isLove = this.musicModel.isLikeSong(this.thisSelectSong?.id ?? '')
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
        .height(20)
        .fillColor('#333333')
        .margin({ left: 30 })
      Text('分享')
        .fontColor('#333333')
        .fontSize(14)
        .margin({ left: 20 })
    }
    .width('100%')
    .height(40)
    .margin({ bottom: 8 })
    .onPressedRow()
  }

  @Builder
  title() {
    Column() {
      Row() {
        // 显示返回按钮：主动设置或者二级标题
        Image($r('app.media.ic_back'))
          .width($r('app.float.head_icon_width'))
          .aspectRatio(1)
          .draggable(false)
          .margin({ right: CommonConstants.SPACE_S })
          .borderRadius(CommonConstants.HALF_PERCENT)
          .stateStyles({
            normal: { .backgroundColor(Color.Transparent)
            },
            pressed: { .backgroundColor($r('sys.color.interactive_pressed'))
            },
          })
          .onClick(() => {
            RouterUtils.pop()
          })
        Blank()
        Image($r('app.media.edit_paly_info'))
          .width(28)
          .padding({ right: 8 })
          .onClick(() => {
            RouterUtils.pushPathByName(RouterMap.ADD_ONE_PLAY_LIST, this.selectList)
          })

      }
      .width('100%')
      .height($r('app.float.nav_header_height'))
    }
    .padding({
      left: CommonConstants.PADDING_PAGE,
      right: CommonConstants.PADDING_PAGE,
    })
    .width(CommonConstants.FULL_PERCENT)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  deleteBuilder() {
    Column() {
      Image($r('app.media.delete_music_info'))
        .height(20)
        .margin({ top: 10 })

      Text('删除')
        .fontSize(14)
        .margin({ top: 5 })
    }
    .width('100%')
    .backgroundColor('#fdfdfd')
    .onPressedColumn()
    .height(80)
    .onClick(() => {
      this.deleteMusic()
    })

  }

  @Builder
  editBuilder() {
    Column({ space: 6 }) {
      Row() {
        Image(ResManager.getPic(this.thisSelectSong?.label ?? 'ic_dream'))
          .width(44)
          .height(44)
          .borderRadius(6)
          .objectFit(ImageFit.Cover)
        Column() {
          Text(this.thisSelectSong?.title)
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Row() {
            if (this.thisSelectSong?.isLocal) {
              Image($r('app.media.ic_local'))
                .height(16)
                .width(25)
                .margin({ right: 6 })
            } else if (this.thisSelectSong?.isVip) {
              Image($r('app.media.ic_vip'))
                .height(16)
                .width(25)
                .margin({ right: 6 })
            }

            Text(this.thisSelectSong?.singer)
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

      // 添加到播放列表
      Row() {
        Image($r('app.media.add_play'))
          .height(20)
          .padding({ left: 30 })
        Text('添加到播放列表')
          .fontSize(14)
          .padding({ left: 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        this.addToPlayQueue(this.thisSelectSong)
      })

      // 添加到歌单
      Row() {
        if (this.isLove) {
          SymbolGlyph($r('sys.symbol.heart_fill'))
            .fontSize(20)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
            .fontColor([$r('app.color.app_theme')])
            .padding({ left: 30 })
        }
        if (!this.isLove) {
          SymbolGlyph($r('sys.symbol.heart'))
            .fontSize(20)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
            .padding({ left: 30 })
        }
        Text(this.isLove ? '取消喜欢' : '喜欢')
          .fontSize(14)
          .padding({ left: 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        this.addToLike(this.thisSelectSong)
        this.isLove = this.musicModel.isLikeSong(this.thisSelectSong?.id ?? '')
      })

      Row() {
        Image($r('app.media.down_icon'))
          .height(20)
          .padding({ left: 30 })
        Text('下载')
          .fontSize(14)
          .margin({ left: 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        this.downloadSong(this.thisSelectSong)
      })

      this.shareBuilder(this.thisSelectSong)

      Row() {
        Image($r('app.media.start_mv'))
          .height(20)
          .padding({ left: 30 })
        Text('播放MV')
          .fontSize(14)
          .padding({ left: 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        // 播放带有mv地址的歌曲
        if (this.thisSelectSong?.mvUrl && this.thisSelectSong?.mvUrl.length > 0) {
          MediaService.getInstance().pause();
          MediaService.getInstance().playMv(this.thisSelectSong?.mvUrl);
        } else {
          promptAction.showToast({ message: '暂无MV' });
        }
      })

      Row() {
        Image($r('app.media.delete_music_info'))
          .height(20)
          .padding({ left: 30 })
        Text('删除')
          .fontSize(14)
          .padding({ left: 20 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .height(40)
      .onPressedRow()
      .onClick(() => {
        if (this.selectList) {
          this.vm.deleteOneMusic(this.selectIndex, this.selectList?.selectIndex)
          this.editMusic = false
        }
      })
    }
  }

  // 添加到播放列表（不立即播放）
  addToPlayQueue(song?: SongItem): void {
    if (MediaService.getInstance().addToSongList(song)) {
      promptAction.showToast({ message: '已加入播放列表' });
    }
  }

  // 添加到喜欢
  addToLike(song?: SongItem): void {
    if (!song) {
      return;
    }
    const songId: string = song.id ?? '';
    if (!songId) {
      promptAction.showToast({ message: '无法添加：缺少歌曲ID' });
      return;
    }
    if (this.isLove) {
      MediaService.getInstance().unCollect(songId);
      song.isCollected = false;
      promptAction.showToast({ message: '已取消喜欢' });
      this.isLove = false
    } else {
      MediaService.getInstance().collect(songId);
      song.isCollected = true;
      promptAction.showToast({ message: '已添加到我喜欢' });
      this.isLove = true
    }
  }

  // 下载
  downloadSong(song?: SongItem): void {
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
    if (downUrl == '') {
      downUrl = this.musicModel.currentSong?.src ?? '';
    }
    if (!downUrl) {
      promptAction.showToast({ message: '无法下载：缺少歌曲文件地址' });
      return;
    }
    DownloadFileUtil.startDownFile(downUrl, getContext(this) as common.UIAbilityContext);
    promptAction.showToast({ message: '下载歌单' });
    getMusicModel().updateDownloadNum(song);
  }

  // 确认批量删除歌单弹窗
  deleteMusic() {
    CommonConfirmDialog.show({
      primaryTitle: '确认删除？',
      content: '',
      secBtnV: '删除',
      secBtnFg: $r('sys.color.warning'),
      confirm: () => {
        if (this.selectList) {
          this.playlistModel = this.vm.deleteTheMusic(this.selectedFlags, this.selectList.selectIndex)
        }
        this.getUIContext().getPromptAction().showToast({ message: '删除成功' });
        this.editAllMusic = false
      },
    })
  }

  build() {
    NavDestination() {
      Column() {
        if (!this.editAllMusic) {
          this.title()
          Row() {
            Image(ResManager.getPic(this.selectList?.playlistModel.cover ?? ''))
              .width(130)
              .height(130)
              .borderRadius(10)
              .margin({ left: 20 })
            Column() {
              Text(this.playlistModel?.title)
                .fontSize(20)
                .clip(true)
              Text(this.playlistModel?.subTitle)
                .fontSize(13)
                .fontColor('#747678')
                .margin({ top: 20 })
                .width('50%')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(2)
            }
            .margin({ left: 18 })
            .alignItems(HorizontalAlign.Start)
          }.width('100%')
          .justifyContent(FlexAlign.Start)
        }
        Column() {
          if (!this.editAllMusic) {
            // 播放全部
            Row() {
              SymbolGlyph($r('sys.symbol.play_round_triangle_fill'))
                .fontSize(30)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
                .fontColor([$r('app.color.app_theme')])
                .margin({ left: 15 })
              Text(`全部播放 ${this.playlistModel?.songList.length}首`)
                .fontWeight(600)
                .fontSize(16)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .layoutWeight(1)
                .margin({ left: 8 })
              Blank()
              Image($r('app.media.ic_mine_music_edit'))
                .width(25)
                .aspectRatio(1)
                .draggable(false)
                .onClick(() => {
                  this.selectedFlags = []
                  // 编辑歌曲
                  this.editAllMusic = true
                })
                .margin({ right: 20 })
            }.width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ top: 10 })
            .onClick(() => {
              this.vmPlay.mediaService.playAllSongs(this.playlistModel?.songList ?? [], true)
            })
          }

          if (this.editAllMusic) {
            Row() {
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                CheckboxGroup({ group: 'checkboxGroup' })
                  .checkboxShape(CheckBoxShape.CIRCLE)
                  .selectedColor($r('sys.color.warning'))
                  .mark({
                    strokeColor: Color.Black,
                    size: 24,
                  })
                  .width(30)
                  .height(30)
                  .padding({ left: 10 })
                Text('全选').fontSize(15)
                Blank()
                Row() {
                  Text('完成')
                    .fontSize(14)
                    .fontColor(Color.White)
                }
                .backgroundColor(Color.Black)
                .height(26)
                .width(50)
                .borderRadius(5)
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .onClick(() => {
                  this.editAllMusic = false
                })
              }
              .margin({ right: 15 })
            }
            .height(40)
            .width('100%')
          }

          // 循环歌单
          List() {
            ForEach(this.playlistModel?.songList, (v: SongItem, index: number) => {
              ListItem() {
                Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                  Row() {
                    Checkbox({ group: 'checkboxGroup' })
                      .width($r('app.float.normal_img_size'))
                      .shape(CheckBoxShape.CIRCLE)
                      .selectedColor($r('sys.color.warning'))
                      .select(this.selectedFlags[index])
                      .onChange((value: boolean) => {
                        this.selectedFlags[index] = value;
                      })
                  }
                  .height(50)
                  .padding({ left: 10 })
                  .visibility(this.editAllMusic ? Visibility.Visible : Visibility.None)

                  // 歌单1
                  Row() {
                    Image(ResManager.getPic(v.label))
                      .width(50)
                      .height(50)
                      .margin({ left: 20 })
                    Column() {
                      Text(v.title)
                        .fontSize(15)
                      Row() {
                        // 标识：本地 > VIP（非VIP不显示）
                        if (v.isLocal) {
                          Image($r('app.media.ic_local'))
                            .height(16)
                            .width(25)
                            .margin({ right: 6 })
                        } else if (v.isVip) {
                          Image($r('app.media.ic_vip'))
                            .height(16)
                            .width(25)
                            .margin({ right: 6 })
                        }
                        Text(v.singer)
                          .fontSize(14)
                          .fontColor('#666666')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .alignItems(VerticalAlign.Center)
                      .margin({ top: 4 })
                    }
                    .margin({ left: 10 })
                    .alignItems(HorizontalAlign.Start)

                    Blank()
                    if (this.editAllMusic) {
                      Image($r('app.media.ic_mine_music_edit'))
                        .width(30)
                        .height(30)
                        .margin({ right: 20 })
                    } else {
                      Column() {
                        Image($r('app.media.liangdian'))
                          .width(25)
                      }
                      .backgroundColor('#e6e8ea')
                      .width(30)
                      .height(30)
                      .borderRadius('50%')
                      .justifyContent(FlexAlign.Center)
                      .alignItems(HorizontalAlign.Center)
                      .margin({ right: 20 })
                      .onClick(() => {
                        this.selectIndex = index
                        this.editMusic = true
                        this.thisSelectSong = v
                        if (v.isCollected) {
                          this.isLove = true
                        } else {
                          this.isLove = false
                        }
                      })
                    }
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Start)
                  .height(80)
                  .onClick(() => {
                    this.vmPlay.mediaService.playSong(v, true)
                  })
                }
              }
            }, (v: SongItem) => v.id)
              .onMove((from: number, to: number) => {
                let tmp = this.playlistModel?.songList.splice(from, 1);
                if (tmp) {
                  this.playlistModel?.songList.splice(to, 0, tmp[0]);
                }
              });
          }
          .width('100%')
          .layoutWeight(1)

          //底部菜单栏
          Blank()
          if (this.editAllMusic) {
            this.deleteBuilder()
          }
          MusicPlayController()
            .visibility(!this.editAllMusic ? Visibility.Visible : Visibility.None)
            // .margin({ bottom: this.vm.windowModel.windowBottomPadding })
        }
        .backgroundColor('#f2f4f5')
        .borderRadius({ topLeft: 20, topRight: 20 })
        .layoutWeight(1)
        .margin({ top: 20 })
      }
      .height('100%')
      .bindSheet($$this.editMusic, this.editBuilder(), {
        height: 400,
        backgroundColor: Color.White,
        showClose: false
      })
      .padding({
        top: 40,
        bottom: this.vm.windowModel.windowBottomPadding
      })
      .backgroundColor('#e4e6e7')
    }.hideTitleBar(true)
  }
}