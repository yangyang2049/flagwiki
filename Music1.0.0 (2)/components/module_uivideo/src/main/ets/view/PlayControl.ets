import { VideoController } from '../controller/VideoController';
import { CommonConstants } from '../common/constants/CommonConstants';
import { VideoItem } from '../viewmodel/VideoItem';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { MyRowModifier } from '../common/util/VideoUtil';
import { Logger } from '../common/util/Logger';

const context: Context = getContext(this);

@ComponentV2
export struct PlayControl {
  @Consumer() playVideoModel: VideoController = new VideoController();
  @Consumer() isLandscape: boolean = false;
  @Consumer() videoList: VideoItem[] = []
  @Consumer() modifier: MyRowModifier = new MyRowModifier()
  @Consumer() windowClass: window.Window = (context as common.UIAbilityContext).windowStage.getMainWindowSync();
  @Consumer() showBar: boolean = true
  @Consumer() clock: number = 0
  @Consumer() CLOCK_TIME: number = 5000
  @Consumer() isPause: boolean = false

  setOrientation(orientation: number) {
    this.windowClass.setPreferredOrientation(orientation).then(() => {
      Logger.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      Logger.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
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
    Row() {
      Row() {
        Stack() {
          this.iconBg()
          Image(this.playVideoModel.status === CommonConstants.STATUS_START ?
          $r('app.media.ic_pause') : $r('app.media.ic_play'))
            .width(24)
            .height(24)
            .fillColor(Color.White)
            .aspectRatio(CommonConstants.ASPECT_RATIO)
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

        Stack() {
          this.iconBg()
          Image($r('app.media.ic_next'))
            .width(24)
            .height(24)
            .aspectRatio(CommonConstants.ASPECT_RATIO)
            .margin({ left: 10, right: 10 })
            .onClick(() => {
              if (this.playVideoModel !== null && this.videoList.length - 1 > this.playVideoModel.index) {
                this.playVideoModel!.nextVideo();
              }
            })
        }
      }

      Stack() {
        this.iconBg()
        Image($r('app.media.ic_exit_full_screen'))
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
            this.isLandscape = false
            this.modifier.isTop = false
            this.setOrientation(window.Orientation.AUTO_ROTATION);
            this.windowClass.setWindowSystemBarEnable(['navigation', 'status'])
            this.windowClass.setWindowLayoutFullScreen(false)
          })
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(24)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 12 })
  }
}