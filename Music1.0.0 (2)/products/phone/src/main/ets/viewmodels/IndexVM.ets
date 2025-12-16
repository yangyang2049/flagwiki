import { uiObserver, window } from '@kit.ArkUI';
import { BaseViewModel, BreakpointUtils, Logger, PlaylistModel, RouterMap, RouterUtils, SongItem } from 'lib_common';
import { LoginSheetUtils } from 'lib_account';
import { REQUIRE_LOGIN_PAGE_LIST } from '../common/Constants';
import { ThemeController } from 'module_theme';
import { SongServiceApi } from 'lib_music_api';

const TAG = 'IndexVM';

/**
 * 首页视图模型
 */
@ObservedV2
export class IndexVM extends BaseViewModel {
  allowedCustomTransitionFromPageNames: string[] = ['IndexPage', 'VideoDetailPage'];
  allowedCustomTransitionToPageNames: string[] = ['LandscapeVideo'];
  breakpoint: BreakpointUtils | null = null;

  redirect() {
    RouterUtils.replacePathByName(RouterMap.START_PAGE);
  }

  setInterception() {
    RouterUtils.getStack().setInterception({
      willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
        operation: NavigationOperation, animated: boolean) => {
        if (typeof to === 'string') {
          Logger.info(TAG, 'target page is navigation home page.');
          return;
        }
        let target: NavDestinationContext = to as NavDestinationContext;

        // 拦截依赖登录的页面
        if (!this.userInfoModel.isLogin && REQUIRE_LOGIN_PAGE_LIST.includes(target?.pathInfo?.name as RouterMap)) {
          target.pathStack.pop();
          LoginSheetUtils.open();
        }
      }
    })
  }

  registerBreakpointListener(context: UIContext) {
    this.breakpoint = new BreakpointUtils(context.getMediaQuery());
    this.breakpoint?.register();
  }

  unregisterBreakpointListener() {
    this.breakpoint?.unRegister();
  }


  isCustomTransitionEnabled(fromName: string, toName: string): boolean {
    if ((this.allowedCustomTransitionFromPageNames.includes(fromName) &&
    this.allowedCustomTransitionToPageNames.includes(toName)) ||
      (this.allowedCustomTransitionFromPageNames.includes(toName) &&
      this.allowedCustomTransitionToPageNames.includes(fromName))) {
      return true;
    }
    return false;
  }

  // 自定义转场动画
  customNavContentTransitionCallback(
    from: NavContentInfo,
    to: NavContentInfo,
    operation: NavigationOperation
  ): NavigationAnimatedTransition | undefined {
    if ((!from || !to) || (!from.name || !to.name)) {
      return undefined;
    }
    // 通过from和to的name对自定义转场路由进行管控
    if (!this.isCustomTransitionEnabled(from.name, to.name)) {
      return undefined;
    }

    // 构造customAnimation给系统侧调用，执行自定义转场动画
    let customAnimation: NavigationAnimatedTransition = {
      onTransitionEnd: (isSuccess: boolean) => {
      },
      timeout: 2000,
      transition: (transitionProxy: NavigationTransitionProxy) => {
      }
    };
    return customAnimation;
  }

  // 监听NavDestination组件的状态变化
  navDestinationListener() {
    // 无感监听路由变化
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      this.navRouteModel.navDestinationUpdateListeners.forEach((callback) => {
        callback(info)
      })
    })
  }

  // 监听WindowStage生命周期变化
  windowStageEventListener() {
    let windowStage = AppStorage.get('windowStage') as window.WindowStage;
    windowStage.on('windowStageEvent', (type: window.WindowStageEventType) => {
      this.windowStageModel.windowStageEventListeners.forEach((callback) => {
        callback(type)
      })
    });
  }

  //设置一个默认歌单
  initMyPlayList() {
    const songList: SongItem[] = SongServiceApi.queryAllSongList().slice(21, 26)
    this.myPlayListModel.playList.push(new PlaylistModel('我的歌单1', '歌单1的描述', songList[0].label, songList));
  }

  // 刷新主题
  refreshTheme() {
    ThemeController.change(this.settingInfo.themeId)
    Logger.info('ThemeController.theme.themeId' + this.settingInfo.themeId)
  }

  // 初始化歌曲原数据
  initSongData() {
    this.myPlayListModel.songList = SongServiceApi.queryAllSongList()
  }
}
