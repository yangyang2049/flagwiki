import { window } from '@kit.ArkUI';
import { PlayPlayer } from '../view/PlayPlayer';
import { PlayControl } from '../view/PlayControl';
import { PlayProgress } from '../view/PlayProgress';
import { VideoController } from '../controller/VideoController';
import { CommonConstants } from '../common/constants/CommonConstants';
import { PlayerModel } from '../common/model/PlayerModel';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { VideoItem } from '../viewmodel/VideoItem';
import { Battery } from '../view/Battery';
import ScreenUtil from '../common/util/ScreenUtil';
import { EasySlider, SliderType } from '../view/EasySlider';
import { EasyCircle } from '../view/Circle';
import { IVideoData, getVideoList } from '../common/util/VideoUtil';

const context: Context = getContext(this);

export enum VolumnAndBrightStyle {
  CIRCLE,
  CAPSULE
}

@ComponentV2
export struct UIFullVideo {
  @Param videoData: IVideoData[] = []
  @Param style: VolumnAndBrightStyle = VolumnAndBrightStyle.CIRCLE;
  @Param controller: VideoController = new VideoController();
  @Param componentHeight: number = 300
  @BuilderParam customTopRegion: () => void
  @BuilderParam customBottomRegion: () => void
  @Provider() videoList: VideoItem[] = []
  @Provider() playVideoModel: VideoController = this.controller;
  @Provider() playerModel: PlayerModel = this.controller.playerModel;
  @Provider() isLandscape: boolean = false;
  @Provider() isFullScreen: boolean = false;
  @Provider() xComponentWidth: number = 0
  @Provider() xComponentHeight: number = 0
  @Provider() videoWidth: number | string = 0
  @Provider() videoHeight: number = 0
  @Provider() showBar: boolean = true
  @Local aspect: number = 9 / 16;

  @Monitor('isLandscape')
  onStrChange(monitor: IMonitor) {
    this.changeOrientation()
  }

  private panOptionBrightAndVolumn: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private panOptionTime: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Horizontal });
  private windowClass: ESObject = (context as common.UIAbilityContext).windowStage.getMainWindowSync();
  // 是否显示锁屏按钮
  @Local isShowLockButton: boolean = true
  // 是否锁屏
  @Local isLockScreen: boolean = false
  // 音量进度条
  @Local isShowVolumeProgress: boolean = false
  // 亮度进度条
  @Local isShowBrightProgress: boolean = false
  // 时间进度条
  @Local isShowTimeProgress: boolean = false
  // 横屏方向
  @Local landscapeOrientation: number = 0
  // 定时器
  @Local clock: number = 0
  private changeWindowSize = (size: Size) => {
    const viewWidth = px2vp(size.width);
    const viewHeight = px2vp(size.height);
    this.xComponentWidth = viewWidth
    this.xComponentHeight = viewHeight;
    if (this.isFullScreen) {
      this.getVideoSize()
    } else {
      this.xComponentWidth = viewWidth
      this.xComponentHeight = this.componentHeight
      this.windowClass.setSpecificSystemBarEnabled('navigationIndicator', true); // show bottom navigation bar
    }
    this.getVideoSize()
  }

  async aboutToAppear() {
    this.getWindowProperties()
    this.playVideoModel = this.playVideoModel
    ScreenUtil.setScreenSize();
    this.videoList = await getVideoList(this.videoData)
    // 监听屏幕的变化
    this.windowClass.on('windowSizeChange', this.changeWindowSize);
  }

  aboutToDisappear() {
    this.playVideoModel.release();
    this.windowClass.off('windowSizeChange', this.changeWindowSize)
  }

  async getWindowProperties() {
    let windowClass = await window.getLastWindow(getContext());
    // 获取窗口属性
    let properties = windowClass.getWindowProperties();
    // 获取窗口宽高
    if (display.getDefaultDisplaySync().orientation === 0) {
      this.xComponentWidth = px2vp(properties.windowRect.width)
      this.xComponentHeight = this.componentHeight
    } else {
      this.isLandscape = true
      this.isFullScreen = true
      this.xComponentWidth = px2vp(properties.windowRect.width)
      this.xComponentHeight = px2vp(properties.windowRect.height)
    }
    this.getVideoSize()
  }

  getVideoSize() {
    this.videoHeight = this.xComponentHeight
    this.videoWidth = this.xComponentHeight / this.playVideoModel.aspect
    if (this.videoWidth > this.xComponentWidth) {
      this.videoWidth = this.xComponentWidth - 32
      this.videoHeight = this.videoWidth * this.playVideoModel.aspect
    }
  }

  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this);
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (this.isLandscape) {
        if (this.showBar) {
          this.clock = setTimeout(() => {
            this.showBar = false
          }, 3000)
        } else {
          clearTimeout(this.clock)
        }
        lastWindow.setPreferredOrientation(2)
        lastWindow.setWindowSystemBarEnable([])
        setTimeout(() => {
          this.landscapeOrientation = display.getDefaultDisplaySync().orientation
        }, 50)
      } else {
        window.getLastWindow(context).then((lastWindow) => {
          lastWindow.setPreferredOrientation(1)
          lastWindow.setWindowSystemBarEnable(['navigation', 'status'])
          this.landscapeOrientation = 0
        });
      }
    });
  }

  // 顶部
  @Builder
  topRegion() {
    Stack({ alignContent: Alignment.Top }) {
      Row()
        .width('100%')
        .height(64)
        .blur(8)
      Row() {
        if (this.customTopRegion) {
          this.customTopRegion()
        } else {
          Row() {
            Row() {
              Row() {
                Image($r('app.media.ic_arrow_left'))
                  .width(24)
                  .height(24)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    if (this.isFullScreen) {
                      this.isFullScreen = false
                      this.isLandscape = !this.isLandscape
                    }
                  })
              }
              .width(24)
              .height(24)
              .borderRadius('50%')
              .backgroundColor(Color.Black)
              .opacity($r('sys.float.ohos_id_alpha_content_secondary'))

              if (this.isFullScreen) {
                Row() {
                  Text(this.playVideoModel.getCurrentVideoName())
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
                    .fontColor(Color.White)
                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                }
                .width('60%')
                .margin({ left: 12, right: 8 })

                Row() {
                  Text(this.playVideoModel.getCurrentVideoEpisode())
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
                    .fontColor(Color.White)
                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)
                }
              }
            }

            Battery()
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .width('100%')
      .height(24)
      .margin(this.isFullScreen ? { top: 12 } : { top: 8 })
    }
    .width('100%')
    .height(64)
    .position({ left: 0, top: 0 })
    .visibility(this.showBar ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  centerRegion() {
    Row() {
      // 锁屏按钮
      Row() {
        Image(this.isLockScreen ? $r('app.media.ic_lock') : $r('app.media.ic_unlock'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.isLockScreen = !this.isLockScreen
            if (this.isLockScreen) {
              this.showBar = false
              this.isShowLockButton = true
            } else {
              this.showBar = true
              this.isShowLockButton = true
            }
          })
      }
      .width(24)
      .height(24)
      .borderRadius('50%')
      .backgroundColor(Color.Black)
      .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
      .visibility(this.isShowLockButton ? Visibility.Visible : Visibility.Hidden)

      // 暂停按钮
      if (!this.isShowTimeProgress && !this.isShowBrightProgress &&
        !this.isShowVolumeProgress && this.playVideoModel.status === CommonConstants.STATUS_PAUSE) {
        Row() {
          Row() {
            Image($r('app.media.ic_pause'))
              .width(60)
              .height(60)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.playVideoModel !== null) {
                  const curStatus = (this.playVideoModel!.getStatus() === CommonConstants.STATUS_START);
                  this.playVideoModel.status = curStatus ? CommonConstants.STATUS_PAUSE : CommonConstants.STATUS_START;
                  this.playVideoModel!.switchPlayOrPause();
                }
              })
          }
          .width(60)
          .height(60)
          .translate({ x: -24 })
          .borderRadius('50%')
          .backgroundColor(Color.Black)
          .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }

      if (this.style === VolumnAndBrightStyle.CIRCLE) {
        Row() {
          if (this.isShowBrightProgress) {
            EasyCircle({ type: SliderType.BRIGHT })
          } else if (this.isShowVolumeProgress) {
            EasyCircle({ type: SliderType.VOLUMN })
          } else if (this.isShowTimeProgress) {
            EasyCircle({ type: SliderType.TIME })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .translate({ x: -24 })
      }
    }
    .width('100%')
    .position({ left: 0, top: '50%' })
    .translate({ y: '-50%' })
  }

  @Builder
  bottomRegion() {
    Column() {
      if (this.customBottomRegion) {
        this.customBottomRegion()
      } else {
        PlayProgress()
        if (this.isFullScreen) {
          PlayControl()
        }
      }
    }
    .width('100%')
    .position({ left: 0, bottom: 0 })
    .visibility(this.showBar ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  buttonRegion() {
    if (this.style === VolumnAndBrightStyle.CAPSULE) {
      Row() {
        if (this.isShowBrightProgress) {
          EasySlider({ type: SliderType.BRIGHT })
        } else if (this.isShowVolumeProgress) {
          EasySlider({ type: SliderType.VOLUMN })
        } else if (this.isShowTimeProgress) {
          EasySlider({ type: SliderType.TIME })
        }
      }
      .position({ left: '50%', top: 40 })
      .translate({ x: '-50%' })
    }
  }

  build() {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 视频区
        if (this.videoList.length > 0) {
          PlayPlayer()
            .zIndex(0)
        }
        Row() {
          this.topRegion()
          this.centerRegion()
          this.buttonRegion()
          this.bottomRegion()
        }
        .width('100%')
        .height('100%')
        .gesture(GestureGroup(GestureMode.Exclusive,
          PanGesture(this.panOptionBrightAndVolumn)
            .onActionStart((event?: GestureEvent) => {
              if (!event) {
                return;
              }
              if (event.fingerList[0].localX >= 200) {
                this.isShowVolumeProgress = true
              } else {
                this.isShowBrightProgress = true
              }
              this.playVideoModel.onActionStart(event);
            })
            .onActionUpdate((event?: GestureEvent) => {
              this.playVideoModel.onActionUpdate(event);
            })
            .onActionEnd(() => {
              this.isShowVolumeProgress = false
              this.isShowBrightProgress = false
              this.playVideoModel.onActionEnd();
            }),
          PanGesture(this.panOptionTime)
            .onActionStart((event?: GestureEvent) => {
              this.playVideoModel.onTimeActionStart(event);
              this.isShowTimeProgress = true
            })
            .onActionUpdate((event?: GestureEvent) => {
              this.playVideoModel.onTimeActionUpdate(event);
            })
            .onActionEnd(() => {
              this.playVideoModel.onActionTimeEnd();
              this.isShowTimeProgress = false
            }),
          TapGesture({ count: 2 })
            .onAction(() => {
              if (this.isLockScreen) {
                return
              }
              if (this.playVideoModel === null) {
                return
              }
              if (this.playVideoModel.getStatus() === CommonConstants.STATUS_PAUSE) {
                this.playVideoModel!.switchPlayOrPause();
              } else {
                this.playVideoModel.pause()
                this.playVideoModel.status = CommonConstants.STATUS_PAUSE;
              }
            }),
          TapGesture({ count: 1 })
            .onAction(() => {
              if (!this.isLockScreen) {
                this.showBar = !this.showBar
                if (this.showBar) {
                  this.clock = setTimeout(() => {
                    this.showBar = false
                  }, 3000)
                } else {
                  clearTimeout(this.clock)
                }
              }
              this.isShowLockButton = !this.isShowLockButton
            })
        )
        )
      }
      .width(this.isFullScreen ? 'calc(100% - 44vp)' : vp2px(this.xComponentWidth - 32) + 'px')
      .height(vp2px(this.xComponentHeight) + 'px')
      .margin(this.landscapeOrientation === 2 ? { right: 12 } : this.landscapeOrientation === 3 ? { left: 12 } : {})
      .alignContent(Alignment.Center)
    }
    .width('100%')
    .height(vp2px(this.xComponentHeight) + 'px')
    .backgroundColor('#000')
    .justifyContent(FlexAlign.Center)
  }
}