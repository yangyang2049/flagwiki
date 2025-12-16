import { AbilityConstant, common, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import {
  BundleUtils,
  CommonMyPlayDialog,
  DownloadFileUtil,
  EventBus,
  Logger,
  PreferenceUtils,
  RouterMap,
  RouterUtils,
  WindowModel,
  WindowUtils
} from 'lib_common';
import { LoginSheetUtils, WXApi, WXEventHandler } from 'lib_account';
import { getMusicModel, SongItem } from 'module_musicplay';
import { MediaService, SongChangedData } from 'module_musicplay/src/main/ets/utils/MediaService';
import { CollectAction } from 'module_musicplay/src/main/ets/viewmodel/FormCardConstant';
import { SongServiceApi } from 'lib_music_api';

const TAG = '[PhoneAbility]';

export default class PhoneAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info(TAG, 'Ability onCreate');
    AppStorage.setOrCreate('context', this.context);
    PreferenceUtils.getInstance(this.context)
    this.handleWeChatCallIfNeed(want);
    this.initSongData()
    this.registerAudioControl()
    this.updateStartLoginTime()
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
    this.offAvoidAreaChange();
    EventBus.cancel('updateCollect')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    WindowUtils.initWindow(windowStage);
    this.setWinConfig(windowStage);
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: ' + JSON.stringify(err));
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
      BundleUtils.getBundleInfo()
    });
  }

  onWindowStageDestroy(): void {
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onNewWant(want: Want): void {
    this.handleWeChatCallIfNeed(want);
  }

  onForeground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
  }

  private async setWinConfig(windowStage: window.WindowStage) {
    AppStorage.setOrCreate('windowStage', windowStage);
    let windowClass: window.Window = windowStage.getMainWindowSync();
    await windowClass.setWindowLayoutFullScreen(true);
    this.onAvoidAreaChange(windowStage);
    // 监听窗口状态
    try {
      let windowClass: window.Window = windowStage.getMainWindowSync();
      windowClass.on('windowStatusChange', (windowStatusType) => {
        getMusicModel().windowsMode = windowStatusType
      });
    } catch (exception) {
      Logger.error(`Failed to unregister callback. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }

  private setAvoidArea(windowClass: window.Window) {
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    let type = window.AvoidAreaType.TYPE_SYSTEM;
    let avoidArea = windowClass.getWindowAvoidArea(type);
    windowModel.windowTopPadding = px2vp(avoidArea.topRect.height);
    type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
    avoidArea = windowClass.getWindowAvoidArea(type);
    windowModel.windowBottomPadding = px2vp(avoidArea.bottomRect.height);
  }

  private onAvoidAreaChange(windowStage: window.WindowStage) {
    try {
      let windowClass: window.Window = windowStage.getMainWindowSync();
      windowClass.on('avoidAreaChange', () => {
        this.setAvoidArea(windowClass);
      });
    } catch (e) {
      Logger.error(TAG, 'Failed to onAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }
  }

  private offAvoidAreaChange() {
    try {
      let windowStage = AppStorage.get('windowStage') as window.WindowStage;
      if (windowStage) {
        windowStage.getMainWindowSync().off('avoidAreaChange');
      }
    } catch (e) {
      Logger.error(TAG, 'Failed to offAvoidAreaChange. Cause: ' + JSON.stringify(e));
    }
  }

  private setWindowSize(windowStage: window.WindowStage) {
    let windowModel: WindowModel = AppStorageV2.connect(WindowModel, () => new WindowModel())!;
    let windowClass: window.Window = windowStage.getMainWindowSync();
    windowModel.windowWidth = windowClass.getWindowProperties().windowRect.width;
    windowModel.windowHeight = windowClass.getWindowProperties().windowRect.height;
  }

  private handleWeChatCallIfNeed(want: Want) {
    WXApi.handleWant(want, WXEventHandler);
  }

  /**
   * 初始化歌曲数据
   */
  async initSongData() {
    Logger.info(TAG, 'initSongData');
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    let initSongs: SongItem[] = SongServiceApi.queryAllSongList()
    if (initSongs) {
      MediaService.getInstance().initAudioPlayer(initSongs, initSongs[0]); //初始化播放器
      PreferenceUtils.getInstance().put('startLoginTime', new Date().getTime())
    }
  }

  // 音频控制注册回调函数
  private registerAudioControl() {
    MediaService.getInstance().setOnPlayStateCall((data: SongChangedData) => {
      Logger.info(TAG, `SongChangedData:${JSON.stringify(data)}`);
      PreferenceUtils.getInstance().put('currentSong', data.songItem);
    })

    //收藏操作回调(播放器以内)
    MediaService.getInstance().setCollectCallback((data: Record<string, string>) => {
      let state: string = data.state;
      // 更新收藏
      this.updateCollect(data.songId, state);
    })
    // 播放MV回调
    MediaService.getInstance().setPlayMvCallback((mvUrl: string) => {
      RouterUtils.pushPathByName(RouterMap.MVPLAYER_PAGE, mvUrl);
    })

    // 下载歌曲回调
    MediaService.getInstance().setDownloadSongCallback((src: string) => {
      DownloadFileUtil.startDownFile(src, getContext(this) as common.UIAbilityContext);
    })

    // 加入歌单回调
    MediaService.getInstance().setAddPalyListCallback((songId: string) => {
      CommonMyPlayDialog.show({
        songId: songId,
        confirm: () => {
          // 所有歌曲元数据
          let songDataList: SongItem[] = SongServiceApi.queryAllSongList()
          if (!songDataList) {
            return
          }
          // 根据id查找歌曲元数据
          let songData: SongItem = songDataList.find((item) => item.id === songId) as SongItem;
          getMusicModel().upataGedanNum(songData, 'add');
        }
      })
    })

    // 从播放页打开登录页面
    MediaService.getInstance().setOpenLoginCallback(() => {
      LoginSheetUtils.open();
    })

    // 收藏操作监听(播放器以外)
    EventBus.listen<Record<string, string>>('updateCollect', (param) => {
      let data: Record<string, string> = param as Record<string, string>;
      this.updateCollect(data.songId, data.state);
    })
  }

  // 更新收藏
  private updateCollect(songId: string, state: string) {
    // 获取收藏列表
    let collectList: SongItem[] = getMusicModel().getCollectList()
    // 所有歌曲元数据
    let songDataList: SongItem[] = SongServiceApi.queryAllSongList()
    if (!songDataList) {
      return
    }
    // 根据id查找歌曲元数据
    let songData: SongItem = songDataList.find((item) => item.id === songId) as SongItem;
    if (state === CollectAction.COLLECTED) {
      // 判断歌曲是否再收藏列表中，不在则添加
      if (!collectList.some((item) => item.id === songId)) {
        songData.isCollected = true

        getMusicModel().addCollect(songData)
      }
    } else {
      // 从收藏列表删除歌曲
      songData.isCollected = false
      getMusicModel().removeCollect(songData)
    }
    EventBus.send('updateCollectList')
  }

  //更新当天第一次登录时间
  private updateStartLoginTime() {
    // 先从持久化中获取获取登录时间
    let startLoginTime: number = PreferenceUtils.getInstance().get('startLoginTime') as number;
    // 判断是否是当天时间，如果不是直接退出
    if (startLoginTime == null || (startLoginTime && startLoginTime > new Date().getTime() - 24 * 60 * 60 * 1000)) {
      //在持久化中记录当前时间
      PreferenceUtils.getInstance().put('startLoginTime', new Date().getTime())
      return;
    }
  }
}