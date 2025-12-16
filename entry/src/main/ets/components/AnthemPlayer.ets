import { SongItem } from '../utils/music/SongItem';
import { getMusicModel, MusicModel } from '../utils/music/MusicModel';
import { MediaService } from '../utils/music/MediaService';
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

/**
 * 简化的国歌播放控制器
 */
@Component
export struct AnthemPlayer {
  private musicModel: MusicModel = getMusicModel();
  private mediaService: MediaService = MediaService.getInstance();
  private context = getContext(this) as common.UIAbilityContext;

  private singleClick(func: () => void, interval: number = 500): () => void {
    let time = 0;
    return () => {
      const nowTime = Date.now();
      const remainTime = interval - (nowTime - time);
      if (remainTime <= 0) {
        time = nowTime;
        func();
      }
    };
  }

  build() {
    Column() {
      // 进度条
      if (this.musicModel.currentSong) {
        Column() {
          Slider({
            min: 0,
            max: this.musicModel.progressMax,
            step: 1,
            value: this.musicModel.progress
          })
            .blockColor($r('app.color.button_primary'))
            .selectedColor($r('app.color.button_primary'))
            .trackColor($r('app.color.gray_border'))
            .blockSize({ width: 12, height: 12 })
            .onChange((value: number, mode: SliderChangeMode) => {
              if (mode === SliderChangeMode.End) {
                this.mediaService.seek(value);
              }
            })
            .height(4)

          Row() {
            Text(this.musicModel.currentTime)
              .fontSize(9)
              .fontColor($r('app.color.text_tertiary'))
            Blank()
            Text(this.musicModel.totalTime)
              .fontSize(9)
              .fontColor($r('app.color.text_tertiary'))
          }
          .width('100%')
          .margin({ top: 12 })
        }
        .width('100%')
        .padding({ left: 8, right: 8 })
        .margin({ top: 16, bottom: 8 })
      }

      // 播放控制栏
      Row() {
        if (!this.musicModel.currentSong) {
          this.NoSong()
        } else {
          // 左侧：当前歌曲信息
          this.SongInfoBuild()

          // 中间：播放操作按钮
          this.PlayButton()
        }

        // 右侧：播放列表按钮（简化版，暂时隐藏）
      }
      .width('100%')
      .height(48)
      .justifyContent(FlexAlign.Center)
      .padding({
        left: 16,
        right: 16
      })
    }
    .width('100%')
    .backgroundColor($r('app.color.bg_tab_bar'))
  }

  @Builder
  NoSong() {
    Row({ space: 16 }) {
      Row() {
        SymbolGlyph($r('sys.symbol.music_fill'))
          .fontSize(28)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
          .fontColor(['#33000000'])
      }
      .height(38)
      .width(38)
      .borderRadius(50)
      .backgroundColor('#0D000000')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Text(this.context.resourceManager.getStringSync($r('app.string.no_playing').id))
        .fontSize(14)
        .fontWeight(500)
        .fontColor('#88000000')
    }
    .layoutWeight(1)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  SongInfoBuild() {
    Row() {
      // 圆形图标
      Image(this.musicModel.currentSong?.label as Resource)
        .height(32)
        .width(32)
        .borderRadius(16)
        .margin({ right: 12 })
        .objectFit(ImageFit.Contain)

      Column() {
        // 第一行：歌曲名称（国歌名称）
        Text(this.musicModel.currentSong?.title ?? '')
          .fontSize(14)
          .fontWeight(500)
          .fontColor('#88000000')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(150)

        // 第二行：国家名称
        Text(this.musicModel.currentSong?.singer ?? '')
          .fontSize(10)
          .fontColor('#4D000000')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width(150)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .layoutWeight(1)
    .onClick(() => {
      if (this.musicModel.songList.length <= 0) {
        promptAction.showToast({ message: this.context.resourceManager.getStringSync($r('app.string.select_song_to_play').id) });
        return;
      }
      // 可以在这里打开播放详情页
    })
  }

  @Builder
  PlayButton() {
    Row() {
      // 上一首
      Image($r('app.media.icon_previous'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.button_primary'))
        .margin({ right: 16 })
        .onClick(this.singleClick(() => {
          this.mediaService.playPrevious();
        }, 1000))

      // 播放/暂停
      Image(this.musicModel.isPlay ? $r('app.media.icon_pause') : $r('app.media.icon_play'))
        .width(28)
        .height(28)
        .fillColor($r('app.color.button_primary'))
        .onClick(this.singleClick(() => {
          this.mediaService.playAndPause();
        }, 1000))

      // 下一首
      Image($r('app.media.icon_next'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.button_primary'))
        .margin({ left: 16 })
        .onClick(this.singleClick(() => {
          this.mediaService.playNext();
        }, 1000))
    }
  }
}


