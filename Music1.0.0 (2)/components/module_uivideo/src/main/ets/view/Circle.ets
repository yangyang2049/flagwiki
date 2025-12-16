import { PlayerModel } from '../common/model/PlayerModel';

export enum SliderType {
  VOLUMN,
  BRIGHT,
  TIME
}

@ComponentV2
export struct EasyCircle {
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
        return $r('app.media.ic_circle_active_volumn')
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

  // 获取文字
  getText(): ResourceStr {
    switch (this.type) {
      case SliderType.VOLUMN:
        return $r('app.string.volume')
      case SliderType.BRIGHT:
        return $r('app.string.brightness')
      case SliderType.TIME:
        return this.playerModel.totalTime
      default:
        return ''
    }
  }

  // 获取值
  getValue(): number {
    switch (this.type) {
      case SliderType.VOLUMN:
        return this.playerModel.volume * 100
      case SliderType.BRIGHT:
        return this.playerModel.bright * 100
      case SliderType.TIME:
        if (this.playerModel.progressVal < 0.01) {
          return 0
        }
        return this.playerModel.progressVal
      default:
        return 0
    }
  }

  build() {
    Column() {
      Stack() {
        Row()
          .width(100)
          .height(100)
          .backgroundColor(Color.Black)
          .opacity($r('sys.float.ohos_id_alpha_content_tertiary'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
        Column() {
          Stack() {
            Stack() {
              Text()
                .width(60)
                .height(60)
                .borderRadius(30)
                .borderWidth(2)
                .borderColor(Color.White)
                .opacity($r('sys.float.ohos_id_alpha_content_fourth'))

              Progress({ value: this.getValue(), type: ProgressType.Ring, })
                .color($r('sys.color.ohos_id_color_palette9'))
                .width(60)
                .backgroundColor('#00000000')
                .style({ strokeWidth: 2 })
            }

            if (this.type === SliderType.TIME) {
              Text(this.playerModel.currentTime)
                .fontColor(this.getValue() === 0 ? Color.Black : $r('sys.color.ohos_id_color_palette9'))
                .fontSize($r('sys.float.ohos_id_text_size_button3'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
            } else {
              Image(this.getIcon())
                .width(24)
                .height(24)
            }
          }
          .alignContent(Alignment.Center)
          .margin({ bottom: 4 })

          Text(this.getText())
            .fontColor(Color.White)
            .fontSize($r('sys.float.ohos_id_text_size_button3'))
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
        }
        .width(100)
      }
      .margin(12)
    }
    .width(100)
    .height(100)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
  }
}