import { PersistenceV2, promptAction } from '@kit.ArkUI';
import { BaseViewModel, Logger, PreferenceUtils, SystemBarOperation } from 'lib_common';
import { AccountApi } from 'lib_account';
import { ThemeController, ThemeModel } from 'module_theme';
import { getMusicModel } from 'module_musicplay';

/**
 * 主页
 */
@ObservedV2
export class IndexPageViewModel extends BaseViewModel {
  @Trace translateY: string | number = '';
  @Trace tabPaddingBottom: Length = '';
  @Trace firstBackTime: number = 0;
  public pageId: number = -1;
  @Trace theme: ThemeModel = PersistenceV2.connect(ThemeModel, 'theme', () => new ThemeModel())!;
  @Trace music = getMusicModel();

  //监听下载品质变化
  @Monitor('settingInfo.qualitySwitch')
  onChangeDownloadQuality() {
    this.music.qualitySwitch = this.settingInfo.qualitySwitch
  }

  @Monitor('userInfoModel.isLogin')
  onChangeLoginStatus() {
    this.music.isLogin = this.userInfoModel.isLogin
  }

  @Monitor('userInfoModel.isVip')
  onChangeUserVip() {
    this.music.isVip = this.userInfoModel.isVip
  }

  @Monitor('settingInfo.teenagersSwitch')
  onChangeEndPlayTime() {
    this.music.teenagersSwitch = this.settingInfo.teenagersSwitch
    this.music.startLoginTime = new Date().getTime();
    PreferenceUtils.getInstance().put('startLoginTime', this.settingInfo.startLoginTime)
  }

  @Monitor('theme.id')
  onChangeThemeColor() {
    Logger.info('ThemeController.theme.isDefaultTheme' + ThemeController.theme.isDefaultTheme)
    this.settingInfo.themeColor = ThemeController.theme.themeColors[0]
    this.settingInfo.themePic = ThemeController.theme.themePic
    this.settingInfo.fontSecondary = ThemeController.theme.themeColors[3]
    this.settingInfo.themeColors = ThemeController.theme.themeColors
    this.settingInfo.themeId = ThemeController.theme.id
  }

  @Monitor('tabModel.showTabBar')
  onChangeShowTabBar(monitor: IMonitor) {
    let isShowCustomTabBar = monitor.value()?.now as boolean
    if (isShowCustomTabBar) {
      this.translateY = ''
    } else {
      this.translateY = '100%'
    }
  }

  refreshUserInfo() {
    new AccountApi().queryUserInfo();
    this.music.isLogin = this.userInfoModel.isLogin
  }

  onReady(context: NavDestinationContext) {
    this.onChangeThemeColor()
  }

  onBackPressed() {
    let nowTime = Date.now();
    if (nowTime - this.firstBackTime < 1500) {
      return false;
    } else {
      this.firstBackTime = nowTime;
      promptAction.showToast({ message: '再按一次退出' });
      return true;
    }
  }

  // 从持久化中获取当天第一次登录时间
  getFirstLoginTime() {
    if(this.settingInfo.teenagersSwitch){
      this.music.startLoginTime = PreferenceUtils.getInstance().get('startLoginTime') as number;
    }

    this.music.teenagersSwitch = this.settingInfo.teenagersSwitch
  }

  setStatusbarContentColor(color: string) {
    SystemBarOperation.setWindowSystemBarProp({
      statusBarContentColor: color
    })
  }
}
