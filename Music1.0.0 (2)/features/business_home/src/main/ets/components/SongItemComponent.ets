import { ThemeController } from 'module_theme';
import { getMusicModel, MusicModel, SongItem } from 'module_musicplay';
import { ResManager } from 'lib_common';

@ComponentV2
export struct SongItemComponent {
  @Param song: SongItem = {
    id: '',
    title: '',
    singer: '',
    label: '',
    mark: '',
    src: '',
    lyric: '',
    isCollected: false,
    isLocal: false,
    mvUrl: '',
    isVip: false,
    collectedCount: 0,
    playlistCount: 0,
    downloadCount: 0,
    shareCount: 0
  };
  @Param onSongClick: (song: SongItem) => void = () => {
  };
  // 非按钮区域点击：用于打开播放页
  @Param onSongAreaClick: (song: SongItem) => void = () => {
  };
  // 由上层根据全局播放状态传入，控制右侧图标显示
  @Local isPlaying: boolean = false;
  @Local musicModel: MusicModel = getMusicModel();

  @Monitor('musicModel.updateSongInfo')
  musicModelChange() {
    if (this.musicModel.currentSong?.id === this.song.id) {
      this.isPlaying = true;
    } else {
      this.isPlaying = false;
    }
  }

  build() {
    Row() {
      Image(ResManager.getPic(this.song.label as string))
        .width(60)
        .height(60)
        .borderRadius(8)
        .objectFit(ImageFit.Cover)

      Column() {
        Text(this.song.title)
          .fontSize(16)
          .fontColor(ThemeController.theme.themeColors[2])
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row() {
          // 标识：本地 > VIP（非VIP不显示）
          if (this.song.isLocal) {
            Image($r('app.media.ic_local'))
              .height(16)
              .width(25)
              .margin({ right: 6 })
              .fillColor(ThemeController.theme.themeColor)
          } else if (this.song.isVip) {
            Image($r('app.media.ic_vip'))
              .height(16)
              .width(25)
              .margin({ right: 6 })
              .fillColor(ThemeController.theme.themeColor)
          }
          if (this.song.label === '国风') {
            Text('国风')
              .fontSize(10)
              .fontColor(ThemeController.theme.themeColor)
              .backgroundColor(ThemeController.theme.themeColors[4])
              .padding({
                top: 2,
                bottom: 2,
                left: 6,
                right: 6
              })
              .borderRadius(4)
              .margin({ right: 6 })
          }
          Text(this.song.singer)
            .fontSize(14)
            .fontColor(ThemeController.theme.themeColors[4])
        }
        .margin({ top: 4 })
        .alignItems(VerticalAlign.Center)
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      Image(this.isPlaying ? $r('app.media.zhibozhong') : $r('app.media.bofang'))
        .width(20)
        .height(20)
        .fillColor(ThemeController.theme.themeColor)
        .onClick((event: ClickEvent) => {
          // 交由上层处理播放/暂停逻辑与状态切换
          this.onSongClick(this.song);
        })
    }
    .width('100%')
    .height(80)
    .padding({
      left: 16,
      top: 12,
      bottom: 12
    })
    .onClick(() => {
      // 非按钮区域点击，打开播放页
      this.onSongAreaClick(this.song);
    })
  }
}
