import { BaseViewModel, PreferenceUtils, RouterMap, RouterUtils } from 'lib_common';
import { agreePrivacyKey } from '../common/Constants';

/**
 * 安全引导页
 */
@ObservedV2
export class SafePageVM extends BaseViewModel {
  // todo: 自行调整是否支持开屏广告
  @Trace isShowAd: boolean = true;

  privacyClick() {
    RouterUtils.pushPathByName(RouterMap.PRIVACY_PAGE);
  }

  /**
   * 同意按钮点击
   */
  agreeBtnClick() {
    PreferenceUtils.getInstance().put(agreePrivacyKey, true);
    RouterUtils.clearStack();
    // 非首次启动开屏页
    let targetPage = this.isShowAd ? RouterMap.SPLASH_PAGE : RouterMap.INDEX_PAGE;
    RouterUtils.pushPathByName(targetPage, null, undefined, false);
  }

  cancelBtnClick() {
    RouterUtils.pushPathByName(RouterMap.AGREE_PRIVACY_PAGE);
  }

  quitApp() {
    getContext().getApplicationContext().killAllProcesses();
  }
}
