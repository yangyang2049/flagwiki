import { CommonConstants, EventBus, ImportSongUtil, scanSandboxMusicFiles, singleClick } from 'lib_common';
import { NavHeaderBar } from 'lib_widget';
import { promptAction } from '@kit.ArkUI';
import { MarkViewModel } from '../viewmodels/MarkVM';
import { SongItem } from 'lib_music_api/src/main/ets/params/response/SongItem';
import { common } from '@kit.AbilityKit';
import fileIo from '@ohos.file.fs';
import { MusicPlayController } from 'module_musicplay';
import { CollectedSongItem } from '../components/CollectedSongItem';
import { Logger } from 'module_musicplay/src/main/ets/utils/Logger';

export class Operation {
  id: number = 0;
  icon: Resource = $r('app.media.song_default');
  name: string = '';
}

@Builder
export function LocalSongsPageBuilder() {
  LocalSongsPage()
}

@ComponentV2
struct LocalSongsPage {
  @Local vm: MarkViewModel = new MarkViewModel();
  @Local selectedSong: SongItem = new SongItem(); // 用于存储选中的歌曲信息
  @Local isShowSheet: boolean = false; //是否展示音质选择页面
  private sandboxMusicPath: string = '';
  private context = getContext(this) as common.UIAbilityContext;
  operationList: Array<Operation> = [
    { id: 1, icon: $r('sys.symbol.music_note_list'), name: '添加到播放列表' },
    { id: 2, icon: $r('sys.symbol.heart'), name: '喜欢' },
    { id: 3, icon: $r('sys.symbol.folder_badge_plus'), name: '添加歌单' },
    { id: 4, icon: $r('sys.symbol.trash'), name: '删除' }
  ]
  suffix: Array<string> = ['.mp3', '.flac', '.wav', '.aac']

  aboutToAppear(): void {
    this.sandboxMusicPath = `${this.context.filesDir}${ImportSongUtil.getCachepath()}`;
    this.getSongs()
    // 监听事件刷新
    // 收藏操作监听(播放器以外)
    EventBus.listen<Record<string, string>>('updateLocalSongs', (param) => {
      this.getSongs()
    })
  }

  aboutToDisappear(): void {
    EventBus.cancel('updateLocalSongs')
  }

  getSongs() {
    scanSandboxMusicFiles(this.context).then(songs => {
      this.vm.localSongs = songs
    })
  }

  // 从沙箱中移除该歌曲
  private async removeSongFromSandbox(song: SongItem) {
    // 根据src 获取文件名
    const targetPath = song.src.split('/').pop();
    // 检查目标目录是否存在，不存在则创建
    if (fileIo.accessSync(this.sandboxMusicPath)) {
      try {
        // 执行文件移动操作
        await fileIo.unlink(song.src);
        Logger.info('文件已从沙箱目录移除：' + targetPath)
        this.getSongs();
      } catch (error) {
        Logger.error('文件移动异常: ', error);
        throw new Error('文件移动失败: ' + error.message);
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        NavHeaderBar({
          title: '本地歌曲',
          showBackBtn: true,
          rightPartBuilder: () => {
            this.rightHeadPartBuilder()
          },
        })

        Column() {
          Row({ space: 8 }) {
            SymbolGlyph($r('sys.symbol.play_round_triangle_fill'))
              .fontSize(32)
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
              .fontColor([$r('app.color.app_theme')])
            Text($r('app.string.play_all', this.vm.localSongs.length))
              .fontWeight(700)
              .fontSize(18)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .layoutWeight(1)
          }
          .height(48)
          .alignSelf(ItemAlign.Start)
          .padding({
            left: 16,
            right: 16
          })
          .onClick(() => {
            this.vm.mediaService.playAllSongs(this.vm.localSongs, true)
          })

          List() {
            ForEach(this.vm.localSongs, (item: SongItem, index: number) => {
              CollectedSongItem({
                item: item,
                index: index,
                sources: 'local',
                onOperationCallback: (value: SongItem) => {
                  this.removeSongFromSandbox(value)
                }
              })
            }, (item: SongItem) => JSON.stringify(item))
          }
          .width('100%')
          .cachedCount(3)
          .layoutWeight(1)
          .divider({
            strokeWidth: 1,
            color: '#E8E8E8',
            startMargin: 16,
            endMargin: 16
          })
        }
        .backgroundColor('#F1F3F5')
        .width('100%')
        .bindSheet(this.isShowSheet, this.operationBindSheet(), {
          height: '40%',
          dragBar: true,
          showClose: false,
          onWillDisappear: () => {
            this.selectedSong = new SongItem();
            this.isShowSheet = false;
          }
        })
        .layoutWeight(1)

        MusicPlayController()
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        bottom: this.vm.windowModel.windowBottomPadding
      })
    }
    .hideTitleBar(true)
  }

  @Builder
  rightHeadPartBuilder() {
    Row({ space: CommonConstants.SPACE_S }) {
      Image($r('app.media.ic_import'))
        .width(40)
        .height(40)
        .alignSelf(ItemAlign.Center)
        .onClick(singleClick(() => {
          promptAction.showToast({ message: '导入歌曲' });
          ImportSongUtil.importLocalSong(this.context).then(() => {
            // 刷新页面
            this.getSongs();
          })
        }))
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.End)
  }

  @Builder
  operationBindSheet() {
    Column() {
      //第一行 歌曲信息，第一列包括歌曲头像、第二列歌曲名和歌手
      Row() {
        Column() {
          Image(this.selectedSong.label)
            .width(80)
            .height(80)
            .borderRadius(4)
            .alignSelf(ItemAlign.Center)
        }
        .alignItems(HorizontalAlign.Center)
        .margin({
          top: 16,
          bottom: 16
        })

        Column() {
          Text(this.selectedSong.title)
            .fontSize(16)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          Text(this.selectedSong.singer)
            .fontSize(12)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
        .padding({
          left: 16,
        })
        .alignItems(HorizontalAlign.Start)
      }
      .padding({
        left: 16,
        right: 16
      })
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      List() {
        ForEach(this.operationList, (item: Operation) => {
          ListItem() {
            Row() {
              SymbolGlyph(item.icon)
                .fontSize(28)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
                .fontColor([$r('app.color.app_theme')])
                .margin({ right: 16 })

              Text(item.name)
                .fontSize(16)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .padding({
                  left: 16
                })
                .layoutWeight(1)
            }
            .margin({ top: 16 })
            .onClick(() => {
              this.isShowSheet = false;
              //处理操作
              promptAction.showToast({ message: item.name });
              if (item.id === 4) {
                this.removeSongFromSandbox(this.selectedSong)
                promptAction.showToast({ message: '删除歌曲' + this.selectedSong.title });
              }
            })
          }
        }, (item: Operation) => JSON.stringify(item))
      }
      .width('100%')
      .cachedCount(3)
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: '#E8E8E8',
        startMargin: 16,
        endMargin: 16
      })
      .padding({
        left: 16,
        right: 16,
        bottom: 16
      })
    }
    .width('100%')
    .height('100%')
  }
}