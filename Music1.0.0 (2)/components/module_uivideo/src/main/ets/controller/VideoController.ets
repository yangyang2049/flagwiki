import { media } from '@kit.MediaKit';
import { display, promptAction } from '@kit.ArkUI';
import { window } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import DateFormatUtil from '../common/util/DateFormatUtil';
import { CommonConstants, AvplayerStatus, Events, SliderMode } from '../common/constants/CommonConstants';
import { PlayConstants } from '../common/constants/PlayConstants';
import { GlobalContext } from '../common/util/GlobalContext';
import { VideoItem } from '../viewmodel/VideoItem';
import { PlayerModel } from '../common/model/PlayerModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../common/util/Logger';

@ObservedV2
export class VideoController {
  private videoList: VideoItem[] = []
  private avPlayer: media.AVPlayer | null = null;
  private duration: number = 0;
  private loop: boolean = false;
  private url?: resourceManager.RawFileDescriptor = {} as resourceManager.RawFileDescriptor;
  private iUrl: string = '';
  private surfaceId: string = '';
  private seekTime: number = PlayConstants.PROGRESS_SEEK_TIME;
  private positionX: number = PlayConstants.POSITION_X;
  private positionY: number = PlayConstants.POSITION_Y;
  private currentTime: number = 0
  @Trace public isSliderChange: boolean = false
  @Trace public screenWidth: number = 0
  @Trace public completed: boolean = false
  @Trace public isLockScreen: boolean = false
  @Trace public aspect: number = 9 / 16
  @Trace public playerModel: PlayerModel;
  @Trace public status: number = -1;
  @Trace public index: number = 0;
  @Trace public videoHeight: number = px2vp(display.getDefaultDisplaySync().width)
  @Trace public videoWidth: number = px2vp(display.getDefaultDisplaySync().width * 9 / 16)

  constructor() {
    this.playerModel = new PlayerModel();
    this.createAVPlayer();
  }

  /**
   * Creates a videoPlayer object.
   */
  async createAVPlayer() {
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    this.avPlayer = avPlayer;
    this.bindState();
  }

  /**
   * AVPlayer binding event.
   */
  async bindState() {
    if (this.avPlayer === null) {
      return;
    }
    this.avPlayer.on(Events.STATE_CHANGE, async (state: media.AVPlayerState) => {
      let avplayerStatus: string = state;
      if (this.avPlayer === null) {
        return;
      }
      switch (avplayerStatus) {
        case AvplayerStatus.IDLE:
          this.resetProgress();
          if (this.iUrl) {
            this.avPlayer.url = this.iUrl;
          } else {
            this.avPlayer.fdSrc = this.url;
          }
          break;
        case AvplayerStatus.INITIALIZED:
          this.avPlayer.surfaceId = this.surfaceId;
          this.avPlayer.prepare();
          break;
        case AvplayerStatus.PREPARED:
          this.avPlayer.videoScaleType = 0;
          this.avPlayer.play();
          this.duration = this.avPlayer.duration;
          this.videoHeight = this.avPlayer.height
          this.videoWidth = this.avPlayer.width
          this.aspect = this.videoHeight / this.videoWidth
          break;
        case AvplayerStatus.PLAYING:
          this.setVolume(this.playerModel.volume);
          this.setBright(this.playerModel.bright);
          this.status = CommonConstants.STATUS_START;
          this.watchStatus();
          break;
        case AvplayerStatus.PAUSED:
          this.status = CommonConstants.STATUS_PAUSE;
          this.watchStatus();
          break;
        case AvplayerStatus.COMPLETED:
          this.playerModel.playSpeed = PlayConstants.PLAY_SPEED;
          this.duration = PlayConstants.PLAYER_DURATION;
          if (!this.loop) {
            let curIndex = this.index + PlayConstants.PLAYER_NEXT;
            if (curIndex === this.videoList.length) {
              this.status = CommonConstants.STATUS_PAUSE
              this.completed = true
              return
            }
            this.index = (curIndex === this.videoList.length) ?
            PlayConstants.PLAYER_FIRST : curIndex;
            if (this.videoList[this.index].iSrc) {
              this.iUrl = this.videoList[this.index].iSrc;
            } else {
              this.url = this.videoList[this.index].src;
            }
          }
          this.avPlayer.reset();
          break;
        case AvplayerStatus.RELEASED:
          this.avPlayer.release();
          this.status = CommonConstants.STATUS_STOP;
          this.watchStatus();
          Logger.info('[PlayVideoModel] state released called');
          break;
        default:
          Logger.info('[PlayVideoModel] unKnown state: ' + state);
          break;
      }
    });
    this.avPlayer.on(Events.TIME_UPDATE, (time: number) => {
      this.initProgress(time);
    });
    this.avPlayer.on(Events.ERROR, async (error: BusinessError) => {
      Logger.info('error happened,and error message is :' + error.message)
      Logger.info('error happened,and error code is :' + error.code)
      this.playError();
    })
  }

  /**
   * This method is triggered when the video playback page is displayed on the video list page.
   */
  async firstPlay(videoList: VideoItem[], surfaceId: string) {
    this.videoList = videoList
    this.index = 0;
    this.url = this.videoList[this.index].src;
    this.iUrl = this.videoList[this.index].iSrc;
    this.surfaceId = surfaceId;
    if (this.avPlayer === null) {
      await this.createAVPlayer();
    }
    if (this.avPlayer !== null) {
      if (this.iUrl) {
        this.avPlayer.url = this.iUrl;
      } else {
        this.avPlayer.fdSrc = this.url;
      }
    }
  }

  /**
   * Release the video player.
   */
  release() {
    if (this.avPlayer !== null) {
      this.avPlayer.release();
    }
  }

  /**
   * Pause Playing.
   */
  pause() {
    if (this.avPlayer !== null) {
      this.avPlayer.pause();
    }
  }

  /**
   * Playback mode. The options are as follows: true: playing a single video; false: playing a cyclic video.
   */
  setLoop() {
    this.loop = !this.loop;
  }

  /**
   * Set the playback speed.
   *
   * @param playSpeed Current playback speed.
   */
  setSpeed(playSpeed: media.PlaybackSpeed) {
    if (this.avPlayer === null) {
      return;
    }
    if (CommonConstants.OPERATE_STATE.indexOf(this.avPlayer.state) === -1) {
      return;
    }
    if (playSpeed < 0) {
      playSpeed = media.PlaybackSpeed.SPEED_FORWARD_0_125_X
      Logger.warn('The player speed cannot be lower than 0.125')
    }
    if (playSpeed > 9) {
      playSpeed = media.PlaybackSpeed.SPEED_FORWARD_3_00_X
      Logger.warn('The player speed cannot be higher than 3')
    }
    this.playerModel.playSpeed = playSpeed;
    this.avPlayer.setSpeed(playSpeed);
  }

  /**
   * Previous video.
   */
  previousVideo() {
    if (this.avPlayer === null) {
      return;
    }
    this.playerModel.playSpeed = PlayConstants.PLAY_SPEED;
    let curIndex = this.index - PlayConstants.CONTROL_NEXT;
    if (curIndex < 0) {
      Logger.info('There is no previous video')
      return
    }
    this.index = curIndex
    if (this.videoList[this.index].iSrc) {
      this.iUrl = this.videoList[this.index].iSrc;
    } else {
      this.iUrl = ''
      this.url = this.videoList[this.index].src;
    }
    this.avPlayer.reset();
  }

  /**
   * Next video.
   */
  nextVideo() {
    if (this.avPlayer === null) {
      return;
    }
    this.playerModel.playSpeed = PlayConstants.PLAY_SPEED;
    let curIndex = this.index + PlayConstants.CONTROL_NEXT;
    if (curIndex > this.videoList.length - 1) {
      Logger.info('There is no next video')
      return
    }
    this.index = curIndex
    if (this.videoList[this.index].iSrc) {
      this.iUrl = this.videoList[this.index].iSrc;
    } else {
      this.iUrl = ''
      this.url = this.videoList[this.index].src;
    }
    this.avPlayer.reset();
  }

  /**
   * Switching Between Video Play and Pause.
   */
  switchPlayOrPause() {
    if (this.avPlayer === null) {
      return;
    }
    if (this.status === CommonConstants.STATUS_START) {
      this.avPlayer.pause();
    } else {
      if (this.completed) {
        this.completed = false
        this.index = this.videoList.length - 1
        this.avPlayer.reset();
      } else {
        this.avPlayer.play();
      }
    }
  }

  /**
   * Slide the progress bar to set the playback progress.
   *
   * @param value Value of the slider component.
   * @param mode Slider component change event.
   */
  setSeekTime(value: number, mode: SliderChangeMode) {
    if (this.avPlayer === null) {
      return;
    }
    if (this.isLockScreen) {
      return
    }
    if (mode === Number(SliderMode.MOVING)) {
      if (value < 0 || value > 100) {
        return
      }
      this.playerModel.progressVal = value;
      this.playerModel.currentTime = DateFormatUtil.secondToTime(Math.floor(value * this.duration /
      CommonConstants.ONE_HUNDRED / CommonConstants.A_THOUSAND));
    }

    if (this.isSliderChange && mode === Number(SliderMode.END)) {
      this.seekTime = value * this.duration / CommonConstants.ONE_HUNDRED;
      this.avPlayer.seek(this.seekTime, media.SeekMode.SEEK_PREV_SYNC);
      if (this.completed) {
        return
      }
      this.avPlayer.play()
    }

    if (!this.isSliderChange && mode === Number(SliderMode.CLICK)) {
      if (value < 0 || value > 100) {
        return
      }
      this.seekTime = value * this.duration / CommonConstants.ONE_HUNDRED;
      this.avPlayer.seek(this.seekTime, media.SeekMode.SEEK_PREV_SYNC);
      if (this.completed) {
        return
      }
      this.avPlayer.play()
    }
  }

  /**
   * Setting the brightness.
   */
  setBright(bright: number) {
    if (this.isLockScreen) {
      return
    }
    if (bright !== -1 && bright < 0) {
      bright = 0
      Logger.warn('The player bright cannot be lower than 0')
    }
    if (bright > 1) {
      bright = 1
      Logger.warn('The player bright cannot be higher than 1')
    }
    this.playerModel.bright = bright
    let windowClass = GlobalContext.getContext().getObject('windowClass') as window.Window;
    windowClass.setWindowBrightness(bright);
  }

  /**
   * Setting the volume.
   */
  setVolume(volume: number) {
    if (this.isLockScreen) {
      return
    }
    if (volume < 0) {
      volume = 0
      Logger.warn('The player bright cannot be lower than 0')
    }
    if (volume > 1) {
      volume = 1
      Logger.warn('The player bright cannot be higher than 1')
    }
    this.playerModel.volume = volume
    this.avPlayer?.setVolume(volume)
  }

  /**
   * Obtains the current video playing status.
   */
  getStatus() {
    return this.status;
  }

  /**
   * Obtains the current video name.
   */
  getCurrentVideoName() {
    if (this.videoList.length > 0 && this.videoList[this.index].name) {
      return this.videoList[this.index].name;
    } else {
      return ''
    }
  }

  /**
   * Obtains the current video name.
   */
  getCurrentVideoEpisode() {
    if (this.videoList.length > 0 && this.videoList[this.index].episode) {
      return this.videoList[this.index].episode;
    } else {
      return ''
    }
  }

  /**
   * Initialization progress bar.
   *
   * @param time Current video playback time.
   */
  initProgress(time: number) {
    let nowSeconds = Math.floor(time / CommonConstants.A_THOUSAND);
    let totalSeconds = Math.floor(this.duration / CommonConstants.A_THOUSAND);
    this.playerModel.currentTime = DateFormatUtil.secondToTime(nowSeconds);
    this.playerModel.totalTime = DateFormatUtil.secondToTime(totalSeconds);
    this.playerModel.progressVal = Math.floor(nowSeconds * CommonConstants.ONE_HUNDRED / totalSeconds);
  }

  /**
   * Reset progress bar data.
   */
  resetProgress() {
    this.seekTime = PlayConstants.PROGRESS_SEEK_TIME;
    this.playerModel.currentTime = PlayConstants.PROGRESS_CURRENT_TIME;
    this.playerModel.progressVal = PlayConstants.PROGRESS_PROGRESS_VAL;
  }

  /**
   * Volume Bright gesture method onActionStart.
   *
   * @param event Gesture event.
   */
  onActionStart(event?: GestureEvent) {
    if (!event) {
      return;
    }
    this.positionY = event.offsetY;
  }

  /**
   * Time gesture method onActionStart.
   *
   * @param event Gesture event.
   */
  onTimeActionStart(event?: GestureEvent) {
    if (!event) {
      return;
    }
    this.pause()
    this.positionX = event.offsetX;
    this.isSliderChange = true
  }

  /**
   * Gesture method onActionUpdate.
   *
   * @param event Gesture event.
   */

  onActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    if (!event.fingerList[0]) {
      return
    }
    if (event.fingerList[0].localX >= this.screenWidth) {
      this.onVolumeActionUpdate(event)
    } else {
      this.onBrightActionUpdate(event)
    }
  }

  onVolumeActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.avPlayer === null) {
      return;
    }
    if (CommonConstants.OPERATE_STATE.indexOf(this.avPlayer.state) === -1) {
      return;
    }
    this.playerModel.volumeShow = true;
    let screenHeight = GlobalContext.getContext().getObject('screenHeight') as number;
    let changeVolume = (this.positionY - event.offsetY) / screenHeight;
    let volume: number = this.playerModel.volume;
    let currentVolume = volume + changeVolume;
    let volumeMinFlag = currentVolume <= PlayConstants.MIN_VALUE;
    let volumeMaxFlag = currentVolume > PlayConstants.MAX_VALUE;
    this.playerModel.volume = volumeMinFlag ? PlayConstants.MIN_VALUE :
      (volumeMaxFlag ? PlayConstants.MAX_VALUE : currentVolume);
    this.setVolume(this.playerModel.volume);
    this.positionY = event.offsetY;
  }

  /**
   * Gesture method onActionUpdate.
   *
   * @param event Gesture event.
   */
  onBrightActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    this.playerModel.brightShow = true;
    let screenHeight = GlobalContext.getContext().getObject('screenHeight') as number;
    let changeBright = (this.positionY - event.offsetY) / screenHeight;
    let bright: number = this.playerModel.bright;
    let currentBright = bright + changeBright;
    let brightMinFlag = currentBright <= PlayConstants.MIN_VALUE;
    let brightMaxFlag = currentBright > PlayConstants.MAX_VALUE;
    this.playerModel.bright = brightMinFlag ? PlayConstants.MIN_VALUE :
      (brightMaxFlag ? PlayConstants.MAX_VALUE : currentBright);
    this.setBright(this.playerModel.bright);
    this.positionY = event.offsetY;
  }

  /**
   * Gesture method onActionUpdate.
   *
   * @param event Gesture event.
   */
  onTimeActionUpdate(event?: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.avPlayer === null) {
      return;
    }
    if (CommonConstants.OPERATE_STATE.indexOf(this.avPlayer.state) === -1) {
      return;
    }
    if (this.avPlayer.state === AvplayerStatus.COMPLETED && this.index === this.videoList.length - 1) {
      this.completed = true
      return
    }
    let screenWidth = GlobalContext.getContext().getObject('screenWidth') as number;
    let changeTime = (event.offsetX - this.positionX) / screenWidth * 100;
    let time: number = this.playerModel.progressVal;
    this.currentTime = time + changeTime;
    this.setSeekTime(this.currentTime, SliderChangeMode.Moving)
    this.positionX = event.offsetX;
  }

  /**
   * Gesture method onActionEnd.
   */
  onActionEnd() {
    setTimeout(() => {
      this.playerModel.volumeShow = false;
      this.playerModel.brightShow = false;
      this.positionX = PlayConstants.POSITION_X;
      this.positionY = PlayConstants.POSITION_Y;
    }, PlayConstants.DISAPPEAR_TIME);
  }

  onActionTimeEnd() {
    this.seekTime = this.playerModel.progressVal * this.duration / CommonConstants.ONE_HUNDRED;

    if (this.avPlayer !== null) {
      if (this.avPlayer.state === AvplayerStatus.COMPLETED && this.index === this.videoList.length - 1) {
        return
      }
      this.avPlayer.seek(this.seekTime, media.SeekMode.SEEK_PREV_SYNC);
      this.switchPlayOrPause()
    }
  }

  /**
   * Sets whether the screen is a constant based on the playback status.
   */
  watchStatus() {
    let windowClass = GlobalContext.getContext().getObject('windowClass') as window.Window;
    if (this.status === CommonConstants.STATUS_START) {
      windowClass.setWindowKeepScreenOn(true);
    } else {
      windowClass.setWindowKeepScreenOn(false);
    }
  }

  /**
   * An error is reported during network video playback.
   */
  playError() {
    promptAction.showToast({
      alignment: Alignment.Center,
      duration: PlayConstants.PLAY_ERROR_TIME,
      message: $r('app.string.play_error')
    });
  }
}