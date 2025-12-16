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
import { IVideoData, getVideoList, MyRowModifier } from '../common/util/VideoUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentController } from '../controller/ComponentController';
import { Logger } from '../common/util/Logger';

const context: Context = getContext(this);

export enum VolumnAndBrightStyle {
  CIRCLE,
  CAPSULE
}

@ComponentV2
export struct UIVideo {
  @Param videoData: IVideoData[] = []
  @Param style: VolumnAndBrightStyle = VolumnAndBrightStyle.CIRCLE;
  @Param controller: VideoController = new VideoController();
  @Param componentController: ComponentController = new ComponentController();
  @Param componentHeight: number = 300
  @BuilderParam customTopRegion: () => void
  @BuilderParam customBottomRegion: () => void
  @Provider() modifier: MyRowModifier = new MyRowModifier()
  @Provider() windowClass: window.Window = (context as common.UIAbilityContext).windowStage.getMainWindowSync();
  @Provider() videoList: VideoItem[] = []
  @Provider() playVideoModel: VideoController = this.controller;
  @Provider() playerModel: PlayerModel = this.controller.playerModel;
  @Provider() isLandscape: boolean = false;
  @Provider() xComponentWidth: number = 0
  @Provider() xComponentHeight: number = 0
  @Provider() videoWidth: number | string = 0
  @Provider() videoHeight: number = 0
  // 判断是否分屏
  @Provider() isSplitScreen: boolean = false
  // 判断是否上下分屏
  @Provider() isTopAndDownSplitScreen: boolean = false
  private panOptionBrightAndVolumn: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private panOptionTime: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Horizontal });
  @Local aspect: number = 9 / 16;
  @Local textWidth: number | string = '60%'
  // 是否显示锁屏按钮
  @Local isShowLockButton: boolean = true
  // 是否锁屏
  @Local isLockScreen: boolean = false
  // 音量进度条
  @Local isShowVolumeProgress: boolean = false
  // 亮度进度条
  @Local isShowBrightProgress: boolean = false
  // 时间进度条
  @Provider() isShowTimeProgress: boolean = false
  // 横屏方向
  @Local landscapeOrientation: number = 0
  // 定时器
  @Provider() showBar: boolean = true
  @Provider() clock: number = 0
  @Provider() CLOCK_TIME: number = 5000
  @Provider() isPause: boolean = false
  @Local screenWidth: number = 0
  @Local cameraPosition: string = ''
  @Local cameraWidth: number = 0
  @Event onBack: (isLandscape: boolean) => void = () => {
  };
  @Event onChaneLandScape: (isLandscape: boolean) => void = () => {
  };

  @Monitor('componentController.isInterceptor')
  onInterceptor(monitor: IMonitor) {
    if (this.componentController.isInterceptor) {
      this.isLandscape = false
      this.modifier.isTop = false
      this.setOrientation(window.Orientation.AUTO_ROTATION);
    }
  }

  @Monitor('isLandscape')
  async onStrChange(monitor: IMonitor) {
    this.componentController.isLandscape = this.isLandscape
    let windowClass = await window.getLastWindow(getContext());
    let properties = windowClass.getWindowProperties();
    const size: Size = {
      width: properties.windowRect.width,
      height: properties.windowRect.height
    }
    this.getWindowSizeChange(size)
    this.getVideoSize()
    if (!this.isLandscape) {
      this.componentController.isInterceptor = this.isLandscape
    }
    this.onChaneLandScape(this.isLandscape)
  }

  private getWindowSizeChange = (size: Size) => {
    this.isShowVolumeProgress = false
    this.isShowBrightProgress = false
    this.isShowTimeProgress = false

    this.getScreenWidth()
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

    let viewWidth = px2vp(size.width);
    let viewHeight = px2vp(size.height);
    if (this.isLandscape) {
      this.xComponentHeight = viewHeight;
      this.windowClass.setWindowSystemBarEnable([])
    } else {
      this.windowClass.setWindowSystemBarEnable(['navigation', 'status'])
      this.xComponentHeight = this.componentHeight;
    }
    this.xComponentWidth = viewWidth;
    if (viewWidth > viewHeight) {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        this.windowClass.setSpecificSystemBarEnabled('navigationIndicator', false);
      }
    } else {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        this.windowClass.setSpecificSystemBarEnabled('navigationIndicator', true);
      }
    }
    this.getVideoSize()
  }

  async aboutToAppear() {
    this.getScreenWidth()
    await this.getWindowProperties()
    this.playVideoModel = this.playVideoModel
    ScreenUtil.setScreenSize();
    this.videoList = await getVideoList(this.videoData)

    this.windowClass.on('windowSizeChange', this.getWindowSizeChange);
  }

  getScreenWidth() {
    this.screenWidth = px2vp(this.windowClass.getWindowProperties().windowRect.width) / 2
    this.playVideoModel.screenWidth = this.screenWidth
  }

  setOrientation(orientation: number) {
    this.windowClass.setPreferredOrientation(orientation).then(() => {
      Logger.info('setWindowOrientation: ' + orientation + ' Succeeded.');
    }).catch((err: BusinessError) => {
      Logger.info('setWindowOrientation: ' + orientation + ' Failed. Cause: ' + JSON.stringify(err));
    });
  }

  aboutToDisappear() {
    this.setOrientation(window.Orientation.AUTO_ROTATION);
    this.playVideoModel.release();

    this.windowClass.off('windowSizeChange', this.getWindowSizeChange)
  }

  async getWindowProperties() {
    let displayClass: display.Display | null = null;
    displayClass = display.getDefaultDisplaySync();
    displayClass.getCutoutInfo((err: BusinessError, data: display.CutoutInfo) => {
      const errCode: number = err.code;
      if (errCode) {
        Logger.error(`Failed to get cutoutInfo. Code: ${err.code}, message: ${err.message}`);
        return;
      }

      if (data.boundingRects.length > 0 && displayClass) {
        const height = px2vp(data.boundingRects[0].height)
        if (data.boundingRects[0].left > displayClass.width / 2) {
          this.cameraPosition = 'right'
          this.cameraWidth = height
        } else if (data.boundingRects[0].left < displayClass.width / 4) {
          this.cameraPosition = 'left'
          this.cameraWidth = height
        } else {
          this.cameraPosition = 'center'
          this.cameraWidth = height
        }
      }
      Logger.info('Succeeded in getting cutoutInfo. data: ' + JSON.stringify(data));
    });

    let windowClass = await window.getLastWindow(getContext());
    // 获取窗口属性
    let properties = windowClass.getWindowProperties();
    // 获取窗口宽高
    this.xComponentWidth = px2vp(properties.windowRect.width)
    this.xComponentHeight = this.componentHeight
    this.getVideoSize()
  }

  getComponentHeight(): string {
    if (this.isLandscape) {
      return '100%'
    } else {
      return vp2px(this.xComponentHeight) + 'px'
    }
  }

  getVideoSize() {
    this.videoHeight = this.xComponentHeight
    this.videoWidth = this.xComponentHeight / this.playVideoModel.aspect
    if (this.videoWidth > this.xComponentWidth) {
      this.videoWidth = this.xComponentWidth - 32
      this.videoHeight = this.videoWidth * this.playVideoModel.aspect
    }
  }

  @Builder
  iconBg() {
    Row()
      .width(40)
      .height(40)
      .flexGrow(0)
      .flexShrink(0)
      .borderRadius('50%')
      .backgroundColor(Color.Black)
      .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
      .stateStyles({
        normal: { .backgroundColor(Color.Transparent)
        },
        pressed: { .backgroundColor($r('sys.color.interactive_pressed'))
        },
      })
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
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Flex() {
              Stack() {
                this.iconBg()
                Image($r('app.media.ic_arrow_left'))
                  .width(24)
                  .height(24)
                  .objectFit(ImageFit.Contain)
              }
              .onClick(() => {
                if (this.isLandscape) {
                  this.isLandscape = false
                  this.modifier.isTop = false
                  this.setOrientation(window.Orientation.AUTO_ROTATION);
                  this.windowClass.setWindowSystemBarEnable(['navigation', 'status'])
                }
              })

              if (this.isLandscape) {
                Row() {
                  Text(this.playVideoModel.getCurrentVideoName())
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
                    .fontColor(Color.White)
                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                    .textOverflow(this.textWidth === '60%' ? { overflow: TextOverflow.Ellipsis } :
                      { overflow: TextOverflow.None })
                    .maxLines(1)
                  Text(this.playVideoModel.getCurrentVideoEpisode())
                    .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
                    .fontColor(Color.White)
                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                    .margin({ left: 8 })
                }
                .width('60%')
                .margin({ left: 12 })
              }
            }
            .flexGrow(1)
            .translate(this.isLandscape && this.cameraPosition === 'right' ? { x: this.cameraWidth } : {})

            if (this.isLandscape) {
              Battery()
                .margin({ right: 14 })
                .flexShrink(0)
                .translate(this.isLandscape && this.cameraPosition === 'left' ? { x: -this.cameraWidth } : {})
            }
          }
          .width('100%')
        }
      }
      .width('100%')
      .height(24)
      .margin(this.isLandscape ? { top: 12 } : { top: 8 })
    }
    .width('100%')
    .height(64)
    .visibility(this.showBar ? Visibility.Visible : Visibility.Hidden)
    .flexShrink(0)
  }

  @Builder
  centerRegion() {
    Row() {
      // 锁屏按钮
      Stack() {
        this.iconBg()
        Image(this.isLockScreen ? $r('app.media.ic_lock') : $r('app.media.ic_unlock'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.isLockScreen = !this.isLockScreen
            this.playVideoModel.isLockScreen = this.isLockScreen
            if (this.isLockScreen) {
              this.showBar = false
            } else {
              this.showBar = true
            }
          })
      }
      .zIndex(99)
      .translate(this.isLandscape && this.cameraPosition === 'center' ? { x: this.cameraWidth } : {})
      .visibility(this.isShowLockButton ? Visibility.Visible : Visibility.Hidden)

      // 暂停按钮
      if (!this.isLockScreen && !this.isShowTimeProgress && !this.isShowBrightProgress &&
        !this.isShowVolumeProgress && (this.isPause || this.playVideoModel.completed)) {
        Row() {
          Stack() {
            Row()
              .width(60)
              .height(60)
              .borderRadius('50%')
              .backgroundColor(Color.Black)
              .opacity($r('sys.float.ohos_id_alpha_content_secondary'))
            Image($r('app.media.ic_pause'))
              .width(60)
              .height(60)
              .fillColor(Color.White)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.isPause = false
                this.playVideoModel!.switchPlayOrPause();
              })
          }
          .translate({ x: -24 })
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
        if (this.isLandscape) {
          PlayControl()
        }
      }
    }
    .width('100%')
    .visibility(this.showBar ? Visibility.Visible : Visibility.Hidden)
    .flexShrink(0)
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
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.SpaceBetween
        }) {
          if (this.isLandscape) {
            this.topRegion()
          }

          Row() {
            this.centerRegion()
            this.buttonRegion()
          }
          .width('100%')
          .flexGrow(1)
          .gesture(GestureGroup(GestureMode.Exclusive,
            PanGesture(this.panOptionBrightAndVolumn)
              .onActionStart((event?: GestureEvent) => {
                if (this.isLockScreen) {
                  return
                }
                if (!event) {
                  return;
                }
                if (!event.fingerList[0]) {
                  return
                }
                if (event.fingerList[0].localX >= this.screenWidth) {
                  this.isShowVolumeProgress = true
                } else {
                  this.isShowBrightProgress = true
                }
                this.playVideoModel.onActionStart(event);
              })
              .onActionUpdate((event?: GestureEvent) => {
                if (this.isLockScreen) {
                  return
                }
                this.playVideoModel.onActionUpdate(event);
              })
              .onActionEnd(() => {
                if (this.isLockScreen) {
                  return
                }
                this.isShowVolumeProgress = false
                this.isShowBrightProgress = false
                this.playVideoModel.onActionEnd();
              }),
            PanGesture(this.panOptionTime)
              .onActionStart((event?: GestureEvent) => {
                if (this.playVideoModel.completed) {
                  return
                }
                if (this.isLockScreen) {
                  return
                }
                if (!event) {
                  return;
                }
                this.isPause = false
                this.playVideoModel.onTimeActionStart(event);
                this.isShowTimeProgress = true
              })
              .onActionUpdate((event?: GestureEvent) => {
                if (this.isLockScreen) {
                  return
                }
                if (!event) {
                  return;
                }
                this.playVideoModel.onTimeActionUpdate(event);
              })
              .onActionEnd(() => {
                if (this.isLockScreen) {
                  return
                }
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
                  this.isPause = false
                  this.playVideoModel!.switchPlayOrPause();
                } else {
                  this.isPause = true
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
                    }, this.CLOCK_TIME)
                  } else {
                    if (this.clock) {
                      clearTimeout(this.clock)
                    }
                  }
                }
                this.isShowLockButton = !this.isShowLockButton
              })
          )
          )

          this.bottomRegion()
        }
        .width('100%')
        .height('100%')
      }
      .width(this.isLandscape ? vp2px(this.xComponentWidth - 32) + 'px' : 'calc(100% - 32vp)')
      .height('100%')
      .margin(this.landscapeOrientation === 2 ? { right: 12 } : this.landscapeOrientation === 3 ? { left: 12 } : {})
      .alignContent(Alignment.Center)
    }
    .width('100%')
    .height(this.getComponentHeight())
    .backgroundColor('#000')
    .justifyContent(FlexAlign.Center)
    .attributeModifier(this.modifier)
    .zIndex(this.modifier.isTop ? 999 : 1)
  }
}