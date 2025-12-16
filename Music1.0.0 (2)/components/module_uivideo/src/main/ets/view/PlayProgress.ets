import { VideoController } from '../controller/VideoController';
import { CommonConstants } from '../common/constants/CommonConstants';
import { PlayConstants } from '../common/constants/PlayConstants';
import { PlayerModel } from '../common/model/PlayerModel';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { MyRowModifier } from '../common/util/VideoUtil';
import { Logger } from '../common/util/Logger';

const context: Context = getContext(this);

@ComponentV2
export struct PlayProgress {
  @Consumer() playVideoModel: VideoController = new VideoController();
  @Consumer() playerModel: PlayerModel = new PlayerModel();
  @Consumer() windowClass: window.Window = (context as common.UIAbilityContext).windowStage.getMainWindowSync();
  @Consumer() modifier: MyRowModifier = new MyRowModifier()
  @Consumer() isLandscape: boolean = false
  @Consumer() showBar: boolean = true
  @Consumer() clock: number = 0
  @Consumer() CLOCK_TIME: number = 5000
  @Consumer() isShowTimeProgress: boolean = false
  @Consumer() isPause: boolean = false

  setOrientation(orientation: number) {
    this.windowClass.setPreferredOrientation(orientation).then(() => {
      Logger.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      Logger.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }

  getFlexOptions(): FlexOptions {
    if (this.isLandscape) {
      return { direction: FlexDirection.Row, alignItems: ItemAlign.Center }
    } else {
      return { direction: FlexDirection.Column }
    }
  }

  @Builder
  iconBg() {
    Row()
      .width(24)
      .height(24)
      .flexGrow(0)
      .flexShrink(0)
      .borderRadius('50%')
      .backgroundColor(Color.Black)
      .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        if (!this.isLandscape) {
          Stack() {
            this.iconBg()
            Image((this.isPause || this.playVideoModel.completed) ? $r('app.media.ic_play') :
            $r('app.media.ic_pause'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
              .fillColor(Color.White)
              .onClick(() => {
                if (this.playVideoModel === null) {
                  return
                }
                if (this.playVideoModel!.getStatus() === CommonConstants.STATUS_PAUSE) {
                  this.isPause = false
                  this.playVideoModel!.switchPlayOrPause();
                } else {
                  this.isPause = true
                  this.playVideoModel.status = CommonConstants.STATUS_PAUSE;
                  this.playVideoModel!.pause()
                }
              })
          }
        }
        Flex(this.getFlexOptions()) {
          if (this.isLandscape) {
            Row() {
              Text(this.playerModel.currentTime)
                .fontColor(Color.White)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            }
            .flexShrink(0)
            .height(16)
            .justifyContent(FlexAlign.End)
          }
          Stack() {
            Row()
              .width('100%')
              .height(4)
              .backgroundColor(Color.White)
              .opacity($r('sys.float.ohos_id_alpha_content_fourth'))
              .borderRadius($r('sys.float.ohos_id_corner_radius_progress_bar'))
            Slider({
              value: this.playerModel.progressVal,
              step: PlayConstants.PROGRESS_STEP,
              style: SliderStyle.OutSet
            })
              .blockColor(Color.White)
              .selectedColor($r('sys.color.ohos_id_color_palette9'))
              .trackThickness(4)
              .blockSize({ width: 16, height: 16 })
              .trackBorderRadius($r('sys.float.ohos_id_corner_radius_progress_bar'))
              .layoutWeight(1)
              .enabled(!this.playVideoModel.completed)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.isPause = false
                if (this.showBar) {
                  clearTimeout(this.clock)
                  this.clock = setTimeout(() => {
                    this.showBar = false
                  }, this.CLOCK_TIME)
                } else {
                  if (this.clock) {
                    clearTimeout(this.clock)
                  }
                }
                if (mode === Number(SliderChangeMode.Moving)) {
                  this.playVideoModel.isSliderChange = true
                  this.playVideoModel.pause()
                  this.isShowTimeProgress = true
                } else if (mode === Number(SliderChangeMode.Click)) {
                  this.playVideoModel.isSliderChange = false
                  this.playVideoModel.pause()
                } else {
                  this.isShowTimeProgress = false
                }
                this.playVideoModel!.setSeekTime(value, mode);
              })
              .margin({ left: -10, right: -10 })
          }
          .padding(this.isLandscape ? { left: 8, right: 8 } : {})

          if (this.isLandscape) {
            Row() {
              Text(this.playerModel.totalTime)
                .fontColor(Color.White)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            }
            .height(16)
            .justifyContent(FlexAlign.Start)
            .flexShrink(0)
          }
          if (!this.isLandscape) {
            Row() {
              Text(this.playerModel.currentTime)
                .fontColor(Color.White)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              Text(this.playerModel.totalTime)
                .fontColor(Color.White)
                .fontSize($r('sys.float.ohos_id_text_size_body3'))
                .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .padding(this.isLandscape ? {} : { left: 8, right: 8 })

        if (!this.isLandscape) {
          Stack() {
            this.iconBg()
            Image($r('app.media.ic_full_screen'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.showBar) {
                  clearTimeout(this.clock)
                  this.clock = setTimeout(() => {
                    this.showBar = false
                  }, this.CLOCK_TIME)
                } else {
                  if (this.clock) {
                    clearTimeout(this.clock)
                  }
                }
                this.isLandscape = true
                this.modifier.isTop = true
                this.windowClass.setWindowSystemBarEnable([])
                this.windowClass.setWindowLayoutFullScreen(true)
                this.setOrientation(window.Orientation.LANDSCAPE);
              })
          }
        }
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(24)
    .justifyContent(FlexAlign.Center)
    .margin({ bottom: 8 })
  }
}