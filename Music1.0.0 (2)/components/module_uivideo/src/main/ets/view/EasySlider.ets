import { PlayConstants } from '../common/constants/PlayConstants';
import { PlayerModel } from '../common/model/PlayerModel';

export enum SliderType {
  VOLUMN,
  BRIGHT,
  TIME
}

@ComponentV2
export struct EasySlider {
  @Param type: SliderType = SliderType.VOLUMN
  @Consumer() playerModel: PlayerModel = new PlayerModel();

  @Monitor('playerModel')
  onStrChange(monitor: IMonitor) {
    this.getIcon()
  }

  // 获取icon
  getIcon(): ResourceStr {
    if (this.type === SliderType.VOLUMN) {
      if (this.playerModel.volume === 0) {
        return $r('app.media.ic_circle_volumn')
      } else {
        return $r('app.media.ic_volumn_small')
      }
    } else if (this.type === SliderType.BRIGHT) {
      if (this.playerModel.bright === 0) {
        return $r('app.media.ic_sun_small')
      } else {
        return $r('app.media.ic_active_sun_small')
      }
    } else {
      return ''
    }
  }

  build() {
    Row() {
      if (this.type === SliderType.TIME) {
        Row() {
          Stack() {
            Row()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Black)
              .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
              .borderRadius('50%')
            Column() {
              Row() {
                Text(this.playerModel.currentTime)
                  .fontColor(Color.White)
                  .fontSize($r('sys.float.ohos_id_text_size_button3'))
                  .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                  .opacity(this.playerModel.progressVal < 0.07 ? $r('sys.float.ohos_id_alpha_content_secondary') : 1)
                Text('/')
                  .fontColor(Color.White)
                  .fontSize($r('sys.float.ohos_id_text_size_button3'))
                  .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                  .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
                Text(this.playerModel.totalTime)
                  .fontColor(Color.White)
                  .fontSize($r('sys.float.ohos_id_text_size_button3'))
                  .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                  .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
              }

              Slider({
                value: this.playerModel.progressVal,
                step: PlayConstants.PROGRESS_STEP,
                style: SliderStyle.NONE
              })
                .blockColor(Color.White)
                .trackColor(Color.White)
                .selectedColor($r('sys.color.ohos_id_color_palette9'))
                .trackThickness(PlayConstants.PROGRESS_TRACK_THICKNESS)
                .layoutWeight(1)
                .opacity(this.playerModel.progressVal <= 0.07 ? $r('sys.float.ohos_id_alpha_content_secondary') : 1)
            }
            .width('calc(100% - 32vp)')
          }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Row() {
          Stack() {
            Row()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Black)
              .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
              .borderRadius('50%')
            Row() {
              Row()
                .width(this.type === SliderType.VOLUMN ? this.playerModel.volume * 100 + '%' :
                  this.playerModel.bright * 100 + '%')
                .height('100%')
                .backgroundColor(Color.White)
                .borderRadius('50%')
                .position({ left: 0 })
            }
            .width('100%')
            .height('100%')
            .borderRadius('50%')
            .clip(true)

            Image(this.getIcon())
              .width(16)
              .height(16)
              .position({ left: 4, top: 4 })
          }
          .width('100%')
          .height('100%')
          .borderRadius('50%')
        }
        .width('100%')
        .height('100%')
      }
    }
    .width(200)
    .height(24)
  }
}